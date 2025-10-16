/* Sublenguajes de SQL
DDL (Data Definition Language / Lenguaje de Definición de Datos): Se usa para definir la estructura de la base de datos y sus objetos.
CREATE: Crea nuevas bases de datos o tablas.
ALTER: Permite modificar la estructura de los objetos existentes.
DROP: Elimina tablas u otros objetos de la base de datos.

DML (Data Manipulation Language / Lenguaje de Manipulación de Datos): Sirve para gestionar los datos dentro de las tablas.
SELECT: Recupera datos de una o más tablas.
INSERT: Añade nuevas filas (registros) a una tabla.
UPDATE: Modifica los datos de los registros existentes en una tabla.
DELETE: Elimina filas de una tabla.

DCL (Data Control Language / Lenguaje de Control de Datos): Gestiona los permisos y el acceso de los usuarios a la base de datos.
GRANT: Otorga permisos a usuarios para acceder a la base de datos o a sus objetos.
REVOKE: Restringe o anula los permisos de un usuario.

TCL (Transaction Control Language / Lenguaje de Control de Transacciones): Controla las transacciones dentro de la base de datos.
COMMIT: Finaliza una transacción, haciendo permanentes los cambios realizados.
ROLLBACK: Revierte la base de datos al estado anterior al inicio de una transacción.
 */
-- 1. Ver todos los registros
select
	*
from
	public.users;

-- 2. Ver el registro cuyo id sea igual a 10
select
	*
from
	public.users u
where
	id = 10;

-- 3. Quiero todos los registros cuyo primer nombre sea Jim (engañosa)
select
	*
from
	public.users u
where
	name like 'Ji_ %';

-- Respuesta del profesor:

select
	*
from
	public.users u
where
	name like 'Jim %';

/* LIKE 'Ji_ %'
Descripción: Este patrón utiliza el guion bajo (_) como un comodín que representa exactamente un solo carácter.
Significado: Este patrón buscará nombres que comiencen con "Ji", seguido de cualquier carácter (gracias al _), y luego cualquier cantidad de caracteres después del espacio.
Ejemplos de coincidencias: Jim, Jin, Jiz, Ji1abc, etc. (cualquier nombre que empiece con "Ji", tenga un carácter adicional y luego más caracteres). 

LIKE 'Jim %'
Descripción: Este patrón busca nombres que comiencen exactamente con la cadena "Jim" seguida de un espacio y cualquier cantidad de caracteres.
Significado: Este patrón solo coincidirá con nombres que comiencen con "Jim" y que tengan un espacio después de "Jim".
Ejemplos de coincidencias: Jim Smith, Jim Brown, pero no Ji o Jin.*/

-- 4. Todos los registros cuyo segundo nombre sea Alexander
select
	*
from
	public.users u
where
	name like '%Alexander';

-- Respuesta del profesor:
select
	*
from
	public.users u
where
	name like '% Alexander';

/* LIKE '%Alexander': Coincidirá con cualquier nombre que termine con "Alexander", sin importar si hay un espacio antes o no.
LIKE '% Alexander': Coincidirá solo con nombres que terminen con un espacio seguido de "Alexander", y es sensible a mayúsculas y minúsculas */

-- 5. Cambiar el nombre del registro con id = 1, por tu nombre Ej:'Fernando Herrera'
select *
from public.users u 
where id = 1;

update
	public.users
set
	name = 'Jean Gracia'
where
	id = 1;

-- 6. Borrar el último registro de la tabla
select *
from public.users u
order by id desc 
limit 1;

delete
from
	public.users
where
	id = (
	select
		id
	from
		public.users u
	order by
		id desc
	limit 1
);

-- Respuesta del profesor:
select
	max(id)
from
	public.users u;

delete
from
	public.users
where
	id = (
	select
		max(id)
	from
		public.users u);

-- Investigacion:
/* CTE (Common Table Expression) o una variable temporal.
PostgreSQL Supported Versions: Current (18) / 17 / 16 / 15 / 14 / 13 */

WITH last_user AS (
    SELECT id
    FROM public.users
    ORDER BY id DESC
    LIMIT 1
)
DELETE FROM public.users
WHERE id = (SELECT id FROM last_user);

/* CTE last_user: Esta parte del código selecciona el id del último registro y lo almacena en una tabla temporal llamada last_user.
DELETE: Luego, el DELETE utiliza el id de last_user para eliminar el registro correspondiente. */

/* Alternativa Usando USING 
Supported Versions: Current (18) / 17 / 16 / 15 / 14 / 13*/
SELECT *
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id;

SELECT *
FROM orders
JOIN customers USING (customer_id);

-- respuesta a la segunda actividad
ALTER table public.users ADD COLUMN primer_nombre TEXT;
ALTER table public.users ADD COLUMN segundo_nombre TEXT;

with necesario as (
select
	position (' ' in name) as espacio
from
	public.users
where
	id = 1
)
select
	name,
	substring(name, 0, (select espacio from necesario)) as primer_nombre,
	substring (name, (select espacio from necesario) + 1) as segundo_nombre
from
	public.users u
where
	id = 1;

with LearnSQL as (
select
	position (' ' in name) as espacio
from
	public.users
where id = 6
)
update public.users
set
	primer_nombre = trim(substring(name, 0, (select espacio from LearnSQL))),
	segundo_nombre = trim(substring (name, (select espacio from LearnSQL)))
where id = 6;

select * from public.users u where id = 6;

-- respuesta tercera actividad first and last name columns
update public.users
set
	primer_nombre = substring(name, 0, position(' ' in name)),
	segundo_nombre = substring(name, position(' ' in name) + 1);

select * from public.users u;


-- clase 35. Operador between
select 
	first_name,
	last_name,
	followers as seguidores,
	(SELECT COUNT(*) 
	FROM public.users u2 
	WHERE u2.followers between 4600 and 4700) AS cantidad_registros
from 
	public.users u
where
	-- followers >= 4600 and followers <= 4700 sustituir por:
	followers between 4600 and 4700
order by seguidores desc;

-- clase 36. Funcionaes agregadas - MAX MIN COUNT ROUND AVG
select 
	count(*) as total_users,
	min(followers) as min_followers,
	max(followers) as max_followers,
	round(avg(followers)) as rounded_avg_followers,
	avg(followers) as avg_followers,
	sum(followers) / count(*) as manual_avg_followers
from public.users u

-- clase 37. GROUP BY (cláusula)
select
	count(*) as people,   -- (A) Función de agregación
	followers as with_followers -- (B) Columna regular (NO agregación)
from
	public.users u
where
	followers between 4500 and 4600
group by
	followers -- (C) Columna de agrupación
order by
	followers asc;

/* Al ejecutar esta consulta, obtendrás una lista de dos columnas:
people: El número total de usuarios (count(*)) que tienen exactamente la misma cantidad de seguidores.
with_followers: El número exacto de seguidores para ese grupo de usuarios. */

/* count(*): Esta es una función de agregación. Cuenta el número total de filas (usuarios) en cada grupo definido posteriormente por la cláusula GROUP BY. Le asignas el alias cantidad para que el nombre de la columna en el resultado sea claro. */

/* Una de las reglas más estrictas de GROUP BY es cómo interactúa con la cláusula SELECT:
Toda columna en el SELECT que NO sea una función de agregación DEBE estar listada en el GROUP BY.
Dado que followers es una columna regular en el SELECT, DEBE estar listada en la cláusula GROUP BY. */

-- ESTO GENERARÍA UN ERROR DE SQL (violando la regla)
--SQL Error [42803]: ERROR: la columna «u.first_name» debe aparecer en la cláusula GROUP BY o ser usada en una función de agregación
SELECT
	COUNT(*),   -- (A) Función de agregación
    followers,  -- (B) Columna regular
    first_name -- NUEVA columna regular
FROM
    public.users u
GROUP BY
    followers;

-- por otro lado:
select
	count(*) as people,
	followers as with_followers,
	first_name as ppl_first_name
from
	public.users u
where followers between 100 and 150
group by
	followers,
	first_name
order by
	followers asc

/* La base de datos agrupa todas las filas con, 108 followers.
la Función de agregación COUNT(*) calcula que hay 8 usuarios en ese grupo.
La base de datos intenta mostrar la columna with_followers (es fácil, es 108).
La base de datos se detiene: ¿Qué valor debe mostrar en la columna ppl_first_name?
Dentro del grupo de 108 seguidores hay 7 nombres
-- Respuesta: agrupara los nombres repetidos y dividira en grupos los demas nombres distintos */

-- clase 39. HAVING
select
	count(*) as total,
	country
from
	public.users u
group by 
	country
having 
	count(*) > 5
order by
	count(*) desc;
/* Estás reemplazando WHERE por HAVING en esta consulta específica porque tu condición de filtro (count(*) > 5) se basa en el resultado de una función de agregación (COUNT(*)) y no en los valores de una fila individual. 
WHERE	Antes del GROUP BY		Filtra filas individuales de la tabla original.
HAVING	Después del GROUP BY	Filtra grupos creados por el GROUP BY

La cláusula HAVING se ejecuta después de que el motor de SQL ha completado el proceso de agrupación:
Agrupación: El GROUP BY country junta a todos los usuarios de "España" en un grupo, a todos los de "México" en otro, etc.
Agregación: El SELECT count(*) calcula el número total de usuarios para cada uno de esos grupos.
Filtrado de Grupos: El HAVING count(*) > 5 ahora puede actuar. Mira el valor de la columna total (que es el resultado de COUNT(*)) y descarta cualquier grupo donde ese total sea 5 o menos.*/

-- clase 40. Distinct (cláusula)
/* La cláusula DISTINCT se utiliza en la sentencia SELECT para eliminar las filas duplicadas de una columna o un conjunto de resultados, asegurando que cada fila devuelta sea única. */

explain analyze
select
	distinct country
from
	public.users u;
Execution Time: 0.307 ms

explain analyze
select
	country 
from public.users u
group by country;
Execution Time: 0.282 ms

/* Se coloca inmediatamente después de la palabra clave SELECT.
DISTINCT aplica su lógica a todas las columnas que están en la sentencia SELECT, no solo a la primera. Para que una fila se considere duplicada, todos sus valores deben coincidir con otra fila.
PostgreSQL evalúa todas las columnas especificadas en la lista de SELECT */

-- Uso con Agregaciones
explain analyze
select
	distinct country,
	(count(country)) as repeticiones
from
	public.users u
group by country
order by repeticiones asc;
Execution Time: 0.578 ms

explain analyze
select
	country,
	(count(country)) as repeticiones
from public.users u
group by country
order by repeticiones asc;
Execution Time: 0.332 ms

/* La Observación Clave: DISTINCT se vuelve redundante.
Cuando usas una función de agregación (como COUNT, SUM, AVG, etc.) en tu lista de SELECT, estás obligado a usar la cláusula GROUP BY para indicar cómo se deben calcular esas agregaciones. */
SELECT
	-- 1. La agregación obliga al GROUP BY
	distinct country, 
	(count(country)) as repeticiones
FROM public.users u
-- 2. El GROUP BY ya garantiza la unicidad de 'country'
group by country 
order by repeticiones asc;

/* El GROUP BY country ya le está diciendo a PostgreSQL que agrupe y colapse todas las filas idénticas de country en una sola fila. Por lo tanto, el resultado del GROUP BY es un conjunto de países únicos.

Agregar DISTINCT delante de country en este contexto no cambia el resultado y es completamente redundante. De hecho, como viste en los tiempos de ejecución, puede introducir una ligera sobrecarga o confundir ligeramente al planificador, haciéndola más lenta. */

/* Esta es la diferencia fundamental que hace que ambas cláusulas existan en SQL:
DISTINCT y GROUP BY tienen propósitos distintos, se debe a que una está enfocada en la presentación de los datos y la otra en el cálculo de los datos.
Si necesitas usar COUNT(), SUM(), AVG(), MAX(), o MIN(), tu única opción es GROUP BY. Su propósito es el cálculo.

Caso Específico: COUNT(DISTINCT...)
Este es un caso donde DISTINCT se comporta como una función de agregación y se usa dentro de la cláusula SELECT, pero aún requiere un GROUP BY.
Propósito: Contar cuántos valores únicos hay dentro de cada grupo. */