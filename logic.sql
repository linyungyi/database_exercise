CREATE OR REPLACE  FUNCTION "SCPVIP"."SYS_RING"    RETURN 
    VARCHAR2
    IS
  RING VARCHAR2(6);
BEGIN
  SELECT COUNT(*) INTO RING FROM VIP_CONFIG WHERE CONFIG_NAME = 'DF_RING_ID';
  IF(RING = 0)
    THEN RETURN '999999';
  END IF;

  SELECT CONFIG_VALUE INTO RING FROM (SELECT CONFIG_VALUE, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_CONFIG WHERE CONFIG_NAME = 'DF_RING_ID') WHERE X = 0;
  RETURN RING;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."RULE_ID2RING"    (MSISDN_IN
    
    IN VARCHAR2, RULEID_IN IN NUMBER)
 RETURN VARCHAR2 IS
  RING VARCHAR2(6);
BEGIN
  IF(RULEID_IN = 0) THEN
    SELECT COUNT(*) INTO RING FROM VIP_TONE0 WHERE MSISDN = MSISDN_IN;
    IF(RING = 0)
      THEN RETURN NULL;
    END IF;
    SELECT RING_ID INTO RING FROM (SELECT RING_ID, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_TONE0 WHERE MSISDN = MSISDN_IN) WHERE X = 0;
    RETURN RING;
  END IF;

  IF(RULEID_IN = 1) THEN
    SELECT COUNT(*) INTO RING FROM VIP_TONE1 WHERE MSISDN = MSISDN_IN;
    IF(RING = 0)
      THEN RETURN NULL;
    END IF;
    SELECT RING_ID INTO RING FROM (SELECT RING_ID, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_TONE1 WHERE MSISDN = MSISDN_IN) WHERE X = 0;
    RETURN RING;
  END IF;

  IF(RULEID_IN = 2) THEN
    SELECT COUNT(*) INTO RING FROM VIP_TONE2 WHERE MSISDN = MSISDN_IN;
    IF(RING = 0)
      THEN RETURN NULL;
    END IF;
    SELECT RING_ID INTO RING FROM (SELECT RING_ID, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_TONE2 WHERE MSISDN = MSISDN_IN) WHERE X = 0;
    RETURN RING;
  END IF;

  IF(RULEID_IN = 3) THEN
    SELECT COUNT(*) INTO RING FROM VIP_TONE3 WHERE MSISDN = MSISDN_IN;
    IF(RING = 0)
      THEN RETURN NULL;
    END IF;
    SELECT RING_ID INTO RING FROM (SELECT RING_ID, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_TONE3 WHERE MSISDN = MSISDN_IN) WHERE X = 0;
    RETURN RING;
  END IF;

  IF(RULEID_IN = 4) THEN
    SELECT COUNT(*) INTO RING FROM VIP_TONE4 WHERE MSISDN = MSISDN_IN;
    IF(RING = 0)
      THEN RETURN NULL;
    END IF;
    SELECT RING_ID INTO RING FROM (SELECT RING_ID, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_TONE4 WHERE MSISDN = MSISDN_IN) WHERE X = 0;
    RETURN RING;
  END IF;

  IF(RULEID_IN = 5) THEN
    SELECT COUNT(*) INTO RING FROM VIP_TONE5 WHERE MSISDN = MSISDN_IN;
    IF(RING = 0)
      THEN RETURN NULL;
    END IF;
    SELECT RING_ID INTO RING FROM (SELECT RING_ID, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_TONE5 WHERE MSISDN = MSISDN_IN) WHERE X = 0;
    RETURN RING;
  END IF;

  IF(RULEID_IN = 6) THEN
    SELECT COUNT(*) INTO RING FROM VIP_TONE6 WHERE MSISDN = MSISDN_IN;
    IF(RING = 0)
      THEN RETURN NULL;
    END IF;
    SELECT RING_ID INTO RING FROM (SELECT RING_ID, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_TONE6 WHERE MSISDN = MSISDN_IN) WHERE X = 0;
    RETURN RING;
  END IF;

  IF(RULEID_IN = 7) THEN
    SELECT COUNT(*) INTO RING FROM VIP_TONE7 WHERE MSISDN = MSISDN_IN;
    IF(RING = 0)
      THEN RETURN NULL;
    END IF;
    SELECT RING_ID INTO RING FROM (SELECT RING_ID, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_TONE7 WHERE MSISDN = MSISDN_IN) WHERE X = 0;
    RETURN RING;
  END IF;

  IF(RULEID_IN = 8) THEN
    SELECT COUNT(*) INTO RING FROM VIP_TONE8 WHERE MSISDN = MSISDN_IN;
    IF(RING = 0)
      THEN RETURN NULL;
    END IF;
    SELECT RING_ID INTO RING FROM (SELECT RING_ID, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_TONE8 WHERE MSISDN = MSISDN_IN) WHERE X = 0;
    RETURN RING;
  END IF;

END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."HAS_RING2"    (MSISDN_IN IN
    
    VARCHAR2)
 RETURN NUMBER IS
  HAS_RING NUMBER(1);
BEGIN
  SELECT NOT_SET INTO HAS_RING FROM VIP_MEMBER WHERE MSISDN = MSISDN_IN;
     RETURN HAS_RING;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN -1 ;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."CLI2RULE_ID"    (MSISDN_IN 
    IN
    VARCHAR2, CALLER_IN IN VARCHAR2)
 RETURN NUMBER IS
  RULE_ID NUMBER(1);
BEGIN
  SELECT GROUP_ID INTO RULE_ID FROM VIP_CLI WHERE MSISDN = MSISDN_IN AND CALLER = CALLER_IN;
  IF RULE_ID >= 1
    THEN RETURN RULE_ID;
  ELSE
    RETURN 0;
  END IF;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."DAYTIME2RULE_ID"    RETURN 
    NUMBER
    IS
BEGIN
  IF TO_CHAR(SYSDATE, 'D') = 1 OR TO_CHAR(SYSDATE, 'D') = 7
    THEN RETURN 8;
  ELSE
    IF TO_CHAR(SYSDATE, 'HH24') >= 8 AND TO_CHAR(SYSDATE, 'HH24') < 18 
      THEN RETURN 6;
    ELSE RETURN 7;
    END IF;
  END IF;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."TIME2RULE_ID"    RETURN 
    NUMBER 
    IS
BEGIN
  IF TO_CHAR(SYSDATE, 'HH24') >= 8 AND TO_CHAR(SYSDATE, 'HH24') < 18 
      THEN RETURN 6;
    ELSE RETURN 7;
    END IF;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."PICKUP_RBT_RING"  
    (MSISDN_IN IN 
    VARCHAR2, CALLER_IN IN VARCHAR2
   )
 RETURN VARCHAR2 IS
   RING VARCHAR2(6); 
   HASRING NUMBER(2);
BEGIN
  SELECT HAS_RING2(MSISDN_IN) INTO HASRING FROM DUAL; 
  IF(HASRING = 0) THEN
 
    IF SUBSTR(MSISDN_IN,0,2) = '02' OR SUBSTR(MSISDN_IN,0,2) = '03' THEN
      RETURN 'V'||SYS_RING_N();
    ELSE
      RETURN 'V'||SYS_RING_S();
    END IF;
  
  ELSIF(HASRING = -1)
    THEN RETURN 'N';
  END IF;

  SELECT CLI2RULE_ID(MSISDN_IN, CALLER_IN) INTO HASRING FROM DUAL;
  IF HASRING IS NOT NULL
    THEN SELECT RULE_ID2RING(MSISDN_IN, HASRING) INTO RING FROM DUAL;
  END IF;
  IF RING IS NOT NULL
    THEN RETURN 'V'||RING;
  END IF;

  SELECT RULE_ID2RING(MSISDN_IN, DAYTIME2RULE_ID()) INTO RING FROM DUAL;
  IF RING IS NOT NULL
    THEN RETURN 'V'||RING;
  END IF;

  SELECT RULE_ID2RING(MSISDN_IN, TIME2RULE_ID()) INTO RING FROM DUAL;
  IF RING IS NOT NULL
    THEN RETURN 'V'||RING;
  END IF;
  
  SELECT RULE_ID2RING(MSISDN_IN, 0) INTO RING FROM DUAL;
  IF RING IS NOT NULL
    THEN RETURN 'V'||RING;
  END IF;
  
  IF SUBSTR(MSISDN_IN,0,2) = '02' OR SUBSTR(MSISDN_IN,0,2) = '03' THEN
   RETURN 'V'||SYS_RING_N();
  ELSE
   RETURN 'V'||SYS_RING_S();
  END IF;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."FIND_MASTER"    (MSISDN_IN 
    IN VARCHAR2)
 RETURN VARCHAR2 IS
   MASTER_MSISDN VARCHAR2(10); 
BEGIN
  SELECT SLAVE_MSISDN."MASTER" INTO MASTER_MSISDN FROM SLAVE_MSISDN WHERE SLAVE = MSISDN_IN; 
   RETURN MASTER_MSISDN;

EXCEPTION
  WHEN OTHERS THEN
    RETURN 'N';
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."PICKUP_RBT"   (MSISDN_IN IN
    
    VARCHAR2, CALLER_IN IN VARCHAR2
   )
 RETURN VARCHAR2 IS
   RING VARCHAR2(6); 
   MASTER_MSISDN VARCHAR2(10); 
BEGIN
  SELECT FIND_MASTER(MSISDN_IN) INTO MASTER_MSISDN FROM DUAL; 
  IF(MASTER_MSISDN = 'N') THEN
    RETURN PICKUP_RBT_RING(MSISDN_IN,CALLER_IN);
  ELSE 
    RETURN PICKUP_RBT_RING(MASTER_MSISDN,CALLER_IN);
  END IF;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."HAS_RING"    (MSISDN_IN IN 
    VARCHAR2)
 RETURN NUMBER IS
  HAS_RING NUMBER(1);
BEGIN
  SELECT COUNT(*) INTO HAS_RING FROM VIP_TONE0 WHERE MSISDN = MSISDN_IN;
  IF HAS_RING > 0 THEN RETURN 1;
  END IF;

  SELECT COUNT(*) INTO HAS_RING FROM VIP_TONE6 WHERE MSISDN = MSISDN_IN;
  IF HAS_RING > 0 THEN RETURN 1;
  END IF;

  SELECT COUNT(*) INTO HAS_RING FROM VIP_TONE7 WHERE MSISDN = MSISDN_IN;
  IF HAS_RING > 0 THEN RETURN 1;
  END IF;

  SELECT COUNT(*) INTO HAS_RING FROM VIP_TONE8 WHERE MSISDN = MSISDN_IN;
  IF HAS_RING > 0 THEN RETURN 1;
  END IF;

  SELECT COUNT(*) INTO HAS_RING FROM VIP_TONE1 WHERE MSISDN = MSISDN_IN;
  IF HAS_RING > 0 THEN RETURN 1;
  END IF;
  
  SELECT COUNT(*) INTO HAS_RING FROM VIP_TONE2 WHERE MSISDN = MSISDN_IN;
  IF HAS_RING > 0 THEN RETURN 1;
  END IF;

  SELECT COUNT(*) INTO HAS_RING FROM VIP_TONE3 WHERE MSISDN = MSISDN_IN;
  IF HAS_RING > 0 THEN RETURN 1;
  END IF;

  SELECT COUNT(*) INTO HAS_RING FROM VIP_TONE4 WHERE MSISDN = MSISDN_IN;
  IF HAS_RING > 0 THEN RETURN 1;
  END IF;

  SELECT COUNT(*) INTO HAS_RING FROM VIP_TONE5 WHERE MSISDN = MSISDN_IN;
  IF HAS_RING > 0 THEN RETURN 1;
  END IF;
  
  RETURN 0;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."GETRING_UNSHOW"    (CALLED 
    IN VARCHAR2, CALLER IN VARCHAR2)
 RETURN VARCHAR2 IS
  RING VARCHAR2(20);
  vicecallee VARCHAR2(10);
BEGIN
  SELECT PICKUP_RBT(CALLED,CALLER) INTO RING FROM DUAL;
            IF RING ='N'
               THEN RETURN 'NNN';
            ELSE
               RETURN 'NN'||RING;
            END IF;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."GETRING_BLOCK"   (CALLED IN
    
    VARCHAR2, CALLER IN VARCHAR2)
 RETURN VARCHAR2 IS
  RING VARCHAR2(20);
  vicecallee VARCHAR2(10);
BEGIN
  SELECT PICKUP_RBT(CALLED,CALLER) INTO RING FROM DUAL;
            IF RING ='N'
               THEN RETURN 'NNN';
            ELSE
               RETURN 'NN'||RING;
            END IF;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."CHECK_RING"    (RING_ID_IN 
    IN
    VARCHAR2)
 RETURN NUMBER IS
  OK NUMBER(1);
BEGIN
  SELECT COUNT(1) INTO OK FROM DUAL WHERE RING_ID_IN BETWEEN 000000 AND 999999;
  IF OK = 1 THEN RETURN 1;
  END IF;

  EXCEPTION WHEN OTHERS THEN 
  SELECT COUNT(1) INTO OK FROM DUAL WHERE 'TLREC0' = RING_ID_IN;
  IF OK = 1 THEN RETURN 1;
  END IF;

  RETURN 0;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."HAS_SLAVE"  (MSISDN_IN IN 
    VARCHAR2)
 RETURN NUMBER IS
  TOTAL NUMBER(4);
BEGIN
  --TOTAL:=0;
  SELECT COUNT(*) INTO TOTAL FROM SLAVE_MSISDN WHERE SLAVE_MSISDN."MASTER" = MSISDN_IN;
     RETURN TOTAL;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN 0 ;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."SYS_RING_N"  RETURN 
    VARCHAR2
    IS
  RING VARCHAR2(6);
BEGIN
  SELECT COUNT(*) INTO RING FROM VIP_CONFIG WHERE CONFIG_NAME = 'DF_RING_ID_N';
  IF(RING = 0)
    THEN RETURN '999999';
  END IF;

  SELECT CONFIG_VALUE INTO RING FROM (SELECT CONFIG_VALUE, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_CONFIG WHERE CONFIG_NAME = 'DF_RING_ID_N') WHERE X = 0;
  RETURN RING;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."SYS_RING_S"  RETURN 
    VARCHAR2
    IS
  RING VARCHAR2(6);
BEGIN
  SELECT COUNT(*) INTO RING FROM VIP_CONFIG WHERE CONFIG_NAME = 'DF_RING_ID_S';
  IF(RING = 0)
    THEN RETURN '999999';
  END IF;

  SELECT CONFIG_VALUE INTO RING FROM (SELECT CONFIG_VALUE, MOD(ROWNUM+TO_NUMBER(TO_CHAR(SYSDATE, 'SS')),RING) X FROM VIP_CONFIG WHERE CONFIG_NAME = 'DF_RING_ID_S') WHERE X = 0;
  RETURN RING;
END;
\

CREATE OR REPLACE  FUNCTION "SCPVIP"."PICKUP_RBT_RING_NEW"  
    (MSISDN_IN IN 
    VARCHAR2, CALLER_IN IN VARCHAR2
   )
 RETURN VARCHAR2 IS
   RING VARCHAR2(6); 
   HASRING NUMBER(2);
BEGIN
  SELECT HAS_RING2(MSISDN_IN) INTO HASRING FROM DUAL; 
  IF(HASRING = 0) THEN
 
    IF SUBSTR(MSISDN_IN,0,2) = '02' OR SUBSTR(MSISDN_IN,0,2) = '03' THEN
      RETURN 'V'||SYS_RING_N();
    ELSE
      RETURN 'V'||SYS_RING_S();
    END IF;
  
  ELSIF(HASRING = -1)
    THEN RETURN 'N';
  END IF;

  SELECT CLI2RULE_ID(MSISDN_IN, CALLER_IN) INTO HASRING FROM DUAL;
  IF HASRING IS NOT NULL
    THEN SELECT RULE_ID2RING(MSISDN_IN, HASRING) INTO RING FROM DUAL;
  END IF;
  IF RING IS NOT NULL
    THEN RETURN 'V'||RING;
  END IF;

  SELECT RULE_ID2RING(MSISDN_IN, DAYTIME2RULE_ID()) INTO RING FROM DUAL;
  IF RING IS NOT NULL
    THEN RETURN 'V'||RING;
  END IF;

  SELECT RULE_ID2RING(MSISDN_IN, TIME2RULE_ID()) INTO RING FROM DUAL;
  IF RING IS NOT NULL
    THEN RETURN 'V'||RING;
  END IF;
  
  SELECT RULE_ID2RING(MSISDN_IN, 0) INTO RING FROM DUAL;
  IF RING IS NOT NULL
    THEN RETURN 'V'||RING;
  END IF;
  
  IF SUBSTR(MSISDN_IN,0,2) = '02' OR SUBSTR(MSISDN_IN,0,2) = '03' THEN
   RETURN 'V'||SYS_RING_N();
  ELSE
   RETURN 'V'||SYS_RING_S();
  END IF;
END;
\