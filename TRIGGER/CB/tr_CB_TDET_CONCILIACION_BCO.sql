CREATE TRIGGER tr_CB_TDET_CONCILIACION_BCO  
ON CB_TDET_CONCILIACION_BCO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@tipo char(1)

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
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status])
					VALUES('CB_TDET_CONCILIACION_BCO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1)
END
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
			@tipo char(1)

BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA,@codigo2=DBC_SECUENCIA,@codigo3 =BCO_ID_BANCO,@codigo4=CTB_NUMERO_CTA, @codigo5 = CBC_NRO_CONCILIACION
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4!='' AND @codigo5!=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status])
					VALUES('CB_TDET_CONCILIACION_BCO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1)
	END
END

	
GO