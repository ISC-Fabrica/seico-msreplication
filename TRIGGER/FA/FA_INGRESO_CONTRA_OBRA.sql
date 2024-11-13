IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_INGRESO_CONTRA_OBRA')
	DROP TRIGGER tr_FA_INGRESO_CONTRA_OBRA
GO

CREATE TRIGGER tr_FA_INGRESO_CONTRA_OBRA  
ON FA_INGRESO_CONTRA_OBRA 
AFTER INSERT,DELETE   
AS 

		declare @codigo varchar(30)='',
				@codigo2 varchar(30)='',
				@codigo3 varchar(30)='',
				@codigo4 varchar(30)='',
				@codigo5 varchar(30)='',
				@observacion varchar(max)='',
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

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!='' AND @codigo4!='' AND @codigo5!=''
BEGIN
	IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_INGRESO_CONTRA_OBRA' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4 AND codigo5=@codigo5) = 0
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
					VALUES('FA_INGRESO_CONTRA_OBRA',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_INGRESO_CONTRA_OBRA_UP')
	DROP TRIGGER TR_FA_INGRESO_CONTRA_OBRA_UP
GO

CREATE TRIGGER TR_FA_INGRESO_CONTRA_OBRA_UP
ON FA_INGRESO_CONTRA_OBRA
AFTER UPDATE
AS

		declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@codigo3 varchar(30)='',
			@codigo4 varchar(30)='',
			@codigo5 varchar(30)='',
			@observacion varchar(max)='',
			@tipo char(1)

			set @observacion='emp_id_empresa,codigo,cod_cli,cod_obra,cod_proy'

BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=codigo,@codigo3=cod_cli,@codigo4=cod_obra,@codigo5=cod_proy 
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='U'

	IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!='' AND @codigo4!='' AND @codigo5!=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_INGRESO_CONTRA_OBRA' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4 AND codigo5=@codigo5) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
				VALUES('FA_INGRESO_CONTRA_OBRA',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
	END
END

	
GO