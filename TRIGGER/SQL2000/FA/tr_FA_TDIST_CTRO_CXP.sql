IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_TDIST_CTRO_CXP')
	DROP TRIGGER tr_FA_TDIST_CTRO_CXP
GO

CREATE TRIGGER tr_FA_TDIST_CTRO_CXP  
ON FA_TDIST_CTRO_CXP 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA,DC_SECUENCIA,DCXP_LINEA'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=DC_SECUENCIA,@codigo3=DCXP_LINEA 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=DC_SECUENCIA,@codigo3=DCXP_LINEA 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_TDIST_CTRO_CXP',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_TDIST_CTRO_CXP_UP')
	DROP TRIGGER TR_FA_TDIST_CTRO_CXP_UP
GO
CREATE TRIGGER TR_FA_TDIST_CTRO_CXP_UP
ON FA_TDIST_CTRO_CXP
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA,DC_SECUENCIA,DCXP_LINEA'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=DC_SECUENCIA,@codigo3=DCXP_LINEA
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_TDIST_CTRO_CXP',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO