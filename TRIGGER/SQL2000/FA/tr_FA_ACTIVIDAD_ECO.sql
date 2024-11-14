IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_ACTIVIDAD_ECO')
	DROP TRIGGER TR_FA_ACTIVIDAD_ECO
GO

CREATE TRIGGER TR_FA_ACTIVIDAD_ECO  
ON FA_ACTIVIDAD_ECO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@observacion varchar(500),
		@tipo char(1)
		
select  @codigo ='',
		@observacion =''

		set @observacion ='codigo'

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

IF @tipo IS NOT NULL AND @codigo !='' AND
   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_ACTIVIDAD_ECO'
               AND tipo = @tipo AND codigo = @codigo)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status],observacion)
					VALUES('FA_ACTIVIDAD_ECO',@tipo,@codigo,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_ACTIVIDAD_ECO_UP')
	DROP TRIGGER TR_FA_ACTIVIDAD_ECO_UP
GO

CREATE TRIGGER TR_FA_ACTIVIDAD_ECO_UP
ON FA_ACTIVIDAD_ECO
AFTER UPDATE
AS

	declare @codigo varchar(30),
			@observacion varchar(500),
			@tipo char(1)
		
select  @codigo ='',
		@observacion =''

	set @observacion ='codigo'


BEGIN
	SELECT @codigo= codigo FROM inserted
	order by codigo asc

	SET @tipo ='U'

	IF @codigo !='' AND
	   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_ACTIVIDAD_ECO'
				   AND tipo = @tipo AND codigo = @codigo)
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status],observacion)
					VALUES('FA_ACTIVIDAD_ECO',@tipo,@codigo,1,@observacion)
	END
END

	
GO
