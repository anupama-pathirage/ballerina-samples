import ballerina.data.sql;

struct RS {
    int id;
    boolean bitData;
}

function main (string[] args) {
    endpoint<sql:ClientConnector> testDB {
        create sql:ClientConnector(
        sql:MYSQL, "localhost", 0, "testdb", "root", "root", {maximumPoolSize:5});
    }

    int ret = testDB.update("CREATE TABLE TestData (id INT, bitData BIT)", null);
    println("Table creation status:" + ret);

    string insertSQL = "INSERT INTO TestData(id,bitData) VALUES (?,?)";
    string selectSQL = "SELECT * FROM TestData";

    sql:Parameter para1 = {sqlType:"integer", value:1, direction:0};
    sql:Parameter para2 = {sqlType:"bit", value:true, direction:0};
    sql:Parameter[] parameters = [para1, para2];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    para1 = {sqlType:"integer", value:2, direction:0};
    para2 = {sqlType:"bit", value:false, direction:0};
    parameters = [para1, para2];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    para1 = {sqlType:"integer", value:3, direction:0};
    para2 = {sqlType:"bit", value:null, direction:0};
    parameters = [para1, para2];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    datatable dt = testDB.select(selectSQL, null);
    var j, _ = <json>dt;
    println(j);

    dt = testDB.select(selectSQL, null);
    var x, _ = <xml>dt;
    println(x);

    dt = testDB.select(selectSQL, null);
    while (dt.hasNext()) {
        var result, _ = (RS)dt.getNext();
        println(result.id + "|" + result.bitData);
    }

    ret = testDB.update("DROP table TestData", null);
    println("Table Drop status:" + ret);

    testDB.close();
    println("Connector shut downs successfully");
}
