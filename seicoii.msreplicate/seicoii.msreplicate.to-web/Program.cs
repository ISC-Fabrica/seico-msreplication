using System;
using System.Configuration;
using seicoii.msreplicate.library.Common;
using seicoii.msreplicate.library.Data.Service;

int MiliSecondsInterval = Convert.ToInt32(ConfigurationManager.AppSettings["MiliSecondsInterval"].ToString());

Logger.Log("Iniciando Ejecucion");

Console.WriteLine("Iniciando Ejecucion...");

while (true)
{
    Console.WriteLine("SEICOII-APP to SEICOII-WEB");

    Console.WriteLine("Ejecutando EjecutarMigracion_ODBC_To_SQLC()...");

    using (var registroMigracionService = new RegistroMigracionService())
    {
        registroMigracionService.EjecutarMigracion_ODBC_To_SQLC();
    }

    Console.WriteLine("");
    Console.WriteLine("Ending timer: {0}\n",
                        DateTime.Now.ToString("h:mm:ss"));

    Logger.Log("Finalizando Ejecucion");

    Console.WriteLine("Finalizando Ejecucion!");

    Thread.Sleep(MiliSecondsInterval);

}
