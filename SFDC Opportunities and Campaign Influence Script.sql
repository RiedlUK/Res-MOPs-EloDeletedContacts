select distinct
o.id as Opportunity_id
,o.name as opportunity_name
,o.stagename as opp_stage
,o.amount as opp_ammount
,o.type as opp_type
,o.isclosed
,o.iswon
,o.lost_reason__C as opp_lost_reason
,o.account_name__C as account_name
,o.opportunity_owner_name__C as opp_owner_name
,o.product_summary__C as product_summary
,o.OWNER_ROLE_NAME__C as owner_role_name
,o.ESTIMATED_AMOUNT__C as opp_estimated_amount
,o.AMOUNT_AT_CLOSEDATE_FX_RATE_IN_USD__C as AMOUNT_AT_CLOSEDATE_FX_RATE_IN_USD
,o.FIELD_DESCRIPTION__C as opp_field_description
,o.PRIMARY_PRODUCT__C as primary_product_id
,o.PRIMARY_PRODUCT_NAME__C as primary_product_name
,o.PRIMARY_PRODUCT_QUANTITY__C as primary_product_quantity
,o.SALES_REP_NAME__C as sales_rep_name
,case when ci.opportunity__C is null then 'N' else 'Y' end as Marketing_Impact_flag //marketing has had influence from the top of the funnel through a campaign.
,ci.campaign__c as MI_campaignid
,ci.CAMPAIGNS_ULTIMATE_PARENT__C as MI_ultimate_parent_id
,ci.CAMPAIGN_BUSINESS_UNIT__C as MI_campaign_business_unit
,ci.CAMPAIGN_TYPE__C as MI_campaign_type
,case when ci.opportunity__c is null and ac.opportunity_id is not null then 'Y' else 'N' end as Marketing_Influence_flag //marketing has had influence at the bottom of the funnel and not through a campaign.
,ac.activity_subject
,ac.activity_type
,o.CLOSEDATE as opp_closed_date
,rt.name as opp_record_type
,o.SHORT_NAME__C as opp_short_name
,c.name as Contact_name
,o.contactid 
,o.PRICE_BOOK_NAME__C as price_book_name
,o.fiscalyear

from t_s_sfdc_opportunity o
join t_s_sfdc_rec_type rt on o.recordtypeid = rt.id // adds in the record name for the opportunities record type
                          and o.fiscalyear = '2021' // Filtering the opportunities to a specific fiscal year
                          
left join t_s_sfdc_contact c on o.contactid = c.id //adds in contact name data

left join (// This left join adds in the data where a campaign has had marketing influence (Marketing Impact Flag field)
          select distinct
          ci.opportunity__C
          ,ci.campaign__c
          ,ci.CAMPAIGNS_ULTIMATE_PARENT__C
          ,ci.CAMPAIGN_BUSINESS_UNIT__C
          ,ci.CAMPAIGN_TYPE__C
          ,c.name campaign_name
          
          
          from t_s_sfdc_campaign_influence ci
          left join t_s_sfdc_opportunity o on ci.opportunity__c = o.id
          join t_s_sfdc_campaign c on ci.campaign__C = c.id                                                 
                                   and ( left(ci.CAMPAIGNS_ULTIMATE_PARENT__C,15) in ('7010W000002efsq', '7010W0000023vOE')  and CAMPAIGN_BUSINESS_UNIT__C not like '%society%' 
                                                                                                                             and o.fiscalyear = '2021') //CHANGE for new financial year
                                   
                                   or ( left(ci.CAMPAIGNS_ULTIMATE_PARENT__C,15) = '7010W0000027yf2' and CAMPAIGN_BUSINESS_UNIT__C not like '%society%' )
                                   
          ) ci on o.id = ci.opportunity__C

left join (//This left join adds in the opportunity task (also called activities) information that relates to marketing activity
           
           Select t.whatid opportunity_id
                        ,t.subject activity_subject
                        ,t.type activity_type
                        
                        
                        
                        from t_s_sfdc_task t
                        join t_s_sfdc_rec_type rt on t.recordtypeid = rt.id
                                                  and rt.name = 'Marketing Activity'
                                                  and OWNER_ROLE_ID__C in ('00Ed0000000eHPQ', '00E0W000001qIVf', '00E0W000001qIVV', '00Ed0000000ieKC', '00E0W0000023QaY')
                                                  and lower(t.type) not like '%social%'
                                                  and lower(t.subject)not like '%ala%'                          
                          ) ac on o.id = ac.opportunity_id

where o.fiscalyear = '2021' //CHANGE for new financial year