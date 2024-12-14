using seicoii.msreplicate.library.Data.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace seicoii.msreplicate.library.Common
{
    public static class Constantes
    {
        public static List<ColumnasBD> ColumnasToMap = new List<ColumnasBD>
        {
            new() { ColumnType = "char", ColumnValue = "'{value}'" },
            new() { ColumnType = "datetime", ColumnValue = "'{value}'" },
            new() { ColumnType = "float", ColumnValue = "{value}" },
            new() { ColumnType = "int", ColumnValue = "{value}" },
            new() { ColumnType = "money", ColumnValue = "{value}" },
            new() { ColumnType = "numeric", ColumnValue = "{value}" },
            new() { ColumnType = "nvarchar", ColumnValue = "'{value}'" },
            new() { ColumnType = "real", ColumnValue = "{value}" },
            new() { ColumnType = "smallint", ColumnValue = "{value}" },
            new() { ColumnType = "tinyint", ColumnValue = "{value}" },
            new() { ColumnType = "varbinary", ColumnValue = "{value}" },
            new() { ColumnType = "varchar", ColumnValue = "'{value}'" },
            new() { ColumnType = "bit", ColumnValue = "{value}" }
        };

        #region Begin For Constraint

        public static string NoCheckConstraint =
           "ALTER TABLE {nombre_table} NOCHECK CONSTRAINT ALL;";

        public static string CheckConstraint =
           "ALTER TABLE {nombre_table} CHECK CONSTRAINT ALL;";

        #endregion End For Constraint

        #region Begin For Triggers

        public static string DisableTriggers =
           "ALTER TABLE {nombre_table} DISABLE TRIGGER ALL;";

        public static string EnableTriggers =
           "ALTER TABLE {nombre_table} ENABLE TRIGGER ALL;";

        #endregion End For Triggers

        public static string Select_ColumnasTabla =
           "SELECT a.name, c.name type, a.isnullable FROM syscolumns a JOIN sysobjects b ON b.id = a.id \r\n" +
            "JOIN systypes c ON a.xtype = c.xtype AND c.name <> 'sysname' \r\n" +
            "WHERE b.type = 'U' AND a.name not in ('pk_Id', 'factura_id') AND b.name = '{nombre_table}' \r\n" +
            "ORDER BY colid";


        public static string Select_TablasPendientes =
            "SELECT distinct nombre_table \r\n" +
            "FROM temp_registroMigracion \r\n" +
            "WHERE status = 1 \r\n" +
            "{condicion_adicional} \r\n" +
            "order by nombre_table ";

        public static string Select_RegistroMigracionPendientes =
            "SET DATEFORMAT YMD;\r\n" +
            "SELECT id, nombre_table, tipo, codigo, codigo2, codigo3, codigo4, codigo5, codigo6, observacion, status, CONVERT(varchar,fechaRegistro,121) as fechaRegistro " +
            "FROM temp_registroMigracion " +
            "WHERE status = 1 and nombre_table = '{nombre_table}' " +
            "Order By id";


        public static string Select_TableInfo =
            "SET DATEFORMAT YMD;\r\n" +
            "SELECT {Columns} FROM {nombre_table} {Condition}";



        public static string Update_EstadoTablasPendientes =
            "UPDATE temp_registroMigracion SET status = 0, detalleError = null WHERE status = 1 and id = {id}";


        public static string Update_EstadoOmitido =
            "UPDATE temp_registroMigracion SET status = 2, detalleError = '{detalleError}' WHERE status = 1 and id = {id}";


        public static string Update_EstadoErroneo =
            "UPDATE temp_registroMigracion SET status = 9, detalleError = '{detalleError}' WHERE status = 1 and id = {id}";


        public static string InsertInto_RegistroMigrado =
            "SET DATEFORMAT YMD;\r\n" +
            "INSERT INTO temp_registroMigrado (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,codigo6,observacion,status,fechaRegistro) " +
            "VALUES ({nombre_table},{tipo},{codigo},{codigo2},{codigo3},{codigo4},{codigo5},{codigo6},{observacion},{status},{fechaRegistro});" +
            "\r\n" +
            "SELECT @@Identity id;";


        public static string Delete_RegistroMigrado =
            "DELETE FROM temp_registroMigrado WHERE id = {id}";



        public static string InsertInto_Tables =
            "SET DATEFORMAT YMD;\r\n" +
            "INSERT INTO {nombre_tabla} ({columnas}) VALUES ({valores});" +
            "\r\n" +
            "SELECT @@ROWCOUNT [Rows];";


        public static string Update_Tables =
            "SET DATEFORMAT YMD;\r\n" +
            "UPDATE {nombre_tabla} SET {valores} {condiciones};" +
            "\r\n" +
            "SELECT @@ROWCOUNT [Rows];";


        public static string Delete_Tables =
            "SET DATEFORMAT YMD;\r\n" +
            "DELETE FROM {nombre_tabla} {condiciones};" +
            "\r\n" +
            "SELECT @@ROWCOUNT [Rows];";


        public static string Select_ExistRecordTable =
            "SELECT distinct 1 as existe FROM {nombre_tabla} {condiciones}";


    }
}
