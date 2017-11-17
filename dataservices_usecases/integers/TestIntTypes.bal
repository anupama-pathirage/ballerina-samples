import ballerina.data.sql;

struct RS {
    int id;
    int tinyIntData;
    int smallIntData;
    int intData;
    int bigIntData;
}

function main (string[] args) {
    endpoint<sql:ClientConnector> testDB {
        create sql:ClientConnector(
        sql:MYSQL, "localhost", 0, "testdb", "root", "root", {maximumPoolSize:5});
    }

    int ret = testDB.update("CREATE TABLE TestData (id INT, intData INT, tinyIntData TINYINT, smallIntData SMALLINT,
            bigIntData BIGINT)", null);
    println("TestData Table creation status:" + ret);

    ret = testDB.update("CREATE TABLE TestUnsignedData (id INT, intData INT UNSIGNED, tinyIntData TINYINT UNSIGNED,
            smallIntData SMALLINT UNSIGNED, bigIntData BIGINT UNSIGNED)", null);
    println("TestUnsignedData Table creation status:" + ret);

    string insertSQL = "INSERT INTO TestData(id,tinyIntData, smallIntData, intData, bigIntData) VALUES (?,?, ?,?,?)";
    string insertUnsignedSQL = "INSERT INTO TestUnsignedData(id,tinyIntData, smallIntData, intData, bigIntData)
            VALUES (?,?, ?,?,?)";
    string selectSQL = "SELECT id,tinyIntData,smallIntData,intData,bigIntData FROM TestData";
    string selectUnsignedSQL = "SELECT id,tinyIntData,smallIntData,intData, bigIntData FROM TestUnsignedData";

    //Insert signed max
    sql:Parameter para1 = {sqlType:"INTEGER", value:1, direction:0};
    sql:Parameter para2 = {sqlType:"TINYINT", value:127, direction:0};
    sql:Parameter para3 = {sqlType:"SMALLINT", value:32767, direction:0};
    sql:Parameter para4 = {sqlType:"INTEGER", value:2147483647, direction:0};
    sql:Parameter para5 = {sqlType:"BIGINT", value:9223372036854775807, direction:0};
    sql:Parameter[] parameters = [para1, para2, para3, para4, para5];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    //Insert signed min
    para1 = {sqlType:"INTEGER", value:2, direction:0};
    para2 = {sqlType:"TINYINT", value:-128, direction:0};
    para3 = {sqlType:"SMALLINT", value:-32768, direction:0};
    para4 = {sqlType:"INTEGER", value:-2147483648, direction:0};
    para5 = {sqlType:"BIGINT", value:-9223372036854775808, direction:0};
    parameters = [para1, para2, para3, para4, para5];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    //Insert null
    para1 = {sqlType:"INTEGER", value:3, direction:0};
    para2 = {sqlType:"TINYINT", value:null, direction:0};
    para3 = {sqlType:"SMALLINT", value:null, direction:0};
    para4 = {sqlType:"INTEGER", value:null, direction:0};
    para5 = {sqlType:"BIGINT", value:null, direction:0};
    parameters = [para1, para2, para3, para4, para5];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    println("=========== Signed Data ==========");
    datatable dt = testDB.select(selectSQL, null);
    var j, _ = <json>dt;
    println(j);

    dt = testDB.select(selectSQL, null);
    var x, _ = <xml>dt;
    println(x);

    dt = testDB.select(selectSQL, null);
    while (dt.hasNext()) {
        var result, _ = (RS)dt.getNext();
        println(result.id + "|" + result.tinyIntData + "|" + result.smallIntData + "|" + result.intData + "|"
                + result.bigIntData);
    }

    //Insert unsigned max
    para1 = {sqlType:"INTEGER", value:1, direction:0};
    para2 = {sqlType:"TINYINT", value:127, direction:0};
    para3 = {sqlType:"SMALLINT", value:65535, direction:0};
    para4 = {sqlType:"INTEGER", value:4294967295, direction:0};
    para5 = {sqlType:"BIGINT", value:9223372036854775807, direction:0};
    parameters = [para1, para2, para3, para4, para5];
    ret = testDB.update(insertUnsignedSQL, parameters);
    println(ret);

    println("=========== Unsigned Data ==========");
    dt = testDB.select(selectUnsignedSQL, null);
    j, _ = <json>dt;
    println(j);

    dt = testDB.select(selectUnsignedSQL, null);
    x, _ = <xml>dt;
    println(x);

    dt = testDB.select(selectUnsignedSQL, null);
    while (dt.hasNext()) {
        var result2, _ = (RS)dt.getNext();
        println(result2.id + "|" + result2.tinyIntData + "|" + result2.smallIntData + "|" + result2.intData + "|"
                + result2.bigIntData);
    }

    ret = testDB.update("DROP table TestData", null);
    println("Table TestData Drop status:" + ret);

    ret = testDB.update("DROP table TestUnsignedData", null);
    println("Table TestUnsignedData Drop status:" + ret);

    testDB.close();
    println("Connector shut downs successfully");
}
