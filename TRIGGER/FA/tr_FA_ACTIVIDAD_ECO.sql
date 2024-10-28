CREATE TRIGGER tr_FA_ACTIVIDAD_ECO  
ON FA_ACTIVIDAD_ECO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= codigo FROM inserted
	order by codigo asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= codigo FROM deleted
	order by codigo asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status])
					VALUES('FA_ACTIVIDAD_ECO',@tipo,@codigo,1)
END
GO

CREATE TRIGGER TR_FA_ACTIVIDAD_ECO_UP
ON FA_ACTIVIDAD_ECO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@tipo char(1)

BEGIN
	SELECT @codigo= codigo FROM inserted
	order by codigo asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status])
					VALUES('FA_ACTIVIDAD_ECO',@tipo,@codigo,1)
	END
END

	
GO
