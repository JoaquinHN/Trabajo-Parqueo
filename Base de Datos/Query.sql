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

--CREATE PROCEDURE RESTAHORAS @horaEntrada VARCHAR (10), @horaSalida VARCHAR (10)
--AS
--BEGIN TRANSACTION
--BEGIN TRY	
--	set @horaEntrada = SELECT horaEntrada FROM Parqueo.Automovil
--	set @horaSalida =  SELECT horaSalida FROM Parqueo.Transaccion



/*
INSERT INTO Parqueo.TipoAutomovil
	VALUES('Rastra'),
		  ('Moto'),
		  ('Turismo')
		  ('Pick-up')
		  ('Camioneta')
		  ('Camión')
		  ('Bus')
		  ('Rastra')
		  ('Motocicleta')

GO
INSERT INTO Parqueo.Automovil(placa,idtipovehiculo)
	VALUES('f25FF', 1)
GO
INSERT INTO Parqueo.Transaccion(idautomovil)
	VALUES(1)
GO


EXEC AGREGARAUTO '05FG05', 1 
GO
SELECT * FROM Parqueo.Automovil
GO
SELECT * FROM Parqueo.Transaccion
GO
SELECT * FROM Parqueo.TipoAutomovil
GO

*/


--DELETE FROM Parqueo.Automovil where idAuto=6
--go
--DELETE FROM Parqueo.TipoAutomovil where idTipo=3
--go
--EXEC AGREGARAUTO 'f25FF', 7 
--GO
--SELECT horaEntrada from Parqueo.Automovil WHERE placa='jejeje'
--GO

--SELECT CONVERT(nvarchar(10), (SELECT horaEntrada from Parqueo.Automovil ), 108) AS Hora 
--go

--select placa, CAST(horaEntrada AS time) FROM Parqueo.Automovil
--GO

