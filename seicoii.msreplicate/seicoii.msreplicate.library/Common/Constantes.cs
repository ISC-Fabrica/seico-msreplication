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

        public static string Select_ColumnasTabla =
           "SELECT a.name, c.name type, a.isnullable FROM syscolumns a JOIN sysobjects b ON b.id = a.id \r\n" +
            "JOIN systypes c ON a.xtype = c.xtype AND c.name <> 'sysname' \r\n" +
            "WHERE b.type = 'U' AND b.name = '{nombre_table}' \r\n" +
            "ORDER BY colid";


        public static string Select_TablasPendientes =
            "SELECT distinct nombre_table FROM temp_registroMigracion WHERE status = 1 order by nombre_table ";

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
            "UPDATE temp_registroMigracion SET status = 0 WHERE status = 1 and id = {id}";


        public static string Update_EstadoOmitido =
            "UPDATE temp_registroMigracion SET status = 2 WHERE status = 1 and id = {id}";


        public static string Update_EstadoErroneo =
            "UPDATE temp_registroMigracion SET status = 9 WHERE status = 1 and id = {id}";


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
            "INSERT INTO {nombre_tabla} ({columnas}) VALUES ({valores})";


        public static string Update_Tables =
            "SET DATEFORMAT YMD;\r\n" +
            "UPDATE {nombre_tabla} SET {valores} {condiciones}";


        public static string Select_ExistRecordTable =
            "SELECT distinct 1 as existe FROM {nombre_tabla} {condiciones}";


    }
}
