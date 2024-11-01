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
