/**
 * A test class for InvocableCrash.
 */
@isTest 
public class InvocableCrashTest {

    @isTest
    private static void testCrash() {

        try {   
            InvocableCrash.execute(new List<String> {'Test'});
            System.assert(false, 'Method did not cause a crash');
        } 
        catch (InvocableCrash.InvocableCrashException ex) { }

    }
}