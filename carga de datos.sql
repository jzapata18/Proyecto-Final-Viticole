BULK INSERT BD_VITICOLE.dbo.Productos
FROM 'C:\Users\Usuario\Desktop\Melina\henrry\Proyecto Final\CVS\productos.csv'
WITH (
    FIELDTERMINATOR = ';',  -- Delimitador de campos
    ROWTERMINATOR = '\n',   -- Delimitador de filas
    FIRSTROW = 2,           -- Ignorar la fila de encabezado
    TABLOCK
	);

----------------CHEK TABLA DE PRODUCTOS---------------------
SELECT TOP 10 * FROM Productos;
SELECT COUNT(*) AS TotalFilas FROM Productos;
------------------------------------------------------------

BULK INSERT BD_VITICOLE.dbo.InventarioInicial
FROM 'C:\Users\Usuario\Desktop\Melina\henrry\Proyecto Final\CVS\InventarioInicial.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
----------------CHEK TABLA DE INVENTARIO INICIAL-------------
SELECT TOP 10 * FROM InventarioInicial;
SELECT COUNT(*) AS TotalFilas FROM InventarioInicial;
--------------------------------------------------------------

BULK INSERT BD_VITICOLE.dbo.InventarioFinal
FROM 'C:\Users\Usuario\Desktop\Melina\henrry\Proyecto Final\CVS\InventarioFinal.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
--------------- CHEK TABLA DE INVENTARIO FINAL-----------------
SELECT TOP 10 * FROM InventarioFinal;
SELECT COUNT(*) AS TotalFilas FROM InventarioFinal;
-----------------------------------------------------------------


BULK INSERT BD_VITICOLE.dbo.Ventas
FROM 'C:\Users\Usuario\Desktop\Melina\henrry\Proyecto Final\CVS\ventas.csv'
WITH (
    FIELDTERMINATOR = ',',       -- o ';' si usás punto y coma
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
---------------- CHEK VENTAS-------------
SELECT TOP 10 * FROM Ventas;
SELECT COUNT(*) AS TotalFilas FROM Ventas;
------------------------------------------


BULK INSERT BD_VITICOLE.dbo.OrdenesCompra
FROM 'C:\Users\Usuario\Desktop\Melina\henrry\Proyecto Final\CVS\OrdenesCompra.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);

----------CHEK ORDENES COMPRA-----------------
SELECT TOP 10 * FROM OrdenesCompra;
SELECT COUNT(*) AS TotalFilas FROM OrdenesCompra;
-------------------------------------------------

	BULK INSERT BD_VITICOLE.dbo.compras
FROM 'C:\Users\Usuario\Desktop\Melina\henrry\Proyecto Final\CVS\COMPRAS.csv'
WITH (
    FIELDTERMINATOR = ',',       -- o ';' si usás punto y coma
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK,
	CODEPAGE = '65001'  -- importante si hay tildes o ñ
);

--REVISAR REVISAR REVISAR REVISAR REVISAR 
----------------------------------------------------
SELECT TOP 10 * FROM Compras;
SELECT COUNT(*) AS TotalFilas FROM compras;   --- en el csv me da un total de 1048576