trigger AY_ContactTrigger on Contact (before insert,after insert) {
       
    List<Contact> errorObjList;
    //try 
    //{
        
        if(Trigger.isInsert && Trigger.isAfter) {
            errorObjList = Trigger.new;
            AY_ContactTriggerHandler.onAfterInsert(trigger.new,trigger.newMap);
        }
        

        if(Trigger.isInsert && Trigger.isBefore) {
            errorObjList = Trigger.new;
            AY_ContactTriggerHandler.onBeforeInsert(trigger.new);
        } 
        
        /*
        if(Trigger.isUpdate && Trigger.isBefore) {
            errorObjList = Trigger.new;
        }
        */
        
        //if(Trigger.isUpdate && Trigger.isAfter) {
        //    errorObjList = Trigger.new;
        //    AY_BloomTriggerHandler.onAfterUpdate(trigger.new,trigger.newMap,trigger.oldMap);
        //} 

        
        ////if(Trigger.isDelete && Trigger.isBefore) {
        ////    errorObjList = Trigger.old;
        ////    system.debug('**** onBeforeDelete ***** ' + trigger.old);
        ////    AY_BloomTriggerHandler.onBeforeDelete(trigger.old);
        ////}
        

        
        //if(Trigger.isDelete && Trigger.isAfter) {
        //    errorObjList = Trigger.old;
        //    system.debug('**** onAfterDelete ***** ' + trigger.old);
        //    AY_BloomTriggerHandler.onAfterDelete(trigger.old);
        //}
            
    //}  
    //catch(exception e){
     //   system.debug('**** Error on AY_BloomTrigger ***** ' + e);
    //}

}