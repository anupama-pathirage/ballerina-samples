This samples demonstrates the nested query support using wso2 dss and ballerina.

Versions : DSS 3.5.1
		   Ballerina 0.92

MySQL Database is used with Tables named "Customers" and "Orders"

CREATE TABLE Customers (
	customerId INT(6),
	firstName VARCHAR(30) NOT NULL,
	lastName VARCHAR(30) NOT NULL,
	registrationID INT(6)
)

insert into Customers (customerId, firstName, lastName, registrationID) values (1, 'John', 'Thomes', 100);

insert into Customers (customerId, firstName, lastName, registrationID) values (2, 'Anne', 'Paul', 200);

CREATE TABLE Orders (
	orderNumber INT(6),
	status VARCHAR(30) NOT NULL,
	customerNumber INT(6)
)

insert into Orders(orderNumber, status, customerNumber) values (1,'active', 1);
insert into Orders(orderNumber, status, customerNumber) values (2,'active', 1);
insert into Orders(orderNumber, status, customerNumber) values (3,'failed', 1);
insert into Orders(orderNumber, status, customerNumber) values (4,'active', 2);
insert into Orders(orderNumber, status, customerNumber) values (5,'suspend', 2);
insert into Orders(orderNumber, status, customerNumber) values (6,'failed', 2);

Ballerina Sample:
----------
Sample Request : http://localhost:9090/testds/testservicequery
or
http://localhost:9090/testds/testservicevar
Http Method : GET
Response:

[{
	"orderNumber": 1,
	"status": "active",
	"customerNumber": 1,
	"firstName": "John"
}, {
	"orderNumber": 2,
	"status": "active",
	"customerNumber": 1,
	"firstName": "John"
}, {
	"orderNumber": 3,
	"status": "failed",
	"customerNumber": 1,
	"firstName": "John"
}, {
	"orderNumber": 4,
	"status": "active",
	"customerNumber": 2,
	"firstName": "Anne"
}, {
	"orderNumber": 5,
	"status": "suspend",
	"customerNumber": 2,
	"firstName": "Anne"
}, {
	"orderNumber": 6,
	"status": "failed",
	"customerNumber": 2,
	"firstName": "Anne"
}]

=========================================================================================================

DSS Sample:
----------------
