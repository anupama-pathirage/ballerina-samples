import ballerina.net.http;
import ballerina.data.sql;
import ballerina.lang.messages;

@http:configuration {basePath:"/testdefaultds"}
service<http> TestStreaming {

    sql:ClientConnector testDBMySQL     = create sql:ClientConnector(sql:MYSQL, "localhost", 3306, "testdb", "root", "root", null);
    sql:ClientConnector testDBMSSQL     = create sql:ClientConnector(sql:SQLSERVER, "localhost", 1433, "testdb", "root", "root", null);
    sql:ClientConnector testDBORCLE     = create sql:ClientConnector(sql:ORACLE, "localhost", 1521, "testdb", "root", "root", null);
    sql:ClientConnector testDBSYBASE    = create sql:ClientConnector(sql:SYBASE, "localhost", 5000, "testdb", "root", "root", null);
    sql:ClientConnector testDBPG        = create sql:ClientConnector(sql:POSTGRE, "localhost", 5432, "testdb", "root", "root", null);
    sql:ClientConnector testDBDB2       = create sql:ClientConnector(sql:IBMDB2, "localhost", 50000, "testdb", "root", "root", null);
    sql:ClientConnector testDBHSQLSVR   = create sql:ClientConnector(sql:HSQLDB_SERVER, "localhost", 9001, "testdb", "root", "root", null);
    sql:ClientConnector testDBHSQLFILE  = create sql:ClientConnector(sql:HSQLDB_FILE, "./target/tempdb/", 0, "testdb", "root", "root", null);
    sql:ClientConnector testDBH2SVR     = create sql:ClientConnector(sql:H2_SERVER, "localhost", 9092, "testdb", "root", "root", null);
    sql:ClientConnector testDBH2FILE    = create sql:ClientConnector(sql:H2_FILE, "./target/tempdb/", 0, "testdb", "root", "root", null);
    sql:ClientConnector testDBDERBYSVR  = create sql:ClientConnector(sql:DERBY_SERVER, "localhost", 1527, "testdb", "root", "root", null);
    sql:ClientConnector testDBDERBYFILE = create sql:ClientConnector(sql:DERBY_FILE, "./target/tempdb/", 0, "testdb", "root", "root", null);


    @http:resourceConfig {
        methods:["GET"],
        path:"/testservice"
    }
    resource testJson (message m) {
        datatable dt = testDBMySQL.select("SELECT * FROM Customers", null);
        message response = {};
        var result, _ = <json>dt;
        messages:setJsonPayload(response, result);
        reply response;
    }
}
