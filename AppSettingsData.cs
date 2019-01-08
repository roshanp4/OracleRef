using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;


namespace LDSFileService.ServiceClassLibrary
{
    [DataContract]
    public class AppSettingsData
    {
        string securekey { get; set; }

        [DataMember]
        public string uwbi { get; set; }
        [DataMember]
        public string RowLevel { get; set; }
        [DataMember]
        public string UserName { get; set; }
        [DataMember]
        public int SessionId { get; set; }
        [DataMember]
        public string ModuleName { get; set; }
        [DataMember]
        public string VersionNumber { get; set; }
        [DataMember]
        public string ScreenCode { get; set; }
        [DataMember]
        public string ScreenName { get; set; }
        [DataMember]
        public string ScreenModule { get; set; }
        [DataMember]
        public string ColorCode { get; set; }
        [DataMember]
        public string CodesCode { get; set; }
        [DataMember]
        public string CodeDescription { get; set; }
        [DataMember]
        public string GroupName { get; set; }
        [DataMember]
        public int DisplaySeq { get; set; }
        [DataMember]
        public bool CodeActive { get; set; }
        [DataMember]
        public string Parent_Flag { get; set; }

        //For Field settings
        [DataMember]
        public string FieldCode { get; set; }
        [DataMember]
        public string FieldShortName { get; set; }
        [DataMember]
        public string FieldName { get; set; }
        [DataMember]
        public string UpdateBy { get; set; }
        [DataMember]
        public string UpdateDate { get; set; }

        //For Role Settings
        [DataMember]
        public string RoleId { get; set; }
        [DataMember]
        public string RoleName { get; set; }
        [DataMember]
        public bool AccessFlag { get; set; }
        //For Cluster Right
        [DataMember]
        public string ClusterCode { get; set; }

        //Audit Trail
        public DateTime AuditTrailFrom { get; set; }
        [DataMember]
        public DateTime AuditTrailTo { get; set; }
        [DataMember]
        public string TableName { get; set; }
        [DataMember]
        public string ColumnName { get; set; }
        [DataMember]
        public string TablePKey { get; set; }
        [DataMember]
        public string TablePKeyValue { get; set; }
        [DataMember]
        public string TransDate { get; set; }
        [DataMember]
        public string UserId { get; set; }
        [DataMember]
        public string OperationType { get; set; }
        [DataMember]
        public string OldValue { get; set; }
        [DataMember]
        public string NewValue { get; set; }
        //For Reservoir Unit Codes
        [DataMember]
        public string PickCode { get; set; }
        [DataMember]
        public string PickName { get; set; }
        [DataMember]
        public string ResUnitCode { get; set; }
        [DataMember]
        public string ResUnitName { get; set; }

        //For System Parm
        [DataMember]
        public string ParmType { get; set; }
        [DataMember]
        public string ParmDesc { get; set; }
        [DataMember]
        public string ParmValue { get; set; }
        [DataMember]
        public string ParmCode { get; set; }

        //For Rig Details
        [DataMember]
        public string RigId { get; set; }
        [DataMember]
        public string RigNum { get; set; }
        [DataMember]
        public string RigName { get; set; }
        [DataMember]
        public string Company { get; set; }
        [DataMember]
        public decimal AirGap { get; set; }
        [DataMember]
        public string EffectiveFrom { get; set; }
        [DataMember]
        public string EffectiveTo { get; set; }
        [DataMember]
        public string InsertBy { get; set; }
        [DataMember]
        public string InsertDate { get; set; }
        [DataMember]
        public string Parent_Code { get; set; }
    }
}