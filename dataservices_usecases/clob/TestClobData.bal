import ballerina.data.sql;

struct RS {
    float ID;
    string CLOBDATA;
    string NCLOBDATA;
}

function main (string[] args) {
    endpoint<sql:ClientConnector> testDB {
        create sql:ClientConnector(
        sql:ORACLE, "localhost", 0, "xe", "system", "oracle", {maximumPoolSize:5});
    }

    int ret = testDB.update("CREATE TABLE TestData (id NUMBER(3), clobData CLOB, nclobData NCLOB)", null);
    println("Type creation status:" + ret);

    string insertSQL = "INSERT INTO TestData(id,clobData,nclobData) VALUES (?,?,?)";
    string selectSQL = "SELECT id,clobData, nclobData FROM TestData";

    //Insert data
    sql:Parameter para1 = {sqlType:"INTEGER", value:1};
    sql:Parameter para2 = {sqlType:"CLOB", value:"TEST"};
    sql:Parameter para3 = {sqlType:"NCLOB", value:"සාම්පල් දත්ත"};
    sql:Parameter[] parameters = [para1, para2, para3];
    ret = testDB.update(insertSQL, parameters);
    println("Data insertion status:" + ret);

    //Insert null values
    para1 = {sqlType:"INTEGER", value:2};
    para2 = {sqlType:"CLOB", value:null};
    para3 = {sqlType:"NCLOB", value:null};
    parameters = [para1, para2, para3];
    ret = testDB.update(insertSQL, parameters);
    println("Null Data insertion status:" + ret);

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
        println(result.ID + "|" + result.CLOBDATA + "|" + result.NCLOBDATA+ "|");
    }

    ret = testDB.update("DROP table TestData", null);
    println("Table Drop status:" + ret);

    testDB.close();
    println("Connector shut downs successfully");

}
