-- 1. Cuantos usuarios tenemos con cuentas @google.com
-- Tip: count, like

select
	count(*),
	substring(email, position('@' in email) +1) as domain
from
	public.users
group by
	substring(email, position('@' in email) +1)
having
	substring(email, position('@' in email) +1) like 'google.com';

-- Respuesta del profesor:
select
	count(*)
from
	public.users
where
	email like '%google.com';

-- 2. De qué países son los usuarios con cuentas de @google.com
-- Tip: distinct

Select
	count(*),
	substring(email, position('@' in email) +1) as domain,
	country
from
	public.users
group by
	substring(email, position('@' in email) +1),
	country
having
	substring(email, position('@' in email) +1) like 'google.com';

-- Respuesta del profesor:
select
	distinct country
from
	public.users
where
	email like '%google.com';

-- 3. Cuantos usuarios hay por país (country)
-- Tip: Group by

select
	count(first_name) as users,
	country
from
	public.users
group by
	country
order by
	users desc;

-- Respuesta del profesor:
select
	count(first_name) as users,
	country
from
	public.users
group by
	country;

-- 4. Listado de direcciones IP de todos los usuarios de Iceland
-- Campos requeridos first_name, last_name, country, last_connection

select
	first_name,
	last_name,
	country,
	last_connection as direcciones_ip
from
	public.users
where country like 'Iceland';

-- Respuesta del profesor:
select
	first_name,
	last_name,
	country,
	last_connection as direcciones_ip
from
	public.users
where country like 'Iceland';

-- 5. Cuantos de esos usuarios (query anterior) tiene dirección IP
-- que incia en 112.XXX.XXX.XXX

select
	count(last_connection),
	first_name,
	last_name,
	country,
	last_connection as direcciones_ip
from
	public.users
group by
	first_name,
	last_name,
	country,
	last_connection
having country like 'Iceland' and last_connection like '112.%';

-- Respuesta del profesor:
select
	count(*)
from
	public.users
where country = 'Iceland' and last_connection like '112.%';

-- 6. Listado de usuarios de Iceland, tienen dirección IP
-- que inicia en 112 ó 28 ó 188
-- Tip: Agrupar condiciones entre paréntesis

/* Ambos queries (consultas SQL) están intentando obtener el mismo resultado: contar las conexiones por usuario (nombre, apellido, país, y última conexión) para los usuarios en Islandia que tienen una dirección IP de última conexión que comienza con '112.', '28.', o '188.'.

La diferencia clave reside en la lógica de su cláusula HAVING y, por lo tanto, en los resultados que devolverán. */

-- Query 1 (Con lógica de precedencia implícita)
select
	count(last_connection),
	first_name,
	last_name,
	country,
	last_connection as direcciones_ip
from
	public.users
group by
	first_name,
	last_name,
	country,
	last_connection
having country like 'Iceland' 
	and last_connection like '112.%'
	OR last_connection LIKE '28.%'
   	OR last_connection LIKE '188.%';

-- Debido a la precedencia de AND, el motor de la base de datos interpreta esta cláusula como si estuviera escrita así:
HAVING (country like 'Iceland' AND last_connection like '112.%')
	OR last_connection LIKE '28.%'
	OR last_connection LIKE '188.%';

/* ¿Qué resultados obtendrá?
Esta consulta devolverá filas que cumplan CUALQUIERA de las siguientes condiciones:

El país es 'Iceland' Y la IP comienza con '112.'. O
La IP comienza con '28.' (sin importar el país). O
La IP comienza con '188.' (sin importar el país).

¡Esto es un error! La condición del país (country LIKE 'Iceland') solo se aplica a la primera parte (last_connection LIKE '112.%'), pero no a las otras dos condiciones de IP. Devolverá usuarios de cualquier país si su IP empieza por '28.' o '188.'. */

-- Query 2 (Con lógica de precedencia explícita y correcta)

SELECT
    COUNT(last_connection) AS total_conexiones,
    first_name,
    last_name,
    country,
    last_connection AS direcciones_ip
FROM
    public.users
GROUP BY
    first_name,
    last_name,
    country,
    last_connection
HAVING 
    country LIKE 'Iceland' 
    AND (
        last_connection LIKE '112.%'
        OR last_connection LIKE '28.%'
        OR last_connection LIKE '188.%'
    );

/* Al usar los paréntesis (), se fuerza la precedencia y se le indica al motor que las condiciones de IP deben evaluarse primero juntas.

¿Qué resultados obtendrá?
Esta consulta devolverá filas que cumplan AMBAS de las siguientes condiciones:

El país es 'Iceland'. Y
La IP comienza con '112.' O con '28.' O con '188.'.
¡Este es el query correcto! Es la manera de garantizar que la condición de país se aplique a todas las condiciones de la dirección IP. */

-- Respuesta del profesor:
select
	first_name,
	last_name,
	country,
	last_connection as direcciones_ip
FROM
    public.users
where
	country LIKE 'Iceland' 
    AND (
        last_connection LIKE '112.%'
        OR last_connection LIKE '28.%'
        OR last_connection LIKE '188.%'
    );

-- 7. Ordene el resultado anterior, por apellido (last_name) ascendente
-- y luego el first_name ascendentemente también

SELECT
    COUNT(last_connection) AS total_conexiones,
    first_name,
    last_name,
    country,
    last_connection
FROM
    public.users
GROUP BY
    first_name,
    last_name,
    country,
    last_connection
HAVING 
    country LIKE 'Iceland' 
    AND (
        last_connection LIKE '112.%'
        OR last_connection LIKE '28.%'
        OR last_connection LIKE '188.%'
    )
order by 
	last_name asc,
	first_name asc;

-- Respuesta del profecor:
select
	first_name,
	last_name,
	country,
	last_connection
FROM
    public.users
where
	country LIKE 'Iceland' 
    AND (
        last_connection LIKE '112.%'
        OR last_connection LIKE '28.%'
        OR last_connection LIKE '188.%'
    )
order by 
	last_name asc,
	first_name asc;

-- 8. Listado de personas cuyo país está en este listado
-- ('Mexico', 'Honduras', 'Costa Rica')
-- Ordenar los resultados de por País asc, Primer nombre asc, apellido asc
-- Tip: Investigar IN
-- Tip2: Ver Operadores de Comparación en la hoja de atajos (primera página)

select 
	country,
	first_name,
	last_name
from 
	public.users u 
where 
	country in ('Mexico', 'Honduras', 'Costa Rica')
order by
	country asc,
	first_name asc,
	last_name asc;

-- la respuesta del profesor es la misma

-- 9. Del query anterior, cuente cuántas personas hay por país
-- Ordene los resultados por País asc

select
	count(first_name) as user_count,
	country
from 
	public.users u
group by
	country
having 
	country in ('Mexico', 'Honduras', 'Costa Rica')
order by
	country asc;

-- respuesta del profesor:
select
	count(*) as total,
	country
from 
	users
where 
	country in ('Mexico', 'Honduras', 'Costa Rica')
group by
	country
order by
	country asc;