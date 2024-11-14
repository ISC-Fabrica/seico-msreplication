IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CB_REPORTE_TESORERIA_DETALLADO')
	DROP TRIGGER tr_CB_REPORTE_TESORERIA_DETALLADO
GO
CREATE TRIGGER tr_CB_REPORTE_TESORERIA_DETALLADO  
ON CB_REPORTE_TESORERIA_DETALLADO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CBC_NRO_CONCILIACION,ctr_nro_referencia,ctr_nro_transaccion'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA, @codigo2= CBC_NRO_CONCILIACION, @codigo3= ctr_nro_referencia, @codigo4 = ctr_nro_transaccion
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA, @codigo2= CBC_NRO_CONCILIACION, @codigo3= ctr_nro_referencia, @codigo4 = ctr_nro_transaccion
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' and @codigo4 !=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_REPORTE_TESORERIA_DETALLADO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CB_REPORTE_TESORERIA_DETALLADO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO





IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CB_REPORTE_TESORERIA_DETALLADO_UP')
	DROP TRIGGER TR_CB_REPORTE_TESORERIA_DETALLADO_UP
GO
CREATE TRIGGER TR_CB_REPORTE_TESORERIA_DETALLADO_UP
ON CB_REPORTE_TESORERIA_DETALLADO
AFTER UPDATE
AS

		declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CBC_NRO_CONCILIACION,ctr_nro_referencia,ctr_nro_transaccion'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA, @codigo2= CBC_NRO_CONCILIACION, @codigo3= ctr_nro_referencia, @codigo4 = ctr_nro_transaccion
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' and @codigo2 !='' and @codigo3 !='' and @codigo4 !=''
	BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CB_REPORTE_TESORERIA_DETALLADO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CB_REPORTE_TESORERIA_DETALLADO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO