This samples demonstrates the  local transaction supportt using wso2 dss and ballerina.

Versions : DSS 3.5.1
		   Ballerina 0.92
		   MySQL DB

MySQL Database is used with Table named "Customers" and "Salary"

CREATE TABLE Customers (
	customerId INT(6),
	firstName VARCHAR(30) NOT NULL,
	lastName VARCHAR(30) NOT NULL,
	registrationID INT(6)
) 

Create Table Salary (customerId INT(6),month_salary FLOAT);

=========================================================================================================

Ballerina Sample:
----------------

Sample Request : http://localhost:9090/TestLocalTx/InsertDataRes
Http Method : POST
Request Headers : Content-Type : application/json
Payload:

{
	"p0_customerId": 1,
	"p1_firstName": "Doe",
	"p2_lastName": "John",
	"p3_registrationID": 10,
	"p4_month_salary": 30025.50
}