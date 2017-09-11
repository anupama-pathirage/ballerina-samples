import ballerina.net.http;
import ballerina.data.sql;
import ballerina.lang.messages;

@http:configuration {basePath:"/testcustomds"}
service<http> TestDS {
    sql:ConnectionProperties props = {url:"jdbc:mysql://localhost:3306/testdb"};
    sql:ClientConnector testDB = create sql:ClientConnector("", "", 0, "", "root", "root", props);

    @http:resourceConfig {
        methods:["GET"],
        path:"/testservice"
    }
    resource testJson (message m) {
        datatable dt = testDB.select("SELECT * FROM Customers", null);
        message response = {};
        var result, _ = <json>dt;
        messages:setJsonPayload(response, result);
        reply response;
    }
}
