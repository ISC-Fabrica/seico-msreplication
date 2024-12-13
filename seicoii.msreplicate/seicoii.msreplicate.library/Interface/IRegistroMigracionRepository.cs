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
        #region Begin For Constraints

        void NoCheckConstraint(string table);
        void CheckConstraint(string table);

        #endregion End For Constraints

        #region Begin For Triggers

        void DisableTriggers(string table);
        void EnableTriggers(string table);

        #endregion End For Triggers

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
        (bool, string) InsertData(string Table, string IntoColumns, string Values);
        (bool, string) UpdateData(string Table, string SetColumns, string Condition);
        (bool, string) DeleteData(string Table, string Condition);

        #endregion End For Insert/Update
    }
}
