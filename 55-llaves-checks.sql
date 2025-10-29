-- 1. Crear una llave primaria en city (id)
alter table public.city add primary key (id);

-- 2. Crear un check en population, para que no soporte negativos
alter table public.city add check (population >= 0);

-- 3. Crear una llave primaria compuesta en "countrylanguage"
-- los campos a usar como llave compuesta son countrycode y language
alter table public.countrylanguage add constraint "countrycode_language_pkey" primary key (countrycode, language);

-- 4. Crear check en percentage, 
-- Para que no permita negativos ni números superiores a 100
alter table public.countrylanguage add constraint check_percentage check (percentage between 0 and 100);

-- Respuesta del profesor:
alter table countrylanguage add check (
    (percentage >= 0) and (percentage <=100)
);