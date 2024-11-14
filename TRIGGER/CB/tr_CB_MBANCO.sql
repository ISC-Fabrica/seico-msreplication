IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CB_MBANCO')
	DROP TRIGGER tr_CB_MBANCO
GO
CREATE TRIGGER tr_CB_MBANCO  
ON CB_MBANCO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@tipo char(1),
		@observacion varchar(max)=''

		SET @observacion = 'emp_id_empresa,nro_cheq,cod_banco'
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

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2 !=''
BEGIN
	IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_MBANCO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
				VALUES('CB_MBANCO',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CB_MBANCO_UP')
	DROP TRIGGER TR_CB_MBANCO_UP
GO

CREATE TRIGGER TR_CB_MBANCO_UP
ON CB_MBANCO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@tipo char(1),
			@observacion varchar(max)=''
			SET @observacion = 'emp_id_empresa,nro_cheq,cod_banco'
BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA,@codigo2 =BCO_ID_BANCO 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2 !=''
	BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_MBANCO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('CB_MBANCO',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO