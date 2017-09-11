This samples demonstrates the data streaming support using wso2 dss and ballerina.

Versions : DSS 3.5.1
		   Ballerina 0.94


MySQL Database is used with Table named "Customers"

CREATE TABLE Customers (
	customerId INT(6),
	firstName VARCHAR(30) NOT NULL,
	lastName VARCHAR(30) NOT NULL,
	registrationID INT(6)
)

insert into Customers (customerId, firstName, lastName, registrationID) values (1, 'John', 'Thomes', 100);

insert into Customers (customerId, firstName, lastName, registrationID) values (2, 'Anne', 'Paul', 200);

Ballerina Sample:
----------
Sample Request : http://localhost:9090/testcustomds/testservice

Http Method : GET
Response:

[{
	"customerId": 1,
	"firstName": "John",
	"lastName": "Thomes",
	"registrationID": 100
}, {
	"customerId": 2,
	"firstName": "Anne",
	"lastName": "Paul",
	"registrationID": 200
}]