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
                 AND  TABLE_NAME = 'temp_Migracion'))
BEGIN
	CREATE TABLE temp_Migracion(
		id int identity(1,1),
		nombre_table varchar(200),
		tipo varchar(10) DEFAULT 'M',
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

IF NOT (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'temp_registroMigrado'))
BEGIN
	CREATE TABLE temp_registroMigrado(
		id int identity(1,1),
		nombre_table varchar(200),
		tipo varchar(10),
		codigo varchar(30),
		codigo2 varchar(30),
		codigo3 varchar(30),
		codigo4 varchar(30),
		codigo5 varchar(30),
		codigo6 varchar(30),
		observacion varchar(500),
		[status] INT,
		fechaRegistro datetime default getdate()
	)

	PRINT 'CREATE TABLE temp_registroMigrado'
END

IF NOT (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'temp_logRegistroTrigger'))
BEGIN
	CREATE TABLE temp_logRegistroTrigger(
		id int identity(1,1),
		nombre_table varchar(200),
		nombre_trigger varchar(200),
		errorline varchar(10),
		message varchar(30),
		fechaRegistro datetime default getdate()
	)

	PRINT 'CREATE TABLE temp_logRegistroTrigger'
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

IF not exists
(
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'fechaMigracion' AND TABLE_NAME = 'temp_registroMigracion'
)
BEGIN
  ALTER TABLE temp_registroMigracion ADD fechaMigracion datetime null
END

IF not exists
(
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'detalleError' AND TABLE_NAME = 'temp_registroMigracion'
)
BEGIN
  ALTER TABLE temp_registroMigracion ADD detalleError varchar(500) null
END

