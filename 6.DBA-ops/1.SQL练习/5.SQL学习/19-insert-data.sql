-- 插入数据
-- 插入完整的行
INSERT INTO customers VALUES(NULL,'Pep E. LaPew','100 Main Street','Los Angeles','CA','90046','USA',NULL,NULL);
-- 插入多个行
INSERT INTO customers(cust_name,cust_address,cust_city,cust_state,cust_zip,cust_country) VALUES('Pep E. LaPew','100 Main Street','Los Angeles','CA','90046','USA'),('M. Martian','42 Galaxy Way','New York','NY','11213','USA');
SELECT * from customers;
