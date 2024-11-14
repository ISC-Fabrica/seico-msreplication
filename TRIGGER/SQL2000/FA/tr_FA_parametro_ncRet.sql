IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_parametro_ncRet')
	DROP TRIGGER TR_FA_parametro_ncRet
GO

CREATE TRIGGER TR_FA_parametro_ncRet  
ON FA_parametro_ncRet 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA,cod_para'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cod_para 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cod_para 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_parametro_ncRet'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_parametro_ncRet',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_parametro_ncRet_UP')
	DROP TRIGGER TR_FA_parametro_ncRet_UP
GO
CREATE TRIGGER TR_FA_parametro_ncRet_UP
ON FA_parametro_ncRet
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA,cod_para'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cod_para 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_parametro_ncRet'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_parametro_ncRet',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO