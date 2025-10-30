-- Tarea con countryLanguage

-- Crear la tabla de language

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS language_code_seq;


-- Table Definition
CREATE TABLE "public"."language" (
    "code" int4 NOT NULL DEFAULT 	nextval('language_code_seq'::regclass),
    "name" text NOT NULL,
    PRIMARY KEY ("code")
);

-- Crear una columna en countrylanguage
ALTER TABLE countrylanguage
ADD COLUMN languagecode varchar(3);

select distinct "language" from public.countrylanguage;

insert into public.language (name)
select distinct "language" from public.countrylanguage;

select 
	count(*)
from 
	public.language;

-- Empezar con el select para confirmar lo que vamos a actualizar
select
	a.countrycode,
	a."language",
	( select b.code from language as b where b.name = a."language")
from
	public.countrylanguage as a;

-- Actualizar todos los registros
update public.countrylanguage as a
set languagecode = ( select b.code from language as b where b.name = a."language");

-- Cambiar tipo de dato en countrylanguage - languagecode por int4
alter table countrylanguage
alter column languagecode type int4
using languagecode::integer;

-- Crear el forening key y constraints de no nulo el language_code
alter table countrylanguage
add constraint fk_countrylanguage_language_code
foreign key (languagecode)
references public.language(code);

alter table public.countrylanguage
alter column languagecode set
not null;

-- Revisar lo creado
select *
from
	public.countrylanguage
where 
	languagecode = '361';