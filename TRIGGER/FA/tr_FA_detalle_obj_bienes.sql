IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_detalle_obj_bienes')
	DROP TRIGGER tr_FA_detalle_obj_bienes
GO
CREATE TRIGGER tr_FA_detalle_obj_bienes  
ON FA_detalle_obj_bienes 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observarcion varchar(max)='',
		@tipo char(1)

		set @observarcion='obb_codigo,dob_local,dob_estado'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= obb_codigo FROM inserted
	order by obb_codigo asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= obb_codigo 
	FROM deleted
	order by obb_codigo asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!='' 
BEGIN
	IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_detalle_obj_bienes' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_detalle_obj_bienes',@tipo,@codigo,@codigo2,@codigo3,1,@observarcion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_detalle_obj_bienes_UP')
	DROP TRIGGER TR_FA_detalle_obj_bienes_UP
GO

CREATE TRIGGER TR_FA_detalle_obj_bienes_UP
ON FA_detalle_obj_bienes
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observarcion varchar(max)='',
		@tipo char(1)

		set @observarcion='obb_codigo,dob_local,dob_estado'

BEGIN
	SELECT @codigo= obb_codigo
	FROM inserted
	order by obb_codigo asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!='' 
	BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_detalle_obj_bienes' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_detalle_obj_bienes',@tipo,@codigo,@codigo2,@codigo3,1,@observarcion)
	END
END

	
GO