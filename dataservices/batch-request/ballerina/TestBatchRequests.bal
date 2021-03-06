import ballerina.net.http;
import ballerina.data.sql;
import ballerina.lang.messages;

@http:configuration {basePath:"/TestBatchRequests"}
service<http> TestBatchRequests {

    sql:ConnectionProperties Properties = {};
    sql:ClientConnector testDB = create sql:ClientConnector(sql:MYSQL, "localhost", 3306, "testdb", "root", "root", Properties);

    @http:resourceConfig {
        methods:["POST"],
        path:"/InsertDataRes"
    }
    resource echo (message m) {
        json payload = messages:getJsonPayload(m);
        int length = lengthof payload;
        int i = 0;
        sql:Parameter[][] batchPara = [];
        while (i < length) {
            json row = payload[i];

            var customerid, _ = (int)row.p0_customerId;
            sql:Parameter p0 = {sqlType:"integer", value:customerid};

            var firstName, _ = (string)row.p1_firstName;
            sql:Parameter p1 = {sqlType:"varchar", value:firstName};

            var lastName, _ = (string)row.p2_lastName;
            sql:Parameter p2 = {sqlType:"varchar", value:lastName};

            var registrationID, _ = (int)row.p3_registrationID;
            sql:Parameter p3 = {sqlType:"integer", value:registrationID};

            sql:Parameter[] item = [p0, p1, p2, p3];
            batchPara[i] = item;
            i = i + 1;
        }
        int[] count = testDB.batchUpdate("Insert into Customers(customerId,firstName,lastName,registrationID) values (?,?,?,?)", batchPara);
        message response = {};
        string test = "Batch Status: ";
        int lenCount = lengthof count;
        i = 0;
        while (i < lenCount ) {
            test = test + " " + count[i];
            i = i + 1;
        }
        messages:setStringPayload(response, test);
        reply response;
    }
}
