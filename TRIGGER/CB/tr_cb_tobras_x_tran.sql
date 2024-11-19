IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_cb_tobras_x_tran')
	DROP TRIGGER tr_cb_tobras_x_tran
GO
CREATE TRIGGER tr_cb_tobras_x_tran  
ON cb_tobras_x_tran 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 datetime,
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CTR_NRO_TRANSACCION,CTR_FECHA_INGRESO,OXT_INDICE'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =CTR_FECHA_INGRESO,@codigo4=OXT_INDICE
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =CTR_FECHA_INGRESO,@codigo4=OXT_INDICE
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4 !=''
BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'cb_tobras_x_tran' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('cb_tobras_x_tran',@tipo,@codigo,@codigo2,CONVERT(VARCHAR(50),@codigo3,121),@codigo4,1,@observacion)
END
GO



IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_cb_tobras_x_tran_UP')
	DROP TRIGGER TR_cb_tobras_x_tran_UP
GO
CREATE TRIGGER TR_cb_tobras_x_tran_UP
ON cb_tobras_x_tran
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 datetime,
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CTR_NRO_TRANSACCION,CTR_FECHA_INGRESO,OXT_INDICE'

BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =CTR_FECHA_INGRESO,@codigo4=OXT_INDICE
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4!=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'cb_tobras_x_tran' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('cb_tobras_x_tran',@tipo,@codigo,@codigo2,CONVERT(VARCHAR(50),@codigo3,121),@codigo4,1,@observacion)
	END
END

	
GO