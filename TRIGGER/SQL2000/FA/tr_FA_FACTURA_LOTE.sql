IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_FACTURA_LOTE')
	DROP TRIGGER TR_FA_FACTURA_LOTE
GO


CREATE TRIGGER TR_FA_FACTURA_LOTE  
ON FA_FACTURA_LOTE 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@codigo6 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		set @observacion='COD_ING, emp_id_empresa,cod_bien,cod_proy,cod_obra,cod_cent'

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

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,codigo6,[status],observacion)
					VALUES('FA_FACTURA_LOTE',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,@codigo6,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_FACTURA_LOTE_UP')
	DROP TRIGGER TR_FA_FACTURA_LOTE_UP
GO
CREATE TRIGGER TR_FA_FACTURA_LOTE_UP
ON FA_FACTURA_LOTE
AFTER UPDATE
AS

		declare @codigo varchar(30),
				@codigo2 varchar(30),
				@codigo3 varchar(30),
				@codigo4 varchar(30),
				@codigo5 varchar(30),
				@codigo6 varchar(30),
				@observacion varchar(500),
				@tipo char(1)

		set @observacion='COD_ING, emp_id_empresa,cod_bien,cod_proy,cod_obra,cod_cent'

BEGIN
	SELECT @codigo= COD_ING,@codigo2=emp_id_empresa,@codigo3=cod_bien,@codigo4=cod_proy,@codigo5=cod_obra,@codigo6=cod_cent
	FROM inserted
	order by COD_ING asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,codigo6,[status],observacion)
			VALUES('FA_FACTURA_LOTE',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,@codigo6,1,@observacion)
	END
END

	
GO