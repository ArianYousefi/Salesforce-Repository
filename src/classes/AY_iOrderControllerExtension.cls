public class AY_iOrderControllerExtension  
{  
  private iOrder__c myOrder;  
  AY_OrderShipInfo myOrderShipInfo;  
  AY_OrderShipInfo.ShipInfo theShipInfo;    
  private ApexPages.StandardController controller {get; set;}  

  public AY_iOrderControllerExtension(ApexPages.StandardController controller)
  {  
    //initialize the stanrdard controller  
    this.controller = controller;  
    this.myOrder = (iOrder__c)controller.getRecord();  
  }

  public void refreshOrderShipInfo()  
  {  
    myOrderShipInfo = new AY_OrderShipInfo();  
    theShipInfo = myOrderShipInfo.getOrderShipInfo(this.myOrder.Order_External_ID__c);  

    myOrder.Order_Status__c = theShipInfo.status;    
    update myOrder;     
  }  

  public String getOrderStatus()  
  {  
    return theShipInfo.status;  
  } 

  public String getOrderComments()  
  {  
    return theShipInfo.comments;  
  } 

  public String getOrderOwner()  
  {  
    return theShipInfo.orderOwner;  
  }  
}