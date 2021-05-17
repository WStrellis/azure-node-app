CREATE DATABASE IF NOT EXISTS node_app;

USE node_app;

CREATE TABLE IF NOT EXISTS shopping_list (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item VARCHAR(255) NOT NULL,
    quantity SMALLINT NOT NULL DEFAULT 1
);

INSERT INTO shopping_list (item, quantity)
VALUES ("celery", DEFAULT),("carrots", DEFAULT),("apples",7);