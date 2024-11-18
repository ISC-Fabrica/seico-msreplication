using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace seicoii.msreplicate.library.Common
{
    public static class Utils
    {
        public static string GetValueString(string Column, string ColumnType, object Value)
        {
            if (Value == null)
            {
                return "NULL";
            }
            var Type = Constantes.ColumnasToMap.Where(x => x.ColumnType.ToLower().Trim().Equals(ColumnType.ToLower().Trim())).FirstOrDefault();
            if (Type == null)
            {
                return "";
            }

            return Type.ColumnValue.Replace("value", Value.ToString());
        }

        public static string ConcatenateString(string cadena, string nuevoValor, string Separator = ",")
        {
            if (nuevoValor == null)
            {
                return cadena;
            }
            if (string.IsNullOrEmpty(cadena))
            {
                return $"{nuevoValor}";
            }
            else
            {
                return $"{cadena}{Separator} {nuevoValor}";
            }
        }

        public static string Concatenate_WHERE(string cadena, string nuevoValor, string Operator = "AND")
        {
            if (nuevoValor == null)
            {
                return cadena;
            }
            if (string.IsNullOrEmpty(cadena))
            {
                return $" WHERE {nuevoValor}";
            }
            else
            {
                return $"{cadena} {Operator} {nuevoValor}";
            }
        }

        public static string Concatenate_JOIN(string cadena, string nuevoValor, string Operator = "AND")
        {
            if (nuevoValor == null)
            {
                return cadena;
            }
            if (string.IsNullOrEmpty(cadena))
            {
                return $" ON {nuevoValor}";
            }
            else
            {
                return $"{cadena} {Operator} {nuevoValor}";
            }
        }

        public static string Replace_Value(string key, string valueFormat, string value)
        {
            if (value == null || value.ToUpper().Trim() == "NULL")
            {
                return $"{key} IS NULL";
            }
            else
            {
                return $"{key} = {valueFormat.Replace("{value}", value)}";
            }
        }

        public static string Replace_ValueInsert(string valueFormat, string value)
        {
            if (string.IsNullOrEmpty(value) || value.ToUpper().Trim() == "NULL")
            {
                return $"NULL";
            }
            else
            {
                return valueFormat.Replace("{value}", value);
            }
        }

        //public static string ValueColumnToString(string columnType, object columnValue)
        //{
        //    //if (columnValue == null)
        //    //{
        //    //    return "";
        //    //}

        //    //switch (columnType.ToLower().Trim())
        //    //{
        //    //    case "money":
        //    //    case "decimal":
        //    //        {
        //    //            return "";
        //    //        }
        //    //    default:
        //    //        {
        //    //            return columnValue.ToString();
        //    //        }

        //    //}
        //}

        //    new() { ColumnType = "char", ColumnValue = "'{value}'" },
        //    new() { ColumnType = "datetime", ColumnValue = "'{value}'" },
        //    new() { ColumnType = "float", ColumnValue = "{value}" },
        //    new() { ColumnType = "int", ColumnValue = "{value}" },
        //    new() { ColumnType = "money", ColumnValue = "{value}" },
        //    new() { ColumnType = "numeric", ColumnValue = "{value}" },
        //    new() { ColumnType = "nvarchar", ColumnValue = "'{value}'" },
        //    new() { ColumnType = "real", ColumnValue = "{value}" },
        //    new() { ColumnType = "smallint", ColumnValue = "{value}" },
        //    new() { ColumnType = "tinyint", ColumnValue = "{value}" },
        //    new() { ColumnType = "varbinary", ColumnValue = "{value}" },
        //    new() { ColumnType = "varchar", ColumnValue = "'{value}'" }
    }
}
