# IMPORTACiÓN LIBRERIAS
import pandas as pd 
import numpy as np
import pyodbc
from sqlalchemy import create_engine

# CONEXIÓN CON DATABASE DE SQL
# Cadena de conexión para SQL Server con autenticación de Windows
conn_str = (
    'mssql+pyodbc://@LAPTOP-NJDM6MFL/BD_VITICOLE?'
    'driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes'
)
engine = create_engine(conn_str)

# CREACIÓN DE DATAFRAMES CON LAS TABLAS DE DATABASE
df_Productos = pd.read_sql('SELECT * FROM PRODUCTOS', engine)
df_OrdenesCompra = pd.read_sql('SELECT * FROM OrdenesCompra', engine)
df_InventarioInicial = pd.read_sql('SELECT * FROM InventarioInicial', engine)
df_InventarioFinal = pd.read_sql('SELECT * FROM InventarioFinal', engine)
df_Compras = pd.read_sql('SELECT * FROM Compras', engine)
df_Ventas = pd.read_sql('SELECT * FROM Ventas', engine)

# TABLA PRODUCTOS
# Sacamos "" a los strings
df_Productos.map(lambda x: x.strip('"') if isinstance(x, str) else x)

# Dropeo de duplicados
df_Productos.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_Productos.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_Productos.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Guardamos los datos filtrados en un archivo nuevo
df_Productos.to_csv('Productos_Final.csv', index=False)

# TABLA INVENTARIO INICIAL
# Dropeo de duplicados
df_InventarioInicial.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_InventarioInicial.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_InventarioInicial.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Convertimos variables que contienen fechas a su formato correspondiente
df_InventarioInicial["startDate"] = pd.to_datetime(df_InventarioInicial["startDate"])

# No hace falta tratamiento de nulos debido a que no hay ninguno

# Guardamos los datos filtrados en un archivo nuevo
df_InventarioInicial.to_csv('InventarioInicial_Final.csv', index=False)

# TABLA INVENTARIO FINAL
# Convertimos variables que contienen fechas a su formato correspondiente
df_InventarioFinal["endDate"] = pd.to_datetime(df_InventarioFinal["endDate"])

# Dropeo de duplicados
df_InventarioFinal.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_InventarioFinal.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_InventarioFinal.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Tratamiento de nulos
# Filtramos la base de inventario inicial y nos quedamos con el nombre de la City para el store 46 
city_46 = df_InventarioInicial[df_InventarioInicial["Store"] == 46]
city_46 = city_46["City"].unique() # Nos quedamos con los valores únicos de City para dicho store
# Reemplazamos los valores nulos, la ciudad para el store 46, con el valor obtenido
df_InventarioFinal['City'] = df_InventarioFinal['City'].fillna(city_46[0]) # El [0] es para quedarnos con el string y que no lo interprete como array

# Guardamos los datos filtrados en un archivo nuevo
df_InventarioFinal.to_csv('InventarioFinal_Final.csv', index=False)

# TABLA ORDENES COMPRA
# Sacamos "" a los strings
df_OrdenesCompra.map(lambda x: x.strip('"') if isinstance(x, str) else x)

# Convertimos variables que contienen fechas a su formato correspondiente
df_OrdenesCompra["InvoiceDate"] = pd.to_datetime(df_OrdenesCompra["InvoiceDate"])
df_OrdenesCompra["PODate"] = pd.to_datetime(df_OrdenesCompra["PODate"])
df_OrdenesCompra["PayDate"] = pd.to_datetime(df_OrdenesCompra["PayDate"])

# Dropeo de duplicados
df_OrdenesCompra.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_OrdenesCompra.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_OrdenesCompra.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Guardamos los datos filtrados en un archivo nuevo
df_OrdenesCompra.to_csv('OrdenesCompra_Final.csv', index=False)

# TABLA COMPRAS
# Convertimos variables que contienen fechas a su formato correspondiente
df_Compras["SalesDate"] = pd.to_datetime(df_Compras["SalesDate"])

# Dropeo de duplicados
df_Compras.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_Compras.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_Compras.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# No hace falta tratamiento de nulos debido a que no hay ninguno

# Guardamos los datos filtrados en un archivo nuevo
df_Compras.to_csv('Compras_Final.csv', index=True)

# TABLA VENTAS
# Convertimos variables que contienen fechas a su formato correspondiente
df_Ventas["PODate"] = pd.to_datetime(df_Ventas["PODate"])
df_Ventas["ReceivingDate"] = pd.to_datetime(df_Ventas["ReceivingDate"])
df_Ventas["InvoiceDate"] = pd.to_datetime(df_Ventas["InvoiceDate"])
df_Ventas["PayDate"] = pd.to_datetime(df_Ventas["PayDate"])

# Dropeo de duplicados
df_Ventas.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_Ventas.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_Ventas.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Tratamiento de nulos
df_Ventas['Size'] = df_Ventas['Size'].fillna('750mL')

# Guardamos los datos filtrados en un archivo nuevo
df_Ventas.to_csv('Ventas_Final.csv', index=True)