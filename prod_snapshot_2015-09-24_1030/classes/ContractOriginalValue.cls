global with sharing class ContractOriginalValue{

    webservice static string setSingleOriginalContractValue(ID oppID)
    {
        string ErrorMessage ='Success';
        Opportunity opp = new Opportunity();
        try 
        {
            opp = [SELECT   ID, 
                                        StageName, 
                                        OriginalValueSetDate__c,
                                        OriginalValueSetBy__c
                                   FROM Opportunity 
                                   WHERE ID = :oppID];
                               
            OpportunityLineItem[] oliList = [SELECT   ID,
                                                    Product_CurrentValue__c,
                                                    Product_OriginalValue__c,
                                                    Waiting_Status__c
                                           FROM OpportunityLineItem
                                           WHERE OpportunityID = :oppID
                                           AND Waiting_Status__c IN ('','Closed Won')];
            //Ensure it has OLIs associated to it
            if (!oliList.isEmpty())
            {
                // Original Value not set earlier
                if (opp.OriginalValueSetDate__c == null)
                {
                    // Opportunity in the right stages
                    if ((opp.StageName == 'Closed Won' || opp.StageName == 'Contract Approved' || opp.StageName == 'Contract Approved by Jumpstart'))
                    {
                        // Set timestamps on Opporunity
                        opp.StageName = 'Closed Won'; 
                        opp.OriginalValueSetDate__c = datetime.now();
                        opp.OriginalValueSetBy__c = UserInfo.getUserId();
                        update opp;
                        
                        //Update the OLI Product_OriginalValue__c to Product_CurrentValue__c
                        for (integer i = 0; i < oliList.size(); i++)        
                        {
                            oliList[i].Product_OriginalValue__c = oliList[i].Product_CurrentValue__c;
                        }
                        update oliList;

                       
                    } // End if opportunity in the right stages
                    else 
                    {
                        ErrorMessage = 'The Opportunity\'s original contract values and stage may not be calculated and updated if the stage is not \"Contract Approved\" or \"Closed Won\". Please contact a Finance Manager to proceed.';
                    } // End wrong opp stages
                } // End If Original Value not set earlier
                else
                {
                    ErrorMessage = 'The Opportunity\'s original contract values have already been calculated.';
                }// Original Value set earlier
            }//End if has related OLI
            else
            {
                ErrorMessage = 'No eligible Opportunity Products found to calculate Original Values for.  Please ensure there are opportunity products assoicated, and their status\' are in \'Closed Won\' or are blank.';
            }// end no related OLI
        }
        catch(exception ex)
        {
            ErrorMessage = ex.getMessage();
        }
        return ErrorMessage;
    }
}