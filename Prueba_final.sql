/ 1.Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves
 primarias, foráneas y tipos de datos.


---Crear tabla "peliculas" 
CREATE TABLE "peliculas" (
    "id" SERIAL PRIMARY KEY,  
    "nombre" VARCHAR(255),
    "año" INTEGER
);

---Select * FROM peliculas;

-- Crear tabla "tags" 
CREATE TABLE "tags" (
    "id" SERIAL PRIMARY KEY,  
    "tag" VARCHAR(32)
);

---Select * FROM tags;

-- Crear tabla "peliculas_tags" para asociar peliculas y tags
CREATE TABLE "peliculas_tags" (
    "peliculas_id" INTEGER,
    "tags_id" INTEGER,
    FOREIGN KEY ("peliculas_id")
        REFERENCES "peliculas"("id"),
    FOREIGN KEY ("tags_id")
        REFERENCES "tags"("id")
);

---Select * FROM peliculas_tags;


/2.Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la
 segunda película debe tener 2 tags asociados.


Insertar datos en la tabla "peliculas" (sin necesidad de especificar "id")
INSERT INTO peliculas(nombre, año)
VALUES 
    ('El_origen', 2010), 
    ('El_rey_leon', 1994), 
    ('The_matrix', 1999), 
    ('Frozen', 1972), 
    ('El_padrino', 2013);

----SELECT * FROM peliculas;
	

-- Insertar datos en la tabla "tags" 

INSERT INTO tags(tag)
VALUES 
    ('Mente'),
    ('Familia'),
    ('Animación'),
    ('Acción'),
	('Aventura'),
	('Suspenso');

----SELECT * FROM tags;	

INSERT INTO peliculas_tags (peliculas_id, tags_id)
VALUES 
    (1, 1),  -- El_origen con Mente
	(1, 6),  -- El_origen con Suspenso
    (1, 5),  -- El_origen con Aventura
    (2, 2),  -- El rey leon con familia
    (2, 3),  -- El rey leon con animacion
    (3, 1),  -- The matrix con mente	
	(4, 3),  -- Frozen con animacion
	(5, 4);  -- El padrino con accion
	
----SELECT * FROM peliculas_tags;

		-- Consultar todas las películas
SELECT * FROM peliculas;
-- Consultar todos los tags
SELECT * FROM tags;

/3.Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
 mostrar 0.


SELECT peliculas.nombre, COUNT(tags.id) AS num_tags
FROM peliculas
JOIN peliculas_tags ON peliculas.id = peliculas_tags.peliculas_id
JOIN tags ON peliculas_tags.tags_id = tags.id
GROUP BY peliculas.nombre
ORDER BY peliculas.nombre;

 

/Segun el modelo #2------

create table preguntas (
    id serial primary key,
    pregunta varchar(255),
    respuesta_correcta varchar(255)
);
---SELECT * FROM preguntas;

create table usuarios (
    id serial primary key,
    nombre varchar(255),
    edad int
);
----SELECT * FROM usuarios;


CREATE TABLE respuestas (
    respuesta varchar(255),
    preguntas_id INTEGER NOT NULL,
    usuarios_id INTEGER NOT NULL,
    FOREIGN KEY (preguntas_id)
        REFERENCES preguntas(id),
    FOREIGN KEY (usuarios_id)
        REFERENCES usuarios(id)
);


----SELECT * FROM respuestas;

INSERT INTO usuarios(nombre, edad)
VALUES 
    ('Carolina', 20), 
    ('Santiago', 32), 
    ('Camila', 35), 
    ('Juan', 28), 
    ('Cristina', 36);

----SELECT * FROM usuarios;

INSERT INTO preguntas(pregunta, respuesta_correcta)
VALUES 
    ('Capital_USA', 'Washington'), 
    ('Numero_continentes', '7'), 
    ('Pais_mas_personas', 'China'), 
    ('perro_en_ingles', 'Dog'), 
    ('Cuantos_planetas', '8');

	
---- SELECT* FROM preguntas;

INSERT INTO respuestas(respuesta, preguntas_id, usuarios_id)
VALUES 
    ('Washington', 1, 2), 
    ('Washington', 1, 3), 
    ('7', 2, 4), 
    ('USA', 3, 5), 
    ('cat', 4, 3),
    ('5', 5, 4),
    ('3', 2, 1);

----SELECT*FROM respuestas;

/1.Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
 pregunta)/
 
SELECT usuarios.nombre,
		COUNT(*) AS num_respuestas_correctas
FROM usuarios
JOIN respuestas ON usuarios.id = respuestas.usuarios_id
JOIN preguntas ON respuestas.preguntas_id= preguntas.id
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY usuarios.nombre
ORDER BY usuarios.nombre;	

/2.Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron
 correctamente/
 
SELECT preguntas.pregunta,
		COUNT(DISTINCT respuestas.usuarios_id) AS num_respuestas_correctas
FROM preguntas
JOIN respuestas ON preguntas.id = respuestas.preguntas_id

WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY preguntas.pregunta
ORDER BY preguntas.pregunta;



/3.Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la
 implementación borrando el primer usuario/

ALTER TABLE respuestas
DROP CONSTRAINT respuestas_usuarios_id_fkey,  -- Este es el nombre de la restricción de la clave foránea
ADD CONSTRAINT respuestas_usuarios_id_fkey FOREIGN KEY (usuarios_id)
REFERENCES usuarios(id) ON DELETE CASCADE;

DELETE FROM usuarios WHERE id = 1;

SELECT * FROM respuestas WHERE usuarios_id = 1;
SELECT * FROM preguntas WHERE preguntas.id = 1;

SELECT * FROM usuarios WHERE usuarios.id = 1;



/4.Crea una restricción que impida insertar usuarios menores de 18 años en la base de
 datos/

ALTER TABLE usuarios
ADD CONSTRAINT edad_minima CHECK (edad >= 18);
INSERT INTO usuarios (nombre, edad) 
VALUES ('Diana', 40);
INSERT INTO usuarios (nombre, edad) 
VALUES ('Andres', 15);

----SELECT * FROM usuarios;


/5.Altera la tabla existente de usuarios agregando el campo email. Debe tener la
 restricción de ser único/


ALTER TABLE usuarios
ADD COLUMN email varchar(255) UNIQUE;

INSERT INTO usuarios (nombre, edad, email) 
VALUES ('Viviana', 25, 'vivi@email.com');


----SELECT * FROM usuarios;



