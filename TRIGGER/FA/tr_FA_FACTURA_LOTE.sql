IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_FACTURA_LOTE')
	DROP TRIGGER tr_FA_FACTURA_LOTE
GO


CREATE TRIGGER tr_FA_FACTURA_LOTE  
ON FA_FACTURA_LOTE 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@codigo6 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		set @observacion='COD_ING,emp_id_empresa,cod_bien,cod_proy,cod_obra,cod_cent'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= COD_ING,@codigo2=emp_id_empresa,@codigo3=cod_bien,@codigo4=cod_proy,@codigo5=cod_obra,@codigo6=cod_cent
	FROM inserted
	order by COD_ING asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= COD_ING,@codigo2=emp_id_empresa,@codigo3=cod_bien,@codigo4=cod_proy,@codigo5=cod_obra,@codigo6=cod_cent
	FROM deleted
	order by COD_ING asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!='' AND @codigo4!='' AND @codigo5!='' AND @codigo6!=''
BEGIN
	IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_FACTURA_LOTE' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4 AND codigo5=@codigo5 AND codigo6 = @codigo6) = 0
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,codigo6,[status],observacion)
					VALUES('FA_FACTURA_LOTE',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,@codigo6,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_FACTURA_LOTE_UP')
	DROP TRIGGER TR_FA_FACTURA_LOTE_UP
GO
CREATE TRIGGER TR_FA_FACTURA_LOTE_UP
ON FA_FACTURA_LOTE
AFTER UPDATE
AS

		declare @codigo varchar(30)='',
				@codigo2 varchar(30)='',
				@codigo3 varchar(30)='',
				@codigo4 varchar(30)='',
				@codigo5 varchar(30)='',
				@codigo6 varchar(30)='',
				@observacion varchar(max)='',
				@tipo char(1)

		set @observacion='COD_ING,emp_id_empresa,cod_bien,cod_proy,cod_obra,cod_cent'

BEGIN
	SELECT @codigo= COD_ING,@codigo2=emp_id_empresa,@codigo3=cod_bien,@codigo4=cod_proy,@codigo5=cod_obra,@codigo6=cod_cent
	FROM inserted
	order by COD_ING asc

	SET @tipo ='U'

	IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!='' AND @codigo4!='' AND @codigo5!='' AND @codigo6!=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_FACTURA_LOTE' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4 AND codigo5=@codigo5 AND codigo6 = @codigo6) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,codigo6,[status],observacion)
			VALUES('FA_FACTURA_LOTE',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,@codigo6,1,@observacion)
	END
END

	
GO