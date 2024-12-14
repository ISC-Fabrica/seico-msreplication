﻿using seicoii.msreplicate.library.Data.Entities;
using seicoii.msreplicate.library.Interface;
using System.Configuration;
using System;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.Common;
using System.Reflection.PortableExecutable;

using seicoii.msreplicate.library.Common;

namespace seicoii.msreplicate.library.Data.Repository
{
    public class ODBCRegistroMigracionRepository : IRegistroMigracionRepository
    {

        string connectionString = ConfigurationManager.ConnectionStrings["SEICOII_APP"].ConnectionString;
        string filtroTablas = ConfigurationManager.AppSettings["FiltroTablas"] ?? string.Empty;

        public ODBCRegistroMigracionRepository() { }

        #region Begin For Constraint

        public void NoCheckConstraint(string table)
        {
            string sentenciaSQL = Constantes.NoCheckConstraint.Replace("{nombre_table}", table);
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.NoCheckConstraint()");
                    OdbcCommand command = new(sentenciaSQL, connection);
                    connection.Open();
                    var re = command.ExecuteNonQuery();

                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.NoCheckConstraint()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.NoCheckConstraint()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
            }
        }

        public void CheckConstraint(string table)
        {
            string sentenciaSQL = Constantes.CheckConstraint.Replace("{nombre_table}", table);
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.CheckConstraint()");
                    OdbcCommand command = new(sentenciaSQL, connection);
                    connection.Open();
                    var re = command.ExecuteNonQuery();

                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.CheckConstraint()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.CheckConstraint()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
            }
        }

        #endregion End For Constraints


        #region Begin For Triggers

        public void DisableTriggers(string table)
        {
            string sentenciaSQL = Constantes.DisableTriggers.Replace("{nombre_table}", table);
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.DisableTriggers()");
                    OdbcCommand command = new(sentenciaSQL, connection);
                    connection.Open();
                    var re = command.ExecuteNonQuery();

                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.DisableTriggers()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.DisableTriggers()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
            }
        }

        public void EnableTriggers(string table)
        {
            string sentenciaSQL = Constantes.EnableTriggers.Replace("{nombre_table}", table);
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.EnableTriggers()");
                    OdbcCommand command = new(sentenciaSQL, connection);
                    connection.Open();
                    var re = command.ExecuteNonQuery();

                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.EnableTriggers()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.EnableTriggers()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
            }
        }

        #endregion End For Triggers


        #region Begin For Select ODBC
        public List<string> GetTables()
        {
            List<string> response = new List<string>();
            string andTables = string.IsNullOrEmpty(filtroTablas) ? "" : $" AND nombre_table IN ({filtroTablas}) ";
            string sentenciaSQL = Constantes.Select_TablasPendientes.Replace("{condicion_adicional}", andTables);
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.GetTables()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    OdbcDataAdapter adapter = new OdbcDataAdapter(sentenciaSQL, connection);
                    connection.Open();
                    DataSet dataSet = new DataSet();
                    adapter.Fill(dataSet);
                    if (dataSet.Tables.Count > 0)
                    {
                        response = dataSet.Tables[0].AsEnumerable().Select(x => x["nombre_table"].ToString() ).ToList<string>();
                    }
                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.GetTables()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.GetTables()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                return response;
            }
        }

        public List<ColumnTable> GetColumnTables(string table)
        {
            List<ColumnTable> response = new List<ColumnTable>();
            string sentenciaSQL = Constantes.Select_ColumnasTabla.Replace("{nombre_table}", table);
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.GetColumnTables()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    OdbcDataAdapter adapter = new OdbcDataAdapter(sentenciaSQL, connection);
                    connection.Open();
                    DataSet dataSet = new DataSet();
                    adapter.Fill(dataSet);
                    if (dataSet.Tables.Count > 0)
                    {
                        response = dataSet.Tables[0].AsEnumerable()
                            .Where(y=> (
                                    !y["name"].ToString().Trim().ToLower().Equals("factura_id") &&
                                    !y["name"].ToString().Trim().ToLower().Equals("pk_id")
                                    ))
                            .Select(x => new ColumnTable
                            {
                                ColumnName = x["name"].ToString()!,
                                ColumnType = x["type"].ToString()!,
                                IsNullable = x["isnullable"].ToString()!.Trim().Equals("1"),
                            }
                        ).ToList();
                    }
                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.GetColumnTables()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.GetColumnTables()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                return response;
            }
        }

        public List<ColumnValues> GetColumnValues(string Table, List<ColumnTable> columns, string Condition)
        {
            List<ColumnValues> response = new List<ColumnValues>();

            var ColumnasSQL = string.Empty;
            foreach (var column in columns)
            {
                var columna = column.ColumnName;
                if (column.ColumnType.Trim().ToLower().Equals("datetime"))
                {
                    columna = $"convert(varchar, {columna}, 121) as {columna}";
                }

                ColumnasSQL = Utils.ConcatenateString(ColumnasSQL, columna);
            }

            string sentenciaSQL = Constantes.Select_TableInfo
                                    .Replace("{Columns}", ColumnasSQL)
                                    .Replace("{nombre_table}", Table)
                                    .Replace("{Condition}", Condition);

            Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.GetColumnValues()");
            Logger.Log($"Sentencia SQL: {sentenciaSQL}");

            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    OdbcDataAdapter adapter = new OdbcDataAdapter(sentenciaSQL, connection);
                    connection.Open();
                    DataSet dataSet = new DataSet();
                    adapter.Fill(dataSet);
                    if (dataSet.Tables.Count > 0)
                    {
                        var dataRow = dataSet.Tables[0].AsEnumerable().FirstOrDefault();
                        if (dataRow != null)
                        {
                            foreach (var column in columns)
                            {
                                var ColumnValue = dataRow[column.ColumnName].ToString();
                                if (string.IsNullOrEmpty(ColumnValue) && column.IsNullable)
                                {
                                    ColumnValue = "NULL";
                                }
                                response.Add(new ColumnValues
                                {
                                    ColumnName = column.ColumnName,
                                    ColumnType = column.ColumnType,
                                    ColumnValue = ColumnValue ?? ""
                                });
                            }
                        }
                    }
                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.GetColumnValues()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.GetColumnValues()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                return response;
            }
        }

        public List<temp_registroMigracion> GetPendings(string table)
        {
            List<temp_registroMigracion> response = new List<temp_registroMigracion>();
            string sentenciaSQL = Constantes.Select_RegistroMigracionPendientes.Replace("{nombre_table}", table);
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.GetPendings()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    OdbcDataAdapter adapter = new OdbcDataAdapter(sentenciaSQL, connection);
                    connection.Open();
                    DataSet dataSet = new DataSet();
                    adapter.Fill(dataSet);
                    if (dataSet.Tables.Count > 0)
                    {
                        response = dataSet.Tables[0].AsEnumerable().Select(x => new temp_registroMigracion
                        {
                            id = Convert.ToInt32(x["id"].ToString()),
                            nombre_table = x["nombre_table"].ToString()!,
                            tipo = x["tipo"].ToString()!,
                            codigo = x["codigo"].ToString()!,
                            codigo2 = x["codigo2"].ToString()!,
                            codigo3 = x["codigo3"].ToString()!,
                            codigo4 = x["codigo4"].ToString()!,
                            codigo5 = x["codigo5"].ToString()!,
                            codigo6 = x["codigo6"].ToString()!,
                            observacion = x["observacion"].ToString()!,
                            status = Convert.ToInt32(x["status"].ToString()),
                            fechaRegistro = Convert.ToDateTime(x["fechaRegistro"].ToString()),
                        }).ToList();
                    }
                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.GetPendings()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.GetPendings()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                return response;
            }
        }

        public bool UpdateStateMigrated(int id)
        {

            bool response = false;
            string sentenciaSQL = Constantes.Update_EstadoTablasPendientes.Replace("{id}", id.ToString());
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.UpdateStateMigrated()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    OdbcCommand command = new(sentenciaSQL, connection);
                    connection.Open();
                    var re = command.ExecuteNonQuery();

                    response = re > 0;
                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.UpdateStateMigrated()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.UpdateStateMigrated()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                return response;
            }
        }

        public bool UpdateStateOmited(int id, string message = "")
        {

            if (string.IsNullOrEmpty(message))
            {
                message = "";
            }
            else if (message.Length > 500)
            {
                message = message.Substring(0, 500);
            }

            bool response = false;
            string sentenciaSQL = Constantes.Update_EstadoOmitido.Replace("{id}", id.ToString()).Replace("{detalleError}", message);
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.UpdateStateOmited()");
                    OdbcCommand command = new(sentenciaSQL, connection);
                    connection.Open();
                    var re = command.ExecuteNonQuery();

                    response = re > 0;
                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.UpdateStateOmited()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.UpdateStateOmited()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                return response;
            }
        }

        public bool UpdateStateErroneo(int id, string error = "")
        {

            if (string.IsNullOrEmpty(error))
            {
                error = "";
            }
            else if (error.Length > 500)
            {
                error = error.Substring(0, 500);
            }

            bool response = false;
            string sentenciaSQL = Constantes.Update_EstadoErroneo.Replace("{id}", id.ToString()).Replace("{detalleError}", error);
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.UpdateStateErroneo()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    OdbcCommand command = new(sentenciaSQL, connection);
                    connection.Open();
                    var re = command.ExecuteNonQuery();

                    response = re > 0;
                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.UpdateStateErroneo()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.UpdateStateErroneo()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                return response;
            }
        }

        #endregion End For Select ODBC


        #region Begin For Insert/Update ODBC

        public int InsertDataMigrated(insert_temp_registroMigrado data)
        {
            int response = 0;
            string sentenciaSQL = Constantes.InsertInto_RegistroMigrado
                                            .Replace("{nombre_table}", Utils.Replace_ValueInsert("'{value}'", data.nombre_table.ToString()))
                                            .Replace("{tipo}", Utils.Replace_ValueInsert("'{value}'", data.tipo.ToString()))
                                            .Replace("{codigo}", Utils.Replace_ValueInsert("'{value}'", data.codigo.ToString()))
                                            .Replace("{codigo2}", Utils.Replace_ValueInsert("'{value}'", data.codigo2.ToString()))
                                            .Replace("{codigo3}", Utils.Replace_ValueInsert("'{value}'", data.codigo3.ToString()))
                                            .Replace("{codigo4}", Utils.Replace_ValueInsert("'{value}'", data.codigo4.ToString()))
                                            .Replace("{codigo5}", Utils.Replace_ValueInsert("'{value}'", data.codigo5.ToString()))
                                            .Replace("{codigo6}", Utils.Replace_ValueInsert("'{value}'", data.codigo6.ToString()))
                                            .Replace("{observacion}", Utils.Replace_ValueInsert("'{value}'", data.observacion.ToString()))
                                            .Replace("{status}", Utils.Replace_ValueInsert("{value}", data.status.ToString()))
                                            .Replace("{fechaRegistro}", Utils.Replace_ValueInsert("'{value}'", data.fechaRegistro.ToString("yyyy-MM-dd HH:mm:ss")));
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.InsertDataMigrated()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    OdbcCommand command = new(sentenciaSQL, connection);
                    connection.Open();
                    var reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        response = Convert.ToInt32(reader[0].ToString());
                    }
                    reader.Close();
                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.InsertDataMigrated()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.InsertDataMigrated()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                return response;
            }

        }

        public bool DeleteDataMigrated(int id)
        {

            bool response = false;
            string sentenciaSQL = Constantes.Delete_RegistroMigrado.Replace("{id}", id.ToString());
            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.DeleteDataMigrated()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    OdbcCommand command = new(sentenciaSQL, connection);
                    connection.Open();
                    var re = command.ExecuteNonQuery();

                    response = re > 0;
                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.DeleteDataMigrated()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.DeleteDataMigrated()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                }
                return response;
            }
        }

        public bool ValidateDataBeforeInsert(string Table, string Condition)
        {
            bool response = false;
            string sentenciaSQL = Constantes.Select_ExistRecordTable
                                            .Replace("{nombre_tabla}", Table)
                                            .Replace("{condiciones}", Condition);

            Logger.Log("ODBCRegistroMigracionRepository.ValidateDataBeforeInsert() - BEGIN");

            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.ValidateDataBeforeInsert()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    OdbcDataAdapter adapter = new OdbcDataAdapter(sentenciaSQL, connection);
                    connection.Open();
                    DataSet dataSet = new DataSet();
                    adapter.Fill(dataSet);
                    if (dataSet.Tables.Count > 0)
                    {
                        response = dataSet.Tables[0].Rows.Count > 0;
                    }
                    Logger.Log($"REGISTRO EXISTENTE = {(response ? "SI" : "NO")}");
                    Logger.Log("ODBCRegistroMigracionRepository.ValidateDataBeforeInsert() - END");
                }
                catch (OdbcException ex)
                {
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.ValidateDataBeforeInsert()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                    Logger.Log("ODBCRegistroMigracionRepository.ValidateDataBeforeInsert() - END");
                }
                catch (Exception ex)
                {
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.ValidateDataBeforeInsert()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                    Logger.Log("ODBCRegistroMigracionRepository.ValidateDataBeforeInsert() - END");
                }
                return response;
            }
        }

        public (bool, string) InsertData(string Table, string IntoColumns, string Values)
        {
            string Mensaje = "Registro Insertado con éxito";
            bool response = false;
            string sentenciaSQL = Constantes.InsertInto_Tables
                                        .Replace("{nombre_tabla}", Table)
                                        .Replace("{columnas}", IntoColumns)
                                        .Replace("{valores}", Values);

            Logger.Log("ODBCRegistroMigracionRepository.InsertData() - BEGIN");
            Logger.Log($"Sentencia SQL: {sentenciaSQL}");
            Logger.Log($"");

            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.InsertData()");
                    OdbcDataAdapter adapter = new OdbcDataAdapter(sentenciaSQL, connection);
                    //Logger.Log(adapter.SelectCommand!.CommandText);
                    connection.Open();
                    DataSet dataSet = new DataSet();
                    adapter.Fill(dataSet);
                    var totalRegistros = "0";
                    if (dataSet.Tables.Count > 0)
                    {
                        var resp = dataSet.Tables[0].Rows[0];
                        totalRegistros = resp[0].ToString();
                        response = Convert.ToInt32(resp[0].ToString()) > 0;
                    }
                    Logger.Log($"REGISTROS INSERTADOS = {totalRegistros}");
                    Logger.Log("ODBCRegistroMigracionRepository.InsertData() - END");
                }
                catch (OdbcException ex)
                {
                    Mensaje = $"OdbcException: {ex.Message}";
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.InsertData()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log($"");
                    Logger.Log(ex.ToString());
                    Logger.Log("ODBCRegistroMigracionRepository.InsertData() - END");
                }
                catch (Exception ex)
                {
                    Mensaje = $"Exception: {ex.Message}";
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.InsertData()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                    Logger.Log($"");
                    Logger.Log("ODBCRegistroMigracionRepository.InsertData() - END");
                }
                return (response, Mensaje);
            }
        }

        public (bool, string) UpdateData(string Table, string SetColumns, string Condition)
        {
            string Mensaje = "Registro Actualizado con éxito";
            bool response = false;
            string sentenciaSQL = Constantes.Update_Tables
                                        .Replace("{nombre_tabla}", Table)
                                        .Replace("{valores}", SetColumns)
                                        .Replace("{condiciones}", Condition);

            Logger.Log("ODBCRegistroMigracionRepository.UpdateData() - BEGIN");
            Logger.Log($"Sentencia SQL: {sentenciaSQL}");
            Logger.Log($"");

            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.UpdateData()");
                    OdbcDataAdapter adapter = new OdbcDataAdapter(sentenciaSQL, connection);
                    //Logger.Log(adapter.SelectCommand!.CommandText);
                    connection.Open();
                    DataSet dataSet = new DataSet();
                    adapter.Fill(dataSet);
                    var totalRegistros = "0";
                    if (dataSet.Tables.Count > 0)
                    {
                        var resp = dataSet.Tables[0].Rows[0];
                        totalRegistros = resp[0].ToString();
                        response = Convert.ToInt32(resp[0].ToString()) > 0;
                    }
                    if (Convert.ToInt32(totalRegistros) == 0)
                    {
                        Mensaje = $"Registro no fue ACTUALIZADO, no concide con la condición: [{Condition.Replace("'", "\"")}]";
                    }
                    Logger.Log($"REGISTROS ACTUALIZADOS = {totalRegistros}");
                    Logger.Log("ODBCRegistroMigracionRepository.UpdateData() - END");
                }
                catch (OdbcException ex)
                {
                    Mensaje = $"OdbcException: {ex.Message}";
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.UpdateData()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                    Logger.Log("ODBCRegistroMigracionRepository.UpdateData() - END");
                }
                catch (Exception ex)
                {
                    Mensaje = $"Exception: {ex.Message}";
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.UpdateData()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                    Logger.Log("ODBCRegistroMigracionRepository.UpdateData() - END");
                }
                return (response, Mensaje);
            }
        }

        public (bool, string) DeleteData(string Table, string Condition)
        {
            string Mensaje = "Registro Eliminado con éxito";
            bool response = false;
            string sentenciaSQL = Constantes.Delete_Tables
                                            .Replace("{nombre_tabla}", Table)
                                            .Replace("{condiciones}", Condition);

            Logger.Log("ODBCRegistroMigracionRepository.DeleteData() - BEGIN");
            Logger.Log($"Sentencia SQL: {sentenciaSQL}");
            Logger.Log($"");

            using (OdbcConnection connection = new(connectionString))
            {
                try
                {
                    Logger.Log("Ejecutando Metodo: ODBCRegistroMigracionRepository.DeleteData()");
                    OdbcDataAdapter adapter = new OdbcDataAdapter(sentenciaSQL, connection);
                    //Logger.Log(adapter.SelectCommand!.CommandText);
                    connection.Open();
                    DataSet dataSet = new DataSet();
                    adapter.Fill(dataSet);
                    var totalRegistros = "0";
                    if (dataSet.Tables.Count > 0)
                    {
                        var resp = dataSet.Tables[0].Rows[0];
                        totalRegistros = resp[0].ToString();
                        response = Convert.ToInt32(resp[0].ToString()) > 0;
                    }
                    if (Convert.ToInt32(totalRegistros) == 0)
                    {
                        Mensaje = $"Registro no fue ELIMINADO, no concide con la condición: [{Condition.Replace("'","\"")}]";
                    }
                    Logger.Log($"REGISTROS ELIMINADOS = {totalRegistros}");
                    Logger.Log("ODBCRegistroMigracionRepository.DeleteData() - END");
                }
                catch (OdbcException ex)
                {
                    Mensaje = $"OdbcException: {ex.Message}";
                    Logger.Log("OdbcException in: ODBCRegistroMigracionRepository.DeleteData()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                    Logger.Log("ODBCRegistroMigracionRepository.DeleteData() - END");
                }
                catch (Exception ex)
                {
                    Mensaje = $"Exception: {ex.Message}";
                    Logger.Log("Exception in: ODBCRegistroMigracionRepository.DeleteData()");
                    Logger.Log($"Sentencia SQL: {sentenciaSQL}");
                    Logger.Log(ex.ToString());
                    Logger.Log("ODBCRegistroMigracionRepository.DeleteData() - END");
                }
                return (response, Mensaje);
            }
        }


        #endregion End For Insert/Update ODBC
    }
}