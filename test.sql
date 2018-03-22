CREATE TABLE albert.MEMBER2
(
	"CUSTOMERID" VARCHAR2(15) NOT NULL, 
	"TYPE" varchar2(2) NOT NULL
)
PARTITION BY LIST ( TYPE )
(
	partition albert1 values('a')
		tablespace albert1,
	partition albert2 values('b')
		tablespace albert2
);