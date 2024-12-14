CREATE TRIGGER tr_CB_MBANCO  
ON CB_MBANCO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2 =BCO_ID_BANCO  
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2 =BCO_ID_BANCO 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status])
					VALUES('CB_MBANCO',@tipo,@codigo,@codigo2,1)
END
GO

CREATE TRIGGER TR_CB_MBANCO_UP
ON CB_MBANCO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@tipo char(1)

BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA,@codigo2 =BCO_ID_BANCO 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status])
					VALUES('CB_MBANCO',@tipo,@codigo,@codigo2,1)
	END
END

	
GO