public class AY_CreateOrderController
{   
    public Order order {get; set;}
    public Boolean isValidOrder {get;set;}
    public List<Order> listOrders= new List<Order>();
    public String errorMessage ;
    public String message {get; set;}
    public ApexPages.StandardController standardController = null;
    public String DeliveryBlock {get; set;}
    public String HeadercurrencyCode {get; set;}

    List<AY_OrderSubmit_SAP.OrderSubmit_element> listResult =  new List<AY_OrderSubmit_SAP.OrderSubmit_element>();

    public AY_CreateOrderController(ApexPages.StandardController standardController)
    {
      this.standardController = standardController;
      this.order = (Order)standardController.getRecord();
      listOrders.add(order);
    }

    // Action method
    public Object startRequest() 
    {   

      Integer TIMEOUT_INT_SECS = 60;  
      Continuation cont = new Continuation(TIMEOUT_INT_SECS);
      cont.continuationMethod = 'processResponse';
      
      List<AY_OrderSubmit_SAP.OrderSubmit_element> listOrderSubmitElements = new List<AY_OrderSubmit_SAP.OrderSubmit_element>();
      
      for (Order o : listOrders) 
      {
        
        AY_OrderSubmit_SAP.OrderSubmit_element orderSubmit = new AY_OrderSubmit_SAP.OrderSubmit_element();
        
        orderSubmit.E1EDK01 = new  AY_OrderSubmit_SAP.E1EDK01_element();

        orderSubmit.E1EDK01.DeliveryBlock = o.DeliveryBlock__c;
        orderSubmit.E1EDK01.HeadercurrencyCode = o.HeadercurrencyCode__c;

        listOrderSubmitElements.add(orderSubmit);
      }
                  
      AY_OrderSubmit_SAP.HTTPS_Port port = new AY_OrderSubmit_SAP.HTTPS_Port();
      
      listResult = port.SfdcOrderSubmitProcess_Async(listOrderSubmitElements);       
          
      return cont;   
    }    
    
    // Callback method
    public Object processResponse() 
    {    

      // Verify results
      for (AY_OrderSubmit_SAP.OrderSubmit_element result : listResult) 
      {
        if (listResult.size() > 0) 
        {
          DeliveryBlock = result.E1EDK01.DeliveryBlock;
          HeadercurrencyCode = result.E1EDK01.HeadercurrencyCode;

        } 
      
        if (listResult.size() > 0) 
        {
          isValidOrder = true;
          message = 'Account created in the system. Please proceed.';
          System.debug('*** message + ' + message);
          //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Address is Valid. Please proceed.'));
        } 
        else 
        {
          isValidOrder = false;
          message = 'An Error occured. Please retry later.';
          System.debug('*** message + ' + message);
          //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
        }

      }

       // Return null to re-render the original Visualforce page
       return null; 
    }

  
}