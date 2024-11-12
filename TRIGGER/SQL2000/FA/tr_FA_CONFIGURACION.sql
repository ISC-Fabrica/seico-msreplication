IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_CONFIGURACION')
	DROP TRIGGER tr_FA_CONFIGURACION
GO
CREATE TRIGGER tr_FA_CONFIGURACION  
ON FA_CONFIGURACION 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@observacion varchar(500),
		@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@codigo3 ='',
		@codigo4 ='',
		@codigo5 ='',
		@observacion =''

		set @observacion='EMP_ID_EMPRESA, CTA_CXC_CLIENTE, CTA_RET_IVA, CTA_RET_FUNTE, CTA_BANCO'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTA_CXC_CLIENTE, @codigo3=CTA_RET_IVA,@codigo4=CTA_RET_FUNTE,@codigo5=CTA_BANCO
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTA_CXC_CLIENTE, @codigo3=CTA_RET_IVA,@codigo4=CTA_RET_FUNTE,@codigo5=CTA_BANCO
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' 
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
					VALUES('FA_CONFIGURACION',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_CONFIGURACION_UP')
	DROP TRIGGER TR_FA_CONFIGURACION_UP
GO

CREATE TRIGGER TR_FA_CONFIGURACION_UP
ON FA_CONFIGURACION
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@observacion varchar(500),
		@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@codigo3 ='',
		@codigo4 ='',
		@codigo5 ='',
		@observacion =''

		set @observacion='EMP_ID_EMPRESA, CTA_CXC_CLIENTE, CTA_RET_IVA, CTA_RET_FUNTE, CTA_BANCO'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTA_CXC_CLIENTE, @codigo3=CTA_RET_IVA,@codigo4=CTA_RET_FUNTE,@codigo5=CTA_BANCO
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
					VALUES('FA_CONFIGURACION',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
	END
END

	
GO