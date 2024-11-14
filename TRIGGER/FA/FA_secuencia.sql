IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_secuencia')
	DROP TRIGGER tr_FA_secuencia
GO

CREATE TRIGGER tr_FA_secuencia  
ON FA_secuencia 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='transa,secuencia'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= transa,@codigo2=secuencia 
	FROM inserted
	order by transa asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= transa,@codigo2=secuencia 
	FROM deleted
	order by transa asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!=''
BEGIN
	IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_secuencia' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_secuencia',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_secuencia_UP')
	DROP TRIGGER TR_FA_secuencia_UP
GO
CREATE TRIGGER TR_FA_secuencia_UP
ON FA_secuencia
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='transa,secuencia'

BEGIN
	SELECT @codigo= transa,@codigo2=secuencia 
	FROM inserted
	order by transa asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!=''
	BEGIN
				IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_secuencia' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_secuencia',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO