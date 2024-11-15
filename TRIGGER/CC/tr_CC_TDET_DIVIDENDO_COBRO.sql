IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TDET_DIVIDENDO_COBRO')
	DROP TRIGGER tr_CC_TDET_DIVIDENDO_COBRO
GO
CREATE TRIGGER tr_CC_TDET_DIVIDENDO_COBRO  
ON CC_TDET_DIVIDENDO_COBRO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(max)='',
		@tipo varchar(10)

		SET @observacion='EMP_ID_EMPRESA,COB_NUMERO, DCB_SECUENCIA, OPE_NUMERO, DIV_NUMERO'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COB_NUMERO,@codigo3=DCB_SECUENCIA,@codigo4=OPE_NUMERO,@codigo5=DIV_NUMERO 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COB_NUMERO,@codigo3=DCB_SECUENCIA,@codigo4=OPE_NUMERO,@codigo5=DIV_NUMERO 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TDET_DIVIDENDO_COBRO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4 AND codigo5=@codigo5) = 0
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
					VALUES('CC_TDET_DIVIDENDO_COBRO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CC_TDET_DIVIDENDO_COBRO_UP')
	DROP TRIGGER TR_CC_TDET_DIVIDENDO_COBRO_UP
GO
CREATE TRIGGER TR_CC_TDET_DIVIDENDO_COBRO_UP
ON CC_TDET_DIVIDENDO_COBRO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(max)='',
		@tipo varchar(10)

		SET @observacion='EMP_ID_EMPRESA, COB_NUMERO, DCB_SECUENCIA, OPE_NUMERO, DIV_NUMERO'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COB_NUMERO,@codigo3=DCB_SECUENCIA,@codigo4=OPE_NUMERO,@codigo5=DIV_NUMERO 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TDET_DIVIDENDO_COBRO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4 AND codigo5=@codigo5) = 0
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
					VALUES('CC_TDET_DIVIDENDO_COBRO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
	END
END

	
GO