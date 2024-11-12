IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_tem_fa_saldos_a_fecha')
	DROP TRIGGER tr_tem_fa_saldos_a_fecha
GO

CREATE TRIGGER tr_tem_fa_saldos_a_fecha  
ON tem_fa_saldos_a_fecha 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA,cod_cliente,num_facturta'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cod_cliente,@codigo3=num_facturta 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cod_cliente 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('tem_fa_saldos_a_fecha',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_tem_fa_saldos_a_fecha_UP')
	DROP TRIGGER TR_tem_fa_saldos_a_fecha_UP
GO
CREATE TRIGGER TR_tem_fa_saldos_a_fecha_UP
ON tem_fa_saldos_a_fecha
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA,cod_cliente,num_facturta'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cod_cliente,@codigo3=num_facturta 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('tem_fa_saldos_a_fecha',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO