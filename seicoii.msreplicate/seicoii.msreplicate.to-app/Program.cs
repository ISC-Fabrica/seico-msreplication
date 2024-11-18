using System;
using System.Configuration;
using Microsoft.Extensions.Hosting;
using seicoii.msreplicate.library.Common;
using seicoii.msreplicate.library.Data.Service;
using Timer = System.Threading.Timer;

class Program
{
    static public void Tick(Object stateInfo)
    {

        Console.WriteLine("SEICOII-WEB to SEICOII-APP");

        Console.WriteLine("Ejecutando EjecutarMigracion_SQLC_To_ODBC()...");

        var registroMigracionService = new RegistroMigracionService();
        registroMigracionService.EjecutarMigracion_SQLC_To_ODBC();

        Console.WriteLine("");
        Console.WriteLine("Ending timer: {0}\n",
                           DateTime.Now.ToString("h:mm:ss"));

        Logger.Log("Finalizando Ejecucion");

        Console.WriteLine("Finalizando Ejecucion!");

    }

    static void Main()
    {
        Logger.Log("Iniciando Ejecucion");

        Console.WriteLine("Iniciando Ejecucion...");

        var MiliSecondsInterval = Convert.ToInt32(ConfigurationManager.AppSettings["MiliSecondsInterval"].ToString());

        TimerCallback callback = new TimerCallback(Tick);

        Console.WriteLine("Creating timer: {0}\n",
                           DateTime.Now.ToString("h:mm:ss"));

        // create a one second timer tick
        Timer stateTimer = new Timer(callback, null, 0, MiliSecondsInterval);

        // loop here forever
        while (true) // repeat forever
        {
            // add a sleep for 100 mSec to reduce CPU usage
            Thread.Sleep(100);

        }
    }
}


