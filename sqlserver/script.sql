CREATE DATABASE ss2pf1;

USE ss2pf1;


DROP TABLE IF EXISTS ventas;

DROP TABLE IF EXISTS compras;


CREATE TABLE ventas(
    Fecha DATE,
    CodigoCliente VARCHAR(50),
    NombreCliente VARCHAR(200),
    TipoCliente VARCHAR(50),
    DireccionCliente VARCHAR(200),
    NumeroCliente VARCHAR(50),
    CodVendedor VARCHAR(50),
    NombreVendedor VARCHAR(200),
    Vacacionista VARCHAR(50),
    CodProducto VARCHAR(50),
    NombreProducto VARCHAR(200),
    MarcaProducto VARCHAR(50),
    Categoria VARCHAR(50),
    CodSucursal VARCHAR(50),
    NombreSucursal VARCHAR(200),
    DireccionSucursal VARCHAR(200),
    Region VARCHAR(50),
    Departamento VARCHAR(50),
    Unidades VARCHAR(50),
    PrecioUnitario VARCHAR(50)
);

CREATE TABLE compras(
    Fecha DATE,
    CodProveedor VARCHAR(50),
    NombreProveedor VARCHAR(200),
    DireccionProveedor VARCHAR(200),
    NumeroProveedor VARCHAR(50),
    WebProveedor VARCHAR(50),
    CodProducto VARCHAR(50),
    NombreProducto VARCHAR(200),
    MarcaProducto VARCHAR(50),
    Categoria VARCHAR(50),
    CodSucursal VARCHAR(50),
    NombreSucursal VARCHAR(200),
    DireccionSucursal VARCHAR(200),
    Region VARCHAR(50),
    Departamento VARCHAR(50),
    Unidades VARCHAR(50),
    CostoU VARCHAR(50)
);


SELECT COUNT(*) AS total FROM ventas;

SELECT COUNT(*) AS total FROM compras;


SET DATEFORMAT dmy;

BULK INSERT ventas
FROM 'C:\Users\Pablo\Dev\SS2-PF1\entradas\SGFood00.vent'
WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '\n', FIRSTROW = 2);

BULK INSERT compras
FROM 'C:\Users\Pablo\Dev\SS2-PF1\entradas\SGFood01.comp'
WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '\n', FIRSTROW = 2);
