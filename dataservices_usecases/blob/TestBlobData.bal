import ballerina.data.sql;

struct RS {
    int id;
    blob binaryData;
    blob varbinaryData;
    blob tinyBlobData;
    blob blobData;
    blob mediumBlobData;
    blob longBlobData;
}

function main (string[] args) {
    endpoint<sql:ClientConnector> testDB {
        create sql:ClientConnector(
        sql:MYSQL, "localhost", 0, "testdb", "root", "root", {maximumPoolSize:5});
    }

    //numeric decimal (65,30) and float double (255,30)
    int ret = testDB.update("CREATE TABLE TestData (id INT, binaryData BINARY(20), varbinaryData VARBINARY(20),
        tinyBlobData TINYBLOB, blobData BLOB, mediumBlobData  MEDIUMBLOB, longBlobData LONGBLOB)", null);
    println("TestData Table creation status:" + ret);

    string insertSQL = "INSERT INTO TestData(id,binaryData,varbinaryData, tinyBlobData, blobData, mediumBlobData,
        longBlobData ) VALUES (?,?,?, ?,?,?,?)";
    string selectSQL = "SELECT id,binaryData, varbinaryData, tinyBlobData, blobData, mediumBlobData, longBlobData
        FROM TestData";

    //Insert signed max
    string text = "Sample Text";
    blob content = text.toBlob("UTF-8");
    println(content);

    sql:Parameter para1 = {sqlType:"INTEGER", value:1};
    sql:Parameter para2 = {sqlType:"BINARY", value:content};
    sql:Parameter para3 = {sqlType:"VARBINARY", value:content};
    sql:Parameter para4 = {sqlType:"BLOB", value:content};
    sql:Parameter para5 = {sqlType:"BLOB", value:content};
    sql:Parameter para6 = {sqlType:"BLOB", value:content};
    sql:Parameter para7 = {sqlType:"BLOB", value:content};
    sql:Parameter[] parameters = [para1, para2, para3, para4, para5, para6, para7];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    //Insert null values
    para1 = {sqlType:"INTEGER", value:2};
    para2 = {sqlType:"BINARY", value:null};
    para3 = {sqlType:"VARBINARY", value:null};
    para4 = {sqlType:"BLOB", value:null};
    para5 = {sqlType:"BLOB", value:null};
    para6 = {sqlType:"BLOB", value:null};
    para7 = {sqlType:"BLOB", value:null};
    parameters = [para1, para2, para3, para4, para5, para6, para7];
    ret = testDB.update(insertSQL, parameters);
    println(ret);

    println("=========== OUTPUT ddd==========");
    datatable dt = testDB.select(selectSQL, null);
    var j, _ = <json>dt;
    println(j);

    dt = testDB.select(selectSQL, null);
    var x, _ = <xml>dt;
    println(x);

    dt = testDB.select(selectSQL, null);
    while (dt.hasNext()) {
        var result, _ = (RS)dt.getNext();
        println(result.id + "|" + result.binaryData.toString("UTF-8") + "|" + result.varbinaryData.toString("UTF-8") +
                "|" + result.tinyBlobData.toString("UTF-8") + "|" + result.blobData.toString("UTF-8") + "|" +
                result.mediumBlobData.toString("UTF-8") + "|" + result.longBlobData.toString("UTF-8") + "|");
    }

    ret = testDB.update("DROP table TestData", null);
    println("Table TestData Drop status:" + ret);

    testDB.close();
    println("Connector shut downs successfully..");
}
