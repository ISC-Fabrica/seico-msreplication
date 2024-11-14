USE SEICOII
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_CG_DETALLE_DIARIO_PLANTILLA')
	DROP TRIGGER TR_CG_DETALLE_DIARIO_PLANTILLA
GO

CREATE TRIGGER TR_CG_DETALLE_DIARIO_PLANTILLA  
ON  CG_DETALLE_DIARIO_PLANTILLA
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='emp_id_empresa,cod_plantilla,cod_diario,cuenta'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= emp_id_empresa,@codigo2=cod_plantilla,@codigo3 =cod_diario,@codigo4=cuenta
	FROM inserted

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=cod_plantilla,@codigo3 =cod_diario,@codigo4=cuenta
	FROM deleted

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4 !='' AND 
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CG_DETALLE_DIARIO_PLANTILLA'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
				VALUES('CG_DETALLE_DIARIO_PLANTILLA',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_CG_DETALLE_DIARIO_PLANTILLA_UP')
	DROP TRIGGER TR_CG_DETALLE_DIARIO_PLANTILLA_UP
GO

CREATE TRIGGER TR_CG_DETALLE_DIARIO_PLANTILLA_UP
ON CG_DETALLE_DIARIO_PLANTILLA
AFTER UPDATE
AS

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='emp_id_empresa,cod_plantilla,cod_diario,cuenta'


SELECT  @codigo= emp_id_empresa,@codigo2=cod_plantilla,@codigo3 =cod_diario,@codigo4=cuenta
FROM inserted

SET @tipo ='U'

IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4!='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CG_DETALLE_DIARIO_PLANTILLA'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
				VALUES('CG_DETALLE_DIARIO_PLANTILLA',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END


	
GO