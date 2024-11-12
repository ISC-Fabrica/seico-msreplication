IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_INGRESO_CONTRA_OBRA')
	DROP TRIGGER tr_FA_INGRESO_CONTRA_OBRA
GO

CREATE TRIGGER tr_FA_INGRESO_CONTRA_OBRA  
ON FA_INGRESO_CONTRA_OBRA 
AFTER INSERT,DELETE   
AS 

		declare @codigo varchar(30),
				@codigo2 varchar(30),
				@codigo3 varchar(30),
				@codigo4 varchar(30),
				@codigo5 varchar(30),
				@observacion varchar(500),
				@tipo char(1)

				set @observacion='emp_id_empresa,codigo,cod_cli,cod_obra,cod_proy'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= emp_id_empresa,@codigo2=codigo,@codigo3=cod_cli,@codigo4=cod_obra,@codigo5=cod_proy 
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=codigo,@codigo3=cod_cli,@codigo4=cod_obra,@codigo5=cod_proy 
	FROM deleted
	order by emp_id_empresa asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
					VALUES('FA_INGRESO_CONTRA_OBRA',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_INGRESO_CONTRA_OBRA_UP')
	DROP TRIGGER TR_FA_INGRESO_CONTRA_OBRA_UP
GO

CREATE TRIGGER TR_FA_INGRESO_CONTRA_OBRA_UP
ON FA_INGRESO_CONTRA_OBRA
AFTER UPDATE
AS

		declare @codigo varchar(30),
			@codigo2 varchar(30),
			@codigo3 varchar(30),
			@codigo4 varchar(30),
			@codigo5 varchar(30),
			@observacion varchar(500),
			@tipo char(1)

			set @observacion='emp_id_empresa,codigo,cod_cli,cod_obra,cod_proy'

BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=codigo,@codigo3=cod_cli,@codigo4=cod_obra,@codigo5=cod_proy 
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
				VALUES('FA_INGRESO_CONTRA_OBRA',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
	END
END

	
GO