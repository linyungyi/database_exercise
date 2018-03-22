CREATE TABLE MEMBER3
(
	"CUSTOMERID" VARCHAR2(15) NOT NULL, 
	"TYPE" varchar2(2) 
)
PARTITION BY LIST( SUBSTR(customerid,0,2) )
(
	partition test21 values('21')
		tablespace test21,
	partition test22 values('22')
		tablespace test22
);
/