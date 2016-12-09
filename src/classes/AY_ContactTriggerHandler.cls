public class AY_ContactTriggerHandler {

  public static Boolean onBeforeInsert = false; 
  //public static Boolean onBeforeUpdate = false; 
  //public static Boolean onBeforeDelete = false; 
  public static Boolean onAfterInsert = false; 
  //public static Boolean onAfterUpdate = false; 
  //public static Boolean onAfterDelete = false;    

  public static void onBeforeInsert(List<Contact> conList){
    if(!onBeforeInsert){
      onBeforeInsert = true;
      for(Contact c : conList)
      {

        SSN_Encryption_Key__c  csEncryption = SSN_Encryption_Key__c.getvalues('System Properties');
        String ssnCombKey = csEncryption.Key__c + c.SSN__c;
        Blob ssnHashBlob = Crypto.generateDigest('SHA-256', Blob.valueOf(ssnCombKey));
        String ssnHash = EncodingUtil.base64Encode(ssnHashBlob);  
        c.SSN_Hash__c =  ssnHash;

        String dobCombKey = csEncryption.Key__c + c.Date_of_Birth__c;
        Blob dobHashBlob = Crypto.generateDigest('SHA-256', Blob.valueOf(dobCombKey));
        String dobHash = EncodingUtil.base64Encode(dobHashBlob);  
        c.DOB_Hash__c =  dobHash;

      }
    }
  }

  public static void onAfterInsert(List<Contact> conList, Map<Id,Contact> mapNewRecord){   
    if(!onAfterInsert){
      onAfterInsert = true;
      Id optyRecordTypeID = getRecordTypeId('Opportunity', 'Standard Opportunity');
      List<Opportunity> listOpportunity = new List<Opportunity>();
      Map<ID,ID> mapContacttoOpportunity = new Map<ID,ID>();
      List<OpportunityContactRole> listOpportunityContactRole = new List<OpportunityContactRole>();
      List<Drivers__c> listDrivers = new List<Drivers__c>();

      for(Contact c : conList)
      {
        Opportunity o = new Opportunity();
        o.Name = c.FirstName + ' ' + c.LastName + ' - ' + 'Insurance Quote';
        o.RecordTypeID = optyRecordTypeID;
        o.AccountId = c.AccountId;
        o.StageName = 'Prospecting';
        o.Type = 'New Business';
        o.CurrencyIsoCode = 'USD';
        o.ForecastCategoryName = 'Pipeline';
        o.CloseDate = Date.today();

        listOpportunity.add(o);
      }

      if(!listOpportunity.isempty())
      {
        insert listOpportunity;
      }

      if(conList.size() == listOpportunity.size() && listOpportunity.size() > 0)
      {
        for(Integer i=0 ; i<conList.size() ; i++)
        {
          mapContacttoOpportunity.put(conList[i].Id,listOpportunity[i].Id);
        }        
      }

      for(Id cID : mapContacttoOpportunity.keySet())
      {
        OpportunityContactRole pcr = new OpportunityContactRole();
        pcr.ContactId = cID;
        pcr.OpportunityId= mapContacttoOpportunity.get(cID);
        pcr.IsPrimary= true;
        pcr.Role ='Primary Driver';
        listOpportunityContactRole.add(pcr);

        Drivers__c pd = new Drivers__c();
        Contact c = mapNewRecord.get(cID);
        pd.Name = c.FirstNAme + ' ' + c.LastName;
        pd.Quote__c = mapContacttoOpportunity.get(cID);
        pd.Primary__c = true;
        pd.Line_1__c = c.Line_1__c;
        pd.Line_2__c = c.Line_2__c;
        pd.City__c = c.City__c;
        pd.State__c = c.State__c;
        pd.Country__c = c.Country__c;
        pd.Email__c = c.Email;
        pd.Phone__c = c.Phone;
        pd.SSN__c = c.SSN__c;
        pd.DOB__c = c.Date_of_Birth__c;
        listDrivers.add(pd);

      }

      if(!listOpportunityContactRole.isempty())
      {
        insert listOpportunityContactRole;
      }

     if(!listDrivers.isempty())
      {
        insert listDrivers;
      }

      
    }
  }

  //public static void onBeforeUpdate(List<Contact> bloomList, Map<Id, Contact> newBloomMap, Map<Id, Contact> oldBloomMap){
  //  if(!onBeforeUpdate){
  //    onBeforeUpdate = true;
  //  }
  //}
    
  //public static void onAfterUpdate(List<Contact> bloomList, Map<Id, Contact> newBloomMap, Map<Id, Contact> oldBloomMap){
  //  if(!onAfterUpdate){
  //    onAfterUpdate = true;
  //  }
  //}
  
  //public static void onBeforeDelete(List<Bloom__c> oldBloomList){
  //  if(!onBeforeDelete){
  //    onBeforeDelete = true;
  //  }
  //}

  //public static void onAfterDelete(List<Bloom__c> oldBloomList){
  //  if(!onAfterDelete){
  //    onAfterDelete = true;
  //    AY_BloomTriggerHelper.doCountBlooms(oldBloomList);
  //  }
  //}

  public static Id getRecordTypeId(String objectName,String recordTypeName)
  {

    if(objectName == 'Opportunity')
    {
        return Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }
    else
    {
      System.debug('***getRecordTypeIdFails');
      return null;
    }
  }

}