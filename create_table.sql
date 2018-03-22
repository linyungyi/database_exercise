CREATE TABLE TEST.MEMBER2
(
	"CUSTOMERID" VARCHAR2(15) NOT NULL, 
    	"PREPAY_FLAG" NUMBER(1) NOT NULL, 
    	"BYWEEKEND" NUMBER(1) NOT NULL, 
    	"BYDAY" NUMBER(1) NOT NULL, 
    	"BYTIME" NUMBER(1) NOT NULL, 
    	"BYCALLING" NUMBER(1) NOT NULL, 
    	"DEFAULT_FILE" VARCHAR2(6) NOT NULL, 
    	"STATUS" NUMBER(1) NOT NULL, 
    	"VOICE_MAIL_NO" VARCHAR2(20),
	"TYPE" varchar2(2) NOT NULL
)
PARTITION BY LIST ( TYPE )
(
	partition "test1" values('a')
		tablespace test1,
	partition "test2" values('b')
		tablespace test2,
	partition "test3" values('c')
		tablespace test3,
	partition "test4" values('d')
		tablespace test4,
	partition "test5" values('e')
		tablespace test5
);