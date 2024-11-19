using Microsoft.SqlServer.Server;
using Microsoft.Win32;
using Newtonsoft.Json;
using seicoii.msreplicate.library.Common;
using seicoii.msreplicate.library.Data.Entities;
using seicoii.msreplicate.library.Data.Repository;
using seicoii.msreplicate.library.Interface;
using System;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace seicoii.msreplicate.library.Data.Service
{
    public class RegistroMigracionService
    {
        IRegistroMigracionRepository _Repository_ODBC = new ODBCRegistroMigracionRepository();
        IRegistroMigracionRepository _Repository_SQLC = new SQLCRegistroMigracionRepository();

        public RegistroMigracionService() { }

        public string EjecutarMigracion_ODBC_To_SQLC()
        {
            try
            {
                Logger.Log("Ejecutando Metodo: EjecutarMigracion_ODBC_To_SQLC");
                //Obtener Tablas a Migrar
                var Tablas = _Repository_ODBC.GetTables();

                if (Tablas != null)
                {
                    var tabTotal = Tablas.Count;
                    var tabCurrent = 1;
                    foreach (var tabla in Tablas)
                    {
                        Console.WriteLine("");
                        Console.WriteLine($"Tabla: {tabla} - {tabCurrent} de {tabTotal}");
                        tabCurrent++;
                        //Obtener Columnas de tabla a Migrar
                        var Columnas = _Repository_ODBC.GetColumnTables(tabla);
                        var ColumnasSQL = string.Empty;
                        foreach (var column in Columnas)
                        {
                            ColumnasSQL = Utils.ConcatenateString(ColumnasSQL, column.ColumnName);
                        }

                        //Obtener Registros de Tabla a Migrar
                        var Registros = _Repository_ODBC.GetPendings(tabla);
                        if (Registros != null && !string.IsNullOrEmpty(ColumnasSQL))
                        {
                            var Total = Registros.Count;
                            var Current = 1;
                            foreach (var registro in Registros)
                            {
                                Console.WriteLine($"Registro {Current} de {Total}");
                                Current++;

                                Logger.Log($"Registro: {JsonConvert.SerializeObject(registro)}");
                                var keys = registro.observacion.Split(',');
                                var Condicion = string.Empty;
                                int indice = 1;
                                if (!string.IsNullOrEmpty(registro.observacion))
                                {
                                    foreach (var key in keys)
                                    {
                                        var typeKey = Columnas.Where(x => x.ColumnName.Trim().ToLower().Equals(key.Trim().ToLower())).FirstOrDefault().ColumnType;
                                        var valueFormat = Constantes.ColumnasToMap.Where(x => x.ColumnType.ToLower().Trim().Equals(typeKey.ToLower().Trim())).FirstOrDefault().ColumnValue;

                                        var dataValue = string.Empty;
                                        switch (indice)
                                        {
                                            case 1:
                                                {
                                                    dataValue = registro.codigo.Trim();
                                                    break;
                                                }
                                            case 2:
                                                {
                                                    dataValue = registro.codigo2.Trim();
                                                    break;
                                                }
                                            case 3:
                                                {
                                                    dataValue = registro.codigo3.Trim();
                                                    break;
                                                }
                                            case 4:
                                                {
                                                    dataValue = registro.codigo4.Trim();
                                                    break;
                                                }
                                            case 5:
                                                {
                                                    dataValue = registro.codigo5.Trim();
                                                    break;
                                                }
                                            case 6:
                                                {
                                                    dataValue = registro.codigo6.Trim();
                                                    break;
                                                }

                                        }

                                        indice++;

                                        if (string.IsNullOrEmpty(dataValue))
                                        {
                                            dataValue = "NULL";
                                        }

                                        var newValue = Utils.Replace_Value(key, valueFormat, dataValue);

                                        Condicion = Utils.Concatenate_WHERE(Condicion, newValue);
                                    }
                                    var Values = _Repository_ODBC.GetColumnValues(tabla, Columnas, Condicion);

                                    if (Values.Count > 0)
                                    {
                                        //Insertar Registro para validar que no se cree en tabla de Migracion
                                        int idMigrado = _Repository_SQLC.InsertDataMigrated(new insert_temp_registroMigrado
                                        {
                                            nombre_table = registro.nombre_table,
                                            tipo = registro.tipo,
                                            codigo = registro.codigo,
                                            codigo2 = registro.codigo2,
                                            codigo3 = registro.codigo3,
                                            codigo4 = registro.codigo4,
                                            codigo5 = registro.codigo5,
                                            codigo6 = registro.codigo6,
                                            observacion = registro.observacion,
                                            status = registro.status,
                                            fechaRegistro = registro.fechaRegistro
                                        });
                                        var ExecuteTran = false;
                                        switch (registro.tipo)
                                        {
                                            case "I": //Insertar
                                                {
                                                    var ExisteRegistro = _Repository_SQLC.ValidateDataBeforeInsert(tabla, Condicion);
                                                    if (!ExisteRegistro)
                                                    {
                                                        var IntoColumns = string.Empty;
                                                        var IntoValues = string.Empty;
                                                        foreach (var val in Values)
                                                        {
                                                            var vFormat = Constantes.ColumnasToMap.Where(x => x.ColumnType.ToLower().Trim().Equals(val.ColumnType.ToLower().Trim())).FirstOrDefault().ColumnValue;
                                                            var valColumn = val.ColumnValue.ToString();

                                                            if ((string.IsNullOrEmpty(valColumn) && !val.ColumnType.ToLower().Trim().Contains("char")) || valColumn.ToUpper().Trim().Equals("NULL"))
                                                            {
                                                                valColumn = "NULL";
                                                            }
                                                            else
                                                            {
                                                                valColumn = $"{vFormat.Replace("{value}", valColumn)}";
                                                            }

                                                            IntoColumns = Utils.ConcatenateString(IntoColumns, val.ColumnName);
                                                            IntoValues = Utils.ConcatenateString(IntoValues, valColumn);
                                                        }

                                                        ExecuteTran = _Repository_SQLC.InsertData(tabla, IntoColumns, IntoValues);
                                                    }
                                                    break;
                                                }
                                            case "U": //Actualizar
                                                {
                                                    var SetColumns = string.Empty;
                                                    foreach (var val in Values)
                                                    {
                                                        var contains = keys.Select(x => x.ToLower().Trim()).Contains(val.ColumnName.ToLower().Trim());
                                                        if (!contains)
                                                        {
                                                            var vFormat = Constantes.ColumnasToMap.Where(x => x.ColumnType.ToLower().Trim().Equals(val.ColumnType.ToLower().Trim())).FirstOrDefault().ColumnValue;

                                                            var valColumn = val.ColumnValue.ToString();

                                                            if ((string.IsNullOrEmpty(valColumn) && !val.ColumnType.ToLower().Trim().Contains("char")) || valColumn.ToUpper().Trim().Equals("NULL"))
                                                            {
                                                                valColumn = "NULL";
                                                            }
                                                            else
                                                            {
                                                                valColumn = $"{vFormat.Replace("{value}", valColumn)}";
                                                            }

                                                            valColumn = $"{val.ColumnName} = {valColumn}";

                                                            SetColumns = Utils.ConcatenateString(SetColumns, valColumn);

                                                        }
                                                    }

                                                    ExecuteTran = _Repository_SQLC.UpdateData(tabla, SetColumns, Condicion);
                                                    break;
                                                }
                                        }
                                        if (ExecuteTran)
                                        {
                                            //Una vez Insertada la Data del Registro se Elimina Registro Migrado
                                            var delMigrado = _Repository_SQLC.DeleteDataMigrated(idMigrado);

                                            //Se cambia de estado a Migrado el Registro de Migración
                                            var Migrado = _Repository_ODBC.UpdateStateMigrated(registro.id);
                                        }
                                        else
                                        {
                                            var tipoRegistro = registro.tipo == "I" ? "Insertar" : (registro.tipo == "U" ? "Actualizar" : "Eliminar");
                                            var Erroneo = _Repository_ODBC.UpdateStateErroneo(registro.id, $"Error al Intentar {tipoRegistro} la tabla {tabla}");
                                        }
                                    }
                                    else
                                    {
                                        var Omitido = _Repository_ODBC.UpdateStateOmited(registro.id, "Tabla sin estructura para Migración");
                                    }
                                }
                                else
                                {
                                    var Omitido = _Repository_ODBC.UpdateStateOmited(registro.id, "Tabla sin estructura para Migración");
                                }
                            }
                        }
                    }
                }
            }
            catch (OdbcException ex)
            {
                Logger.Log("OdbcException in: RegistroMigracionService.EjecutarMigracion_ODBC_To_SQLC()");
                Logger.Log(ex.ToString());;
            }
            catch (SqlException ex)
            {
                Logger.Log("SqlException in: RegistroMigracionService.EjecutarMigracion_ODBC_To_SQLC()");
                Logger.Log(ex.ToString());;
            }
            catch (Exception ex)
            {
                Logger.Log("Exception in: RegistroMigracionService.EjecutarMigracion_ODBC_To_SQLC()");
                Logger.Log(ex.ToString());;
            }

            return "";

        }

        public string EjecutarMigracion_SQLC_To_ODBC()
        {
            try
            {
                Logger.Log("Ejecutando Metodo: EjecutarMigracion_SQLC_To_ODBC");
                //Obtener Tablas a Migrar
                var Tablas = _Repository_SQLC.GetTables();

                if (Tablas != null)
                {
                    var tabTotal = Tablas.Count;
                    var tabCurrent = 1;
                    foreach (var tabla in Tablas)
                    {
                        Console.WriteLine("");
                        Console.WriteLine($"Tabla: {tabla} - {tabCurrent} de {tabTotal}");
                        tabCurrent++;
                        //Obtener Columnas de tabla a Migrar
                        var Columnas = _Repository_SQLC.GetColumnTables(tabla);
                        var ColumnasSQL = string.Empty;
                        foreach (var column in Columnas)
                        {
                            ColumnasSQL = Utils.ConcatenateString(ColumnasSQL, column.ColumnName);
                        }

                        //Obtener Registros de Tabla a Migrar
                        var Registros = _Repository_SQLC.GetPendings(tabla);
                        if (Registros != null && !string.IsNullOrEmpty(ColumnasSQL))
                        {
                            var Total = Registros.Count;
                            var Current = 1;
                            foreach (var registro in Registros)
                            {
                                Console.WriteLine($"Registro {Current} de {Total}");
                                Current++;

                                Logger.Log($"Registro: {JsonConvert.SerializeObject(registro)}");
                                var keys = registro.observacion.Split(',');
                                var Condicion = string.Empty;
                                int indice = 1;
                                if (!string.IsNullOrEmpty(registro.observacion))
                                {
                                    foreach (var key in keys)
                                    {
                                        var typeKey = Columnas.Where(x => x.ColumnName.Trim().ToLower().Equals(key.Trim().ToLower())).FirstOrDefault().ColumnType;
                                        var valueFormat = Constantes.ColumnasToMap.Where(x => x.ColumnType.ToLower().Trim().Equals(typeKey.ToLower().Trim())).FirstOrDefault().ColumnValue;

                                        var dataValue = string.Empty;
                                        switch (indice)
                                        {
                                            case 1:
                                                {
                                                    dataValue = registro.codigo.Trim();
                                                    break;
                                                }
                                            case 2:
                                                {
                                                    dataValue = registro.codigo2.Trim();
                                                    break;
                                                }
                                            case 3:
                                                {
                                                    dataValue = registro.codigo3.Trim();
                                                    break;
                                                }
                                            case 4:
                                                {
                                                    dataValue = registro.codigo4.Trim();
                                                    break;
                                                }
                                            case 5:
                                                {
                                                    dataValue = registro.codigo5.Trim();
                                                    break;
                                                }
                                            case 6:
                                                {
                                                    dataValue = registro.codigo6.Trim();
                                                    break;
                                                }

                                        }

                                        indice++;

                                        if (string.IsNullOrEmpty(dataValue))
                                        {
                                            dataValue = "NULL";
                                        }

                                        var newValue = Utils.Replace_Value(key, valueFormat, dataValue);

                                        Condicion = Utils.Concatenate_WHERE(Condicion, newValue);
                                    }
                                    var Values = _Repository_SQLC.GetColumnValues(tabla, Columnas, Condicion);

                                    if (Values.Count > 0)
                                    {
                                        //Insertar Registro para validar que no se cree en tabla de Migracion
                                        int idMigrado = _Repository_ODBC.InsertDataMigrated(new insert_temp_registroMigrado
                                        {
                                            nombre_table = registro.nombre_table,
                                            tipo = registro.tipo,
                                            codigo = registro.codigo,
                                            codigo2 = registro.codigo2,
                                            codigo3 = registro.codigo3,
                                            codigo4 = registro.codigo4,
                                            codigo5 = registro.codigo5,
                                            codigo6 = registro.codigo6,
                                            observacion = registro.observacion,
                                            status = registro.status,
                                            fechaRegistro = registro.fechaRegistro
                                        });

                                        var ExecuteTran = false;
                                        switch (registro.tipo)
                                        {
                                            case "I": //Insertar
                                                {
                                                    var ExisteRegistro = _Repository_ODBC.ValidateDataBeforeInsert(tabla, Condicion);
                                                    if (!ExisteRegistro)
                                                    {
                                                        var IntoColumns = string.Empty;
                                                        var IntoValues = string.Empty;
                                                        foreach (var val in Values)
                                                        {
                                                            var vFormat = Constantes.ColumnasToMap.Where(x => x.ColumnType.ToLower().Trim().Equals(val.ColumnType.ToLower().Trim())).FirstOrDefault().ColumnValue;
                                                            var valColumn = val.ColumnValue.ToString();

                                                            if ((string.IsNullOrEmpty(valColumn) && !val.ColumnType.ToLower().Trim().Contains("char")) || valColumn.ToUpper().Trim().Equals("NULL"))
                                                            {
                                                                valColumn = "NULL";
                                                            }
                                                            else
                                                            {
                                                                valColumn = $"{vFormat.Replace("{value}", valColumn)}";
                                                            }

                                                            IntoColumns = Utils.ConcatenateString(IntoColumns, val.ColumnName);
                                                            IntoValues = Utils.ConcatenateString(IntoValues, valColumn);
                                                        }

                                                        ExecuteTran = _Repository_ODBC.InsertData(tabla, IntoColumns, IntoValues);
                                                    }
                                                    break;
                                                }
                                            case "U": //Actualizar
                                                {
                                                    var SetColumns = string.Empty;
                                                    foreach (var val in Values)
                                                    {
                                                        var contains = keys.Select(x => x.ToLower().Trim()).Contains(val.ColumnName.ToLower().Trim());
                                                        if (!contains)
                                                        {
                                                            var vFormat = Constantes.ColumnasToMap.Where(x => x.ColumnType.ToLower().Trim().Equals(val.ColumnType.ToLower().Trim())).FirstOrDefault().ColumnValue;

                                                            var valColumn = val.ColumnValue.ToString();

                                                            if ((string.IsNullOrEmpty(valColumn) && !val.ColumnType.ToLower().Trim().Contains("char")) || valColumn.ToUpper().Trim().Equals("NULL"))
                                                            {
                                                                valColumn = "NULL";
                                                            }
                                                            else
                                                            {
                                                                valColumn = $"{vFormat.Replace("{value}", valColumn)}";
                                                            }

                                                            valColumn = $"{val.ColumnName} = {valColumn}";

                                                            SetColumns = Utils.ConcatenateString(SetColumns, valColumn);

                                                        }
                                                    }

                                                    ExecuteTran = _Repository_ODBC.UpdateData(tabla, SetColumns, Condicion);
                                                    break;
                                                }
                                        }
                                        if (ExecuteTran)
                                        {
                                            //Una vez Insertada la Data del Registro se Elimina Registro Migrado
                                            var delMigrado = _Repository_ODBC.DeleteDataMigrated(idMigrado);

                                            //Se cambia de estado a Migrado el Registro de Migración
                                            var Migrado = _Repository_SQLC.UpdateStateMigrated(registro.id);
                                        }
                                        else
                                        {
                                            var tipoRegistro = registro.tipo == "I" ? "Insertar" : (registro.tipo == "U" ? "Actualizar" : "Eliminar");
                                            var Erroneo = _Repository_SQLC.UpdateStateErroneo(registro.id, $"Error al Intentar {tipoRegistro} la tabla {tabla}");
                                        }
                                    }
                                    else
                                    {
                                        var Omitido = _Repository_SQLC.UpdateStateOmited(registro.id, "Tabla sin estructura para Migración");
                                    }
                                }
                                else
                                {
                                    var Omitido = _Repository_SQLC.UpdateStateOmited(registro.id, "Tabla sin estructura para Migración");
                                }
                            }
                        }
                    }
                }
            }
            catch (OdbcException ex)
            {
                Logger.Log("OdbcException in: RegistroMigracionService.EjecutarMigracion_SQLC_To_ODBC()");
                Logger.Log(ex.ToString()); ;
            }
            catch (SqlException ex)
            {
                Logger.Log("SqlException in: RegistroMigracionService.EjecutarMigracion_SQLC_To_ODBC()");
                Logger.Log(ex.ToString()); ;
            }
            catch (Exception ex)
            {
                Logger.Log("Exception in: RegistroMigracionService.EjecutarMigracion_SQLC_To_ODBC()");
                Logger.Log(ex.ToString()); ;
            }

            return "";

        }

    }
}
