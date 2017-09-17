import ballerina.net.http;
import ballerina.data.sql;
import ballerina.lang.messages;
import ballerina.lang.datatables;
import ballerina.lang.time;

struct resultdata {
    int orderId;
    string LUT;
}
@http:configuration {basePath:"/testds"}
service<http> TestStreaming {

    sql:ClientConnector testDB = create sql:ClientConnector(sql:MYSQL, "localhost", 3306, "testdb", "root", "root", null);

    @http:resourceConfig {
        methods:["GET"],
        path:"/jsondata"
    }
    resource testJson (message m) {
        datatable dt = testDB.select("SELECT * FROM StockOrders where orderId = 1", null);
        message response = {};
        var result, _ = <json>dt;
        messages:setJsonPayload(response, result);
        reply response;
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/stringdata"
    }
    resource teststruct (message m) {
        datatable dt = testDB.select("SELECT * FROM StockOrders where orderId = 1", null);
        string responseStr = "";
        while (datatables:hasNext(dt)) {
            any dataStruct = datatables:next(dt);
            var rs, _ = (resultdata)dataStruct;
            responseStr = responseStr + rs.LUT;
            responseStr = responseStr + "|";

        }
        message response = {};
        messages:setStringPayload(response, responseStr);
        reply response;
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/adddata"
    }
    resource testadd (message m) {
        string sql = "insert into StockOrders(orderId, LUT) values (?,?)";
        sql:Parameter para1 = {sqlType:"integer", value:2};
        sql:Parameter para2 = {sqlType:"timestamp", value:"2017-01-30T13:27:01"};
        sql:Parameter[] params = [para1, para2];
        int count = testDB.update(sql, params);

        time:Time timeCreated = time:createTime(2017, 1, 30, 13, 27, 01, 0, "Asia/Colombo");
        para1 = {sqlType:"integer", value:3};
        para2 = {sqlType:"timestamp", value:timeCreated};
        params = [para1, para2];
        count = testDB.update(sql, params);

        para1 = {sqlType:"integer", value:4};
        para2 = {sqlType:"timestamp", value:1485763021000};
        params = [para1, para2];
        count = testDB.update(sql, params);

        datatable dt = testDB.select("SELECT * FROM StockOrders", null);
        var result, _ = <json>dt;
        message response = {};
        messages:setJsonPayload(response, result);
        reply response;
    }
}
