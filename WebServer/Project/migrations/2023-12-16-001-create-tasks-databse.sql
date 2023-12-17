CREATE DATABASE tasks;

CREATE TABLE tasks (
   id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
   title VARCHAR(255) NOT NULL,
   description TEXT,
   deadline_date DATETIME,
   completion_status TINYINT(1) NOT NULL
);

INSERT INTO tasks
    ( title, description, deadline_date, completion_status)
        VALUES
                ("Wash Dog", "Wash the dog", NULL, 0),
                ( "Clean Car", "Wash the Car", "2023-12-25", 0);
