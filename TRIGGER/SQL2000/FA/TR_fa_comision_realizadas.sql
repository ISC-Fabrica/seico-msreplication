IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_fa_comision_realizadas')
	DROP TRIGGER TR_FA_comision_realizadas
GO
CREATE TRIGGER TR_FA_comision_realizadas  
ON fa_comision_realizadas 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@observacion varchar(500),
		@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@codigo3 ='',
		@codigo4 ='',
		@observacion =''

		SET @observacion ='emp_id_empresa,nro_factura,codigo_tran,cod_contrato'


IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= emp_id_empresa, @codigo2=nro_factura,@codigo3= codigo_tran,@codigo4=COD_CONTRATO  
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= emp_id_empresa, @codigo2=nro_factura,@codigo3= codigo_tran,@codigo4=COD_CONTRATO  
	FROM deleted
	order by emp_id_empresa asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'fa_comision_realizadas'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('fa_comision_realizadas',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_fa_comision_realizadas_UP')
	DROP TRIGGER TR_FA_comision_realizadas_UP
GO

CREATE TRIGGER TR_FA_comision_realizadas_UP
ON fa_comision_realizadas
AFTER UPDATE
AS

	declare @codigo varchar(30),
			@codigo2 varchar(30),
			@codigo3 varchar(30),
			@codigo4 varchar(30),
			@observacion varchar(500),
			@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@codigo3 ='',
		@codigo4 ='',
		@observacion =''

			SET @observacion ='emp_id_empresa,nro_factura,codigo_tran,cod_contrato'

BEGIN
	SELECT @codigo= emp_id_empresa, @codigo2=nro_factura,@codigo3= codigo_tran,@codigo4=COD_CONTRATO  
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='U'

	IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'fa_comision_realizadas'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4)
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('fa_comision_realizadas',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO