This samples demonstrates the  distributted transaction support using wso2 dss and ballerina.

Versions : DSS 3.5.1
		   Ballerina 0.93
		   MySQL DB

Two MySQL Databases are used with Table named "Customers" in first database and table "Salary" in the second database

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

Sample Request : http://localhost:9090/TestXATx/InsertDataRes
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