-- Lesson 01: CRUD practice. Run only inside the disposable local lab_db.
-- WARNING: The script DROPS and recreates ONLY the lesson01_students practice table.
-- Do not run in a real application database.

SELECT DATABASE() AS current_database;

DROP TABLE IF EXISTS lesson01_students;

-- DDL: define a table with typed columns and constraints.
CREATE TABLE lesson01_students (
    id INT PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    age INT NOT NULL
) ENGINE=InnoDB;

-- DML: insert three mock rows.
INSERT INTO lesson01_students (id, name, age) VALUES
    (1, 'Alice', 20),
    (2, 'Bob', 19),
    (3, 'Chen', 22);

-- DQL: read rows, filter, and sort.
SELECT id, name, age
FROM lesson01_students
WHERE age >= 20
ORDER BY age DESC, id ASC;

-- DML: update one specific record.
UPDATE lesson01_students
SET age = 22
WHERE id = 1;

-- DML: delete one specific record.
DELETE FROM lesson01_students
WHERE id = 2;

-- Verify remaining practice data: id 1 (Alice, 22), id 3 (Chen, 22).
SELECT id, name, age
FROM lesson01_students
ORDER BY id ASC;
