IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_HISTORICO_FCH_CONTRA_ING')
	DROP TRIGGER TR_FA_HISTORICO_FCH_CONTRA_ING
GO

CREATE TRIGGER TR_FA_HISTORICO_FCH_CONTRA_ING  
ON FA_HISTORICO_FCH_CONTRA_ING 
AFTER INSERT,DELETE   
AS 

	declare @codigo varchar(30),
			@codigo2 varchar(30),
			@codigo3 varchar(30),
			@codigo4 varchar(30),
			@codigo5 varchar(30),
			@observacion varchar(500),
			@tipo char(1)

			set @observacion='emp_id_empresa,cod_local,fecha_desde,fcha_hasta,estado'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
		SELECT @codigo= emp_id_empresa,@codigo2=cod_local,@codigo3=convert(varchar, fecha_desde, 121),@codigo4=convert(varchar, fcha_hasta, 121),@codigo5=estado
		FROM inserted
		order by emp_id_empresa asc

		SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
		SELECT @codigo= emp_id_empresa,@codigo2=cod_local,@codigo3=convert(varchar, fecha_desde, 121),@codigo4=convert(varchar, fcha_hasta, 121),@codigo5=estado
		FROM deleted
		order by emp_id_empresa asc

		SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_HISTORICO_FCH_CONTRA_ING'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4 AND codigo5 = @codigo5)
BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
			VALUES('FA_HISTORICO_FCH_CONTRA_ING',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_HISTORICO_FCH_CONTRA_ING_UP')
	DROP TRIGGER TR_FA_HISTORICO_FCH_CONTRA_ING_UP
GO

CREATE TRIGGER TR_FA_HISTORICO_FCH_CONTRA_ING_UP
ON FA_HISTORICO_FCH_CONTRA_ING
AFTER UPDATE
AS

		declare @codigo varchar(30),
			@codigo2 varchar(30),
			@codigo3 varchar(30),
			@codigo4 varchar(30),
			@codigo5 varchar(30),
			@observacion varchar(500),
			@tipo char(1)

			set @observacion='emp_id_empresa,cod_local,fecha_desde,fcha_hasta,estado'

BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=cod_local,@codigo3=convert(varchar, fecha_desde, 121),@codigo4=convert(varchar, fcha_hasta, 121),@codigo5=estado
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='U'

	IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_HISTORICO_FCH_CONTRA_ING'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4 AND codigo5 = @codigo5)
	BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
			VALUES('FA_HISTORICO_FCH_CONTRA_ING',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
	END
END

	
GO