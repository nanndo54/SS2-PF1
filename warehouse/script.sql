CREATE DATABASE seminario2_201901698;

USE seminario2_201901698;


-- Borrando datos

DELETE FROM compras;
DELETE FROM ventas;
DELETE FROM Compra;
DELETE FROM Venta;
DELETE FROM Vendedor;
DELETE FROM Cliente;
DELETE FROM TipoCliente;
DELETE FROM Proveedor;
DELETE FROM Sucursal;
DELETE FROM Region;
DELETE FROM Departamento;
DELETE FROM Producto;
DELETE FROM Categoria;
DELETE FROM Marca;


SET DATEFORMAT dmy;

-- Tablas pivote

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

-- Tablas de dimensiones

CREATE TABLE Marca(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50)
);

CREATE TABLE Categoria(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50)
);

CREATE TABLE Producto(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Codigo VARCHAR(50),
    Nombre VARCHAR(200),
    idMarca INT FOREIGN KEY (idMarca) REFERENCES Marca(id),
    idCategoria INT FOREIGN KEY (idCategoria) REFERENCES Categoria(id)
);

CREATE TABLE Departamento(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50)
);

CREATE TABLE Region(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50),
    idDepartamento INT FOREIGN KEY (idDepartamento) REFERENCES Departamento(id)
);

CREATE TABLE Sucursal(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Codigo VARCHAR(50),
    Nombre VARCHAR(200),
    Direccion VARCHAR(200),
    idRegion INT FOREIGN KEY (idRegion) REFERENCES Region(id)
);

CREATE TABLE Proveedor(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Codigo VARCHAR(50),
    Nombre VARCHAR(200),
    Direccion VARCHAR(50),
    Numero VARCHAR(50),
    Web VARCHAR(50)
);

CREATE TABLE TipoCliente(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50)
);

CREATE TABLE Cliente(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Codigo VARCHAR(50),
    Nombre VARCHAR(200),
    Direccion VARCHAR(50),
    Numero VARCHAR(50),
    idTipo INT FOREIGN KEY (idTipo) REFERENCES TipoCliente(id)
);

CREATE TABLE Vendedor(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Codigo VARCHAR(50),
    Nombre VARCHAR(200),
    Vacacionista INT
);

-- Tablas de hechos

CREATE TABLE Compra(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATE,
    Unidades BIGINT,
    CostoUnitario DECIMAL(10,2),
    idSucursal INT FOREIGN KEY (idSucursal) REFERENCES Sucursal(id),
    idProducto INT FOREIGN KEY (idProducto) REFERENCES Producto(id),
    idProveedor INT FOREIGN KEY (idProveedor) REFERENCES Proveedor(id)
);

CREATE TABLE Venta(
    id INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATE,
    Unidades BIGINT,
    PrecioUnitario DECIMAL(10,2),
    idSucursal INT FOREIGN KEY (idSucursal) REFERENCES Sucursal(id),
    idProducto INT FOREIGN KEY (idProducto) REFERENCES Producto(id),
    idCliente INT FOREIGN KEY (idCliente) REFERENCES Cliente(id),
    idVendedor INT FOREIGN KEY (idVendedor) REFERENCES Vendedor(id)
);

-- Insertar datos

INSERT INTO Marca(Nombre)
SELECT DISTINCT MarcaProducto FROM ventas
UNION
SELECT DISTINCT MarcaProducto FROM compras;

INSERT INTO Categoria(Nombre)
SELECT DISTINCT Categoria FROM ventas
UNION
SELECT DISTINCT Categoria FROM compras;

INSERT INTO Producto(Codigo, Nombre, idMarca, idCategoria)
SELECT DISTINCT CodProducto, NombreProducto, m.id, c.id FROM ventas v
INNER JOIN Marca m ON v.MarcaProducto = m.Nombre
INNER JOIN Categoria c ON v.Categoria = c.Nombre
UNION
SELECT DISTINCT CodProducto, NombreProducto, m.id, ca.id FROM compras c
INNER JOIN Marca m ON c.MarcaProducto = m.Nombre
INNER JOIN Categoria ca ON c.Categoria = ca.Nombre;

INSERT INTO Departamento(Nombre)
SELECT DISTINCT Departamento FROM ventas
UNION
SELECT DISTINCT Departamento FROM compras;

INSERT INTO Region(Nombre, idDepartamento)
SELECT DISTINCT Region, d.id FROM ventas v
INNER JOIN Departamento d ON v.Departamento = d.Nombre
UNION
SELECT DISTINCT Region, d.id FROM compras c
INNER JOIN Departamento d ON c.Departamento = d.Nombre;

INSERT INTO Sucursal(Codigo, Nombre, Direccion, idRegion)
SELECT DISTINCT CodSucursal, NombreSucursal, DireccionSucursal, r.id FROM ventas v
INNER JOIN Region r ON v.Region = r.Nombre
UNION
SELECT DISTINCT CodSucursal, NombreSucursal, DireccionSucursal, r.id FROM compras c
INNER JOIN Region r ON c.Region = r.Nombre;

INSERT INTO Proveedor(Codigo, Nombre, Direccion, Numero, Web)
SELECT DISTINCT CodProveedor, NombreProveedor, DireccionProveedor, NumeroProveedor, WebProveedor FROM compras;

INSERT INTO TipoCliente(Nombre)
SELECT DISTINCT TipoCliente FROM ventas;

INSERT INTO Cliente(Codigo, Nombre, Direccion, Numero, idTipo)
SELECT DISTINCT CodigoCliente, NombreCliente, DireccionCliente, NumeroCliente, t.id FROM ventas v
INNER JOIN TipoCliente t ON v.TipoCliente = t.Nombre;

INSERT INTO Vendedor(Codigo, Nombre, Vacacionista)
SELECT DISTINCT CodVendedor, NombreVendedor, CASE WHEN Vacacionista = 'SI' THEN 1 ELSE 0 END FROM ventas;

INSERT INTO Compra(Fecha, Unidades, CostoUnitario, idSucursal, idProducto, idProveedor)
SELECT DISTINCT Fecha, Unidades, CostoU, s.id, p.id, pr.id FROM compras c
INNER JOIN Sucursal s ON c.CodSucursal = s.Codigo
INNER JOIN Producto p ON c.CodProducto = p.Codigo
INNER JOIN Proveedor pr ON c.CodProveedor = pr.Codigo;

INSERT INTO Venta(Fecha, Unidades, PrecioUnitario, idSucursal, idProducto, idCliente, idVendedor)
SELECT DISTINCT Fecha, Unidades, PrecioUnitario, s.id, p.id, cl.id, ve.id FROM ventas v
INNER JOIN Sucursal s ON v.CodSucursal = s.Codigo
INNER JOIN Producto p ON v.CodProducto = p.Codigo
INNER JOIN Cliente cl ON v.CodigoCliente = cl.Codigo
INNER JOIN Vendedor ve ON v.CodVendedor = ve.Codigo;

-- Consultando el total de datos en cada tabla

SELECT 'Marca' AS Tabla, COUNT(*) AS Total FROM Marca
UNION
SELECT 'Categoria' AS Tabla, COUNT(*) AS Total FROM Categoria
UNION
SELECT 'Producto' AS Tabla, COUNT(*) AS Total FROM Producto
UNION
SELECT 'Departamento' AS Tabla, COUNT(*) AS Total FROM Departamento
UNION
SELECT 'Region' AS Tabla, COUNT(*) AS Total FROM Region
UNION
SELECT 'Sucursal' AS Tabla, COUNT(*) AS Total FROM Sucursal
UNION
SELECT 'Proveedor' AS Tabla, COUNT(*) AS Total FROM Proveedor
UNION
SELECT 'TipoCliente' AS Tabla, COUNT(*) AS Total FROM TipoCliente
UNION
SELECT 'Cliente' AS Tabla, COUNT(*) AS Total FROM Cliente
UNION
SELECT 'Vendedor' AS Tabla, COUNT(*) AS Total FROM Vendedor
UNION
SELECT 'Compra' AS Tabla, COUNT(*) AS Total FROM Compra
UNION
SELECT 'Venta' AS Tabla, COUNT(*) AS Total FROM Venta;

SELECT ? = COUNT([*]) from compras
SELECT ? = COUNT([*]) from ventas
SELECT ? = COUNT([*]) from Marca
SELECT ? = COUNT([*]) from Categoria
SELECT ? = COUNT([*]) from Producto
SELECT ? = COUNT([*]) from Departamento
SELECT ? = COUNT([*]) from Region
SELECT ? = COUNT([*]) from Sucursal
SELECT ? = COUNT([*]) from Proveedor
SELECT ? = COUNT([*]) from TipoCliente
SELECT ? = COUNT([*]) from Cliente
SELECT ? = COUNT([*]) from Vendedor
SELECT ? = COUNT([*]) from Compra
SELECT ? = COUNT([*]) from Venta
