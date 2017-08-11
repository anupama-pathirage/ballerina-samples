This samples demonstrates the batch request support using wso2 dss and ballerina.

MySQL Database is used with Table named "Customers"

CREATE TABLE Customers (
	customerId INT(6),
	firstName VARCHAR(30) NOT NULL,
	lastName VARCHAR(30) NOT NULL,
	registrationID INT(6)
) 

DSS Sample:
----------
Sample Request : http://localhost:9763/services/TestBatchRequests/InsertDataRes_batch_req
Http Method : POST
Request Headers : Content-Type : application/json
Payload:

{
    "_postinsertdatares_batch_req": {
        "_postinsertdatares": [{
                "p0_customerId": 1,
                "p1_firstName": "Doe",
                "p2_lastName": "John",
                "p3_registrationID": 10
            },
            {
                "p0_customerId": 2,
                "p1_firstName": "Anne",
                "p2_lastName": "John",
                "p3_registrationID": 100
            }
        ]
    }
}

=========================================================================================================

Ballerina Sample:
----------------

Sample Request : http://localhost:9090/TestBatchRequests/InsertDataRes
Http Method : POST
Request Headers : Content-Type : application/json
Payload:

 [{
 		"p0_customerId": 1,
 		"p1_firstName": "Doe",
 		"p2_lastName": "John",
 		"p3_registrationID": 10
 	},
 	{
 		"p0_customerId": 2,
 		"p1_firstName": "Anne",
 		"p2_lastName": "John",
 		"p3_registrationID": 100
 	}
 ]
