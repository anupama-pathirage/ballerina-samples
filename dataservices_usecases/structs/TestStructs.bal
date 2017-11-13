import ballerina.data.sql;

struct customtype {
    int i;
    float j;
    string s;
    int k;
    float l;
    string m;
}

struct RS {
    string structdata;
}

function main (string[] args) {
    endpoint<sql:ClientConnector> testDB {
         create sql:ClientConnector(
            sql:ORACLE, "localhost", 0, "xe", "system", "oracle", {maximumPoolSize:5});
    }

    int ret = testDB.update("CREATE TYPE customtype AS object (field1 NUMBER(5),field2 NUMBER(9,2), field3 varchar(50), field5 NUMBER(5),field6 NUMBER(9,2), field7 varchar(50))", null);
    println("Type creation status:" + ret);

    ret = testDB.update("CREATE TABLE structdatatable(id number(20), structdata customtype)", null);
    println("Table creation status:" + ret);

    customtype t = {i : 10, j : 2.3, s : "test",k : 11, l : 12.3, m : "test2"};
    sql:Parameter para1 = {sqlType:"integer", value:"3", direction:0};
    sql:Parameter para2 = {sqlType:"struct", value:t, direction:0};

    sql:Parameter[] parameters = [para1, para2];

    ret = testDB.update("INSERT INTO structdatatable(id,structdata) VALUES (?,?)", parameters);
    println(ret);

    ret = testDB.update("DROP table structdatatable", null);
    println("Table Drop status:" + ret);

    ret = testDB.update("DROP type customtype", null);
    println("Type Drop status:" + ret);

    testDB.close();
    println("Connector shut downs successfully");

}
