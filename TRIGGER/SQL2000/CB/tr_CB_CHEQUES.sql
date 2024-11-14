USE SEICOII
GO

CREATE TRIGGER tr_CB_CHEQUES  
ON CB_CHEQUES 
AFTER INSERT,DELETE   
AS 

declare @tipo char(1),
		@observacion varchar(500),
		@codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30)
		

SET @observacion='emp_id_empresa,nro_cheq,cod_banco,cta_banco'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= emp_id_empresa, @codigo2=nro_cheq, @codigo3=cod_banco, @codigo4=cta_banco FROM inserted

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= emp_id_empresa, @codigo2=nro_cheq, @codigo3=cod_banco, @codigo4=cta_banco FROM deleted

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CB_CHEQUES'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CB_CHEQUES',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO

CREATE TRIGGER TR_CB_CHEQUES_UP
ON CB_CHEQUES
AFTER UPDATE
AS

declare @tipo char(1),
		@observacion varchar(500),
		@codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30)

SET @observacion='emp_id_empresa,nro_cheq,cod_banco,cta_banco'

SELECT @codigo= emp_id_empresa, @codigo2=nro_cheq, @codigo3=cod_banco, @codigo4=cta_banco FROM inserted

SET @tipo ='U'

IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CB_CHEQUES'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CB_CHEQUES',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END

	
GO