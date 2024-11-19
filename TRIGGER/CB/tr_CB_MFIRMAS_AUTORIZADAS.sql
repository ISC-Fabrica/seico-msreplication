IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CB_MFIRMAS_AUTORIZADAS')
	DROP TRIGGER tr_CB_MFIRMAS_AUTORIZADAS
GO
CREATE TRIGGER tr_CB_MFIRMAS_AUTORIZADAS  
ON CB_MFIRMAS_AUTORIZADAS 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='BCO_ID_BANCO,EMP_ID_EMPRESA,CTB_NUMERO_CTA,FRA_SECUENCIA'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= BCO_ID_BANCO ,@codigo2 =EMP_ID_EMPRESA,@codigo3=CTB_NUMERO_CTA, @codigo4 = FRA_SECUENCIA 
	FROM inserted
	order by BCO_ID_BANCO asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= BCO_ID_BANCO ,@codigo2 =EMP_ID_EMPRESA,@codigo3=CTB_NUMERO_CTA, @codigo4 = FRA_SECUENCIA 
	FROM deleted
	order by BCO_ID_BANCO asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4 !=''
BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_MFIRMAS_AUTORIZADAS' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CB_MFIRMAS_AUTORIZADAS',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CB_MFIRMAS_AUTORIZADAS_UP')
	DROP TRIGGER TR_CB_MFIRMAS_AUTORIZADAS_UP
GO

CREATE TRIGGER TR_CB_MFIRMAS_AUTORIZADAS_UP
ON CB_MFIRMAS_AUTORIZADAS
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@codigo3 varchar(30)='',
			@codigo4 varchar(30)='',
			@observacion varchar(max)='',
			@tipo char(1)

			SET @observacion ='BCO_ID_BANCO,EMP_ID_EMPRESA,CTB_NUMERO_CTA,FRA_SECUENCIA'

BEGIN
	SELECT  @codigo= BCO_ID_BANCO ,@codigo2 =EMP_ID_EMPRESA,@codigo3=CTB_NUMERO_CTA, @codigo4= FRA_SECUENCIA
	FROM inserted
	order by BCO_ID_BANCO asc

	SET @tipo ='U'

	IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4!=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_MFIRMAS_AUTORIZADAS' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CB_MFIRMAS_AUTORIZADAS',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO