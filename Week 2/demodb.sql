CREATE USER demo
IDENTIFIED BY p4ssw0rd
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA 10M ON users;

GRANT connect to demo;
GRANT resource to demo;
GRANT create session to demo;
GRANT create table to demo;
GRANT create view to demo;

CONN demo/p4ssw0rd;

/*This is DDL*/
create table "PERSON" (
    P_ID NUMBER PRIMARY KEY,
    P_NAME VARCHAR2(200),
    P_AGE INTEGER,
    P_STATE VARCHAR2(50)
);

/*Alter table*/
ALTER TABLE PERSON 
    MODIFY P_ID INTEGER;
    
/*Adding data (DML)*/
INSERT INTO PERSON VALUES(1, 'Bob', 26, 'HI');
Insert into person values(2, 'Sam', 21, 'MA');
insert into person(p_id, P_NAME) values(4, 'Mike');

/*Queries (DML/DQL)*/
SELECT * FROM PERSON;
SELECT P_ID, P_NAME FROM PERSON;

/*CAN USE operators on numerics, or join chars with +*/
SELECT P_AGE * P_AGE FROM PERSON;
SELECT P_AGE * P_AGE AS AGESQUARED FROM PERSON;

/*Alias keyword AS*/
SELECT 'FIRST NAME', P_NAME FROM PERSON;
SELECT P_NAME AS FIRST_NAME, P_STATE FROM PERSON;

/*Group By: reduce rows to distinct values*/
INSERT INTO PERSON VALUES (5, 'Sarah', 31, 'HI');
SELECT P_STATE FROM PERSON
    GROUP BY P_STATE;
    
/*Aggregate functions (AVG, MIN, MAX, SUM, COUNT)
  Performs an action on entire column*/
SELECT AVG(P_AGE), P_STATE FROM PERSON GROUP BY P_STATE;
SELECT COUNT(P_STATE), P_STATE FROM PERSON GROUP BY P_STATE;

/*Scalar functions, operate on individual entries (LOWER, UPPER, NVL)*/
SELECT UPPER(P_NAME) FROM PERSON;
SELECT LOWER(P_NAME) FROM PERSON WHERE P_ID = 5;
SELECT NVL(P_AGE, 0) FROM PERSON;

/*Order By*/
SELECT * FROM PERSON ORDER BY P_NAME;
SELECT * FROM PERSON ORDER BY P_ID DESC;
SELECT * FROM PERSON ORDER BY P_AGE, P_STATE ASC;
INSERT INTO PERSON VALUES (6, 'Bob', 22, 'AL');
INSERT INTO PERSON VALUES (7, 'Jack', 26, 'TX');
SELECT P_AGE, P_NAME FROM PERSON GROUP BY P_AGE, P_NAME ORDER BY P_AGE;

/*WHERE vs. HAVING*/
SELECT * FROM PERSON WHERE P_AGE != 26;
SELECT P_STATE, AVG(P_AGE) FROM PERSON GROUP BY P_STATE HAVING AVG(P_AGE) > 27;
--Having is for aggregate functions with group by clauses

/*Joins*/
CREATE TABLE DEPARTMENT (
    D_ID INTEGER PRIMARY KEY,
    D_NAME VARCHAR2(100) NOT NULL
);

CREATE TABLE PHONE_NUMBERS (
    P_ID INTEGER PRIMARY KEY,
    P_NUMBER VARCHAR2(20)
);

CREATE TABLE EMPLOYEES (
    E_ID INTEGER PRIMARY KEY,
    E_NAME VARCHAR2(2000) NOT NULL,
    E_HIRED DATE,
    E_DEPT INTEGER,
    E_PHONE INTEGER UNIQUE,
    FOREIGN KEY (E_DEPT) REFERENCES DEPARTMENT(D_ID),
    FOREIGN KEY (E_PHONE) REFERENCES PHONE_NUMBERS(P_ID)
);

INSERT INTO DEPARTMENT VALUES (1, 'SALES');
INSERT INTO DEPARTMENT VALUES (2, 'HR');
INSERT INTO DEPARTMENT VALUES (3, 'TRAINING');

INSERT INTO PHONE_NUMBERS VALUES (100, '(281) 586-4839');
INSERT INTO PHONE_NUMBERS VALUES (101, '(285) 574-0374');
INSERT INTO PHONE_NUMBERS VALUES (102, '(249) 587-4739');
INSERT INTO PHONE_NUMBERS VALUES (103, '(555) 555-5555');
INSERT INTO PHONE_NUMBERS VALUES (104, '(859) 398-3984');

INSERT INTO EMPLOYEES 
    VALUES (1, 'JOHN', CURRENT_TIMESTAMP, 1, 100);
INSERT INTO EMPLOYEES
    VALUES (2, 'JAKE', CURRENT_TIMESTAMP, 2, 101);
INSERT INTO EMPLOYEES
    VALUES (3, 'JOE', CURRENT_TIMESTAMP, 3, 102);
INSERT INTO EMPLOYEES
    VALUES (4, 'JIM', CURRENT_TIMESTAMP, 1, 103);
INSERT INTO EMPLOYEES
    VALUES (5, 'JAMES', CURRENT_TIMESTAMP, 2, 104);
    
/*Inner join: TableA INNER JOIN Table B ON FK = PK*/
SELECT E_NAME, D_NAME FROM DEPARTMENT INNER JOIN EMPLOYEES
    ON E_DEPT = D_ID;
SELECT * FROM DEPARTMENT INNER JOIN EMPLOYEES ON E_DEPT = D_ID;

/*Aliasing with Joins*/
SELECT DEPT.D_NAME, EMP.E_NAME
FROM DEPARTMENT DEPT
INNER JOIN EMPLOYEES EMP
ON EMP.E_DEPT = DEPT.D_ID;

/*Join all tables, show everyone in sales with phone number*/
SELECT E_NAME EmpName, P_NUMBER Cell
FROM DEPARTMENT INNER JOIN EMPLOYEES
ON E_DEPT = D_ID
INNER JOIN PHONE_NUMBERS
ON E_PHONE = P_ID
WHERE D_NAME = 'SALES';

/*AND, OR keywords for expressions*/
SELECT * FROM EMPLOYEES 
WHERE E_NAME = 'JOHN' OR E_NAME = 'JIM';

SELECT * FROM DEPARTMENT
WHERE D_NAME = 'SALES' OR D_ID = 2;

/*UNIONS: select statement + select statement*/
SELECT * FROM EMPLOYEES WHERE E_NAME = 'JOHN'
UNION
SELECT * FROM EMPLOYEES WHERE E_PHONE = 101;

/*Cross Joins: Cartesian joins*/
SELECT * FROM EMPLOYEES CROSS JOIN DEPARTMENT;
SELECT * FROM PHONE_NUMBERS CROSS JOIN DEPARTMENT;

/*TRUNCATE: deletes all rows, but keeps columns*/
TRUNCATE TABLE PERSON;

/*DROP: erases table from existence*/
DROP TABLE PERSON;

/*Constraints: Primary Key, Foreign Key, Not Null
    Unique, Default, Check*/
CREATE TABLE PERSON (
    P_ID INTEGER PRIMARY KEY,
    P_NAME VARCHAR2(100) NOT NULL,
    P_AGE INTEGER CHECK(P_AGE > 18),
    P_COUNTRY VARCHAR2(100) DEFAULT 'USA',
    P_SSN NUMBER UNIQUE
);

INSERT INTO PERSON VALUES (1, 'Sam', 19, '', 1);
INSERT INTO PERSON(P_ID, P_NAME, P_AGE, P_SSN)
    VALUES (2, 'John', 20, 2);
INSERT INTO PERSON VALUES (3, 'Jack', 25, 'Canada', 3);

/*IN operator: allows you to specify values in WHERE,
    same as multiple OR conditions*/
SELECT * FROM DEPARTMENT WHERE D_NAME IN ('SALES', 'HR');
SELECT * FROM EMPLOYEES WHERE E_DEPT IN
    (SELECT E_DEPT FROM EMPLOYEES WHERE E_DEPT = 1);
    
/*EXISTS operator: test for existence, returns true
    if one or more returned*/
SELECT * FROM EMPLOYEES WHERE EXISTS
    (SELECT D_NAME FROM DEPARTMENT WHERE D_ID = 2);  
    
    
/*PL/SQL*/
CREATE TABLE CAVE (
    Cave_Id INTEGER PRIMARY KEY,
    Cave_Name VARCHAR2(50),
    Max_Bears INTEGER DEFAULT 4,
    CONSTRAINT Unique_Cave_Name UNIQUE (Cave_Name)
);

CREATE TABLE BEAR_TYPE (
    Bear_Type_Id INTEGER PRIMARY KEY,
    Bear_Type_Name VARCHAR2(50)
);

CREATE TABLE BEAR (
    Bear_Id INTEGER PRIMARY KEY,
    Bear_Name VARCHAR2(50),
    Bear_Age INTEGER,
    Bear_Weight Integer,
    Bear_Type_Id INTEGER,
    Cave_Id INTEGER,
    CONSTRAINT Check_Bear_Age CHECK (Bear_Age > 0),
    CONSTRAINT Check_Bear_Weight CHECK (Bear_Weight > 0)
);

CREATE TABLE BEEHIVE (
    Beehive_Id INTEGER PRIMARY KEY,
    Hive_Weight INTEGER DEFAULT 50,
    CONSTRAINT Check_Hive_Weight CHECK (Hive_Weight > 0)
);

CREATE TABLE BEAR_BEEHIVE (
    Bear_Id INTEGER,
    Beehive_Id INTEGER,
    CONSTRAINT FK_BearBeehive PRIMARY KEY (Bear_Id, Beehive_Id)
);

--Create foreign keys
ALTER TABLE BEAR ADD CONSTRAINT FK_Bear_Type_Id
FOREIGN KEY (Bear_Type_Id)
REFERENCES BEAR_TYPE (Bear_Type_Id);

ALTER TABLE BEAR ADD CONSTRAINT FK_Cave_Id
FOREIGN KEY (Cave_Id)
REFERENCES CAVE (Cave_Id);

ALTER TABLE BEAR_BEEHIVE ADD CONSTRAINT FK_Bear_Id
FOREIGN KEY (Bear_Id)
REFERENCES BEAR (Bear_Id);

ALTER TABLE BEAR_BEEHIVE ADD CONSTRAINT FK_Beehive_Id
FOREIGN KEY (Beehive_Id)
REFERENCES BEEHIVE (Beehive_Id);

--Populate
INSERT INTO CAVE (Cave_Id, Cave_Name, Max_Bears)
VALUES (1, 'Yosemite', 4);
INSERT INTO CAVE (Cave_Id, Cave_Name, Max_Bears)
VALUES (2, 'Yellowstone', 5);

INSERT INTO BEEHIVE VALUES (1, 35);
INSERT INTO BEEHIVE VALUES (2, 50);

INSERT INTO BEAR_TYPE (Bear_Type_Id, Bear_Type_Name)
VALUES (1, 'Picnic');

INSERT INTO BEAR (Bear_Id, Bear_Name, Bear_Age, Bear_Weight, Bear_Type_Id, Cave_Id)
Values (1, 'Yogi', 30, 200, 1, 1);
INSERT INTO BEAR (Bear_Id, Bear_Name, Bear_Age, Bear_Weight, Bear_Type_Id, Cave_Id)
Values (2, 'Boo Boo', 20, 100, 1, 1);

INSERT INTO BEAR_BEEHIVE VALUES(1, 2);

/*Sequences*/
CREATE SEQUENCE SQ_BEAR_PK
START WITH 3
INCREMENT BY 2;

--Create before insert trigger
CREATE OR REPLACE TRIGGER TR_INSERT_BEAR
BEFORE INSERT ON BEAR
FOR EACH ROW
BEGIN
    SELECT SQ_BEAR_PK.NEXTVAL
    INTO :NEW.Bear_Id FROM DUAL;
END;
/

--Create View to show how many bears per cave
CREATE VIEW VW_BEARS_PER_CAVE (Location, Total) AS
SELECT Cave_Name, COUNT(Bear_Id) FROM CAVE, BEAR
WHERE BEAR.Cave_Id = CAVE.Cave_Id
GROUP BY Cave_Name;

SELECT * FROM VW_BEARS_PER_CAVE;

--Functions
CREATE OR REPLACE FUNCTION
FIND_MAX_NUMBER(X IN NUMBER, Y IN NUMBER)
RETURN NUMBER AS Z NUMBER;
BEGIN
    IF X > Y THEN Z:=X;
    ELSE Z:=Y; END IF;
    RETURN Z;
END;
/

--Run function
DECLARE
    FIRST_NUM NUMBER;
    SECOND_NUM NUMBER;
    MAX_NUM NUMBER;
BEGIN
    FIRST_NUM:=22;
    SECOND_NUM:=42;
    MAX_NUM:= FIND_MAX_NUMBER(FIRST_NUM, SECOND_NUM);
    DBMS_OUTPUT.PUT_LINE('MAX= '||MAX_NUM);
END;
/

--Function with characters
CREATE OR REPLACE FUNCTION
FIND_MAX_CHAR (X IN VARCHAR2, Y IN VARCHAR2)
RETURN VARCHAR2 AS Z VARCHAR2(4);
BEGIN
    IF X>Y THEN Z:=X;
    ELSE Z:=Y; END IF;
    RETURN Z;
END;
/
--Use it
DECLARE
    FIRST_CHAR VARCHAR2(4);
    SECOND_CHAR VARCHAR2(4);
    MAX_CHAR VARCHAR2(4);
BEGIN
    FIRST_CHAR:='A';
    SECOND_CHAR:='Z';
    MAX_CHAR:=FIND_MAX_CHAR (FIRST_CHAR, SECOND_CHAR);
    DBMS_OUTPUT.PUT_LINE('MAX = '||MAX_CHAR);
END;

--Stored Procedures
CREATE OR REPLACE PROCEDURE HELLO_WORLD_SP IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/

BEGIN
    HELLO_WORLD_SP;
END;
/

--Cursors
CREATE OR REPLACE PROCEDURE
GET_ALL_BEARS(S OUT SYS_REFCURSOR) AS
BEGIN
    OPEN S FOR
    SELECT BEAR_ID, BEAR_NAME FROM BEAR;
END;
/

DECLARE
    S SYS_REFCURSOR;
    SOME_ID BEAR.BEAR_ID%TYPE;
    SOME_NAME BEAR.BEAR_NAME%TYPE;
BEGIN
    GET_ALL_BEARS(S);
    LOOP
        FETCH S INTO SOME_ID, SOME_NAME;
        EXIT WHEN S%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(SOME_ID||'IS CURRENT ID, '||SOME_NAME||' IS CURRENT NAME');
    END LOOP;
    CLOSE S;
END;
/

/*Stored Procedure SP_FEED_BEAR
INPUTS: BEAR_ID, BEEHIVE_ID, HONEY_AMT
CHECK BEAR/HIVE PAIR VALIDITY
INCREASE/DECREASE HIVE/BEAR_WEIGHT BY HONEY_AMT
DBMS_OUTPUT RESULT*/
CREATE OR REPLACE PROCEDURE
SP_FEED_BEAR(B_ID IN NUMBER, H_ID IN NUMBER, HONEY_AMT IN NUMBER) AS
BEGIN
    IF TRUE THEN
        DBMS_OUTPUT.PUT_LINE('VALID PAIR');
    ELSE
        DBMS_OUTPUT.PUT_LINE('INVALID PAIR');
    END IF;
    
    --SAVEPOINT; 
    UPDATE BEEHIVE SET HIVE_WEIGHT = HIVE_WEIGHT - HONEY_AMT
        WHERE BEEHIVE_ID = H_ID;
    UPDATE BEAR SET BEAR_WEIGHT = BEAR_WEIGHT + HONEY_AMT
        WHERE BEAR_ID = B_ID;
        
    DBMS_OUTPUT.PUT_LINE('FED BEAR '||HONEY_AMT|| 'LBS');
    COMMIT;
    
    EXCEPTION
        WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('FAILED TO FEED BEAR');
        ROLLBACK;
END;
/

BEGIN
    SP_FEED_BEAR(1, 1, 5);
END;
/

SELECT * FROM BEAR, BEEHIVE;

Commit;
