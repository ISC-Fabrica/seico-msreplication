IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_DETLOCAL_ALQUILER')
	DROP TRIGGER TR_FA_DETLOCAL_ALQUILER
GO

CREATE TRIGGER TR_FA_DETLOCAL_ALQUILER  
ON FA_DETLOCAL_ALQUILER 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		set @observacion='EMP_ID_EMPRESA, loc_codigo, fcha_alquiler'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=loc_codigo,@codigo3=convert(varchar, fcha_alquiler, 121) 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

	
END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=loc_codigo,@codigo3=convert(varchar, fcha_alquiler, 121) 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_DETLOCAL_ALQUILER'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
		VALUES('FA_DETLOCAL_ALQUILER',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_DETLOCAL_ALQUILER_UP')
	DROP TRIGGER TR_FA_DETLOCAL_ALQUILER_UP
GO

CREATE TRIGGER TR_FA_DETLOCAL_ALQUILER_UP
ON FA_DETLOCAL_ALQUILER
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		set @observacion='EMP_ID_EMPRESA, loc_codigo, fcha_alquiler'

BEGIN
		SELECT @codigo= EMP_ID_EMPRESA,@codigo2=loc_codigo,@codigo3=convert(varchar, fcha_alquiler, 121) 
		FROM inserted
		order by EMP_ID_EMPRESA asc

		SET @tipo ='U'

		IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_DETLOCAL_ALQUILER'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
		BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
			VALUES('FA_DETLOCAL_ALQUILER',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
		END
END

	
GO