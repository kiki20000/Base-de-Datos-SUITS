/* nos deberia mostrar un listado de estudiantes y el abogado que le da clase */
SELECT * FROM ESTUDIANTES WHERE ABO_TRAB_CODIGO = 'X00001';

/* nos deberia de mostrar el total de alumnos que tiene el abogado que le digamos */
SELECT TOTAL_ESTUDIANTES('X00001') FROM DUAL;

/* nos mostrara un listado de nuestros abogados y a cuantos alumnos tiene a su cargo */
SELECT TRAB_CODIGO, TOTAL_ESTUDIANTES(TRAB_CODIGO) FROM ABOGADOS;

/* nos mostrara un listado de nuestros abogados y en cuantos casos estan atendiendo */
SELECT DISTINCT ABO_TRAB_CODIGO, TOTAL_CASOS(ABO_TRAB_CODIGO) FROM ATIENDE;

/* nos mostrara el total de casos que atiende el abogado X00002 */
SELECT COUNT(*) FROM ATIENDE WHERE ABO_TRAB_CODIGO='X00002';

/* llamamos a la funcion y comprobamos el select anterior */
SELECT TOTAL_CASOS ('X00002') FROM DUAL;

/* nos deberia de mostrar el nombre y codigo del abogado, y ademas un listado con el dni 
 de los clientes que lleva y el codigo de expediente que tenga asignado */
EXECUTE TOTAL_EXPEDIENTES_ABOGADO ('X00001'); 

/* si le pasamos el dni del demandante nos deberia de mostrar un listado con las visitas que hemos tenido con el, de modo 
que nos saldra sobre cual expediente nos hemos reunido y cuando nos reunimos */
SELECT COD_EXPEDIENTE,FECHA_VISITA FROM VISITAR WHERE DNI_DEMANDANTE='78451296H' AND ABO_TRAB_CODIGO='X00002';

/* si le pasamos el dni del demandante nos deberia de mostrar un listado con las visitas que hemos tenido con el, de modo 
que nos saldra sobre cual expediente nos hemos reunido y cuando nos reunimos, ademas tambien nos lleva un conteo del 
numero de visitas que hemos tenido con ese demandante */
EXECUTE LISTADO_VISITAS ('X00002','78451296H');

/* mostraremos un listado de los abogados e intentaremos insertar uno en estudiantes de modo que nos deberia de saltar un error */
select * from abogados;
insert into estudiantes values ('X00001','X00002');

/* mostraremos un listado de los estudiantes e intentaremos insertar uno en abogados de modo que nos deberia de saltar un error */
SELECT * FROM ESTUDIANTES;
INSERT INTO ABOGADOS VALUES ('X00007','L\M\X', 'C00007');

/* nos mostrara un error ya que ese expediente no ha realizado ninguna visita con su demandante */
INSERT INTO JUICIO VALUES('44444444B', '56748912Z', 'X00001', '11111111A', 'E0007');

/* nos muestra un listado del historial delictivo de nuestro cliente, deberemos pasarle el dni y este nos devolvera el tipo de 
delito y su codigo de expediente */
EXECUTE LISTADO_CLIEN('11111111A');

/* si le pasamos el dni del juez nos mostrara los datos relativos a ese juez como su nombre, apellidos, codigo de juez y si es mucho o poco corrupto */
EXECUTE LISTADO_JUECES('55555555G');

/* nos deberia de saltar un aviso diciendo que la edad no es correcta ya que es menor de 18 años */
INSERT INTO TRABAJADORES VALUES ('X00007', 'Pablo', 'Rodriguez Pastor', '05/12/2005','22/12/2018');

/* esta funcion si le pasamos el codigo del trabajador nos mostrara todos los datos relativos de el hacia la empresa como por ejemplo: su nombre,
apellidos, codigo de trabajador, cuantos años lleva trabajando para nosotros, y ademas en funcion de los años que lleve nos dira si es novato, intermedio o avanzado */
EXECUTE NOVATO ('X00001');

/* Esta vista lo que hará será devolver el tipo de falta, el código del expediente y el DNI del cliente de aquellos acusados 
que hayan cometido faltas catalogadas como “Muy grave" */
SELECT * FROM EXPO_GRAV;

/* Esta vista devuelve el DNI, nombre, apellidos y correo electrónico de todos los clientes de la base de datos */ 
SELECT * FROM LIST_CLIEN;

/* Esta vista devolverá el número de veces que se ha cometido un trapo sucio por parte de un juez */
SELECT * FROM TRAPOS;

/* Esta vista se encargará de mostrar todos los trabajadores cuyo año de nacimiento se encuentra comprendido entre 1991 y el 2000 y no dejará insertar ningun registro cuyo
año para la fecha de nacimiento no esté comprendido entre estos valores */
SELECT * FROM TRAB_00;

/* Esta vista mostrará el código de expediente, el DNI, el nombre y los apellidos de los clientes del bufete*/
select * from DATOS_ESTUDIANTES;

/* Esta vista mostrará la suma de todas las comisiones que los abogados del tipo Penal han cobrado */
select * from TOTAL_COMISIONES;

/* Esta función calcula y devuelve la media de los años trabajados por todos los empleados que están en el bufete. */
SELECT MEDIA_TRABAJADA FROM DUAL;