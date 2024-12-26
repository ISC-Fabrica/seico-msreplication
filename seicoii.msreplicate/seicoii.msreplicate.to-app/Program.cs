using System;
using System.Configuration;
using seicoii.msreplicate.library.Common;
using seicoii.msreplicate.library.Data.Service;

int MiliSecondsInterval = Convert.ToInt32(ConfigurationManager.AppSettings["MiliSecondsInterval"].ToString());

Logger.Log("Iniciando Ejecucion");

Console.WriteLine("Iniciando Ejecucion...");

while (true)
{
    Console.WriteLine("SEICOII-WEB to SEICOII-APP");

    Console.WriteLine("Ejecutando EjecutarMigracion_SQLC_To_ODBC()...");

    using (var registroMigracionService = new RegistroMigracionService())
    {
        registroMigracionService.EjecutarMigracion_SQLC_To_ODBC();
    }

    Console.WriteLine("");
    Console.WriteLine("Ending timer: {0}\n",
                        DateTime.Now.ToString("h:mm:ss"));

    Logger.Log("Finalizando Ejecucion");

    Console.WriteLine("Finalizando Ejecucion!");

    Thread.Sleep(MiliSecondsInterval);

}
