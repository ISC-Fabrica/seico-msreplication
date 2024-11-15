using System;
using System.IO;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using System.Runtime.CompilerServices;

namespace seicoii.msreplicate.library.Common
{

    public static class Logger 
    {
        private static string filePath = GetLogFileName;
        private static int idLog = 1;
        public static object _locked = new object();

        public static void LogHeader(string message)
        {
            lock (_locked)
            {
                using (StreamWriter streamWriter = File.AppendText(filePath))
                {
                    DateTime ahora = DateTime.Now;
                    streamWriter.WriteLine($"{ahora.ToString("dd/MM/yyyy HH:mm:ss")} - Begin");
                    streamWriter.WriteLine(message);
                    streamWriter.WriteLine($"{ahora.ToString("dd/MM/yyyy HH:mm:ss")} - End");
                    streamWriter.WriteLine("");
                    streamWriter.Close();
                }
            }
        }

        public static void Log(string message)
        {
            lock (_locked)
            {
                if (File.Exists(filePath))
                {
                    long length = new System.IO.FileInfo(filePath).Length;

                    if (length > (2147483648)) //12 GB
                    {
                        idLog++;
                        filePath = GetLogFileName;
                    }
                }

                using (StreamWriter streamWriter = File.AppendText(filePath))
                {
                    streamWriter.WriteLine($"{DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")} - {message}");
                    streamWriter.Close();
                }
            }

        }

        private static string GetLogFileName
        {
            get
            {
                string PathLog = ConfigurationManager.AppSettings["PathLog"];
                string FileNameLog = ConfigurationManager.AppSettings["FileNameLog"];
                string IdentiLog = idLog.ToString("000");

                if (string.IsNullOrEmpty(PathLog))
                {
                    PathLog = Path.Combine(Assembly.GetExecutingAssembly().Location, "Log");
                }

                if (!Directory.Exists(PathLog))
                {
                    Directory.CreateDirectory(PathLog);
                }

                if (string.IsNullOrEmpty(FileNameLog))
                {
                    FileNameLog = "ReplicationLog_{currentdate}.log";
                }

                FileNameLog = FileNameLog.Replace("{currentdate}", DateTime.Now.ToString("yyyy-MM-dd HH-mm-ss"));

                FileNameLog = FileNameLog.Replace(".log", $"_{IdentiLog}.log");

                return Path.Combine(PathLog, FileNameLog);
            }
        }
    }
}
