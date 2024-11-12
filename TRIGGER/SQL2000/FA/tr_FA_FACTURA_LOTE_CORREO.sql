IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_FACTURA_LOTE_CORREO')
	DROP TRIGGER tr_FA_FACTURA_LOTE_CORREO
GO

CREATE TRIGGER tr_FA_FACTURA_LOTE_CORREO  
ON FA_FACTURA_LOTE_CORREO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		set @observacion='NOM_EMP,ERROR,DIARIO'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= NOM_EMP,@codigo2=ERROR,@codigo3=DIARIO 
	FROM inserted
	order by NOM_EMP asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= NOM_EMP,@codigo2=ERROR,@codigo3=DIARIO 
	FROM deleted
	order by NOM_EMP asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_FACTURA_LOTE_CORREO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_FACTURA_LOTE_CORREO_UP')
	DROP TRIGGER TR_FA_FACTURA_LOTE_CORREO_UP
GO

CREATE TRIGGER TR_FA_FACTURA_LOTE_CORREO_UP
ON FA_FACTURA_LOTE_CORREO
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		set @observacion='NOM_EMP,ERROR,DIARIO'

BEGIN
	SELECT @codigo= NOM_EMP,@codigo2=ERROR,@codigo3=DIARIO 
	FROM inserted
	order by NOM_EMP asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
			VALUES('FA_FACTURA_LOTE_CORREO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO