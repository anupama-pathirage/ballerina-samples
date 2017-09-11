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

Ballerina Sample:
----------------------
Sample Request : http://localhost:9090/testds/testservice
Http Method : POST

Request:

<DynamicQueryTest>
      <columns>customerId,firstName</columns>
      <table>Customers</table>
      <whereclause>registrationID = 200</whereclause>
</DynamicQueryTest>


Response:

<results>
   <result>
      <customerId>2</customerId>
      <firstName>Anne</firstName>
   </result>
</results>

DSS Sample
---------------------

Sample soap request body
<body>
   <p:TestDynamicQuery xmlns:p="http://ws.wso2.org/dataservice">
      <!--Exactly 1 occurrence-->
      <p:columns>customerId,firstName</p:columns>
      <!--Exactly 1 occurrence-->
      <p:table>Customers</p:table>
      <!--Exactly 1 occurrence-->
      <p:whereclause>registrationID = 200</p:whereclause>
   </p:TestDynamicQuery>
</body>

sample soap response

<results xmlns="http://ws.wso2.org/dataservice">
   <result>
      <customerId>2</customerId>
      <firstName>Anne</firstName>
   </result>
</results>