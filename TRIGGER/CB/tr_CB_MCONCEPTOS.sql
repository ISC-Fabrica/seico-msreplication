IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CB_MCONCEPTOS')
	DROP TRIGGER tr_CB_MCONCEPTOS
GO
CREATE TRIGGER tr_CB_MCONCEPTOS  
ON CB_MCONCEPTOS 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max),
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,TIP_ID_TRANSACCION,CON_ID_CONCEPTO'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2 =TIP_ID_TRANSACCION,@codigo3=CON_ID_CONCEPTO  
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2 =TIP_ID_TRANSACCION,@codigo3=CON_ID_CONCEPTO 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_MCONCEPTOS' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CB_MCONCEPTOS',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CB_MCONCEPTOS_UP')
	DROP TRIGGER TR_CB_MCONCEPTOS_UP
GO
CREATE TRIGGER TR_CB_MCONCEPTOS_UP
ON CB_MCONCEPTOS
AFTER UPDATE
AS

		declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max),
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,TIP_ID_TRANSACCION,CON_ID_CONCEPTO'

BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA,@codigo2 =TIP_ID_TRANSACCION,@codigo3=CON_ID_CONCEPTO 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' and @codigo2 !='' and @codigo3 !=''
	BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_MCONCEPTOS' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
						VALUES('CB_MCONCEPTOS',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO