IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_BANCO')
	DROP TRIGGER tr_FA_DETBIENES
GO
CREATE TRIGGER tr_FA_DETBIENES  
ON FA_DETBIENES 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),
		@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@observacion =''

		SET @observacion='EMP_ID_EMPRESA, loc_codigo'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=loc_codigo 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=loc_codigo 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_DETBIENES',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_DETBIENES_UP')
	DROP TRIGGER TR_FA_DETBIENES_UP
GO
CREATE TRIGGER TR_FA_DETBIENES_UP
ON FA_DETBIENES
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),
		@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@observacion =''

		SET @observacion='EMP_ID_EMPRESA, loc_codigo'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=loc_codigo 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_DETBIENES',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO