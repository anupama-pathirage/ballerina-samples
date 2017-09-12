import ballerina.net.http;
import ballerina.data.sql;
import ballerina.lang.datatables;
import ballerina.lang.messages;

struct ResultOneData {
    int orderNumber;
    string  status;
    int customerNumber;
}

struct ResultTwoData {
    string  firstName;
}

struct ResultData {
    int orderNumber;
    string  status;
    int customerNumber;
    string  firstName;
}



@http:configuration {basePath:"/testds"}
service<http> TestStreaming {

    sql:ConnectionProperties Properties = {};
    sql:ClientConnector testDB = create sql:ClientConnector(sql:MYSQL, "localhost", 3306, "testdb", "root", "root", Properties);

    @http:resourceConfig {
        methods:["GET"],
        path:"/testservicevar"
    }
    resource testWithVariables (message m) {
        //first query
        json jsonRes = [];
        int index = 0;
        datatable dt = testDB.select("select orderNumber,status,customerNumber from Orders", null);
        while (datatables:hasNext(dt)) {
            any dataStruct1 = datatables:next(dt);
            var rs1, _ = (ResultOneData) dataStruct1;
            //2nd query
            sql:Parameter para1 = {sqlType:"integer", value:rs1.customerNumber};
            sql:Parameter[] parameters = [para1];
            datatable dt2 = testDB.select("select firstName from Customers where customerId = ? ", parameters);
            string name;
            while (datatables:hasNext(dt2)) {
                any dataStruct2 = datatables:next(dt2);
                var rs2, _ = (ResultTwoData)dataStruct2;
                name = rs2.firstName;
            }
            //generate output
            ResultData rs = {};
            rs.orderNumber = rs1.orderNumber;
            rs.status = rs1.status;
            rs.customerNumber= rs1.customerNumber;
            rs.firstName = name;
            var j,_ = <json> rs;
            jsonRes[index] = j;
            index = index + 1;

        }
        message response = {};
        messages:setJsonPayload(response, jsonRes);
        reply response;
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/testservicequery"
    }
    resource testWithQuery (message m) {
        datatable dt = testDB.select("select o.orderNumber,o.status,o.customerNumber,c.firstName from Orders o left join Customers c on o.customerNumber = c.customerId", null);
        var jsonRes,_ = <json>dt;
        message response = {};
        messages:setJsonPayload(response, jsonRes);
        reply response;
    }
}
