public class AY_AccountOrderController
{  
  private Account acc;  
  AY_OrderShipInfo myOrderShipInfo;  
  AY_OrderShipInfo.ShipInfo theShipInfo;    
  private ApexPages.StandardController controller {get; set;} 
  public String orderStatus {get; set;} 
  public String orderComments {get; set;}
  public String orderOwner {get; set;}

  public AY_AccountOrderController(ApexPages.StandardController controller)
  {  
    //initialize the stanrdard controller  
    this.controller = controller;  
    this.acc = (Account)controller.getRecord();  
  }

  public void refreshOrderShipInfo()  
  {  
    
    myOrderShipInfo = new AY_OrderShipInfo();  
    theShipInfo = myOrderShipInfo.getOrderShipInfo(this.acc.Order_External_ID__c); 
    orderStatus =  theShipInfo.status;
    orderComments = theShipInfo.comments;
    orderOwner = theShipInfo.orderOwner;
        
  }  

}