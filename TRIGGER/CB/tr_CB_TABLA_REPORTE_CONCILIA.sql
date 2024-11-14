IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CB_TABLA_REPORTE_CONCILIA')
	DROP TRIGGER tr_CB_TABLA_REPORTE_CONCILIA
GO
CREATE TRIGGER tr_CB_TABLA_REPORTE_CONCILIA  
ON CB_TABLA_REPORTE_CONCILIA 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(30)='',
		@tipo char(1)

		SET @observacion ='emp_id_empresa,nro_concilia,cod_banco'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= emp_id_empresa, @codigo2= nro_concilia, @codigo3=cod_banco 
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= emp_id_empresa, @codigo2= nro_concilia, @codigo3=cod_banco 
	FROM deleted
	order by emp_id_empresa asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2 !='' AND @codigo3 !=''
BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_TABLA_REPORTE_CONCILIA' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
						VALUES('CB_TABLA_REPORTE_CONCILIA',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO




IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CB_TABLA_REPORTE_CONCILIA_UP')
	DROP TRIGGER TR_CB_TABLA_REPORTE_CONCILIA_UP
GO
CREATE TRIGGER TR_CB_TABLA_REPORTE_CONCILIA_UP
ON CB_TABLA_REPORTE_CONCILIA
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(30)='',
		@tipo char(1)

		SET @observacion ='emp_id_empresa,nro_concilia,cod_banco'

BEGIN
	SELECT @codigo= emp_id_empresa, @codigo2= nro_concilia, @codigo3=cod_banco 
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3 !=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_TABLA_REPORTE_CONCILIA' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
						VALUES('CB_TABLA_REPORTE_CONCILIA',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO