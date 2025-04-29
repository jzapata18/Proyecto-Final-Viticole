-- CREACION DE BASE DE DATOS
CREATE DATABASE BD_VITICOLE;
-- USO DE BASE DE DATOS
USE BD_VITICOLE;

-- CREACION TABLA DE PROVEEDORES
CREATE TABLE DIM_VENDORS(
ID_vendors_number INT PRIMARY KEY NOT NULL,
vendors_name VARCHAR (200) UNIQUE
);

-- CREACION TABLA DE PRODUCTOS
CREATE TABLE DIM_PRODUCTS(
ID_brand INT PRIMARY KEY NOT NULL, -- CLAVE PRIMARIA: identificador unico para cada producto
description VARCHAR(200), -- descripcion del producto
sales_price DECIMAL(15,2), -- precio de venta del producto
size VARCHAR (200), --tamaño del producto
volume DECIMAL (15,2), -- volumen del producto
classification INT, -- clasificiacion del producto
purchase_price DECIMAL (15,2), -- precio de compra del producto
ID_vendors_number INT, -- id del proveedor del producto
FOREIGN KEY (ID_vendors_number) REFERENCES dim_vendors(ID_vendors_number) --clave foranea que vincula  la columna ID_vendors_number de esta tabla
-- con la columna ID_vendors_number de la tabla DIM_VENDORS. esto asegura que cada producto tenga un proveedor valido
);

-- CREACION TABLA DE ORDENES DE COMPRA REALIZADAS A LOS PROVEEDORES
CREATE TABLE DIM_INVOICE_PURCHASE (
ID_po_number INT PRIMARY KEY NOT NULL, --clave primaria 
ID_vendors_number INT, -- identificador del proveedor
invoice_date DATE, -- fecha en que se genero la factura de compra
po_date DATE, --fecha en que se genero la orden de compra
pay_date DATE, -- fecha en que se realiza el pago
quantity INT, --cantidad de productos ordenados
total_amount DECIMAL (15,2), -- monto total de la factura
freight DECIMAL (15,2), --costo del envio  de la compra
approval VARCHAR(200), -- estado de la orden de la compra
FOREIGN KEY (ID_vendors_number) REFERENCES dim_Vendors(ID_vendors_number) -- se establece una relacion  con la tabla de proveedores mediante una clave foranea
);

-- CRACION TABLA DE TIENDAS
CREATE TABLE DIM_STORE(
ID_store INT PRIMARY KEY NOT NULL,
city VARCHAR (200)
);

-- CREACION TABLA INVENTARIO
CREATE TABLE FACTS_INVENTARIO (
ID_inventario INT PRIMARY KEY NOT NULL IDENTITY (1,1), -- ID unico del inventario, empieza en 1 y se incrementa automaticamente con cada nuevo registro
ID_store INT, --  ID de la tienda, relacionada con la tabla ID_store
ID_brand INT, -- ID del producto, relacionado con la tabla ID_products
on_hands INT CHECK (on_hands >=0), -- cantidad de productos en el inventario, no puede ser negativo
sales_price DECIMAL (15,2),
dates DATE DEFAULT GETDATE(),
ID_purchases INT,
ID_sales INT,
FOREIGN KEY (ID_store) REFERENCES DIM_STORE(ID_store),
FOREIGN KEY (ID_BRAND) REFERENCES DIM_PRODUCTS (ID_brand)
);

-- CREACION TABLA DE VENTAS
CREATE TABLE FACTS_SALES (
ID_sales INT PRIMARY KEY NOT NULL IDENTITY (1,1), -- llave primaria automatica
ID_inventario INT, -- se conecta con el inventario para saber de que stock se vendio
ID_store INT, -- que tienda hizo la venta
ID_vendors_number INT, -- que proveedor participo de la venta
ID_brand INT, -- que producto se vendio
sales_date DATE, -- cuando se vendio
quantity_sales INT, -- cuantas unidades se vendieron
sales_price DECIMAL (15,2), -- precio de venta unitario
total_amount DECIMAL (15,2), -- total de ventas
excise_tax DECIMAL (15,2), -- impuesto aplicado
FOREIGN KEY (ID_inventario) REFERENCES FACTS_INVENTARIO(ID_inventario),
FOREIGN KEY (ID_store) REFERENCES DIM_STORE(ID_store),
FOREIGN KEY (ID_vendors_number) REFERENCES DIM_VENDORS (ID_vendors_number),
FOREIGN KEY (ID_BRAND) REFERENCES DIM_PRODUCTS(ID_brand)
);

TABLA DE COMPRAS
CREATE TABLE FACTS_PURCHASE(
ID_purchase INT PRIMARY KEY NOT NULL IDENTITY(1,1), -- llave primaria
ID_inventario INT, -- se conecta con el inventario para saber a que stock corresponde
ID_store INT, -- que tienda compro
ID_brand INT, -- que producto se compro
ID_vendors_number INT, -- de que proveedor compraron
ID_po_number INT,  -- numero de orden de compra
receiving_date DATE,  -- cuando recibieron el producto
purchase_price DECIMAL(15,2), --precio de compra unitario
quantity_price DECIMAL(15,2), -- cuantas unidades compraron
total_amount DECIMAL(15,2), -- total de compra
FOREIGN KEY (ID_inventario) REFERENCES FACTS_INVENTARIO(ID_inventario),
FOREIGN KEY (ID_store) REFERENCES DIM_STORE(ID_store),
FOREIGN KEY (ID_brand) REFERENCES DIM_PRODUCTS(ID_brand),
FOREIGN KEY (ID_vendors_number) REFERENCES DIM_VENDORS(ID_vendors_number)
);