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
	
)
GO

CREATE TABLE Parqueo.Transaccion
(
	idTran INT NOT NULL IDENTITY CONSTRAINT PK_Tran_id PRIMARY KEY CLUSTERED,
	fechaEntrada DATETIME2 NOT NULL,
	fechaSalida DATETIME2 NOT NULL,
	cobro MONEY NOT NULL
)

CREATE TABLE Parqueo.TipoAutomovil
(
	idTipo INT NOT NULL IDENTITY CONSTRAINT PK_Tipo_id PRIMARY KEY CLUSTERED,
	tipoVehiculo VARCHAR(12) NOT NULL,
)
GO


ALTER TABLE Parqueo.Automovil  WITH CHECK ADD  CONSTRAINT FK_Parqueo_Automovil$EsUn$Parqueo_TipoAutomovil_id FOREIGN KEY(idAuto)
REFERENCES Parqueo.TipoAutomovil (idTipo)
GO

ALTER TABLE Parqueo.Automovil  WITH CHECK ADD  CONSTRAINT FK_Parqueo_Automovil$TieneUna$Parqueo_Transaccion_id FOREIGN KEY(idAuto)
REFERENCES Parqueo.Transaccion (idTran)
GO
