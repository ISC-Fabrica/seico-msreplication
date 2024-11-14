IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_bienes_servicion')
	DROP TRIGGER TR_FA_bienes_servicion
GO
CREATE TRIGGER TR_FA_bienes_servicion 
ON FA_bienes_servicion 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),
		@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@observacion =''

		SET @observacion ='EMP_ID_EMPRESA, bis_codigo'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=bis_codigo FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= emp_id_empresa, @codigo2 = bis_codigo FROM deleted

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_bienes_servicion'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_bienes_servicion',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_bienes_servicion_UP')
	DROP TRIGGER TR_FA_bienes_servicion_UP
GO

CREATE TRIGGER TR_FA_bienes_servicion_UP
ON FA_bienes_servicion
AFTER UPDATE
AS

	declare @codigo varchar(30),
			@codigo2 varchar(30),
			@observacion varchar(500),
			@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@observacion =''

			SET @observacion ='EMP_ID_EMPRESA, bis_codigo'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=bis_codigo FROM inserted

	SET @tipo ='U'

	IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_bienes_servicion'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_bienes_servicion',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO