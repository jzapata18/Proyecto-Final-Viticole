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
size VARCHAR (200), --tamaño del producto especificado en unidades de medida
volume DECIMAL (15,2), -- volumen del producto en mililitros
classification INT, -- categoria a la que pertenece el producto
purchase_price DECIMAL (15,2), -- precio al que se compra el producto
ID_vendors_number INT, -- identificador unico del proveedor del producto
FOREIGN KEY (ID_vendors_number) REFERENCES dim_vendors(ID_vendors_number)--clave foranea que vincula  la columna ID_vendors_number de esta tabla-- con la columna ID_vendors_number de la tabla DIM_VENDORS. esto asegura que cada producto tenga un proveedor valido
); 


-- CREACION TABLA DE ORDENES DE COMPRA REALIZADAS A LOS PROVEEDORES
CREATE TABLE DIM_INVOICE_PURCHASE (
ID_po_number INT PRIMARY KEY NOT NULL, --identificador unico de la compra
ID_vendors_number INT, -- identificador del proveedor
invoice_date DATE, -- fecha en que se genero la factura de compra
po_date DATE, --fecha en que se genero la orden de compra
pay_date DATE, -- fecha en que se realiza el pago
quantity INT NOT NULL, --cantidad de unidades compradas del producto
total_amount DECIMAL (15,2), -- importe total de la compra
freight DECIMAL (15,2), --costo del envio  de la compra
approval VARCHAR(200), -- estado de la orden de la compra
FOREIGN KEY (ID_vendors_number) REFERENCES dim_Vendors(ID_vendors_number) -- se establece una relacion  con la tabla de proveedores mediante una clave foranea
);

-- CRACION TABLA DE TIENDAS
CREATE TABLE DIM_STORE(
ID_store INT PRIMARY KEY NOT NULL,
city VARCHAR (200)
);

-- CREACION DE LA TABLA INVENTARIO INICIAL
CREATE TABLE InventarioInicial(
ID_inventario_inicial INT PRIMARY KEY NOT NULL IDENTITY (1,1),
ID_store INT,
ID_brand INT,
Description VARCHAR(200),
Size VARCHAR(200),
On_hands INT CHECK (on_hands>=0),
Sales_Price DECIMAL(10,2),
Start_Date DATE NOT NULL,
FOREIGN KEY (ID_store) REFERENCES DIM_STORE(ID_store),
FOREIGN KEY (ID_BRAND) REFERENCES DIM_PRODUCTS (ID_brand)
);

-- CREACION DE TABLA INVENTARIO FINAL
CREATE TABLE InventarioFinal(
ID_inventario_final INT PRIMARY KEY NOT NULL IDENTITY (1,1),
ID_store INT,
ID_brand INT,
Description VARCHAR(200),
Size VARCHAR(200),
On_hands INT CHECK (on_hands>=0),
Sales_price DECIMAL(10,2),
End_Date DATE NOT NULL,
FOREIGN KEY (ID_store) REFERENCES DIM_STORE(ID_store),
FOREIGN KEY (ID_BRAND) REFERENCES DIM_PRODUCTS (ID_brand)
);


-- CREACION TABLA DE VENTAS
CREATE TABLE FACTS_SALES (
ID_sales INT PRIMARY KEY NOT NULL IDENTITY (1,1), -- llave primaria automatica
ID_inventario_final INT, -- se conecta con el inventario para saber de que stock se vendio
ID_store INT, -- que tienda hizo la venta
ID_vendors_number INT, -- que proveedor participo de la venta
ID_brand INT, -- que producto se vendio
sales_date DATE, -- cuando se vendio
quantity_sales INT, -- cuantas unidades se vendieron
sales_price DECIMAL (15,2), -- precio de venta unitario
total_amount DECIMAL (15,2), -- total de ventas
excise_tax DECIMAL (15,2), -- impuesto aplicado
FOREIGN KEY (ID_inventario_final) REFERENCES InventarioFinal(ID_inventario_final),
FOREIGN KEY (ID_store) REFERENCES DIM_STORE(ID_store),
FOREIGN KEY (ID_vendors_number) REFERENCES DIM_VENDORS (ID_vendors_number),
FOREIGN KEY (ID_BRAND) REFERENCES DIM_PRODUCTS(ID_brand)
);

--TABLA DE COMPRAS
CREATE TABLE FACTS_PURCHASE(
ID_purchase INT PRIMARY KEY NOT NULL IDENTITY(1,1), -- llave primaria
ID_inventario_inicial INT,
ID_store INT, -- que tienda compro
ID_brand INT, -- que producto se compro
ID_vendors_number INT, -- de que proveedor compraron
ID_po_number INT,  -- numero de orden de compra
receiving_date DATE,  -- cuando recibieron el producto
purchase_price DECIMAL(15,2), --precio de compra unitario
quantity_price DECIMAL(15,2), -- cuantas unidades compraron
total_amount DECIMAL(15,2), -- total de compra
FOREIGN KEY (ID_inventario_inicial) REFERENCES InventarioInicial(ID_inventario_inicial),
FOREIGN KEY (ID_store) REFERENCES DIM_STORE(ID_store),
FOREIGN KEY (ID_brand) REFERENCES DIM_PRODUCTS(ID_brand),
FOREIGN KEY (ID_vendors_number) REFERENCES DIM_VENDORS(ID_vendors_number)
);