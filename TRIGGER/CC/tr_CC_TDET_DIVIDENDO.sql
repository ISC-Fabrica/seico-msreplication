IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TDET_DIVIDENDO')
	DROP TRIGGER tr_CC_TDET_DIVIDENDO
GO

CREATE TRIGGER tr_CC_TDET_DIVIDENDO  
ON CC_TDET_DIVIDENDO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,OPE_NUMERO,DIV_NUMERO'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=OPE_NUMERO,@codigo3=DIV_NUMERO
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=OPE_NUMERO,@codigo3=DIV_NUMERO
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TDET_DIVIDENDO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_TDET_DIVIDENDO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TDET_DIVIDENDO_UP')
	DROP TRIGGER tr_CC_TDET_DIVIDENDO_UP
GO

CREATE TRIGGER tr_CC_TDET_DIVIDENDO_UP
ON CC_TDET_DIVIDENDO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',		
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,OPE_NUMERO,DIV_NUMERO'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=OPE_NUMERO,@codigo3=DIV_NUMERO
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!='' 
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TDET_DIVIDENDO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_TDET_DIVIDENDO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO