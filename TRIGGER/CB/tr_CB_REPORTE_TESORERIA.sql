IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CB_REPORTE_TESORERIA')
	DROP TRIGGER tr_CB_REPORTE_TESORERIA
GO

CREATE TRIGGER tr_CB_REPORTE_TESORERIA  
ON CB_REPORTE_TESORERIA 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(MAX)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CBC_NRO_CONCILIACION,cod_banco'


IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CBC_NRO_CONCILIACION,@codigo3=cod_banco 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CBC_NRO_CONCILIACION,@codigo3=cod_banco 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2 !='' AND @codigo3 !=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_REPORTE_TESORERIA' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CB_REPORTE_TESORERIA',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CB_REPORTE_TESORERIA_UP')
	DROP TRIGGER TR_CB_REPORTE_TESORERIA_UP
GO

CREATE TRIGGER TR_CB_REPORTE_TESORERIA_UP
ON CB_REPORTE_TESORERIA
AFTER UPDATE
AS

		declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(MAX)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CBC_NRO_CONCILIACION,cod_banco'

BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CBC_NRO_CONCILIACION,@codigo3=cod_banco 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2 !='' AND @codigo3 !=''
	BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_REPORTE_TESORERIA' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CB_REPORTE_TESORERIA',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO