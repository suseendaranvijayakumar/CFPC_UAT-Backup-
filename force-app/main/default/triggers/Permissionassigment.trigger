trigger Permissionassigment on User (after insert) {
       System.debug('Entered into Trigger');
    Set<Id> userId=new Set<Id>();
    for(User user: Trigger.new){
        userId.add(user.id);
        }
      User_Permission_assigment.afterInsert(userId);
      
    

}