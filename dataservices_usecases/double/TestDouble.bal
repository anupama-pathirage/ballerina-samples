import ballerina.data.sql;

struct RS {
    int id;
    float numericData;
    float decimalData;
    float floatData;
    float doubleData;
}

function main (string[] args) {
    endpoint<sql:ClientConnector> testDB {
        create sql:ClientConnector(
        sql:MYSQL, "localhost", 0, "testdb", "root", "root", {maximumPoolSize:5});
    }

    //numeric decimal (65,30) and float double (255,30)
    int ret = testDB.update("CREATE TABLE TestData (id INT, numericData NUMERIC(65,1), decimalData DECIMAL(65,1), floatData FLOAT(255,1), doubleData DOUBLE(255,1))", null);
    println("TestData Table creation status:" + ret);

    string insertSQL = "INSERT INTO TestData(id,numericData,decimalData,floatData,doubleData ) VALUES (?,?,?,?,?)";
    string selectSQL = "SELECT id,numericData, decimalData,floatData,doubleData FROM TestData";

    //Insert signed max
    sql:Parameter para1 = {sqlType:"INTEGER", value:1};
    sql:Parameter para2 = {sqlType:"NUMERIC", value:9199999999999999999999999999999999999999999999999999999999999911.1};
    sql:Parameter para3 = {sqlType:"DECIMAL", value:9199999999999999999999999999999999999999999999999999999999999911.1};
    sql:Parameter para4 = {sqlType:"FLOAT", value:99999999999999999999999999999999999911.1};
    sql:Parameter para5 = {sqlType:"DOUBLE", value:9199999999999999999999999999999999999999999999999999999999999911.1};
    sql:Parameter[] parameters = [para1, para2, para3, para4, para5];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    //Insert null values
    para1 = {sqlType:"INTEGER", value:2};
    para2 = {sqlType:"NUMERIC", value:null};
    para3 = {sqlType:"DECIMAL", value:null};
    para4 = {sqlType:"FLOAT", value:null};
    para5 = {sqlType:"DOUBLE", value:null};
    parameters = [para1, para2, para3, para4, para5];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    println("=========== OUTPUT ==========");
    datatable dt = testDB.select(selectSQL, null);
    var j,_ = <json>dt;
    println(j);

    dt = testDB.select(selectSQL, null);
    var x,_ = <xml>dt;
    println(x);

    dt = testDB.select(selectSQL, null);
    while (dt.hasNext()) {
        var result,_ = (RS)dt.getNext();
        println(result.id + "|" + result.numericData + "|" + result.decimalData+ "|" + result.floatData+ "|" + result.doubleData);
    }

    ret = testDB.update("DROP table TestData", null);
    println("Table TestData Drop status:" + ret);

    testDB.close();
    println("Connector shut downs successfully..");
}
