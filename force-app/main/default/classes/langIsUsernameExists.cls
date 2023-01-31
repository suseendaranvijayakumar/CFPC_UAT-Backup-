public without sharing  class langIsUsernameExists {

    public static Boolean checkDupUsername(user us){
        List<user> usr = [select Id,username from user where username =: us.Username LIMIT 1];
            If(usr.size()>0){
              return true;                 
            }
        return false;
    }
}