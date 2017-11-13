import ballerina.data.sql;

struct resultdata {
    int orderId;
    string LUT;
}

function main (string[] args) {
    endpoint<sql:ClientConnector> testDB {
                                  create sql:ClientConnector(
                                         sql:MYSQL, "localhost", 3306, "testdb", "root", "root", {maximumPoolSize:5});
}
    int ret = testDB.update("CREATE TABLE StockOrders (orderId INT(6), LUT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP );", null);
    println("Table creation status:" + ret);

    string sql = "insert into StockOrders(orderId, LUT) values (?,?)";
    //Insert time from string variable
    sql:Parameter para1 = {sqlType:"integer", value:2};
    sql:Parameter para2 = {sqlType:"timestamp", value:"2017-01-30T13:27:01"};
    sql:Parameter[] params = [para1, para2];
    int count = testDB.update(sql, params);

    //Insert time from Ballerina Time struct
    Time timeCreated = createTime(2017, 1, 30, 13, 27, 01, 0, "Asia/Colombo");
    para1 = { sqlType:"integer", value:3};
    para2 = {sqlType:"timestamp", value:timeCreated};
    params =[ para1, para2];
    count = testDB.update(sql, params);

    //Insert time from long variable which contains epoch time
    para1 = { sqlType:"integer", value:4};
    para2 = {sqlType:"timestamp", value:1485763021000};
    params =[ para1, para2];
    count = testDB.update(sql, params);

    //Retrive time data from DB, currently supported as strings only
    datatable dt = testDB.select("SELECT * FROM StockOrders", null);
    var result, _ = <json>dt;
    println( result);

    dt = testDB.select("SELECT * FROM StockOrders", null);
    string responseStr = "";
    while (dt. hasNext()) {
    var rs, _ = (resultdata)dt.getNext();
        responseStr = responseStr + rs. LUT;
        responseStr = responseStr + "|";

    }
    println( responseStr);

    ret = testDB.update("DROP TABLE StockOrders", null);
    println("Table drop status:" + ret);
}
