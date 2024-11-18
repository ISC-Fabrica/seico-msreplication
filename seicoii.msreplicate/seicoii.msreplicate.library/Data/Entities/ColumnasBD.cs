using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace seicoii.msreplicate.library.Data.Entities
{
    public class ColumnasBD
    {
        public string ColumnType { get; set; }
        public string ColumnValue { get; set; }
    }

    public class ColumnTable
    {
        public string ColumnName { get; set; }
        public string ColumnType { get; set; }
        public bool IsNullable { get; set; }
    }

    public class ColumnValues
    {
        public string ColumnName { get; set; }
        public string ColumnType { get; set; }
        public object ColumnValue { get; set; }
    }

}
