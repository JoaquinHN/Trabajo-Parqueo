USE tempdb
GO

IF EXISTS(SELECT * FROM sys.databases WHERE [name] = 'Estacionamiento')
	BEGIN
		DROP DATABASE Estacionamiento
	END
GO

CREATE DATABASE Estacionamiento
GO

USE Estacionamiento
GO

CREATE SCHEMA Parqueo
GO

CREATE TABLE Parqueo.Automovil
(
	idAuto INT NOT NULL IDENTITY CONSTRAINT PK_Automovil_id PRIMARY KEY CLUSTERED,
	placa VARCHAR(10) NOT NULL,
	idtipovehiculo INT NOT NULL,

	
)
GO

CREATE TABLE Parqueo.Transaccion
(
	idTran INT NOT NULL IDENTITY CONSTRAINT PK_Tran_id PRIMARY KEY CLUSTERED,
	fechaEntrada TIME NOT NULL
		DEFAULT GETDATE(),
	fechaSalida TIME NULL,
	cobro MONEY NOT NULL,
	idautomovil INT NOT NULl,
)
GO


CREATE TABLE Parqueo.TipoAutomovil
(
	idTipo INT NOT NULL IDENTITY CONSTRAINT PK_Tipo_id PRIMARY KEY CLUSTERED,
	tipoVehiculo VARCHAR(12) NOT NULL,
)
GO


ALTER TABLE Parqueo.Automovil  WITH CHECK ADD  CONSTRAINT FK_Parqueo_Automovil$EsUn$Parqueo_TipoAutomovil_id FOREIGN KEY(idtipovehiculo)
REFERENCES Parqueo.TipoAutomovil (idTipo)
GO

ALTER TABLE Parqueo.Transaccion  WITH CHECK ADD  CONSTRAINT FK_Transaccion$TieneUn$Automovil FOREIGN KEY(idautomovil)
REFERENCES Parqueo.Automovil (idAuto)
GO

INSERT INTO Parqueo.Transaccion
	VALUES
	(GETDATE(),GETDATE(),112)
GO
SELECT*FROM Parqueo.Transaccion
GO