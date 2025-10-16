-- Seccion 4: funciones agregadas agrupaciones y ordenamiento
-- Nombre, apellido e IP, donde la última conexión se dió de 221.XXX.XXX.XXX
select
	first_name,
	last_name,
	last_connection
from
	public.users u
where
	last_connection like '221.%'
order by id;


-- Nombre, apellido y seguidores(followers) de todos a los que lo siguen más de 4600 personas
select 
	first_name,
	last_name,
	followers as seguidores
from 
	public.users u
where followers > 4600;
