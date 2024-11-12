IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_TRAN_DOCUMENTOS25082011')
	DROP TRIGGER tr_FA_TRAN_DOCUMENTOS25082011
GO

CREATE TRIGGER tr_FA_TRAN_DOCUMENTOS25082011  
ON FA_TRAN_DOCUMENTOS25082011 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,sec_doc,cod_tipo,cod_cliente'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=sec_doc,@codigo3=cod_tipo,@codigo4=cod_cliente
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=sec_doc,@codigo3=cod_tipo,@codigo4=cod_cliente
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('FA_TRAN_DOCUMENTOS25082011',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_TRAN_DOCUMENTOS25082011_UP')
	DROP TRIGGER TR_FA_TRAN_DOCUMENTOS25082011_UP
GO

CREATE TRIGGER TR_FA_TRAN_DOCUMENTOS25082011_UP
ON FA_TRAN_DOCUMENTOS25082011
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,sec_doc,cod_tipo,cod_cliente'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=sec_doc,@codigo3=cod_tipo,@codigo4=cod_cliente
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('FA_TRAN_DOCUMENTOS25082011',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO