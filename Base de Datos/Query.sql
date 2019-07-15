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
	idTipo INT NOT NULL
		
)
GO

CREATE TABLE Parqueo.Transaccion
(
	idTran INT NOT NULL IDENTITY CONSTRAINT PK_Tran_id PRIMARY KEY CLUSTERED,
	horaSalida TIME NULL,
	horaEntrada TIME NOT NULl DEFAULT GETDATE(),
	cobro MONEY NULL,
	idAuto INT NOT NULl,
	fecha DATETIME2 DEFAULT GETDATE() NOT NULL
)
GO


ALTER TABLE Parqueo.Automovil
	ADD CONSTRAINT
	FK_UnTipoVehiculo_PuedeTenerVariosVehiculos
	FOREIGN KEY (idTipo) REFERENCES Parqueo.TipoAutomovil(idTipo)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
GO

ALTER TABLE Parqueo.Transaccion
	ADD CONSTRAINT
	FK_UnVehiculo_PuedeTener_VariasTransacciones
	FOREIGN KEY (idAuto) REFERENCES Parqueo.Automovil(idAuto)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
GO

--PROCEDIMIENTOS ALMACENADOS

CREATE PROCEDURE AGREGARAUTOS @placa VARCHAR(10), @idTipo INT
AS
DECLARE @idAuto INT
BEGIN TRANSACTION

		IF NOT EXISTS(SELECT * FROM Parqueo.Automovil WHERE placa=@placa)
		BEGIN
			INSERT INTO Parqueo.Automovil(placa , idTipo) 
			VALUES (@placa, @idTipo)
			INSERT INTO Parqueo.Transaccion(idAuto,horaEntrada)
			VALUES(@idTipo,GETDATE())
		END
		ELSE
			BEGIN	
			SELECT @idAuto =idAuto FROM Parqueo.Automovil WHERE placa = @placa AND idTipo=@idTipo
			IF NOT EXISTS(SELECT * FROM Parqueo.Transaccion a INNER JOIN Parqueo.Automovil b
			ON a.idAuto = b.idAuto WHERE a.idAuto=@idAuto AND b.idTipo=@idTipo 
			AND a.horaSalida IS NULL)
				BEGIN
					INSERT INTO Parqueo.Transaccion(idAuto,horaEntrada) VALUES (@idAuto,GETDATE())
				END
				
			END
	COMMIT TRANSACTION
GO

EXEC AGREGARAUTOS 'FFF123',3
GO

CREATE PROC MostrarVehiculo
AS BEGIN
	SELECT a.idAuto as Id, a.placa as Placa,b.idTipo, b.tipoVehiculo, c.horaEntrada FROM Parqueo.Automovil a INNER JOIN Parqueo.TipoAutomovil b 
	ON a.idAuto=b.idTipo INNER JOIN Parqueo.Transaccion c ON a.idAuto=c.idTran
END
GO

DECLARE @HOLA INT
EXEC @HOLA = MostrarVehiculo
go


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
		  ('Turismo'),
		  ('Pick-up'),
		  ('Camioneta'),
		  ('Camión'),
		  ('Bus'),
		  ('Rastra'),
		  ('Motocicleta')
GO
INSERT INTO Parqueo.Automovil(placa,idTipo)
	VALUES('f25FF', 1)
GO
INSERT INTO Parqueo.Transaccion(idautomovil)
	VALUES(1)
GO
EXEC AGREGARAUTO '05FG05', 1 
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



--CONSULTAS
SELECT * FROM Parqueo.Automovil
GO
SELECT * FROM Parqueo.Transaccion
GO
SELECT * FROM Parqueo.TipoAutomovil
GO

INSERT INTO Parqueo.Transaccion(idAuto,horaEntrada)
VALUES(2,GETDATE())
GO