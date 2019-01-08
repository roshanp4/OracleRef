using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Web;
using System.IO;

namespace LDSFileService.ServiceClassLibrary
{
    [DataContract]
    public class AttributeSettingsData
    {

        [DataMember]
        public int GroupId { set; get; }
        [DataMember]
        public string GroupName { set; get; }

        [DataMember]
        public string User { set; get; }
        [DataMember]
        public string Owner { set; get; }
        [DataMember]
        public int AttributeId { set; get; }
        [DataMember]
        public string AttributeName { get; set; }
        [DataMember]
        public string AttributeType { set; get; }
        [DataMember]
        public string AttributeTypeDescription { set; get; }
        [DataMember]
        public bool AttributeStatus { get; set; }

        [DataMember]
        public string Style { get; set; }
        [DataMember]
        public string StyleVal { get; set; }
        [DataMember]
        public bool IsMandatory { get; set; }
        [DataMember]
        public bool IsUnique { get; set; }
        [DataMember]
        public bool DefaultValFlag { get; set; }
        [DataMember]
        public string DefaultVal { get; set; }

        [DataMember]
        public int LibraryId { set; get; }
        [DataMember]
        public bool IsValueMandatory { set; get; }
        [DataMember]
        public bool IsInhMandatory { set; get; }
        [DataMember]
        public string LibraryName { get; set; }



        [DataMember]
        public string CreatedBy { set; get; }
        [DataMember]
        public DateTime? CreatedDate { get; set; }
        [DataMember]
        public DateTime? ModFromDate { get; set; }
        [DataMember]
        public DateTime? ModToDate { get; set; }
        [DataMember]
        public string AttributeFilter { get; set; }
        [DataMember]
        public string Updatedby { set; get; }
        [DataMember]
        public DateTime? UpdatedDate { get; set; }

        [DataMember]
        public int? ObjectId { set; get; }
        [DataMember]
        public int NewObjectId { set; get; }
        [DataMember]
        public string ObjectName { get; set; }
        [DataMember]
        public string ObjectType { set; get; }
        [DataMember]
        public string FilePath { get; set; }
        [DataMember]
        public string FilePathChange { get; set; }
        [DataMember]
        public string ObjectIdnFilePath { get; set; }
        [DataMember]
        public int CurrentVersion { set; get; }
        [DataMember]
        public string FileType { get; set; }
        [DataMember]
        public string FileSize { get; set; }
        [DataMember]
        public string Description { get; set; }
        [DataMember]
        public int ParantId { set; get; }
        [DataMember]
        public string IconImageName { get; set; }
        [DataMember]
        public int SortOrder { get; set; }
        [DataMember]
        public string DeleteFlag { get; set; }
        [DataMember]
        public string AttributeValue { get; set; }
        [DataMember]
        public string ValMand { get; set; }
        [DataMember]
        public string InheritMand { get; set; }
        [DataMember]
        public string Status { get; set; }

        [DataMember]
        public string FilterSectionType { get; set; }
        [DataMember]
        public string FilterObjectType { get; set; }
        [DataMember]
        public string FilterDocCount { get; set; }
        [DataMember]
        public string FilterCount { get; set; }

        [DataMember]
        public string ListVal { get; set; }


    }
}