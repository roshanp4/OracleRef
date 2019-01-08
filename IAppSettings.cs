using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace LDSFileService.ServiceClassLibrary
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IAppSettings" in both code and config file together.
    [ServiceContract]
    public interface IAppSettings
    {
        [OperationContract]
        int GetSessionId();
        [OperationContract]
        IList<AppSettingsData> GetRelatedDataCount(IList<AppSettingsData> oAppSettingParams);
        [OperationContract]
        IList<AppSettingsData> GetCodeGroup();
        [OperationContract]
        IList<AppSettingsData> GetParentList(string GroupName);
        [OperationContract]
        IList<AppSettingsData> GetCodeList(string GroupName);
        [OperationContract]
        IList<AppSettingsData> GetCodes(string GroupName, string parent);
        [OperationContract]
        List<AppSettingsData> GetSystemSettings();
        [OperationContract]
        string SaveSystemSettings(string parm_code, string parm_value, string updated_by, DateTime updated_Date);
        [OperationContract]
        string DeleteRefernceData(IList<AppSettingsData> oReferenceData);
        [OperationContract]
        string SaveRefernceData(IList<AppSettingsData> oReferenceData);
    }
}
