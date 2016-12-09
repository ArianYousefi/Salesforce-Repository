public class AY_CreateContactController
{   
  	public Contact con {get; set;}
  	public Boolean isValidAddress {get;set;}
  	public List<Contact> listContact = new List<Contact>();
  	public String errorMessage = '';
  	public ApexPages.StandardController standardController = null;

  	public AY_CreateContactController(ApexPages.StandardController standardController)
  	{
    	this.standardController = standardController;
     	this.con = (Contact)standardController.getRecord();
     	listContact.add(con);
  	}

    public void validateResult()
    {
	    List<ValidateAddressesBySOAP.addressSOAP> listAddress = new List<ValidateAddressesBySOAP.addressSOAP>();
	    for (Contact c : listContact) {
	        ValidateAddressesBySOAP.addressSOAP address = new ValidateAddressesBySOAP.addressSOAP();
	        address.id = c.Id;
	        address.line1 = c.Line_1__c;
	        address.line2 = c.Line_2__c;
	        address.city = c.City__c;
	        address.state = c.State__c;
	        address.country = c.Country__c;
	        address.zipCode = c.Zip_Code__c;
	        listAddress.add(address);
	    }
	                
	    // TODO: Declare a new variable called "port" of type ValidateAddressesBySOAP.ValidateAddressesPort. Populate it using the default constructor
	    ValidateAddressesBySOAP.ValidateAddressesPort port = new ValidateAddressesBySOAP.ValidateAddressesPort();
		// TODO: Declare a variable called "listResult" of type List <ValidateAddressesBySOAP.validationResultSOAP>
		List<ValidateAddressesBySOAP.validationResultSOAP> listResult =  new List<ValidateAddressesBySOAP.validationResultSOAP>();
		// TODO: Initialize this variable to the result of calling the ValidateAddresses method on the "port" variable, passing in the listAddress variable.
		listResult = port.ValidateAddresses(listAddress);
	    // Verify results
	    for (ValidateAddressesBySOAP.validationResultSOAP result : listResult) {
			if (result.differences != null) {
	            //Following loop was added for debugging purposes
	            for (ValidateAddressesBySOAP.difference diff : result.differences) { 
	                System.debug('Field: [' + diff.fieldName + '] Expecting: [' + diff.expecting + '] Received: [' + diff.received + ']'); 
	            	errorMessage += 'Field: [' + diff.fieldName + '] Expecting: [' + diff.expecting + '] Received: [' + diff.received + ']' ;
	            }
	        } 
			
	        //Candidate__c cand = mapCands.get(result.testAddress.id);
	        if (result.isValid) {
	            isValidAddress = true;
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Address is Valid. Please proceed.'));
	        } else {
	            isValidAddress = false;
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
	        }
	    }

	}
  
}