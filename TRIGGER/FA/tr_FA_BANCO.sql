CREATE TRIGGER tr_FA_BANCO 
ON FA_BANCO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=proy,@codigo3=obra,@codigo4=codigo 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=proy,@codigo3=obra,@codigo4=codigo
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2 !='' AND @codigo3 !='' AND @codigo4 !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status])
					VALUES('FA_BANCO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1)
END
GO

CREATE TRIGGER TR_FA_BANCO_UP
ON FA_BANCO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@codigo3 varchar(30)='',
			@codigo4 varchar(30)='',
			@tipo char(1)

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=proy,@codigo3=obra,@codigo4=codigo
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2 !='' AND @codigo3 !='' AND @codigo4 !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status])
					VALUES('FA_BANCO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1)
	END
END

	
GO