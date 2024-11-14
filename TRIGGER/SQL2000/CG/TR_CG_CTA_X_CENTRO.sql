USE SEICOII
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_CG_CTA_X_CENTRO')
	DROP TRIGGER TR_CG_CTA_X_CENTRO
GO

CREATE TRIGGER TR_CG_CTA_X_CENTRO  
ON  CG_CTA_X_CENTRO
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='EMP_ID_EMPRESA,CTA_CODIGO_CUENTA,CRE_ID_CTRO_RESPONSABILIDAD'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTA_CODIGO_CUENTA,@codigo3 =CRE_ID_CTRO_RESPONSABILIDAD
	FROM inserted

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTA_CODIGO_CUENTA,@codigo3 =CRE_ID_CTRO_RESPONSABILIDAD
	FROM deleted

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CG_CTA_X_CENTRO'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
				VALUES('CG_CTA_X_CENTRO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_CG_CTA_X_CENTRO_UP')
	DROP TRIGGER TR_CG_CTA_X_CENTRO_UP
GO

CREATE TRIGGER TR_CG_CTA_X_CENTRO_UP
ON CG_CTA_X_CENTRO
AFTER UPDATE
AS

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='EMP_ID_EMPRESA,CTA_CODIGO_CUENTA,CRE_ID_CTRO_RESPONSABILIDAD'


SELECT  @codigo= EMP_ID_EMPRESA,@codigo2=CTA_CODIGO_CUENTA,@codigo3 =CRE_ID_CTRO_RESPONSABILIDAD
FROM inserted

SET @tipo ='U'

IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CG_CTA_X_CENTRO'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
				VALUES('CG_CTA_X_CENTRO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END


	
GO