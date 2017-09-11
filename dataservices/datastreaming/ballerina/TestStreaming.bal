import ballerina.net.http;
import ballerina.data.sql;
import ballerina.lang.messages;

@http:configuration {basePath:"/teststreaming"}
service<http> TestStreaming {

    sql:ConnectionProperties Properties = {};
    sql:ClientConnector testDB = create sql:ClientConnector(sql:MYSQL, "localhost", 3306, "testdb", "root", "root", Properties);

    @http:resourceConfig {
        methods:["GET"],
        path:"/json"
    }
    resource testJson (message m) {
        datatable dt = testDB.select("SELECT * FROM Customers", null);
        message response = {};
        var result, _ = <json>dt;
        messages:setJsonPayload(response, result);
        reply response;
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/xml"
    }
    resource testXML (message m) {
        datatable dt = testDB.select("SELECT * FROM Customers", null);
        message response = {};
        var result, _ = <xml>dt;
        messages:setXmlPayload(response, result);
        reply response;
    }
}
