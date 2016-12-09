public with sharing class AY_ContactSearchController_v2 {
  
  public Contact con{get;set;}
  public List<Contact> contactList {get;set;}
  // create a list of strings to hold the conditions
  List<string> conditions = new List<string>();
  private integer totalRecs = 0;
  private integer OffsetSize = 0;
  private integer LimitSize= 10;

  public AY_ContactSearchController_v2()
  {
    system.debug('==>AY_ContactSearchController_v2  is calling==>');
    con = new Contact();
    //contactList  = new List<Contact>();
  }

  public void searchContact()
  {
    totalRecs = 0;
    OffsetSize = 0;

    if(contactList !=null && contactList.size()>0)
    {
     contactList=null;
    }

    searchContacts();
    conditions.clear();
  }


  public Void searchContacts()
  {

    System.debug('Total Records is ==>'+totalRecs);
    System.debug('OffsetSize is ==>'+OffsetSize);

    if(contactList != null && !contactList.isEmpty())
    {
      contactList.clear();
    }

    String strQuery ='SELECT Id,FirstName,LastName,State__c,SSN__c,Zip_Code__c,DOB_Hash__c,SSN_Hash__c,Date_of_Birth__c From Contact';
    
    if(con.FirstName != null)
    {
      conditions.add('FirstName Like\'%' + String.escapeSingleQuotes(con.FirstName) +'%\' ');
    }

    if(con.LastName != null)
    {
      conditions.add('LastName Like\'%' + String.escapeSingleQuotes(con.LastName) +'%\' ');
    } 

    if(con.Zip_Code__c != null)
    {
      conditions.add('Zip_Code__c Like\'%' + con.Zip_Code__c +'%\' ');
    } 

    if(con.State__c != null)
    {
      conditions.add('Zip_Code__c Like\'%' + String.escapeSingleQuotes(con.State__c) +'%\' ');
    } 

    SSN_Encryption_Key__c  csEncryption = SSN_Encryption_Key__c.getvalues('System Properties');

    if(con.SSN__c != null)
    {
      
      String ssnCombKey = csEncryption.Key__c + con.SSN__c;
      Blob ssnHash = Crypto.generateDigest('SHA-256', Blob.valueOf(ssnCombKey));
      String ssnHashString = EncodingUtil.base64Encode(ssnHash);  

      conditions.add('SSN_Hash__c =: ssnHashString');
    } 


    if(con.Date_of_Birth__c != null)
    {
      
      String dobCombKey = csEncryption.Key__c + con.Date_of_Birth__c;
      Blob dobHash = Crypto.generateDigest('SHA-256', Blob.valueOf(dobCombKey));
      String dobHashString = EncodingUtil.base64Encode(dobHash);  

      conditions.add('DOB_Hash__c =: dobHashString');
    } 

    if (conditions.size() > 0) 
    {
      strQuery += '  WHERE ' + conditions[0];
      for (Integer i = 1; i < conditions.size(); i++)
      {
        strQuery += '  AND ' + conditions[i];
      }
    }

    if(totalRecs != null && totalRecs == 0)
    {
      List<Contact> conTemp = Database.query(strQuery);
      totalRecs = (conTemp != null && conTemp.size() > 0) ? conTemp.size() : 0;
    }

    system.debug('strQuery ==>'+strQuery );
    // add sort and limits at the end  
    strQuery += ' ORDER BY Name  ASC, CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize';
      
    contactList  =Database.query(strQuery); 
      
    //conditions.clear();
    //return accountList.size();
  }

  public void FirstPage()
  {
    OffsetSize = 0;
    searchContacts();
  }
  public void previous()
  {
    OffsetSize = (OffsetSize-LimitSize);
    searchContacts();
  }
  public void next()
  {
    OffsetSize = OffsetSize + LimitSize;
    searchContacts();
  }
  public void LastPage()
  {
    OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
    searchContacts();
  }
  public boolean getprev()
  {
    if(OffsetSize == 0)
    {
      return true;
    }
    else 
    {
      return false;
    }

  }
  public boolean getnxt()
  {
    if((OffsetSize + LimitSize) > totalRecs)
    {
      return true;
    }
    else 
    {
      return false;
    }

  }

}