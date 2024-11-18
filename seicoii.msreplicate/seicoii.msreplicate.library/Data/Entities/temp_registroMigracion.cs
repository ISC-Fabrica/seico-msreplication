using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace seicoii.msreplicate.library.Data.Entities
{
    public class temp_registroMigracion
    {
        public int id { get; set; }
        public string nombre_table { get; set; }
        public string tipo { get; set; }
        public string codigo { get; set; }
        public string codigo2 { get; set; }
        public string codigo3 { get; set; }
        public string codigo4 { get; set; }
        public string codigo5 { get; set; }
        public string codigo6 { get; set; }
        public string observacion { get; set; }
        public int status { get; set; }
        public DateTime fechaRegistro { get; set; }
    }

    public class insert_temp_registroMigrado
    {
        public string nombre_table { get; set; }
        public string tipo { get; set; }
        public string codigo { get; set; }
        public string codigo2 { get; set; }
        public string codigo3 { get; set; }
        public string codigo4 { get; set; }
        public string codigo5 { get; set; }
        public string codigo6 { get; set; }
        public string observacion { get; set; }
        public int status { get; set; }
        public DateTime fechaRegistro { get; set; }
    }
}
