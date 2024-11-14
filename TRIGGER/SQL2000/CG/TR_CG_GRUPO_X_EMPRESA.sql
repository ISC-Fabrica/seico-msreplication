USE SEICOII
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_CG_GRUPO_X_EMPRESA')
	DROP TRIGGER TR_CG_GRUPO_X_EMPRESA
GO

CREATE TRIGGER TR_CG_GRUPO_X_EMPRESA  
ON  CG_GRUPO_X_EMPRESA
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='EMP_ID_EMPRESA,GRC_ID_GRUPO_CONTABLE'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=GRC_ID_GRUPO_CONTABLE
	FROM inserted

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=GRC_ID_GRUPO_CONTABLE
	FROM deleted

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' AND 
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CG_GRUPO_X_EMPRESA'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
				VALUES('CG_GRUPO_X_EMPRESA',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_CG_GRUPO_X_EMPRESA_UP')
	DROP TRIGGER TR_CG_GRUPO_X_EMPRESA_UP
GO

CREATE TRIGGER TR_CG_GRUPO_X_EMPRESA_UP
ON CG_GRUPO_X_EMPRESA
AFTER UPDATE
AS

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='EMP_ID_EMPRESA,GRC_ID_GRUPO_CONTABLE'


SELECT  @codigo= EMP_ID_EMPRESA,@codigo2=GRC_ID_GRUPO_CONTABLE
FROM inserted

SET @tipo ='U'

IF @codigo !='' and @codigo2 !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CG_GRUPO_X_EMPRESA'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
				VALUES('CG_GRUPO_X_EMPRESA',@tipo,@codigo,@codigo2,1,@observacion)
END


	
GO