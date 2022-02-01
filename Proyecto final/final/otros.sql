connect system/bdadmin;

CREATE USER e3Jefe IDENTIFIED BY DIOS;
GRANT DBA TO e3Jefe;

CREATE USER e3Abogados IDENTIFIED BY ABO;
GRANT CONNECT, RESOURCE, CREATE VIEW TO e3Abogados;

CREATE USER e3Estudiante IDENTIFIED BY ESTU;
GRANT CONNECT TO e3Estudiante;


connect e3/e3;

CREATE OR REPLACE VIEW EXPO_GRAV (TIPO, EXPEDIENTE, CLIENTE)
AS SELECT TIPO_DE_FALTA, CODIGO_EXPEDIENTE, CLIEN_DNI
FROM EXPEDIENTE
WHERE TIPO_DE_FALTA='Muy Grave';

CREATE OR REPLACE VIEW LIST_CLIEN
AS SELECT DNI, NOMBRE, APELLIDOS, CORREO_ELEC
FROM CLIENTE;

CREATE OR REPLACE VIEW TRAPOS
AS SELECT CODIGO_TRAPO, COUNT(CODIGO_TRAPO) AS NUM_VECES
FROM OCULTA
GROUP BY CODIGO_TRAPO;

CREATE OR REPLACE VIEW TRAB_00
AS SELECT CODIGO ,NOMBRE ,APELLIDOS ,FECHA_INI,FECHA_NACIMIENTO 
FROM TRABAJADORES
WHERE TO_NUMBER(TO_CHAR(FECHA_NACIMIENTO, 'YYYY')) BETWEEN 1999 AND 2001
WITH CHECK OPTION CONSTRAINT ANONAC_9901;