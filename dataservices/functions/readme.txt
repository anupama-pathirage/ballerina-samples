This samples demonstrates the database function call support using wso2 dss and ballerina.

A stored function is a special kind stored program that returns a single value.

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

CREATE FUNCTION CustomerLevel(p_id INT) RETURNS VARCHAR(10)
    DETERMINISTIC
BEGIN
DECLARE lvl varchar(10);
    DECLARE regid int;

	Select registrationID into regid from Customers where customerid = p_id;

    IF regid > 100 THEN
 	SET lvl = 'SENIOR';
    ELSEIF regid <= 100 THEN
        SET lvl = 'NEWCOMER';
    END IF;

 RETURN (lvl);


Ballerina Sample:
----------------------
Sample Request : http://localhost:9090/testds/testservice
Http Method : POST

Request:

<id>1</id>

Response:

<results>
   <result>
      <level>NEWCOMER</level>
   </result>
</results>

DSS Sample
---------------------

Sample soap request body
<body>
   <p:testservice xmlns:p="http://ws.wso2.org/dataservice">
      <!--Exactly 1 occurrence-->
      <p:id>1</p:id>
   </p:testservice>
</body>

sample soap response

<results xmlns="http://ws.wso2.org/dataservice">
   <result>
      <level>NEWCOMER</level>
   </result>
</results>