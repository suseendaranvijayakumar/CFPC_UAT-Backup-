({
    
     doInit: function(component, event, helper) {
        // Set the attribute value. 
        // You could also fire an event here instead.
        window.setTimeout( $A.getCallback(function() { component.set("v.spinner",false); }), 30000 );
        
       
    },
    

})