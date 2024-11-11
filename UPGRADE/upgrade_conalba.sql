IF NOT (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'temp_registroMigracion'))
BEGIN
	CREATE TABLE temp_registroMigracion(
		id int identity(1,1),
		nombre_table varchar(200),
		tipo varchar(10),
		codigo varchar(30),
		codigo2 varchar(30),
		codigo3 varchar(30),
		codigo4 varchar(30),
		codigo5 varchar(30),
		codigo6 varchar(30),
		observacion varchar(max),
		[status] INT,
		fechaRegistro datetime default getdate()
	)

	PRINT 'CREATE TABLE temp_registroMigracion'
END

IF NOT (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'log_triggers'))
BEGIN
	CREATE TABLE log_triggers(
		id int identity(1,1),
		observacion varchar(max),
		nombreTrigger varchar(max),
		codStatus int,
		fecha_registro datetime default(GETDATE())
	)
END

IF NOT (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'temp_Migracion'))
BEGIN
	CREATE TABLE temp_Migracion(
		id int identity(1,1),
		codigo int,
		tipo varchar(10),
		nombreTabla varchar(max)
	)
END

IF not exists
(
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'fechaModificacion' AND TABLE_NAME = 'temp_registroMigracion'
)
BEGIN
  ALTER TABLE temp_registroMigracion ADD fechaModificacion datetime
END

IF not exists
(
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'fechaMigracion' AND TABLE_NAME = 'AUD_FA_CLIENTE'
)
BEGIN
  ALTER TABLE AUD_FA_CLIENTE ADD fechaMigracion datetime
END

IF not exists
(
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'fechaMigracion' AND TABLE_NAME = 'FA_TRAN_DOCUMENTOS'
)
BEGIN
  ALTER TABLE FA_TRAN_DOCUMENTOS ADD fechaMigracion datetime
END


/*
	MODIFICAR EL NOMBRE DE LA BASE DE DATOS ESTE PROCESO SIRVE
	PARA ACTUALIZAR EL NIVEL DE COMPATIVILIDAD DE LA BASE DE DATOS
	ESTA NO VA AFECTAR EL RENDIMIENTO DE LA MISMA.

	ESTA ACTUALIZACION ES REQUERIDA PARA DESERIALIZAR OBJECTOS JSON
*/

IF (SELECT COUNT(1) FROM sys.databases WHERE name = 'SEICOII' AND compatibility_level < 130) = 1
BEGIN
	ALTER DATABASE SEICOII
	SET COMPATIBILITY_LEVEL = 160;
END
