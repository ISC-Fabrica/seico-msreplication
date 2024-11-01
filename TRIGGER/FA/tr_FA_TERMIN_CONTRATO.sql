IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_TERMIN_CONTRATO')
	DROP TRIGGER tr_FA_TERMIN_CONTRATO
GO

CREATE TRIGGER tr_FA_TERMIN_CONTRATO  
ON FA_TERMIN_CONTRATO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='COD_EMPRESA,LOC_CODIGO,CLI_CODIGO,LOC_NUMERO'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= COD_EMPRESA,@codigo2=LOC_CODIGO,@codigo3=CLI_CODIGO,@codigo4=LOC_NUMERO
	FROM inserted
	order by COD_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= COD_EMPRESA,@codigo2=LOC_CODIGO,@codigo3=CLI_CODIGO,@codigo4=LOC_NUMERO
	FROM deleted
	order by COD_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('FA_TERMIN_CONTRATO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_TERMIN_CONTRATO_UP')
	DROP TRIGGER TR_FA_TERMIN_CONTRATO_UP
GO

CREATE TRIGGER TR_FA_TERMIN_CONTRATO_UP
ON FA_TERMIN_CONTRATO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='COD_EMPRESA,LOC_CODIGO,CLI_CODIGO,LOC_NUMERO'

BEGIN
	SELECT @codigo= COD_EMPRESA,@codigo2=LOC_CODIGO,@codigo3=CLI_CODIGO,@codigo4=LOC_NUMERO
	FROM inserted
	order by COD_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('FA_TERMIN_CONTRATO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO