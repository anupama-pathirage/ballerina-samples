import ballerina.net.http;
import ballerina.data.sql;
import ballerina.lang.messages;
import ballerina.lang.errors;


@http:configuration {basePath:"/TestLocalTx"}
service<http> TestBatchRequests {

    sql:ConnectionProperties Properties = {};
    sql:ClientConnector testDB = create sql:ClientConnector(sql:MYSQL, "localhost", 3306, "testdb", "root", "root", Properties);


    @http:resourceConfig {
        methods:["POST"],
        path:"/InsertDataRes"
    }
    resource insertData (message m) {

        json payload = messages:getJsonPayload(m);

        var customerid, _ = (int)payload.p0_customerId;
        sql:Parameter p0 = {sqlType:"integer", value:customerid};

        var firstName, _ = (string)payload.p1_firstName;
        sql:Parameter p1 = {sqlType:"varchar", value:firstName};

        var lastName, _ = (string)payload.p2_lastName;
        sql:Parameter p2 = {sqlType:"varchar", value:lastName};

        var registrationID, _ = (int)payload.p3_registrationID;
        sql:Parameter p3 = {sqlType:"integer", value:registrationID};

        sql:Parameter[] paramCustomers = [p0, p1, p2, p3];

        var month_salary, _ = (float)payload.p4_month_salary;
        sql:Parameter p4 = {sqlType:"double", value:month_salary};

        sql:Parameter[] paramSalary = [p0, p4];
        string transactionStatus = "";

        try {
            transaction {
                int insertCountCustomers = testDB.update ("Insert into Customers (customerId,firstName,lastName,registrationID)
                                                          values (?,?,?,?)", paramCustomers);
                int insertCountSalary = testDB.update ("Insert into Salary (customerId,month_salary)
                                                       values (?,?)", paramSalary);
            } failed {
                transactionStatus = transactionStatus + "FAILED ";
            } committed {
                transactionStatus = transactionStatus + "SUCCESS ";
            } aborted {
                transactionStatus = transactionStatus + "ABORTED ";
            }
        } catch (errors:Error err) {
            transactionStatus = transactionStatus + "ERROR ";
        }
        message responseMsg = {};
        messages:setStringPayload(responseMsg, transactionStatus);
        reply responseMsg;
    }
}
