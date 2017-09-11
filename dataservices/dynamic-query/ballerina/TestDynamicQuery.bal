import ballerina.net.http;
import ballerina.data.sql;
import ballerina.lang.messages;
import ballerina.lang.xmls;
import ballerina.lang.system;

@http:configuration {basePath:"/testds"}
service<http> TestDS {
    sql:ClientConnector testDB = create sql:ClientConnector(sql:MYSQL, "localhost", 3306, "testdb", "root", "root", null);

    @http:resourceConfig {
        methods:["POST"],
        path:"/testservice"
    }
    resource testJson (message m) {
        xml payload = messages:getXmlPayload(m);
        string columns = xmls:getString(payload, "/DynamicQueryTest/columns/text()");
        string table = xmls:getString(payload, "/DynamicQueryTest/table/text()");
        string whereclause = xmls:getString(payload, "/DynamicQueryTest/whereclause/text()");
        string query = string `Select {{columns}} from {{table}} where {{whereclause}} `;
        system:println(query);
        datatable dt = testDB.select(query, null);
        message response = {};
        var result, _ = <xml>dt;
        messages:setXmlPayload(response, result);
        reply response;
    }
}
