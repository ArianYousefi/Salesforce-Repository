public class AY_CreateAccountController
{   
    public Account acc {get; set;}
    public Boolean isValidAddress {get;set;}
    public List<Account> listAccount = new List<Account>();
    public String errorMessage ;
    public String message {get; set;}
    public ApexPages.StandardController standardController = null;

    List<ValidateAddressesBySOAP.validationResultSOAP> listResult =  new List<ValidateAddressesBySOAP.validationResultSOAP>();

    public AY_CreateAccountController(ApexPages.StandardController standardController)
    {
      this.standardController = standardController;
      this.acc = (Account)standardController.getRecord();
      listAccount.add(acc);
    }

    // Action method
    public Object startRequest() 
    {   

      Integer TIMEOUT_INT_SECS = 60;  
      Continuation cont = new Continuation(TIMEOUT_INT_SECS);
      cont.continuationMethod = 'processResponse';
      
      List<ValidateAddressesBySOAP.addressSOAP> listAddress = new List<ValidateAddressesBySOAP.addressSOAP>();
      
      for (Account a : listAccount) 
      {
        
        ValidateAddressesBySOAP.addressSOAP address = new ValidateAddressesBySOAP.addressSOAP();
        
        address.id = a.Id;
        address.line1 = a.BillingStreet;
        address.line2 = a.Line_2__c;
        address.city = a.BillingCity;
        address.state = a.BillingState;
        address.country = a.BillingCountry;
        address.zipCode = a.BillingPostalCode;

        listAddress.add(address);
      }
                  
      ValidateAddressesBySOAP.ValidateAddressesPort port = new ValidateAddressesBySOAP.ValidateAddressesPort();
      
      listResult = port.ValidateAddresses(listAddress);       
          
      return cont;   
    }    
    
    // Callback method
    public Object processResponse() 
    {    

      // Verify results
      for (ValidateAddressesBySOAP.validationResultSOAP result : listResult) 
      {
        if (result.differences != null) 
        {
          //Following loop was added for debugging purposes
          for (ValidateAddressesBySOAP.difference diff : result.differences) 
          { 
            System.debug('Field: [' + diff.fieldName + '] Expecting: [' + diff.expecting + '] Received: [' + diff.received + ']'); 
            errorMessage += 'Field: [' + diff.fieldName + '] Expecting: [' + diff.expecting + '] Received: [' + diff.received + ']' ;
          }
        } 
      
        //Candidate__c cand = mapCands.get(result.testAddress.id);
        if (result.isValid) 
        {
          isValidAddress = true;
          message = 'Account created in the system. Please proceed.';
          System.debug('*** message + ' + message);
          //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Address is Valid. Please proceed.'));
        } 
        else 
        {
          isValidAddress = false;
          message = 'An Error occured. Please retry later.';
          System.debug('*** message + ' + message);
          //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
        }

      }

       // Return null to re-render the original Visualforce page
       return null; 
    }

  
}