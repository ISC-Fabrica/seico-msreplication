IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_motivo')
	DROP TRIGGER TR_FA_motivo
GO

CREATE TRIGGER TR_FA_motivo  
ON FA_motivo 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,mot_codigo'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=mot_codigo
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=mot_codigo
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_motivo'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_motivo',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_motivo_UP')
	DROP TRIGGER TR_FA_motivo_UP
GO
CREATE TRIGGER TR_FA_motivo_UP
ON FA_motivo
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,mot_codigo'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=mot_codigo
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_motivo'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_motivo',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO