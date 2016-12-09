public class AY_CreateAccountRESTController
{   
    public Account acc {get; set;}
    public String message {get; set;}
    public ApexPages.StandardController standardController = null;
    private String baseSericeURL = 'http://services.groupkt.com/country/get/iso2code/';
    //private String baseSericeURL = 'http://intg-playground.herokuapp.com/sfdc/omlistener/endpoint/cacfbcfd-d9a5-4732-98d7-8c3889c4a090';
    private String returnedContinuationId ;
    public String response {get;set;} 
    public Boolean isCreated {get;set;}

    public AY_CreateAccountRESTController(ApexPages.StandardController standardController)
    {
      this.standardController = standardController;
      this.acc = (Account)standardController.getRecord();
    }

    // Action method
    public Continuation startRequest() 
    {   

      Integer TIMEOUT_INT_SECS = 60;  
      Continuation con = new Continuation(TIMEOUT_INT_SECS);
      con.continuationMethod = 'processResponse';

      // Create callout request
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      req.setEndpoint(baseSericeURL + acc.BillingCountry);
      //req.setEndpoint(baseSericeURL);

      returnedContinuationId = con.addHttpRequest(req);

      return con; 
    }    
    
    // Callback method
    public Object processResponse() 
    {    

      // Get the response by using the unique label
      HttpResponse httpRes = Continuation.getResponse(returnedContinuationId);
      // Set the result variable that is displayed on the Visualforce page
      response = httpRes.getBody();

      if (response.contains('USA')) 
      {
        acc.Customer_External_ID__c = '123456';
        upsert acc;
        message = 'Account created in the system. Please click on Close button and proceeed.';
        System.debug('*** message + ' + message);
        isCreated = true;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Address is Valid. Please proceed.'));
      } 
      else 
      {
        message = 'An Error occured. Please retry later.';
        System.debug('*** message + ' + message);
        isCreated = false;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
      }

        //if (httpRes.getStatusCode() != 200) {
        //    System.debug('The status code returned was not expected: ' +
        //    httpRes.getStatusCode() + ' ' + httpRes.getStatus());
        //    message = 'Account creation failed. Please try later.';
        //    isCreated = false;
        //} else {  
        //    System.debug(httpRes.getBody());
        //    message = 'Account created in the system. Please proceed.';
        //    isCreated = true;
        //}

       // Return null to re-render the original Visualforce page
       return null; 
    }


    public PageReference close()
    {

      PageReference detailPage = new PageReference('/');
      
      if(acc.Id != null)
      {
        detailPage = new PageReference('/' + acc.Id);
      }
      else
      {
        detailPage = new PageReference('/' + '001/o');
      }

      return ApexPages.hasMessages() ? null : detailPage;       
    }

  
}