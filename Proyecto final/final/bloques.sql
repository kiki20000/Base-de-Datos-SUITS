connect e3/e3;
/* 1 */

CREATE OR REPLACE FUNCTION TOTAL_ESTUDIANTES(NUM_ABO ABOGADOS.TRAB_CODIGO%TYPE)
RETURN NUMBER
IS
    TOTAL NUMBER;
BEGIN 
    SELECT COUNT(*) INTO TOTAL
    FROM ESTUDIANTES
    WHERE UPPER(ABO_TRAB_CODIGO) = UPPER(NUM_ABO);
    
    RETURN TOTAL;
END;
/

/* 2 */

CREATE OR REPLACE FUNCTION TOTAL_CASOS(NUM_CAS ABOGADOS.TRAB_CODIGO%TYPE)
RETURN NUMBER
IS
    TOTAL NUMBER;
BEGIN 
    SELECT COUNT(*) INTO TOTAL
    FROM ATIENDE
    WHERE UPPER(ABO_TRAB_CODIGO) = UPPER(NUM_CAS);
    
    RETURN TOTAL;
END;
/

/* 3 */

SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE TOTAL_EXPEDIENTES_ABOGADO (NUM_ABO VARCHAR)
IS
    CURSOR AUX_CUR IS
        SELECT  CLIEN_DNI, COD_EXPEDIENTE
        FROM ATIENDE
        WHERE UPPER(ABO_TRAB_CODIGO) = UPPER(NUM_ABO)
        ORDER BY COD_EXPEDIENTE;
        
        EXISTE NUMBER;
        NOMBRE VARCHAR(10); 
BEGIN 
    EXISTE := 0;

    SELECT COUNT(*) INTO EXISTE
    FROM ABOGADOS
    WHERE UPPER(TRAB_CODIGO)= UPPER(NUM_ABO);

    IF EXISTE = 0 THEN
        DBMS_OUTPUT.PUT_LINE('NO HEMOS ENCONTRADO AL ABOGADO CON EL CODIGO: ' || NUM_ABO);
    ELSE
        SELECT NOMBRE INTO NOMBRE
        FROM TRABAJADORES
        WHERE UPPER(CODIGO) = UPPER(NUM_ABO);
    
        DBMS_OUTPUT.PUT_LINE('-----------------------');
        DBMS_OUTPUT.PUT_LINE('EL ABOGADO: ' || NOMBRE || ' Y EL CODIGO ' || NUM_ABO);
        DBMS_OUTPUT.PUT_LINE('-----------------------');
        
        FOR AUX IN AUX_CUR LOOP
            DBMS_OUTPUT.PUT_LINE(AUX.CLIEN_DNI || ' ' || AUX.COD_EXPEDIENTE);
        END LOOP;
    END IF;
END;
/

/* 4 */

SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE LISTADO_VISITAS (NUM_ABO VARCHAR, DNI_DE VARCHAR)
IS
    CURSOR AUX_CUR IS
        SELECT COD_EXPEDIENTE, FECHA_VISITA
        FROM VISITAR
        WHERE UPPER(ABO_TRAB_CODIGO) = UPPER(NUM_ABO) AND UPPER(DNI_DEMANDANTE) = UPPER(DNI_DE)
        ORDER BY COD_EXPEDIENTE;
        
        CONTADOR NUMBER := 0; 
        
BEGIN     
        DBMS_OUTPUT.PUT_LINE('-----------------------');
        DBMS_OUTPUT.PUT_LINE('EL ABOGADO: ' || NUM_ABO || ' SE REUNIO CON EL DEMANDANTE: ' || dni_de);
        DBMS_OUTPUT.PUT_LINE('-----------------------');
        
        FOR AUX IN AUX_CUR LOOP
            CONTADOR :=CONTADOR+1;
            DBMS_OUTPUT.PUT_LINE('VISITA '||CONTADOR|| ': '|| AUX.COD_EXPEDIENTE || ' ' || AUX.FECHA_VISITA);
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('-----------------------');
        DBMS_OUTPUT.PUT_LINE('TOTAL: '||CONTADOR); 
        
END;
/
 
/* 5 */


SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER INSER_ESTUDIANTE
    BEFORE INSERT ON ESTUDIANTES
    FOR EACH ROW
DECLARE
    EXISTE NUMBER:= 0;

BEGIN
    IF INSERTING THEN
        SELECT COUNT(*) INTO EXISTE
        FROM ABOGADOS
        WHERE TRAB_CODIGO = :NEW.TRAB_CODIGO;

        IF EXISTE != 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO REALIZAR EL ALTA. 
            EL EMPLEADO CON CODIGO: ' || :NEW.TRAB_CODIGO  || 'YA ES ABOGADO.');
        END IF;
    END IF;
END;
/

/* 6 */

SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER INSER_ABOGADO
    BEFORE INSERT ON ABOGADOS
    FOR EACH ROW
DECLARE
    EXISTE NUMBER:= 0;

BEGIN
    IF INSERTING THEN
        SELECT COUNT(*) INTO EXISTE
        FROM ESTUDIANTES
        WHERE TRAB_CODIGO = :NEW.TRAB_CODIGO;
        
        IF EXISTE != 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO REALIZAR EL ALTA. 
            EL EMPLEADO CON CODIGO: ' || :NEW.TRAB_CODIGO || 'YA ES ESTUDIANTE.');
        END IF;
    END IF;
END;
/

/* 7 */

SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER INSER_JUICIO
    BEFORE INSERT ON JUICIO
    FOR EACH ROW
DECLARE
    EXISTE NUMBER:= 0;
    NUM_VISI NUMBER:=0;

BEGIN
    IF INSERTING THEN
        SELECT COUNT(*) INTO NUM_VISI
        FROM VISITAR
        WHERE COD_EXPEDIENTE = :NEW.COD_EXPEDIENTE;
        
        IF INSERTING THEN
            SELECT COUNT(*) INTO EXISTE
            FROM JUICIO
            WHERE NUM_VISI = 0;
        
            IF EXISTE != 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUEDE IR A JUICIO AUN. 
                EL EXPEDIENTE CON CODIGO: ' || :NEW.COD_EXPEDIENTE || ' NO HA REALIZADO NINGUNA VISITA.');
            END IF;
        END IF;      
        
    END IF;
END;
/


/* 8 */

CREATE OR REPLACE PROCEDURE LISTADO_CLIEN (DNI_C VARCHAR)
IS
    CURSOR AUX_CUR IS
        SELECT TIPO_DE_FALTA, CODIGO_EXPEDIENTE
        FROM EXPEDIENTE
        WHERE CLIEN_DNI = DNI_C
        ORDER BY CODIGO_EXPEDIENTE;
        
    CONTADOR NUMBER:=1;

BEGIN
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    DBMS_OUTPUT.PUT_LINE('EL CLIENTE: ' || DNI_C);
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    
    FOR AUX IN AUX_CUR LOOP
        DBMS_OUTPUT.PUT_LINE(CONTADOR || '. ' || AUX.TIPO_DE_FALTA || '  ' || AUX.CODIGO_EXPEDIENTE);
        CONTADOR := CONTADOR +1;
    END LOOP;
END;
/

/* 9 */

create or replace FUNCTION NUM_TRA(DNI_JU VARCHAR)
RETURN NUMBER
IS
    TOTAL NUMBER;
BEGIN
    SELECT COUNT(*) INTO TOTAL
    FROM OCULTA
    WHERE JUEZ_DNI = DNI_JU;

    RETURN TOTAL;
END;
/

/* 10 */

CREATE OR REPLACE PROCEDURE LISTADO_JUECES (DNI_J VARCHAR)
IS
    CURSOR AUX_CUR IS
        SELECT NOMBRE, APELLIDOS, FAMILIARES, CODIGO, NUM_TRA(DNI_J) AS TIPO
        FROM JUEZ
        WHERE DNI_JUEZ = DNI_J;

        ESTADO VARCHAR(20);
        CONTADOR NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('EL JUEZ CON DNI: ' || DNI_J);
    DBMS_OUTPUT.PUT_LINE('---------------------------');
    
    FOR AUX IN AUX_CUR LOOP
        IF AUX.TIPO = 0 THEN
            ESTADO := 'IMPECABLE';
        ELSIF AUX.TIPO < 3 THEN
            ESTADO:= 'POCO CORRUPTO';
        ELSE
            ESTADO:= 'MUY CORRUPTO';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(AUX.NOMBRE ||' ' || AUX.APELLIDOS || ' ' || AUX.FAMILIARES || ' ' || AUX.CODIGO || ' ' || ESTADO);
    END LOOP;
END;
/

/* 11 */

create or replace FUNCTION EDAD_REAL(ANYO DATE)
RETURN NUMBER
IS
    ANONAC NUMBER;
    MESNAC NUMBER;
    DIANAC NUMBER;

    ANOACTUAL NUMBER;
    MESACTUAL NUMBER;
    DIAACTUAL NUMBER;

    EDAD NUMBER;

BEGIN
        ANONAC := TO_NUMBER(TO_CHAR(ANYO, 'YYYY'));
        MESNAC := TO_NUMBER(TO_CHAR(ANYO, 'MM'));
        DIANAC := TO_NUMBER(TO_CHAR(ANYO, 'DD'));

        ANOACTUAL := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
        MESACTUAL := TO_NUMBER(TO_CHAR(SYSDATE, 'MM'));
        DIAACTUAL := TO_NUMBER(TO_CHAR(SYSDATE, 'DD'));

        IF MESACTUAL > MESNAC THEN
            EDAD := ANOACTUAL - ANONAC;
        ELSIF MESACTUAL = MESNAC AND DIAACTUAL >= DIANAC THEN
            EDAD := ANOACTUAL - ANONAC; 
        ELSE
            EDAD := ANOACTUAL - ANONAC - 1;
        END IF;

        RETURN EDAD;

END;
/

/* 12 */

 CREATE OR REPLACE TRIGGER COMPROBAR_FECHA
    BEFORE INSERT ON TRABAJADORES
    FOR EACH ROW
BEGIN
IF EDAD_REAL(:NEW.FECHA_NACIMIENTO) < 18 THEN
        RAISE_APPLICATION_ERROR(-20010, 'NO SE PUEDE REALIZAR EL ALTA.
            EL ESTUDIANTE CON EL CODIGO: '
            || :NEW.CODIGO ||  'NO TIENE 
            LA EDAD CORRECTA');
    END IF;
END;
/

/* 13 */

CREATE OR REPLACE PROCEDURE NOVATO(CO VARCHAR)
IS
    CURSOR AUX_CUR IS
        SELECT NOMBRE,APELLIDOS, CODIGO, EDAD_REAL(FECHA_INI) AS RANGO
        FROM TRABAJADORES
        WHERE codigo = CO
        ORDER BY codigo;

        RANGO VARCHAR(15);
BEGIN
    DBMS_OUTPUT.PUT_LINE('NOMBRE APELLIDO CODIGO RANGO');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    FOR AUX IN AUX_CUR LOOP 
        IF AUX.RANGO < 2 THEN
            RANGO := 'NOVATO';
        ELSIF AUX.RANGO > 3 THEN
            RANGO := 'AVANZADO';
        ELSE
            RANGO := 'INTERMEDIO';
        END IF;

        DBMS_OUTPUT.PUT_LINE(AUX.NOMBRE || ' ' || AUX.APELLIDOS || ' '  || AUX.CODIGO  || ' ' || AUX.RANGO || ' ' || rango);
    END LOOP;
END;
/