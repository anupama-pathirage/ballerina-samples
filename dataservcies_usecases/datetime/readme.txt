This samples demonstrates the datetime support using ballerina.

Versions : Ballerina 0.94

MySQL Database is used with Table named "StockOrders"

CREATE TABLE StockOrders (
  orderId INT(6),
  LUT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

Insert into StockOrders(orderId) values(1);

Ballerina Sample:
----------
Sample Request : http://localhost:9090/testds/jsondata
Http Method : GET
Response:

[{"orderId":1,"LUT":"2017-09-17 20:33:25.0"}]

---------------------------------------
Sample Request : http://localhost:9090/testds/stringdata
Http Method : GET
Response:

2017-09-17T20:33:25.000+05:30|

--------------------------------------

Sample Request : http://localhost:9090/testds/adddata
Http Method : GET
Response:

[{
	"orderId": 1,
	"LUT": "2017-09-17 20:33:25.0"
}, {
	"orderId": 2,
	"LUT": "2017-01-30 13:27:01.0"
}, {
	"orderId": 3,
	"LUT": "2017-01-30 13:27:01.0"
}, {
	"orderId": 4,
	"LUT": "2017-01-30 13:27:01.0"
}]