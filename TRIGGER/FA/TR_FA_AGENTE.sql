
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_AGENTE')
	DROP TRIGGER tr_FA_AGENTE
GO
CREATE TRIGGER tr_FA_AGENTE  
ON FA_AGENTE 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='nom_tipo_egte,emp_id_empresa'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= nom_tipo_egte,@codigo2=emp_id_empresa FROM inserted
	order by pk_Id asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= pk_Id FROM deleted
	order by pk_Id asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_AGENTE',@tipo,@codigo,@codigo2,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_AGENTE_UP')
	DROP TRIGGER TR_FA_AGENTE_UP
GO

CREATE TRIGGER TR_FA_AGENTE_UP
ON FA_AGENTE
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@tipo char(1),
			@observacion varchar(max)

			SET @observacion='nom_tipo_egte,emp_id_empresa'

BEGIN
	SELECT @codigo= nom_tipo_egte,@codigo2=emp_id_empresa FROM inserted
	order by pk_Id asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_AGENTE',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO