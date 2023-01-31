({
    redirectToAccount: function(component, event, helper) {
        var loggedInUser;
        var state;
        var navEvt;
        
        var action = component.get("c.getLoggedInUser");
        action.setCallback(this, function(response) {
            state = response.getState();
            if (state === "SUCCESS") {
                loggedInUser = response.getReturnValue();
                navEvt = $A.get("e.force:navigateToURL");
                navEvt.setParams({
                    "url": "/contact/" + loggedInUser.ContactId,
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);
    }
    
})