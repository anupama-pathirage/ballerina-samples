import ballerina.net.http;
import ballerina.data.sql;
import ballerina.lang.messages;

@http:configuration {basePath:"/testds"}
service<http> TestDS {
    sql:ConnectionProperties properties = {url:"jdbc:mysql://localhost:3306/testdb",
                                              driverClassName:"com.mysql.jdbc.Driver", maximumPoolSize:1,
                                              idleTimeout:600000, connectionTimeout:30000, autoCommit:true, maxLifetime:1800000,
                                              minimumIdle:1, poolName:"testNySQLPool", isolateInternalQueries:false,
                                              allowPoolSuspension:false, readOnly:false, validationTimeout:5000, leakDetectionThreshold:0,
                                              connectionInitSql:"SELECT 1",
                                              transactionIsolation:"TRANSACTION_READ_COMMITTED", catalog:"testdb",
                                              connectionTestQuery:"SELECT 1"};
    sql:ClientConnector testDB     = create sql:ClientConnector("", "", 0, "", "root", "root", properties);

    @http:resourceConfig {
        methods:["GET"],
        path:"/testservice"
    }
    resource testJson (message m) {
        datatable dt = testDB.select("SELECT * FROM Customers", null);
        message response = {};
        var result, _ = <json>dt;
        messages:setJsonPayload(response, result);
        reply response;
    }
}
