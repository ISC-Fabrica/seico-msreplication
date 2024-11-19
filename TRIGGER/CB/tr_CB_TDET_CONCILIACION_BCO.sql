IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CB_MFIRMAS_AUTORIZADAS')
	DROP TRIGGER tr_CB_TDET_CONCILIACION_BCO
GO
CREATE TRIGGER tr_CB_TDET_CONCILIACION_BCO  
ON CB_TDET_CONCILIACION_BCO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,DBC_SECUENCIA,BCO_ID_BANCO,CTB_NUMERO_CTA,CBC_NRO_CONCILIACION'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=DBC_SECUENCIA,@codigo3 =BCO_ID_BANCO,@codigo4=CTB_NUMERO_CTA, @codigo5 = CBC_NRO_CONCILIACION
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=DBC_SECUENCIA,@codigo3 =BCO_ID_BANCO,@codigo4=CTB_NUMERO_CTA, @codigo5 = CBC_NRO_CONCILIACION
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4 !='' AND @codigo5 !=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_TDET_CONCILIACION_BCO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4 AND codigo5=@codigo5) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
					VALUES('CB_TDET_CONCILIACION_BCO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
END
GO





IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CB_TDET_CONCILIACION_BCO_UP')
	DROP TRIGGER TR_CB_TDET_CONCILIACION_BCO_UP
GO

CREATE TRIGGER TR_CB_TDET_CONCILIACION_BCO_UP
ON CB_TDET_CONCILIACION_BCO
AFTER UPDATE
AS

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)


		SET @observacion ='EMP_ID_EMPRESA,DBC_SECUENCIA,BCO_ID_BANCO,CTB_NUMERO_CTA,CBC_NRO_CONCILIACION'

BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA,@codigo2=DBC_SECUENCIA,@codigo3 =BCO_ID_BANCO,@codigo4=CTB_NUMERO_CTA, @codigo5 = CBC_NRO_CONCILIACION
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4!='' AND @codigo5!=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_TDET_CONCILIACION_BCO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4 AND codigo5=@codigo5) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
					VALUES('CB_TDET_CONCILIACION_BCO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
	END
END

	
GO