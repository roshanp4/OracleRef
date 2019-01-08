using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace LDSFileService.ServiceClassLibrary
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IAttributeSettings" in both code and config file together.
    [ServiceContract]
    public interface IAttributeSettings
    {
        // Get
        [OperationContract]
        List<AttributeSettingsData> GetFullAttributeList(string Status, string Search_Param);
        [OperationContract]
        List<AttributeSettingsData> GetAttributeGroupList(string strSearch);
        [OperationContract]
        List<AttributeSettingsData> GetGroupAttributes(int GroupId, int LibraryId, string GroupFlag);
        [OperationContract]
        List<AttributeSettingsData> GetAttributesListValues(int AttributeId);
        [OperationContract]
        List<AttributeSettingsData> GetAttributeByLibrary(int LibraryId, bool Status);
        [OperationContract]
        List<AttributeSettingsData> GetAttributeGroupByLibraryId(int LibraryId);
        [OperationContract]
        List<AttributeSettingsData> GetAttributeGroupById(int GroupId);
        [OperationContract]
        List<AttributeSettingsData> GetAttributeListById(string AttributeId);

        [OperationContract]
        List<AttributeSettingsData> GetObjectAttributeList(int ObjectId);

        [OperationContract]
        List<AttributeSettingsData> GetSysAttributeGroupByLibraryId(int LibraryId, bool Status);

        //For Saving
        [OperationContract]
        string SaveAttribute(AttributeSettingsData oliveDoc, out string AttrIdOut);
        [OperationContract]
        void SaveAttributeGroup(AttributeSettingsData oliveDoc);
        [OperationContract]
        string SaveAttributeGroupMaster(AttributeSettingsData oliveDoc, out string GroupIdOut);
        [OperationContract]
        void SaveAttributeListVal(AttributeSettingsData oliveDoc);
        [OperationContract]
        string CopyAttributesToNew(AttributeSettingsData oliveDoc);
        [OperationContract]
        string CopyGroupsToNew(AttributeSettingsData oliveDoc);
        [OperationContract]
        void SaveObjectAttribute(AttributeSettingsData oliveDoc);
        [OperationContract]
        void SaveObjectAttributeGroup(AttributeSettingsData oliveDoc);

        // For Deleting   
        [OperationContract]
        string DeleteAttributeMaster(AttributeSettingsData oliveDoc);
        [OperationContract]
        string DeleteAttributeGroupMaster(AttributeSettingsData oliveDoc);
        [OperationContract]
        void DeleteAttributeListVal(AttributeSettingsData oliveDoc);

        //For Deleting
        [OperationContract]
        string DeleteObjectAttribute(AttributeSettingsData oliveDoc);
    }
}
