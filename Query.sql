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
CREATE TABLE Parqueo.TipoAutomovil
(
	idTipo INT NOT NULL IDENTITY CONSTRAINT PK_Tipo_id PRIMARY KEY CLUSTERED,
	tipoVehiculo NVARCHAR(12) NOT NULL,
)
GO

CREATE TABLE Parqueo.Automovil
(
	idAuto INT NOT NULL IDENTITY CONSTRAINT PK_Automovil_id PRIMARY KEY CLUSTERED,
	placa VARCHAR(10) NOT NULL,
	idtipovehiculo INT NOT NULL,
		horaEntrada TIME NOT NULL
		DEFAULT GETDATE()
)
GO

CREATE TABLE Parqueo.Transaccion
(
	idTran INT NOT NULL IDENTITY CONSTRAINT PK_Tran_id PRIMARY KEY CLUSTERED,
	horaSalida TIME NULL
			DEFAULT GETDATE(),
	cobro MONEY NULL,
	idautomovil INT NOT NULl,
)
GO

ALTER TABLE Parqueo.Automovil  WITH CHECK ADD  CONSTRAINT FK_Parqueo_Automovil$EsUn$Parqueo_TipoAutomovil_id FOREIGN KEY(idtipovehiculo)
REFERENCES Parqueo.TipoAutomovil (idTipo)
GO

ALTER TABLE Parqueo.Transaccion  WITH CHECK ADD  CONSTRAINT FK_Transaccion$TieneUn$Automovil FOREIGN KEY(idautomovil)
REFERENCES Parqueo.Automovil (idAuto)
GO

CREATE PROCEDURE AGREGARAUTO @placa VARCHAR(10), @idtipovehiculo INT
AS
begin TRANSACTION
	BEGIN TRY
			INSERT INTO Parqueo.Automovil(placa, idtipovehiculo)
			VALUES (@placa, @idtipovehiculo);
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH
GO

/*
INSERT INTO Parqueo.TipoAutomovil
	VALUES('Rastra'),
		  ('Moto'),
		  ('Bicicleta')
INSERT INTO Parqueo.Automovil
	VALUES('f25FF', 1)

INSERT INTO Parqueo.Transaccion(idautomovil)
	VALUES(1)



EXEC AGREGARAUTO '05FG05', 1 
GO
SELECT * FROM Parqueo.Automovil
GO
SELECT * FROM Parqueo.Transaccion
GO
SELECT * FROM Parqueo.TipoAutomovil
GO

*/