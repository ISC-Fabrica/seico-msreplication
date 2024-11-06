IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_mese')
	DROP TRIGGER tr_FA_mese
GO
CREATE TRIGGER tr_FA_mese  
ON FA_mese 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@observacion varchar(max),
		@tipo char(1)

		set @observacion ='mes'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= mes 
	FROM inserted
	order by mes asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= mes 
	FROM deleted
	order by mes asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status],observacion)
					VALUES('FA_mese',@tipo,@codigo,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_mese_UP')
	DROP TRIGGER TR_FA_mese_UP
GO

CREATE TRIGGER TR_FA_mese_UP
ON FA_mese
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@observacion varchar(max),
		@tipo char(1)

		set @observacion ='mes'

BEGIN
	SELECT @codigo= mes 
	FROM inserted
	order by mes asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status],observacion)
					VALUES('FA_mese',@tipo,@codigo,1,@observacion)
	END
END

	
GO