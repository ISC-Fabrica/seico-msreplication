IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_VENT_LOCAL')
	DROP TRIGGER tr_FA_VENT_LOCAL
GO

CREATE TRIGGER tr_FA_VENT_LOCAL  
ON FA_VENT_LOCAL 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,loc_codigo,obb_codigo,cli_codigo'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=loc_codigo,@codigo3=obb_codigo,@codigo4=cli_codigo
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=loc_codigo,@codigo3=obb_codigo,@codigo4=cli_codigo
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('FA_VENT_LOCAL',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_VENT_LOCAL_UP')
	DROP TRIGGER TR_FA_VENT_LOCAL_UP
GO

CREATE TRIGGER TR_FA_VENT_LOCAL_UP
ON FA_VENT_LOCAL
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,loc_codigo,obb_codigo,cli_codigo'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=loc_codigo,@codigo3=obb_codigo,@codigo4=cli_codigo
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('FA_VENT_LOCAL',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO