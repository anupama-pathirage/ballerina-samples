import ballerina.net.http;
import ballerina.data.sql;
import ballerina.lang.messages;
import ballerina.lang.xmls;

@http:configuration {basePath:"/testds"}
service<http> TestDS {
    sql:ClientConnector testDB = create sql:ClientConnector(sql:MYSQL, "localhost", 3306, "testdb", "root", "root", null);

    @http:resourceConfig {
        methods:["POST"],
        path:"/testservice"
    }
    resource testJson (message m) {
        xml payload = messages:getXmlPayload(m);
        string s = xmls:getTextValue(payload);
        var id, _ = (string)s;
        sql:Parameter para1 = {sqlType:"integer", value:id};
        sql:Parameter[] parameters = [para1];
        datatable dt = testDB.select("select CustomerLevel(?) as level", parameters);
        message response = {};
        var result, _ = <xml>dt;
        messages:setXmlPayload(response, result);
        reply response;
    }
}
