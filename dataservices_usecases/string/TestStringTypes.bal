import ballerina.data.sql;

struct RS {
    int id;
    string charData;
    string varcharData;
    string ncharData;
    string nvarcharData;
    string tinyTextData;
    string textData;
    string mediumTextData;
    string longTextData;
}

function main (string[] args) {
    endpoint<sql:ClientConnector> testDB {
        create sql:ClientConnector(
        sql:MYSQL, "localhost", 0, "testdb", "root", "root", {maximumPoolSize:5});
    }

    int ret = testDB.update("CREATE TABLE TestData (id INT, charData CHAR(30), varcharData VARCHAR(30),
                ncharData NCHAR(30), nvarcharData NVARCHAR(30), tinyTextData TINYTEXT, textData TEXT,
                mediumTextData MEDIUMTEXT, longTextData LONGTEXT)", null);
    println("TestData Table creation status:" + ret);

    string insertSQL = "INSERT INTO TestData(id,charData, varcharData, ncharData, nvarcharData, tinyTextData,textData,
        mediumTextData, longTextData) VALUES (?,?,?,?,?,?,?,?,?)";
    string selectSQL = "SELECT id,charData, varcharData, ncharData, nvarcharData, tinyTextData,textData, mediumTextData,
        longTextData FROM TestData";

    //Insert signed max
    sql:Parameter para1 = {sqlType:"INTEGER", value:1};
    sql:Parameter para2 = {sqlType:"CHAR", value:"TESTCHAR"};
    sql:Parameter para3 = {sqlType:"VARCHAR", value:"TESTVARCHAR"};
    sql:Parameter para4 = {sqlType:"NCHAR", value:"TESTNCHAR"};
    sql:Parameter para5 = {sqlType:"NVARCHAR", value:"TESTNVARCHAR"};
    sql:Parameter para6 = {sqlType:"VARCHAR", value:"TESTTINYTEXT"};
    sql:Parameter para7 = {sqlType:"VARCHAR", value:"TESTTEXT"};
    sql:Parameter para8 = {sqlType:"VARCHAR", value:"TESTMEDIUMTEXT"};
    sql:Parameter para9 = {sqlType:"VARCHAR", value:"TESTLONGTEXT"};
    sql:Parameter[] parameters = [para1, para2, para3, para4, para5, para6, para7, para8, para9];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    //Insert null values
    para1 = {sqlType:"INTEGER", value:null};
    para2 = {sqlType:"CHAR", value:null};
    para3 = {sqlType:"VARCHAR", value:null};
    para4 = {sqlType:"NCHAR", value:null};
    para5 = {sqlType:"NVARCHAR", value:null};
    para6 = {sqlType:"VARCHAR", value:null};
    para7 = {sqlType:"VARCHAR", value:null};
    para8 = {sqlType:"VARCHAR", value:null};
    para9 = {sqlType:"VARCHAR", value:null};
    parameters = [para1, para2, para3, para4, para5, para6, para7, para8, para9];
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
        println(result.id + "|" + result.charData + "|" + result.varcharData + "|" + result.ncharData + "|"
                + result.nvarcharData + "|" + result.tinyTextData + "|" + result.textData + "|" + result.mediumTextData
                + "|" + result.longTextData  );
    }

    ret = testDB.update("DROP table TestData", null);
    println("Table TestData Drop status:" + ret);

    testDB.close();
    println("Connector shut downs successfully");
}
