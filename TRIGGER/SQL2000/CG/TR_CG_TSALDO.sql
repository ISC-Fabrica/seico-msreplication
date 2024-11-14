USE SEICOII
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_CG_TSALDO')
	DROP TRIGGER TR_CG_TSALDO
GO

CREATE TRIGGER TR_CG_TSALDO  
ON  CG_TSALDO
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='EMP_ID_EMPRESA,FIS_ANIO,FIS_PERIODO,CTA_CODIGO_CUENTA'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=FIS_ANIO,@codigo3 =FIS_PERIODO,@codigo4=CTA_CODIGO_CUENTA
	FROM inserted

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=FIS_ANIO,@codigo3 =FIS_PERIODO,@codigo4=CTA_CODIGO_CUENTA
	FROM deleted

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4 !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CG_TSALDO'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
				VALUES('CG_TSALDO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_CG_TSALDO_UP')
	DROP TRIGGER TR_CG_TSALDO_UP
GO

CREATE TRIGGER TR_CG_TSALDO_UP
ON CG_TSALDO
AFTER UPDATE
AS

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='EMP_ID_EMPRESA,FIS_ANIO,FIS_PERIODO,CTA_CODIGO_CUENTA'


SELECT  @codigo= EMP_ID_EMPRESA,@codigo2=FIS_ANIO,@codigo3 =FIS_PERIODO,@codigo4=CTA_CODIGO_CUENTA
FROM inserted

SET @tipo ='U'

IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4!='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CG_TSALDO'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
				VALUES('CG_TSALDO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END


	
GO