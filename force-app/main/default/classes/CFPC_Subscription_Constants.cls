public class CFPC_Subscription_Constants {
    
	public static FINAL  Map<string,string> chapters = new Map<String,string>{'Alberta Chapter fee'=>'AB','Alberta Chapter fee - n/c'=>'AB',
            												'British Columbia Chapter fee'=>'BC','British Columbia Chapter fee -n/c'=>'BC',
            												'Manitoba Chapter fee'=>'MB', 'Manitoba Chapter fee - n/c'=>'MB',
            												'New Brunswick Chapter fee'=>'NB', 'New Brunswick Chapter fee - n/c'=>'NB',
                                                            'Newfoundland and Labrador Chapter fee' =>'NL','Newfoundland and Labrador Chapter fee - n/c' =>'NL',
            												'Nova Scotia Chapter fee'=>'NS','Nova Scotia Chapter fee - n/c'=>'NS',
            												'Ontario Chapter fee'=>'ON','Ontario Chapter fee - n/c'=>'ON',
                                                            'Prince Edward Island Chapter fee'=>'PE','Prince Edward Island Chapter fee - n/c'=>'PE',
            												'Quebec Chapter fee'=>'QC','Quebec Chapter fee - n/c'=>'QC',
        													'Saskatchewan Chapter fee' =>'SK','Saskatchewan Chapter fee - n/c' =>'SK'};
    public static FINAL Map<string,string> newClass = new Map<String,string>{'Associate National fee'=>'Associate', 'NMMP National fee'=>'Non-Member Mainpro+ Participant', 
                   										    'Non-Practicing National Fee' =>'Non-Practicing','Practicing National Fee'=>'Practicing','Learner National Fee'=>'Learner'};                                             
    public static FINAL Set<string> selfLrnPrgm = new Set<string>{'Self Learning Program fee','Self Learning Program fee - n/c','Self Learning Program Fee - NMMP'};                                                            
}