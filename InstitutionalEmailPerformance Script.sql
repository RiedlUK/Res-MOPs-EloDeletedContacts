select 
        esend.campaign_name as "Campaign Name"
        ,esend.job_number as "Job Number"        
        ,esend.contactid as "Eloqua Contact ID"
        ,'' as "Segment ID"
        ,'' as "Segment"
        ,esend.campaignid as "Eloqua Campaign ID"
        ,esend.assetid as "Email ID"
        ,esend.assetname as "Email Name"
        ,esend.activitydate as "Email Send Date"
        ,tsend.emailssent as "Total Sends"
        ,cast(tsend.emailsSent as Int) - case when bback.emailsbounced is null then 0 else cast(bback.emailsbounced as Int) end as "Total Delivered"
        ,topen.emailsopened as "Total Opens"
        ,tclick.emailsclicked as "total Clickthroughs"
        ,esend.emailaddress as "Email Address"
        ,tunsub.unsubscribed as "Total Unsubscribes by Email"
        ,bback.emailsbounced as "bouncebacks"
        ,bback.hardbounce as "Total Hard Bouncbacks"
        ,bback.softbounce as "Total Soft Bouncbacks"
        ,esend.business_unit

from ( //Creates the main cohort from the t_S_emailsendtable
        select --*
        
                concat( esend.campaignid, '.', esend.assetid,'.',esend.contactid) as UniqueSendID
                ,concat(esend.assetid,'.', esend.contactid) as UniqueBounceID
                ,esend.campaignid
                ,esend.assetid 
                ,esend.contactid
                ,esend.assetname 
                ,esend.emailaddress
                ,cast(esend.activitydate AS datetime) as activitydate
                ,ca.campaign_name
                ,ca.job_number
               ,ca.business_unit
                
                
        from prod_edw.cust360.t_s_emailsend esend
        join prod_edw.cust360.t_s_contact co on co.contact_id = esend.contactid and co.ROOT_INSTITUTIONAL_DOMAIN1 like '%.%'
        join prod_edw.cust360.t_s_campaign ca on esend.campaignid = ca.eloqua_campaign_id and cast(esend.activitydate as datetime) > dateadd(month,-12, getdate())                                                                                          
                                                                                         and ca.division = 'RC'
                                                                                                                                                                                                           
        join prod_edw.cust360.t_s_contact c on esend.contactid = c.contact_id 
        
        )esend 


left join ( //joining total emails sent by UniqueSendID to main esend cohort.
           select 
                 concat( es.campaignid, '.', es.assetid,'.',es.contactid) as UniqueSendID
                 ,count(es.activityid) as EmailsSent
            
             
           from   prod_edw.cust360.t_s_emailsend es
             
           group by concat( es.campaignid, '.', es.assetid,'.',es.contactid)
             
           )tsend on esend.UniqueSendID = tsend.UniqueSendID
           
left join ( //joining total bouncebacks, soft bouncebacks and hard bouncebacks by UniqueBounceID to main esend cohort.
           select
                 concat(bb.assetid,'.',bb.contactid) as UniqueBounceID
                ,count(bb.activityid) EmailsBounced
                ,sum(case when left(bb.SMTPERRORCODE,1) = '5' then 1 else 0 end) HardBounce
                ,sum(case when left(bb.SMTPERRORCODE,1) = '4' then 1 else 0 end) SoftBounce
             
             from prod_edw.cust360.t_s_bounceback bb
             
             group by  concat(bb.assetid,'.',bb.contactid)
           )bback on esend.UniqueBounceID = bback.UniqueBounceID

left join ( //joining total emails opened by UniqueSendID to main esend cohort.     
             select 
                  concat(eo.campaignid,'.', eo.assetid, '.', eo.contactid) as UniqueSendID
                  ,count(eo.activityid) EmailsOpened
                  
             from prod_edw.cust360.t_s_emailopen eo
                  
             group by concat(eo.campaignid,'.', eo.assetid, '.', eo.contactid)
                  
            ) topen on esend.uniquesendid = topen.uniquesendid
            
left join ( //joining total emails clicked through by UniqueSendID to main esend cohort.
           select  
                 concat(ec.campaignid, '.', ec.assetid, '.', ec.contactid) as UniqueSendID
                 ,count(ec.activityid) EmailsClicked
                 
           from prod_edw.cust360.t_s_emailclickthrough ec
                 
           group by concat(ec.campaignid, '.', ec.assetid, '.', ec.contactid)
                 
              ) tclick on esend.uniquesendid = tclick.uniquesendid
              
left join ( //joining total unsubscribes through by UniqueSendID to main esend cohort.
            select 
                  concat(u.campaignid, '.', u.assetid, '.', u.contactid) as UniqueSendID,
                  count(u.activityid) as Unsubscribed
                   
             from prod_edw.cust360.t_s_unsubscribe u
                   
             group by concat(u.campaignid, '.', u.assetid, '.', u.contactid)
              
              )Tunsub on esend.uniquesendid = tunsub.uniquesendid    