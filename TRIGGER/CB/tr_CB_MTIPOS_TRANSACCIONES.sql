IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CB_MTIPOS_TRANSACCIONES')
	DROP TRIGGER tr_CB_MTIPOS_TRANSACCIONES
GO
CREATE TRIGGER tr_CB_MTIPOS_TRANSACCIONES  
ON CB_MTIPOS_TRANSACCIONES 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max),
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,TIP_ID_TRANSACCION,TCO_ID_TIPO_COMPROBANTE'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA, @codigo2=TIP_ID_TRANSACCION,@codigo3=TCO_ID_TIPO_COMPROBANTE 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA, @codigo2=TIP_ID_TRANSACCION,@codigo3=TCO_ID_TIPO_COMPROBANTE 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_MTIPOS_TRANSACCIONES' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CB_MTIPOS_TRANSACCIONES',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CB_MTIPOS_TRANSACCIONES_UP')
	DROP TRIGGER TR_CB_MTIPOS_TRANSACCIONES_UP
GO
CREATE TRIGGER TR_CB_MTIPOS_TRANSACCIONES_UP
ON CB_MTIPOS_TRANSACCIONES
AFTER UPDATE
AS

			declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@codigo3 varchar(30)='',
			@observacion varchar(max),
			@tipo char(1)

			SET @observacion ='EMP_ID_EMPRESA,TIP_ID_TRANSACCION,TCO_ID_TIPO_COMPROBANTE'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA, @codigo2=TIP_ID_TRANSACCION,@codigo3=TCO_ID_TIPO_COMPROBANTE 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_MTIPOS_TRANSACCIONES' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CB_MTIPOS_TRANSACCIONES',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO