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
		horaEntrada TIME NOT NULL,
)
GO

CREATE TABLE Parqueo.Transaccion
(
	idTran INT NOT NULL IDENTITY CONSTRAINT PK_Tran_id PRIMARY KEY CLUSTERED,
	horaSalida TIME NULL,
	cobro MONEY NULL,
	idautomovil INT NOT NULl,
)
GO

ALTER TABLE Parqueo.Automovil
	ADD CONSTRAINT
	FK_UnTipoVehiculo_PuedeTenerVariosVehiculos
	FOREIGN KEY (idTipo) REFERENCES Parqueo1.TipoAutomovil(idTipo)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
GO

ALTER TABLE Parqueo.Transaccion  WITH CHECK ADD  CONSTRAINT FK_Transaccion$TieneUn$Automovil FOREIGN KEY(idautomovil)
REFERENCES Parqueo.Automovil (idAuto)
GO

ALTER TABLE Parqueo.Transaccion
	ADD CONSTRAINT
	FK_UnVehiculo_PuedeTener_VariasTransacciones
	FOREIGN KEY (idAuto) REFERENCES Parqueo.Automovil(idAuto)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
GO
/*PROCEDIMIENTOS PARA AGRAGAR Y ACTUALIZAR*/
CREATE PROCEDURE AGREGARAUTOS @placa VARCHAR(10), @idtipovehiculo INT, @horaEntrada TIME
AS
DECLARE @idAuto INT
BEGIN TRANSACTION

		IF NOT EXISTS(SELECT * FROM Parqueo.Automovil WHERE placa=@placa)
		BEGIN
			INSERT INTO Parqueo.Automovil(placa, idtipovehiculo, horaEntrada)
			VALUES (@placa, @idtipovehiculo, @horaEntrada);
		END
	COMMIT TRANSACTION
GO
/*/
DROP PROCEDURE ACTUALIZARFECHAUTO
GO
*/
CREATE PROCEDURE ACTUALIZARFECHAUTO @idAuto int, @horaEntrada TIME
AS
BEGIN TRANSACTION 
	BEGIN TRY
		IF EXISTS(SELECT * FROM Parqueo.Automovil WHERE idAuto=@idAuto) 
			BEGIN
			UPDATE Parqueo.Automovil SET horaEntrada=@horaEntrada WHERE idAuto=@idAuto;
		END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH
GO

CREATE PROCEDURE AGREGARTRANSACCION @horaSalida TIME, @cobro MONEY, @idautomovil INT
AS
BEGIN TRANSACTION

		IF NOT EXISTS(SELECT * FROM Parqueo.Transaccion WHERE horaSalida=@horaSalida)
		BEGIN
			INSERT INTO Parqueo.Transaccion(horaSalida, cobro,idautomovil)
			VALUES (@horaSalida, @cobro, @idautomovil);
		END
	COMMIT TRANSACTION
GO

--CREATE PROCEDURE RESTAHORAS @horaEntrada VARCHAR (10), @horaSalida VARCHAR (10)
--AS
--BEGIN TRANSACTION
--BEGIN TRY	
--	set @horaEntrada = SELECT horaEntrada FROM Parqueo.Automovil
--	set @horaSalida =  SELECT horaSalida FROM Parqueo.Transaccion



/*
INSERT INTO Parqueo.TipoAutomovil
	VALUES('Turismo'),
		  ('Pick-up'),
		  ('Camioneta'),
		  ('Camión'),
		  ('Bus'),
		  ('Rastra'),
		  ('Motocicleta')
GO
INSERT INTO Parqueo.Automovil(placa,idtipovehiculo)
	VALUES('f25FF', 1, )
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