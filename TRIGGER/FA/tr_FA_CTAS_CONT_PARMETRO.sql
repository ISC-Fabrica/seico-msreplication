IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_CTAS_CONT_PARMETRO')
	DROP TRIGGER tr_FA_CTAS_CONT_PARMETRO
GO
CREATE TRIGGER tr_FA_CTAS_CONT_PARMETRO  
ON FA_CTAS_CONT_PARMETRO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		set @observacion ='CODIGO, EMP_ID_EMPRESA, par_codigo'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= CODIGO,@codigo2=EMP_ID_EMPRESA,@codigo3=par_codigo
	FROM inserted
	order by CODIGO asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= CODIGO,@codigo2=EMP_ID_EMPRESA,@codigo3=par_codigo
	FROM deleted
	order by CODIGO asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_CTAS_CONT_PARMETRO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_CTAS_CONT_PARMETRO_UP')
	DROP TRIGGER TR_FA_CTAS_CONT_PARMETRO_UP
GO

CREATE TRIGGER TR_FA_CTAS_CONT_PARMETRO_UP
ON FA_CTAS_CONT_PARMETRO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		set @observacion ='CODIGO, EMP_ID_EMPRESA, par_codigo'

BEGIN
	SELECT @codigo= CODIGO,@codigo2=EMP_ID_EMPRESA,@codigo3=par_codigo
	FROM inserted
	order by CODIGO asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_CTAS_CONT_PARMETRO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO