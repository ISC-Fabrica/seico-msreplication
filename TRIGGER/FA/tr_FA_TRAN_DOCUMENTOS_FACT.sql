IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_TRAN_DOCUMENTOS_FACT')
	DROP TRIGGER tr_FA_TRAN_DOCUMENTOS_FACT
GO

CREATE TRIGGER tr_FA_TRAN_DOCUMENTOS_FACT  
ON FA_TRAN_DOCUMENTOS_FACT 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='emp_id_empresa,sec_comp,fact'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= emp_id_empresa,@codigo2=sec_comp,@codigo3=fact 
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=sec_comp,@codigo3=fact  
	FROM deleted
	order by emp_id_empresa asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_TRAN_DOCUMENTOS_FACT',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_TRAN_DOCUMENTOS_FACT_UP')
	DROP TRIGGER TR_FA_TRAN_DOCUMENTOS_FACT_UP
GO
CREATE TRIGGER TR_FA_TRAN_DOCUMENTOS_FACT_UP
ON FA_TRAN_DOCUMENTOS_FACT
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='emp_id_empresa,sec_comp,fact'

BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=sec_comp ,@codigo3=fact 
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_TRAN_DOCUMENTOS_FACT',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO