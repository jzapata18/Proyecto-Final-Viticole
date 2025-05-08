# === IMPORTACIÓN DE LIBRERIAS ===
import pandas as pd 
import numpy as np
import pyodbc
from sqlalchemy import create_engine
import os
import shutil
import zipfile
from kaggle.api.kaggle_api_extended import KaggleApi

# === DESCARGA DE ARCHIVOS CSV DE KAGGLE ===
# Configuración
DATASET = 'bhanupratapbiswas/inventory-analysis-case-study'
NOMBRE_ARCHIVO_ZIP = 'inventory-analysis-case-study.zip'

# Obtener la ruta a la carpeta "Downloads" del usuario actual
DIRECTORIO_DESTINO = os.path.join(os.path.expanduser("~"), "Downloads", "datasets_kaggle")

# Limpiar carpeta previa
if os.path.exists(DIRECTORIO_DESTINO):
    shutil.rmtree(DIRECTORIO_DESTINO)
os.makedirs(DIRECTORIO_DESTINO, exist_ok=True)

# Descarga desde Kaggle
api = KaggleApi()
api.authenticate()
api.dataset_download_files(DATASET, path=DIRECTORIO_DESTINO, unzip=True)

# Eliminar archivo zip si fue descargado
zip_path = os.path.join(DIRECTORIO_DESTINO, NOMBRE_ARCHIVO_ZIP)
if os.path.exists(zip_path):
    os.remove(zip_path)

print('Descarga completada correctamente en:', DIRECTORIO_DESTINO)

# === CREACIÓN DE DATAFRAMES CON LOS ARCHIVOS CSV ===
# Creamos los dataframes
df_Productos = pd.read_csv(DIRECTORIO_DESTINO + "/2017PurchasePricesDec.csv", sep=',')
df_OrdenesCompra = pd.read_csv(DIRECTORIO_DESTINO + "/InvoicePurchases12312016.csv", sep=',')
df_InventarioInicial = pd.read_csv(DIRECTORIO_DESTINO + "/BegInvFINAL12312016.csv", sep=',')
df_InventarioFinal = pd.read_csv(DIRECTORIO_DESTINO + "/EndInvFINAL12312016.csv", sep=',')
df_Compras = pd.read_csv(DIRECTORIO_DESTINO + "/PurchasesFINAL12312016.csv", sep=',')
df_Ventas = pd.read_csv(DIRECTORIO_DESTINO + "/SalesFINAL12312016.csv", sep=',')

# === CREACIÓN DE DATAFRAMES NORMALIZADOS ===
# Los construímos a partir de valores únicos de otros dataframes
df_Tiendas = df_InventarioInicial[['Store', 'City']].drop_duplicates().reset_index(drop=True)
df_Proveedores = df_OrdenesCompra[['VendorNumber', 'VendorName']].drop_duplicates().reset_index(drop=True)

# Reenombramos los campos necesarios
df_Tiendas = df_Tiendas.rename(columns={'Store': 'Id_Store'})
df_Proveedores = df_Proveedores.rename(columns={
    'VendorNumber': 'Id_Vendor_Number',
    'VendorName': 'Vendor_Name'
    })

# === TABLA PRODUCTOS ===
# Redondeamos a dos decimales todas las columnas numéricas
df_Productos = df_Productos.round(2)

# Dropeo de duplicados
df_Productos.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_Productos.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_Productos.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Tratamiento de nulos específico
df_Productos = df_Productos[df_Productos["Volume"] != "Unknown"]
df_Productos = df_Productos.dropna(subset=["Volume"])

# Reenombramos los campos necesarios
df_Productos = (df_Productos.rename(columns={
    'Brand': 'Id_Brand',
    'PurchasePrice': 'Purchase_Price',
    'VendorNumber': 'Id_Vendor_Number',
    'Price' : 'Sales_Price'
})
[['Id_Brand', 'Id_Vendor_Number', 'Description', 'Classification', 'Size', 'Volume', 
  'Purchase_Price', 'Sales_Price']])

# === TABLA INVENTARIO INICIAL ===
# Convertimos variables que contienen fechas a su formato correspondiente
df_InventarioInicial["startDate"] = pd.to_datetime(df_InventarioInicial["startDate"])

# Redondeamos a dos decimales todas las columnas numéricas
df_InventarioInicial = df_InventarioInicial.round(2)

# Dropeo de duplicados
df_InventarioInicial.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_InventarioInicial.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_InventarioInicial.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Seleccionamos y reenombramos solo los campos necesarios
df_InventarioInicial = (df_InventarioInicial.rename(columns={
'InventoryId':'Id_Inventario',
'Store':'Id_Store',
'Brand':'Id_Brand',
'onHand':'On_Hand',
'Price':'Sales_Price',
'startDate':'Date'
})
[['Id_Inventario', 'Id_Store', 'Id_Brand', 'On_Hand', 
  'Sales_Price', 'Date']])

# === TABLA INVENTARIO FINAL ===
# Convertimos variables que contienen fechas a su formato correspondiente
df_InventarioFinal["endDate"] = pd.to_datetime(df_InventarioFinal["endDate"])

# Redondeamos a dos decimales todas las columnas numéricas
df_InventarioFinal = df_InventarioFinal.round(2)

# Dropeo de duplicados
df_InventarioFinal.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_InventarioFinal.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_InventarioFinal.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Tratamiento de nulos
# Filtramos el df de tiendas y nos quedamos con el nombre de la City para el store 46 
city_46 = df_Tiendas[df_Tiendas["Id_Store"] == 46]
city_46 = city_46["City"].unique() # Nos quedamos con los valores únicos de City para dicho store
# Reemplazamos los valores nulos, la ciudad para el store 46, con el valor obtenido
df_InventarioFinal['City'] = df_InventarioFinal['City'].fillna(city_46[0]) # El [0] es para quedarnos con el string y que no lo interprete como array

# Seleccionamos y reenombramos solo los campos necesarios
df_InventarioFinal = (df_InventarioFinal.rename(columns={
'InventoryId':'Id_Inventario',
'Store':'Id_Store',
'Brand':'Id_Brand',
'onHand':'On_Hand',
'Price':'Sales_Price',
'endDate':'Date'
})
[['Id_Inventario', 'Id_Store', 'Id_Brand', 'On_Hand', 
  'Sales_Price', 'Date']])

# === TABLA ORDENES COMPRA ===
# Convertimos variables que contienen fechas a su formato correspondiente
df_OrdenesCompra["InvoiceDate"] = pd.to_datetime(df_OrdenesCompra["InvoiceDate"])
df_OrdenesCompra["PODate"] = pd.to_datetime(df_OrdenesCompra["PODate"])
df_OrdenesCompra["PayDate"] = pd.to_datetime(df_OrdenesCompra["PayDate"])

# Redondeamos a dos decimales todas las columnas numéricas
df_OrdenesCompra = df_OrdenesCompra.round(2)

# Dropeo de duplicados
df_OrdenesCompra.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_OrdenesCompra.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_OrdenesCompra.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Solo se ecuentran valores nulos en la columna 'approval' que no resulta relevante para el análisis
df_OrdenesCompra["Approval"] = df_OrdenesCompra["Approval"].fillna("None")

# Seleccionamos y reenombramos solo los campos necesarios
df_OrdenesCompra = (df_OrdenesCompra.rename(columns={
    'PONumber': 'Id_Po_Number',
    'VendorNumber': 'Id_Vendor_Number',
    'InvoiceDate': 'Invoice_Date',
    'PODate': 'Po_Date',
    'PayDate': 'Pay_Date',
    'Quantity': 'Total_Quantity',
    'Dollars': 'Total_Amount',
    'Freight': 'Freight',
    'Approval': 'Approval'})
[['Id_Po_Number', 'Id_Vendor_Number', 'Po_Date', 'Invoice_Date', 'Pay_Date', 'Total_Quantity',
    'Total_Amount', 'Freight', 'Approval']])

# === TABLA VENTAS ===
# Convertimos variables que contienen fechas a su formato correspondiente
df_Ventas["SalesDate"] = pd.to_datetime(df_Ventas["SalesDate"])

# Redondeamos a dos decimales todas las columnas numéricas
df_Ventas = df_Ventas.round(2)

# Dropeo de duplicados
df_Ventas.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_Ventas.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_Ventas.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Seleccionamos y reenombramos solo los campos necesarios
df_Ventas = (df_Ventas.rename(columns={
    'InventoryId': 'Id_Inventario',
    'Store': 'Id_Store',
    'Brand': 'Id_Brand',
    'SalesQuantity': 'Quantity_Sales',
    'SalesDollars': 'Total_Amount',
    'SalesPrice': 'Sales_Price',
    'SalesDate': 'Sales_Date',
    'ExciseTax': 'Excise_Tax',
    'VendorNo': 'Id_Vendor_Number',     
})
[['Id_Inventario', 'Id_Store', 'Id_Brand', 'Id_Vendor_Number', 
  'Sales_Date', 'Quantity_Sales', 'Sales_Price', 
  'Total_Amount', 'Excise_Tax']])

# Le asignamos nombre al índice que actúa como PK
df_Ventas.index.name = "Id_Venta"

# === TABLA COMPRAS ===
# Convertimos variables que contienen fechas a su formato correspondiente
df_Compras["PODate"] = pd.to_datetime(df_Compras["PODate"])
df_Compras["ReceivingDate"] = pd.to_datetime(df_Compras["ReceivingDate"])
df_Compras["InvoiceDate"] = pd.to_datetime(df_Compras["InvoiceDate"])
df_Compras["PayDate"] = pd.to_datetime(df_Compras["PayDate"])

# Redondeamos a dos decimales todas las columnas numéricas
df_Compras = df_Compras.round(2)

# Dropeo de duplicados
df_Compras.drop_duplicates(inplace=True)

# Dropeo de registros y columnas 100% nulos
df_Compras.dropna(axis=0, how="all", inplace=True) # Eliminamos filas con todos sus valores nulos
df_Compras.dropna(axis=1, how="all", inplace=True) # Eliminamos columnas con todos sus valores nulos

# Tratamiento de nulos
df_Compras['Size'] = df_Compras['Size'].fillna('750mL')

# Seleccionamos y reenombramos solo los campos necesarios
df_Compras = (
    df_Compras.rename(columns={
        'InventoryId': 'Id_Inventario',
        'Store': 'Id_Store',
        'Brand': 'Id_Brand',
        'VendorNumber': 'Id_Vendor_Number',
        'PONumber': 'Id_Po_Number',
        'ReceivingDate': 'Receiving_Date',
        'PurchasePrice': 'Purchase_Price',
        'Quantity': 'Quantity_Purchases',
        'Dollars': 'Total_Amount',
    })
    [['Id_Inventario', 'Id_Store', 'Id_Brand', 'Id_Vendor_Number', 
      'Id_Po_Number', 'Receiving_Date', 'Purchase_Price', 
      'Quantity_Purchases', 'Total_Amount']]
)

# Le asignamos nombre al índice que actúa como PK
df_Compras.index.name = "Id_Compra"

# === CARGA A DATABASE ===
# Conexión con la base de datos de SQL
server = 'sqlserver-viticole.database.windows.net '
database = 'DB_Viticole'  
username = 'UserGianniViticole' # Completar con usuario
password = 'DAFT12.userGianni' # Completar con contraseña
driver = 'ODBC Driver 17 for SQL Server'  # o el que tengas instalado

# Cadena de conexión
connection_string = f"mssql+pyodbc://{username}:{password}@{server}/{database}?driver={driver}"
engine = create_engine(connection_string)

# Generación de tablas en la base de datos
# Tabla tiendas
df_Tiendas.to_sql('Tiendas', con=engine, if_exists='replace', index=False)
print("Se generó la tabla tiendas")

# Tabla proveedores
df_Proveedores.to_sql('Proveedores', con=engine, if_exists='replace', index=False)
print("Se generó la tabla proveedores")

# Tabla productos
df_Productos.to_sql('Productos', con=engine, if_exists='replace', index=False)
print("Se generó la tabla productos")
                      
# Tabla inventario inicial
df_InventarioInicial.to_sql('InventarioInicial', con=engine, if_exists='replace', index=False)
print("Se generó la tabla inventario inicial")

# Tabla inventario final
df_InventarioFinal.to_sql('InventarioFinal', con=engine, if_exists='replace', index=False)
print("Se generó la tabla inventario final")

# Tabla ordenes compras
df_OrdenesCompra.to_sql('OrdenesCompra', con=engine, if_exists='replace', index=False)
print("Se generó la tabla ordenes compras")

# Tabla ventas
df_Ventas.to_sql('Ventas', con=engine, if_exists='replace', index=True)
print("Se generó la tabla ventas")

# Tabla compras
df_Compras.to_sql('Compras', con=engine, if_exists='replace', index=True)
print("Se generó la tabla compras")

print("Script terminado.")