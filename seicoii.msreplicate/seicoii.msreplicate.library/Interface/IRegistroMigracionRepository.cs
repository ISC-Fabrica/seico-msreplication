using seicoii.msreplicate.library.Data.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace seicoii.msreplicate.library.Interface
{
    public interface IRegistroMigracionRepository
    {
        #region Begin For Select

        List<string> GetTables();
        List<ColumnTable> GetColumnTables(string table);
        List<ColumnValues> GetColumnValues(string Table, List<ColumnTable> columns, string Condition);
        List<temp_registroMigracion> GetPendings(string table);
        bool UpdateStateMigrated(int id);
        bool UpdateStateOmited(int id, string message = "");
        bool UpdateStateErroneo(int id, string error = "");

        #endregion End For Select

        #region Begin For Insert/Update

        int InsertDataMigrated(insert_temp_registroMigrado data);
        bool DeleteDataMigrated(int id);
        bool ValidateDataBeforeInsert(string Table, string Condition);
        bool InsertData(string Table, string IntoColumns, string Values);
        bool UpdateData(string Table, string SetColumns, string Condition);

        #endregion End For Insert/Update
    }
}
