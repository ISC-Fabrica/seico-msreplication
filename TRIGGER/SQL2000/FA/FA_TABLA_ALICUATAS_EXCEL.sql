IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_TABLA_ALICUATAS_EXCEL')
	DROP TRIGGER tr_FA_TABLA_ALICUATAS_EXCEL
GO

CREATE TRIGGER tr_FA_TABLA_ALICUATAS_EXCEL  
ON FA_TABLA_ALICUATAS_EXCEL 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='emp_id_empresa,COD_LOCAL,FCHA_INGRESO'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= emp_id_empresa,@codigo2=COD_LOCAL,@codigo3=FCHA_INGRESO 
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=COD_LOCAL,@codigo3=FCHA_INGRESO  
	FROM deleted
	order by emp_id_empresa asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_TABLA_ALICUATAS_EXCEL',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_TABLA_ALICUATAS_EXCEL_UP')
	DROP TRIGGER TR_FA_TABLA_ALICUATAS_EXCEL_UP
GO
CREATE TRIGGER TR_FA_TABLA_ALICUATAS_EXCEL_UP
ON FA_TABLA_ALICUATAS_EXCEL
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='emp_id_empresa,COD_LOCAL,FCHA_INGRESO'

BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=COD_LOCAL ,@codigo3=FCHA_INGRESO 
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_TABLA_ALICUATAS_EXCEL',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO