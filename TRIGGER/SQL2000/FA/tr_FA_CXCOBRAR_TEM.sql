IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_CXCOBRAR_TEM')
	DROP TRIGGER tr_FA_CXCOBRAR_TEM
GO
CREATE TRIGGER tr_FA_CXCOBRAR_TEM  
ON FA_CXCOBRAR_TEM 
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

		SET @observacion ='EMP_ID_EMPRESA, tipo, Num_factura, cod_cliente'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=tipo,@codigo3=Num_factura,@codigo4=cod_cliente 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=tipo,@codigo3=Num_factura,@codigo4=cod_cliente 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('FA_CXCOBRAR_TEM',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_CXCOBRAR_TEM_UP')
	DROP TRIGGER TR_FA_CXCOBRAR_TEM_UP
GO

CREATE TRIGGER TR_FA_CXCOBRAR_TEM_UP
ON FA_CXCOBRAR_TEM
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

		SET @observacion ='EMP_ID_EMPRESA, tipo, Num_factura, cod_cliente'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=tipo,@codigo3=Num_factura,@codigo4=cod_cliente 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('FA_CXCOBRAR_TEM',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO