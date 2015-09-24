global class opportunityProductEntry_VFC {
    
    public List<wrapOpportunityLI> olineItemWrapperLI {get; set;}
    public opportunityLineItem[] olineItemCM {get;set;}
    public opportunityLineItem[] childOpptyLI {get;set;}
    public opportunityLineItem[] olifinalSave {get;set;}
    public opportunity oppty {get;set;}
    private Id OppId;
    private Integer prodNum;
    private Set<Id> selectedPEId= New Set<Id>();
    public String toUnselectCM {get; set;}
    public String toUnselectLI {get; set;}
    public Integer grandTotalPriceCM {get;set;}
    public Integer grandTotalPriceOLI {get;set;}
    public Boolean renderCMTable {get;set;}
    public Boolean renderLITable {get;set;}
    
    //Child OLI table creation
    public Integer selectedNoOfLocs {get;set;}
    public String selectedQLI {get;set;}
    public String selectedEmailR {get;set;}
    public String selectedPbeId {get;set;}
    public String selectedProdName {get;set;}
    public String selectedPbName {get;set;}
    public String selectedUnitPrice {get;set;}
    public Boolean renderchildTable {get;set;}
    public static final Integer SOCIALMgmtReachAd_MAX = 21000;
    
    public opportunityProductEntry_VFC(ApexPages.StandardController controller) {
           
           //fetch all the parameters passed through the URL entry
           OppId = System.currentPagereference().getParameters().get('OppId');
           String prodNumStr = System.currentPagereference().getParameters().get('ProdNum');
           
           if(OppId!=null){
              oppty=[SELECT ID, Name, PriceBook2.Name FROM Opportunity WHERE ID=: OppId];
           }
           
           if(prodNumStr!=null  &&  prodNumStr!=''){ //Add Oppty Product button Clicked
               
                   prodNum=Integer.valueof(prodNumStr);
                   
                   for (Integer i = 0; i < prodNum ; i++) {
                      String istr=String.valueof(i);
                      Id peId=System.currentPagereference().getParameters().get('peId-' + istr);
                      if(peId!=null){
                          selectedPEId.add(peId);
                      }
                   }
                   
                   addOLItoList();
                   
           }
                          
    }
    
    // This function runs to add OLI to the list
    public void addOLItoList(){
    
           olineItemCM = new opportunityLineItem[]{};
           olineItemWrapperLI = new List<wrapOpportunityLI>();

           for(PricebookEntry pbe : [SELECT Id,UnitPrice,Invoice_CancelFeePercent__c,MgmtFee_Percent__c,Product2.Edit_NumberOfLocations__c,Product2.Edit_Qty_ContractMonths__c,Product2.Edit_NumberOfHours__c,Product2.Name,Product2.HasMediaSpend__c,Pricebook2.Name,PriceRangeMin__c,PriceRangeMax__c,Product2.Edit_Qty_LineItems__c, Product2.UseMatrix__c, Product2.Edit_Email_Recipients__c FROM PricebookEntry WHERE ID IN:selectedPEId]){
              
               if(pbe.Product2.Edit_Qty_LineItems__c==True){
               
                   olineItemWrapperLI.add(new wrapOpportunityLI(new opportunityLineItem(OpportunityId=OppId, 
                                                   PriceBookEntry=pbe, 
                                                   PriceBookEntryId=pbe.Id, 
                                                   Qty_ContractMonths__c=1.00,
                                                   ServiceDate=Date.TODAY(),
                                                   End_Date__c=Date.TODAY()),pbe.Product2.Name,pbe.Pricebook2.Name,null)
                                                   );
                   
               }else if(pbe.Product2.Edit_Qty_ContractMonths__c==True){
                   
                   olineItemCM.add(new opportunityLineItem(OpportunityId=OppId, 
                                                   PriceBookEntry=pbe, 
                                                   PriceBookEntryId=pbe.Id, 
                                                   UnitPrice=pbe.UnitPrice,
                                                   Qty_LineItems__c=1.00,
                                                   Mgmt_Fee_Percent__c=pbe.MgmtFee_Percent__c,
                                                   Qty_ContractMonths__c=4.00,
                                                   ServiceDate=Date.TODAY(),
                                                   End_Date__c=Date.TODAY()
                                                   ));
                                                   
               }else if(pbe.Product2.Edit_Qty_ContractMonths__c==False) {
                 
                  olineItemCM.add(new opportunityLineItem(OpportunityId=OppId, 
                                                   PriceBookEntry=pbe, 
                                                   PriceBookEntryId=pbe.Id, 
                                                   UnitPrice=pbe.UnitPrice,
                                                   Qty_LineItems__c=1.00,
                                                   Mgmt_Fee_Percent__c=pbe.MgmtFee_Percent__c,
                                                   Qty_ContractMonths__c=1.00,
                                                   ServiceDate=Date.TODAY(),
                                                   End_Date__c=Date.TODAY()
                                                   ));
                   
               }
           }
           
           if(olineItemWrapperLI.size() > 0){
              renderLITable=True;
           }
           else{
             renderLITable=False; 
           }
           if(olineItemCM.size() > 0){
              renderCMTable=True;   
           }else{
              renderCMTable=False;
           }
           
    }
    
    // This function runs when user clicks remove link: Remove OLI from List & refresh table
    public PageReference removeCMOLIfromList() {
       Integer count = 0;
       for(opportunityLineItem oli : olineItemCM) {
            
            if((String)oli.PriceBookEntryId==toUnselectCM){
                
                olineItemCM.remove(count);
                break;
            }
            count++;
       }

       return null;
    }
    // This function runs when user clicks remove link: Remove OLI from List & refresh table
    public PageReference removeLIOLIfromList() {
       Integer count = 0;
       for(wrapOpportunityLI wr : olineItemWrapperLI) {
            
            if((String)wr.parentOLI.PriceBookEntryId==toUnselectLI){
                olineItemWrapperLI.remove(count);
                if(wr.childOLI!=null){
                  wr.childOLI.clear();
                }
                break;
            }
            count++;
       }

       return null;
    }
    // This function runs when user clicks Save button: Save OLI & Back to Opportunity page
    public PageReference onSave(){
        
        olifinalSave = new opportunityLineItem[]{};
        for(wrapOpportunityLI wr : olineItemWrapperLI) {
           if(wr.childOLI !=null) {
             olifinalSave.addall(wr.childOLI); 
           }           
        }
        
        for(opportunityLineItem ot : olifinalSave) {
           ot.TotalPrice=null;            
        }
        
        for(opportunityLineItem ol: olineItemCM){
              
              if(ol.PriceBookEntry.Product2.Edit_NumberOfLocations__c==True){
                 ol.Quantity=ol.Qty_ContractMonths__c;
                 ol.Invoice_PriceVariable__c = returnMatrixResult(Integer.ValueOf(ol.NumberOfLocations__c), String.ValueOf(ol.PriceBookEntryId));
                 ol.UnitPrice= ol.NumberOfLocations__c * ol.Invoice_PriceVariable__c;
              }else if(ol.PriceBookEntry.Product2.Edit_NumberOfHours__c==True){
                 ol.Quantity=ol.Qty_ContractMonths__c;
				 ol.Invoice_PriceVariable__c = ol.UnitPrice;
                 ol.UnitPrice=ol.NumberOfHours__c * ol.UnitPrice;
              }else{
                 ol.Quantity=ol.Qty_ContractMonths__c;
              }
              
              if(ol.PriceBookEntry.Invoice_CancelFeePercent__c > 0){
                      ol.Invoice_CancelFeePercent__c=ol.PriceBookEntry.Invoice_CancelFeePercent__c;
              }else if(ol.PriceBookEntry.Product2.HasMediaSpend__c==True && ol.PriceBookEntry.MgmtFee_Percent__c == null){
                 //HasMediaSpend__c==True && MgmtFee_Percent__c ==null 
                 //For some custom products user enters Management Fee 
                 //and that should go on Cancellation Mgmt Fee field on OLI 
                 ol.Invoice_CancelFeePercent__c = ol.Mgmt_Fee_Percent__c;
              }else if(ol.PriceBookEntry.Invoice_CancelFeePercent__c==0){
                  
                      Integer intInputUnitPrice=Integer.valueof(ol.UnitPrice);
                      List<Automated_Rate_Calculation__c> outputList= New List<Automated_Rate_Calculation__c>();
                      
                      if(intInputUnitPrice>=SOCIALMgmtReachAd_MAX){
                         outputList=automatedRateCalculationUtil.getEmailBlastRate(intInputUnitPrice,1, ol.PriceBookEntryId);
                      }else{
                         outputList=automatedRateCalculationUtil.getEmailBlastRate(intInputUnitPrice,0, ol.PriceBookEntryId);
                      }
                      
                      if(outputList.size()>0) {
                         ol.Invoice_CancelFeePercent__c= outputList[0].MatrixResult__c;
                      }
               }
        }
        
        olifinalSave.addall(olineItemCM);
        
        Boolean dataValidate= oliDataValidate();
        if(dataValidate==False) {
               try{
                    if(olifinalSave.size()>0){
                        Insert(olifinalSave);
                    }
                }
                catch(Exception e){
                    ApexPages.addMessages(e);
                    return null;
                }  
                   
                // After save return the user to the Opportunity
                return new PageReference('/' + ApexPages.currentPage().getParameters().get('OppId'));
        }else{
                return null; 
        }
    }
    
    public Boolean oliDataValidate() {
        Boolean dataError=false;
        
        for(opportunityLineItem oli : olifinalSave){
           if(oli.Qty_LineItems__c== 0 || oli.Qty_LineItems__c== 0.00){
              dataError=True;
              oli.Qty_LineItems__c.addError('Must be nonzero.');
             
           }else if(oli.Qty_ContractMonths__c== 0 || oli.Qty_ContractMonths__c== 0.00){
              dataError=True;
              oli.Qty_ContractMonths__c.addError('Must be nonzero.');
           }else if(oli.Qty_LineItems__c < 0 || oli.Qty_LineItems__c > 25){
              dataError=True;
              oli.Qty_LineItems__c.addError('Must be be between 1 to 25.');
           }else if(oli.Email_Recipients_Qty__c < 10000){
              dataError=True;
              oli.Email_Recipients_Qty__c.addError('The Email - Recipients Qty field must contain the number 10,000 or larger.');
           }else if(oli.PriceBookEntry.PriceRangeMin__c!=null && oli.PriceBookEntry.PriceRangeMax__c!=null && (oli.UnitPrice < oli.PriceBookEntry.PriceRangeMin__c || oli.UnitPrice > oli.PriceBookEntry.PriceRangeMax__c)){
              dataError=True;
              oli.UnitPrice.addError('Must be within range : ' + oli.PriceBookEntry.PriceRangeMin__c + ' to ' + oli.PriceBookEntry.PriceRangeMax__c);
           }else if(oli.PriceBookEntry.PriceRangeMin__c==null && oli.PriceBookEntry.PriceRangeMax__c!=null && oli.UnitPrice > oli.PriceBookEntry.PriceRangeMax__c){
              dataError=True;
              oli.UnitPrice.addError('Must be less than or equal to: ' + oli.PriceBookEntry.PriceRangeMax__c); 
           }else if(oli.PriceBookEntry.PriceRangeMin__c!=null && oli.PriceBookEntry.PriceRangeMax__c==null && oli.UnitPrice < oli.PriceBookEntry.PriceRangeMin__c){
              dataError=True;
              oli.UnitPrice.addError('Must be greater than or equal to: ' + oli.PriceBookEntry.PriceRangeMin__c);
           }
           
        }
        for(wrapOpportunityLI wr : olineItemWrapperLI) {
           
           if(wr.parentOLI.Qty_LineItems__c <= 0 || wr.parentOLI.Qty_LineItems__c > 25){
              dataError=True;
              wr.parentOLI.Qty_LineItems__c.addError('Must be be between 1 to 25.');
           }
           if(wr.parentOLI.Email_Recipients_Qty__c < 10000){
              dataError=True;
              wr.parentOLI.Email_Recipients_Qty__c.addError('The Email - Recipients Qty field must contain the number 10,000 or larger.');
           }
           
        }
        return dataError;
    }
    
    // This function runs when user clicks Cancel button: back to Opportunity
    public PageReference onCancel(){
      //return the user to the Opportunity
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('OppId'));
    }
    
    /* The remoting method derives the pricing for Maps & Reputation*/
    @RemoteAction
    public static Decimal returnMatrixResult(Integer selectedNoOfLocs, String selectedPbeId){
    	Decimal retMatrixResult = 0;
    	List<Automated_Rate_Calculation__c> listResult = 
    		    automatedRateCalculationUtil.getEmailBlastRate(selectedNoOfLocs,1, selectedPbeId);
        if(listResult!=null && listResult.size()>0){
            retMatrixResult=listResult[0].MatrixResult__c;
        } 
        
        return retMatrixResult;
    }  
    
    // This function calculates Pricing fro Email blast and creates Child table
    public PageReference createChildTable(){
          
          Long intInputEmail;
          Decimal calculatedPrice;
		  Decimal matrixResult;
          Long intInputQLI;
          Integer pbeUnitPrice; 
          
          selectedEmailR=selectedEmailR.replace(',', '');
          selectedQLI=selectedQLI.replace(',', '');
          
          if(selectedEmailR!=null && !String.isEmpty(selectedEmailR)){
                try{
                   intInputEmail= Long.valueof(selectedEmailR);
                } catch (Exception e) {
                   intInputEmail= 0;
                }    
          }
          
          
          if(selectedQLI!=null && !String.isEmpty(selectedQLI)){
                try{
                   intInputQLI=Long.valueof(selectedQLI);
                } catch (Exception e) {
                   intInputQLI=0;
                } 
          }
          
          if(selectedUnitPrice!=null && !String.IsEmpty(selectedUnitPrice)){
          		try{
                   pbeUnitPrice= Integer.valueof(selectedUnitPrice);
                   if(pbeUnitPrice >0){
                   	  calculatedPrice = pbeUnitPrice;
                   }
                } catch (Exception e) {
                   pbeUnitPrice= 0;
                } 
          }
          
          if (pbeUnitPrice ==0 && intInputEmail!=null && intInputEmail >= 10000 && intInputQLI!=null){
             
             List<Automated_Rate_Calculation__c> listResult= automatedRateCalculationUtil.getEmailBlastRate(intInputEmail,intInputQLI,selectedPbeId);
             if(listResult!=null && listResult.size()>0){
			    matrixResult=listResult[0].MatrixResult__c;
                calculatedPrice=listResult[0].MatrixResult__c * intInputEmail;
             }
          }else{
                Integer count = 0;
                for(wrapOpportunityLI wr : olineItemWrapperLI) {
                        
                        if((String)wr.parentOLI.PriceBookEntryId==selectedPbeId){
                            wr.parentOLI.Email_Recipients_Qty__c=intInputEmail;
                            wr.parentOLI.Qty_LineItems__c=intInputQLI;
                            break;
                        }
                        count++;
                 }
          }
          
          childOpptyLI = new opportunityLineItem[]{};
          
          if(intInputQLI!=null && intInputQLI <=25 && intInputQLI > 0) {
                  for (Integer i = 0; i < intInputQLI ; i++) {
                      
                      childOpptyLI.add(new opportunityLineItem(OpportunityId=System.currentPagereference().getParameters().get('OppId'), 
                                                           PriceBookEntryId=selectedPbeId, 
                                                           UnitPrice=calculatedPrice,
                                                           TotalPrice=calculatedPrice,
														   Invoice_PriceVariable__c=matrixResult,
                                                           Qty_LineItems__c=1.00,
                                                           Qty_ContractMonths__c=1.00,
                                                           Email_Recipients_Qty__c=intInputEmail,
                                                           Quantity=1.00,
                                                           ServiceDate=Date.TODAY(),
                                                           End_Date__c=Date.TODAY()
                                                           ));
                  }
                  
                  Integer count = 0;
                  for(wrapOpportunityLI wr : olineItemWrapperLI) {
                        
                        if((String)wr.parentOLI.PriceBookEntryId==selectedPbeId){
                            renderchildTable=True;
                            wr.childOLI=childOpptyLI;
                            
                            break;
                        }else{
                            renderchildTable=False;
                        }
                        count++;
                   }
            }else{
                
                Integer count = 0;
                for(wrapOpportunityLI wr : olineItemWrapperLI) {
                        
                        if((String)wr.parentOLI.PriceBookEntryId==selectedPbeId){
                            wr.parentOLI.Qty_LineItems__c=intInputQLI;
                            if( wr.childOLI!=null){
                              wr.childOLI.clear();
                            }
                            
                            break;
                        }
                        count++;
                }
            } 
          
          return null;
    }
    //Wrapper class
    public class wrapOpportunityLI {
   
           public opportunityLineItem parentOLI {get; set;}
           public opportunityLineItem[] childOLI {get; set;}
           public String prodName {get; set;}
           public String pbookName {get; set;}
           
           public wrapOpportunityLI(opportunityLineItem pOLI,String pname,String pbname,opportunityLineItem[] cOLI) {
                parentOLI = pOLI;
                childOLI = cOLI;
                prodName=pname;
                pbookName=pbname;
           }
    
    }
         
}