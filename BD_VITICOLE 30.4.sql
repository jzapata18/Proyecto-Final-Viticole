-- CREACION DE BASE DE DATOS
CREATE DATABASE BD_VITICOLE;
--USO DE BASE DE DATOS
USE BD_VITICOLE;

-- CREACION TABLA DE PROVEEDORES
CREATE TABLE PROVEEDORES(
ID_vendors_number INT PRIMARY KEY NOT NULL,
vendors_name VARCHAR (200) UNIQUE
);

-- CREACION TABLA DE PRUDUCTOS
CREATE TABLE PRODUCTOS (
	ID_Brand INT PRIMARY KEY NOT NULL, -- IDENTIFICADOR UNICO PARA CADA PRODUCTO
	Description VARCHAR(200), --DESCRIPCION DEL PRODUCTO
	Sales_Price DECIMAL(10,2) NOT NULL, -- PRECIO DE VENTA DEL PRODUCTO
	Size VARCHAR(200), -- TAMAÑO DEL PRODUCTO ESPECIFICANDO EN UNIDADES DE MEDIDA
	Volume INT NOT NULL, --VOLUMEN DEL PRODUCTO EN MILIMETROS
	Classification INT, -- CATEGORIA EN LA QUE PERTENECE EL PRODUCTO
	Purchase_Price DECIMAL(10,2) NOT NULL, -- PRECIO AL QUE SE COMPRA EL PRODUCTO
	VendorNumber INT, -- NUMERO DEL VENDEDOR
	VendorName VARCHAR(200)); -- NOMBRE DEL VENDEDOR

-- CREACION TABLA DE ORDENES DE COMPRA REALIZADAS A LOS PROVEEDORES
CREATE TABLE OrdenesCompra(
	VendorNumber INT,
	VendorName VARCHAR(200),
	InvoiceDate DATE, -- fecha en que se genero la factura de compra
	ID_PONumber INT PRIMARY KEY NOT NULL,
	PODate DATE, -- FECHA EN LA QUE SE GENERO LA ORDEN DE COMPRA
	PayDate DATE, -- FECHA EN QUE SE REALIZA EL PAGO
	Quantity INT NOT NULL, -- CANTIDAD DE UNIDADES COMPRADAS DEL PRODUCTO
	Total_Amount DECIMAL(10,2) NOT NULL, -- IMPORTE TOTAL DE LA COMPRA
	Freight DECIMAL(10,2) NOT NULL, -- COSTO DEL ENVIO DE LA COMPRA
	Approval VARCHAR(200)); -- ESTADO DE LA ORDEN DE LA COMPRA

-- CRACION TABLA DE TIENDAS
CREATE TABLE TIENDAS(
ID_store INT PRIMARY KEY NOT NULL,
city VARCHAR (200)
);

    -- CREACION TABLA INVENTARIO INICIAL
CREATE TABLE InventarioInicial(
	ID_inventario_inicial VARCHAR(50) PRIMARY KEY,
	Store INT NOT NULL,
	City VARCHAR(50),
	Brand INT NOT NULL,
	Description VARCHAR(200),
	Size VARCHAR(200),
	onHand INT NOT NULL,
	Price DECIMAL(10,2),
	startDate DATE NOT NULL);

	-- CREACION TABLA INVENTARIO FINAL
CREATE TABLE InventarioFinal(
	ID_inventario_final VARCHAR(50) PRIMARY KEY,
	Store INT NOT NULL,
	City VARCHAR(50) NOT NULL,
	Brand INT NOT NULL,
	Description VARCHAR(200),
	Size VARCHAR(200),
	onHand INT NOT NULL,
	Price DECIMAL(10,2),
	endDate DATE NOT NULL);

	-- CREACION TABLA COMPRAS
CREATE TABLE Compras(
	InventoryId VARCHAR(50) NOT NULL,
	Store INT NOT NULL, -- QUE TIENDA COMPRO
	Brand INT NOT NULL, -- QUE PRODUCTO SE COMPRO
	Description VARCHAR(200),
	Size VARCHAR(200),
	VendorNumber INT,
	VendorName VARCHAR(200),
	PONumber INT NOT NULL,
	PODate DATE,
	ReceivingDate DATE NOT NULL, -- CUANDO RECIBIERON EL PRODUCTO
	InvoiceDate DATE,
	PayDate DATE,
	Purchase_Price DECIMAL(10,2), -- PRECIO DE COMPRA UNITARIO
	Quantity INT NOT NULL, -- CUANTAS UNIDADES COMPRARON
	Total_Amount DECIMAL(10,2), -- TOTAL DE COMPRA
	Classification VARCHAR(50));
	
	-- CREACION TABLA VENTAS
CREATE TABLE Ventas(
	InventoryId VARCHAR(50) NOT NULL,
	Store INT NOT NULL,
	Brand INT NOT NULL,
	Description VARCHAR(200),
	Size VARCHAR(200),
	SalesQuantity INT NOT NULL,
	SalesDollars DECIMAL(10,2),
	SalesPrice DECIMAL(10,2),
	SalesDate DATE NOT NULL,
	Volume INT,
	Classification VARCHAR(50),
	ExciseTax DECIMAL(10,2) NOT NULL,
	VendorNo INT,
	VendorName VARCHAR(200));
	



------------------------------------------------------------------
-- GENERAR LAS RELACIONES
------------------------------------------------------------------

-- Generar Relacion entre Compras y OrdenesCompra
ALTER TABLE Compras
ADD CONSTRAINT FK_Compras_OrdenesCompra
FOREIGN KEY (PONumber) REFERENCES OrdenesCompra(ID_PONumber);

-- Generar Relacion entre Compras y Productos
ALTER TABLE Compras
ADD CONSTRAINT FK_Compras_Productos
FOREIGN KEY (Brand) REFERENCES PRODUCTOS(ID_Brand);

-- Generar Relacion entre Compras y InventarioInicial
ALTER TABLE Compras
ADD CONSTRAINT FK_Compras_InventarioInicial
FOREIGN KEY (InventoryId) REFERENCES InventarioInicial(ID_inventario_inicial);  

-- Generar Relacion entre Ventas y InventarioFinal
ALTER TABLE Ventas
ADD CONSTRAINT FK_Ventas_InventarioFinal
FOREIGN KEY (InventoryId) REFERENCES InventarioFinal(ID_inventario_final); 

-- Generar Relacion entre ventas y productos
ALTER TABLE Ventas
ADD CONSTRAINT FK_Ventas_Productos
FOREIGN KEY (Brand) REFERENCES PRODUCTOS(ID_Brand);

-- Generar Relacion entre InventarioInicial y productos
ALTER TABLE InventarioInicial
ADD CONSTRAINT FK_InventarioInicial_Productos
FOREIGN KEY (Brand) REFERENCES PRODUCTOS(ID_Brand);

-- Generar Relacion entre InventarioFinal y productos
ALTER TABLE InventarioFinal
ADD CONSTRAINT FK_InventarioFinal_Productos
FOREIGN KEY (Brand) REFERENCES PRODUCTOS(ID_Brand);
