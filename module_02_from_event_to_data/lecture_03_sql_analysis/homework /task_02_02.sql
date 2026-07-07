CREATE TABLE Data_Layers
(
	LayerID serial PRIMARY KEY, 
	LayerName VARCHAR(50) UNIQUE NOT NULL, 
	Description TEXT
);

INSERT INTO data_layers (layername) VALUES
('Bronze'),
('Silver'),
('Gold');

SELECT * FROM data_layers;

ALTER TABLE data_layers ADD COLUMN manager_email varchar(100);

UPDATE data_layers 
SET manager_email = 'bronze.manager@example.com' 
WHERE layername = 'Bronze';

UPDATE data_layers 
SET manager_email = 'silver.manager@example.com' 
WHERE layername = 'Silver';

UPDATE data_layers 
SET manager_email = 'gold.manager@example.com' 
WHERE layername = 'Gold';


ALTER TABLE data_layers ADD CONSTRAINT manager_email UNIQUE (manager_email);

ALTER TABLE shops RENAME COLUMN address TO shop_address;