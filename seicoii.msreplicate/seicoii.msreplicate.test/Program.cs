
using seicoii.msreplicate.library.Common;
using seicoii.msreplicate.library.Data.Service;

var registroMigracionService = new RegistroMigracionService();

Logger.Log("Iniciando Ejecucion");

Console.WriteLine("Iniciando Ejecucion...");

Console.WriteLine("Ejecutando EjecutarMigracion_ODBC_To_SQLC()...");


registroMigracionService.EjecutarMigracion_ODBC_To_SQLC();


Logger.Log("Finalizando Ejecucion");

Console.WriteLine("Finalizando Ejecucion!");

Console.ReadKey();

