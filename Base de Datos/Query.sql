USE tempdb
GO

IF NOT EXISTS(SELECT * FROM sys.databases WHERE [name] = 'Estacionamiento')
	BEGIN
		CREATE DATABASE Estacionamiento
	END
GO

USE Estacionamiento
GO

CREATE SCHEMA Parqueo
GO

CREATE TABLE Parqueo.Automovil
(
	idAuto INT NOT NULL IDENTITY CONSTRAINT PK_Automovil_id PRIMARY KEY CLUSTERED,
	placa VARCHAR(10) NOT NULL,
	fechaEntrada DATETIME2 NOT NULL,
	fechaSalida DATETIME2 NOT NULL,
	tipoVehiculo VARCHAR(12) NOT NULL,
	cobro MONEY NOT NULL
)
GO

CREATE TABLE Parqueo.Estacionamiento
(
	idEstacionamiento INT NOT NULL IDENTITY CONSTRAINT PK_Estacionamiento_id PRIMARY KEY CLUSTERED,


)
