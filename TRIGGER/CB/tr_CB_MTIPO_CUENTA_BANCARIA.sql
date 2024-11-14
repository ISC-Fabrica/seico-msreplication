IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CB_MTIPO_CUENTA_BANCARIA')
	DROP TRIGGER TR_CB_MTIPO_CUENTA_BANCARIA
GO

CREATE TRIGGER TR_CB_MTIPO_CUENTA_BANCARIA  
ON CB_MTIPO_CUENTA_BANCARIA 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@observacion varchar(max),
		@tipo char(1)

		SET @observacion ='TCB_ID_TIPO'


IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= TCB_ID_TIPO 
	FROM inserted
	order by TCB_ID_TIPO asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= TCB_ID_TIPO 
	FROM deleted
	ORDER BY TCB_ID_TIPO ASC

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_MTIPO_CUENTA_BANCARIA' AND tipo=@tipo AND codigo=@codigo) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status],observacion)
					VALUES('CB_MTIPO_CUENTA_BANCARIA',@tipo,@codigo,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CB_MTIPO_CUENTA_BANCARIA_UP')
	DROP TRIGGER TR_CB_MTIPO_CUENTA_BANCARIA_UP
GO

CREATE TRIGGER TR_CB_MTIPO_CUENTA_BANCARIA_UP
ON CB_MTIPO_CUENTA_BANCARIA
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@observacion varchar(max),
		@tipo char(1)

	SET @observacion ='TCB_ID_TIPO'

BEGIN
	SELECT @codigo= TCB_ID_TIPO 
	FROM inserted
	order by TCB_ID_TIPO asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_MTIPO_CUENTA_BANCARIA' AND tipo=@tipo AND codigo=@codigo) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status],observacion)
					VALUES('CB_MTIPO_CUENTA_BANCARIA',@tipo,@codigo,1,@observacion)
	END
END

	
GO