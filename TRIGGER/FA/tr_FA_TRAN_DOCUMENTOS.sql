IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_TRAN_DOCUMENTOS')
	DROP TRIGGER tr_FA_TRAN_DOCUMENTOS
GO

CREATE TRIGGER tr_FA_TRAN_DOCUMENTOS  
ON FA_TRAN_DOCUMENTOS 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA,sec_doc'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=sec_doc 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=sec_doc 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2 !=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_TRAN_DOCUMENTOS' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_TRAN_DOCUMENTOS',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_TRAN_DOCUMENTOS_UP')
	DROP TRIGGER TR_FA_TRAN_DOCUMENTOS_UP
GO
CREATE TRIGGER TR_FA_TRAN_DOCUMENTOS_UP
ON FA_TRAN_DOCUMENTOS
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA,sec_doc'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=sec_doc 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2 !=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_TRAN_DOCUMENTOS' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_TRAN_DOCUMENTOS',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO