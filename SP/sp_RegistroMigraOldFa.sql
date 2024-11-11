IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_RegistroMigraOldFa]') AND type in (N'P', N'PC'))
	EXEC('CREATE PROCEDURE sp_RegistroMigraOldFa AS')
GO

ALTER PROCEDURE sp_RegistroMigraOldFa
@accion CHAR(3),
@nombreTable varchar(200)		= NULL,
@columnas varchar(max)			= NULL,
@valores varchar(max)			= NULL
AS
BEGIN
		IF @accion = 'I'
		BEGIN
			DECLARE @sqlInsert NVARCHAR(MAX);

			SET @sqlInsert = 'INSERT INTO ' + @nombreTable + ' (' + @columnas + ') VALUES (' + @valores + ')';

			EXEC sp_executesql @sqlInsert;
		END

		IF @accion = 'U'
		BEGIN
			DECLARE @Sql NVARCHAR(MAX), @UpdateSql NVARCHAR(MAX);
			SET @Sql = 'UPDATE ' + QUOTENAME(@nombreTable) + ' SET ';

			 SET @UpdateSql = '';
    
			DECLARE @Json NVARCHAR(MAX) = REPLACE(@columnas,'[','');
			DECLARE @JsonFiltro NVARCHAR(MAX) = @valores;

			DECLARE @Campo NVARCHAR(255), @Valor NVARCHAR(255);

			DECLARE @JsonTable TABLE (Campo NVARCHAR(255), Valor NVARCHAR(255));
			DECLARE @JsonTableFiltro TABLE (Campo NVARCHAR(255), Valor NVARCHAR(255));

			INSERT INTO @JsonTable (Campo, Valor)
			SELECT 
				[key],
				[value]
			FROM OPENJSON(@Json) 

			INSERT INTO @JsonTableFiltro (Campo, Valor)
			SELECT 
				[key],
				[value]
			FROM OPENJSON(@JsonFiltro)
			

			DECLARE @Row NVARCHAR(MAX);
			DECLARE db_cursor CURSOR FOR
			SELECT Campo, Valor FROM @JsonTable;
    
			OPEN db_cursor;
			FETCH NEXT FROM db_cursor INTO @Campo, @Valor;
    
			WHILE @@FETCH_STATUS = 0
			BEGIN

				SET @UpdateSql = @UpdateSql + QUOTENAME(@Campo) + ' = CONVERT(VARCHAR(MAX),''' + @Valor + '''), ';
        
				FETCH NEXT FROM db_cursor INTO @Campo, @Valor;
			END;
    
			CLOSE db_cursor;
			DEALLOCATE db_cursor;

			IF LEN(@UpdateSql) > 0
			BEGIN
				SET @UpdateSql = LEFT(@UpdateSql, LEN(@UpdateSql) - 1); -- Eliminar la coma final
			END;

			DECLARE @FC VARCHAR(MAX), @FV varchar(MAX)

			SELECT @FC=Campo, @FV=Valor FROM @JsonTableFiltro

			SET @UpdateSql += ' WHERE ' + QUOTENAME(@FC) + ' = CONVERT(VARCHAR(MAX),''' + @FV + ''')'

			SET @Sql = @Sql + @UpdateSql;
						
			EXEC sp_executesql @Sql;

		END
END