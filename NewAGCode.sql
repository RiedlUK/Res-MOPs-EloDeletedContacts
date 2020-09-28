
select 
        esend.campaign_name as "Campaign Name"
        ,esend.job_number as "Job Number"
        ,bback.emailsbounced as "bouncebacks"
        ,esend.country as "Contact Country"
        ,esend.contactid as "Eloqua Contact ID"
        ,'' as "Segment ID"
        ,'' as "Segment"
        ,esend.orcid_id1 as "ORCID ID"
        ,esend.campaignid as "Eloqua Campaign ID"
        ,'' as "Journal Title"
        ,'' as "Journal Code"
        ,esend.assetid as "Email ID"
        ,esend.assetname as "Email Name"
        ,esend."YearMonth"
        ,esend.activitydate as "Email Send Date"
        ,tsend.emailssent as "Total Sends"
        ,cast(tsend.emailsSent as Int) - case when bback.emailsbounced is null then 0 else cast(bback.emailsbounced as Int) end as "Total Delivered"
        ,topen.emailsopened as "Total Opens"
        ,tclick.emailsclicked as "Total Clickthroughs"
        ,esend.emailaddress as "Email Address"
        ,tunsub.unsubscribed as "Total Unsubscribes by Email"
        ,bback.hardbounce as "Total Hard Bouncbacks"
        ,bback.softbounce as "Total Soft Bouncbacks"

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
                ,cast(concat(left(esend.activitydate,4),SUBSTRING(esend.activitydate, 6, 2 )) as int) as "YearMonth"
                ,'' as campaign_name
                ,'' as job_number
                ,c.country
                ,c.ORCID_ID1
                
                
        from dev_edw.cust360.t_s_emailsend esend
        join dev_edw.cust360.t_s_contact c on esend.contactid = c.contact_id 
                                           and cast(esend.activitydate as date)  > '2020-03-01 00:00:00.000'
                                           //and esend.campaignid = '25441'     
                                           and esend.campaignid in (
                                                                    select distinct Eloqua_campaign_id

                                                                      from dev_edw.CUST360.t_s_campaign c 
                                                                      inner join dev_edw.CUST360.t_s_EMAILSEND es on es.campaignid = c.eloqua_campaign_id 
                                                                                     and cast(es.activitydate as datetime)  > '2020-03-01 00:00:00.000'
                                                                                     and c.eloqua_campaign_id not in ('24013', //Global Program Campaigns (always on campaigns)
                                                                                                                   '24260',
                                                                                                                   '24853',
                                                                                                                   '25198',
                                                                                                                   '24878',
                                                                                                                   '25055',
                                                                                                                   '27387')                                                                                                    

                                                                      where c.sub_campaign_type = 'SUB'
                                                                      and c.business_unit not in ( 'OTHM-CV', 'OTHM-EDIT', 'OTHM-COMPUBB2B', 'OTHM-MV', 'OTHM-BFPR', 'OTHM-GIT', 'OTHM-COMEM', 'KL-PROFESSIONALLEARNING',
                                                                                                                     'KL-DIGITALDELIVERY', 'KL-PROFESSIONALDEVELOPMENT', 'KL-EDUCATION', 'KL-OTHER', 'TS-WORKPLACELEARNING',
                                                                                                                     'Knowledge & Learning - Education', 'KL-EDUCATION', 'KL-PROFESSIONALDEVELOPMENT', 'TS-WORKPLACELEARNING', 'RC-COMPUBB2B',
                                                                                                                     'KL-DIGITALDELIVERY', 'KL-PROFESSIONALLEARNING', 'OTHM-COMPUBB2B', 'OTHM-CV', 'RC-OTHER',
                                                                                                                     'Corporate - Internal communications within Wiley', 'CORP-INT', 'Research - Commercial Publishing/B2B',
                                                                                                                     'Knowledge & Learning - Professional Development', 'Talent Solutions & Ed Services - TS/Workplace Learning Solutions',
                                                                                                                     'Knowledge & Learning - Digital Delivery and Product Management', 'KL-LIBRARY', 'OTHM-MV', 'CORP-WILEYCOM', 'Corporate - Other',
                                                                                                                     'OTHM-BFPR', 'KL-OTHER', 'Knowledge & Learning - Professional Learning', 'KL-CORP', 'CORP-OTHER', 'CORP-CONF', 'OTHM-COMEM',
                                                                                                                     'OTHM-EDITOTH' ) 
                                                                    )
        )esend 


left join ( //joining total emails sent by UniqueSendID to main esend cohort.
           select 
                 concat( es.campaignid, '.', es.assetid,'.',es.contactid) as UniqueSendID
                 ,count(es.activityid) as EmailsSent
            
             
           from   dev_edw.cust360.t_s_emailsend es
             
           group by concat( es.campaignid, '.', es.assetid,'.',es.contactid)
             
           )tsend on esend.UniqueSendID = tsend.UniqueSendID
           
left join ( //joining total bouncebacks, soft bouncebacks and hard bouncebacks by UniqueBounceID to main esend cohort.
           select
                 concat(bb.assetid,'.',bb.contactid) as UniqueBounceID
                ,count(bb.activityid) EmailsBounced
                ,sum(case when left(bb.SMTPERRORCODE,1) = '5' then 1 else 0 end) HardBounce
                ,sum(case when left(bb.SMTPERRORCODE,1) = '4' then 1 else 0 end) SoftBounce
             
             from dev_edw.cust360.t_s_bounceback bb
             
             group by  concat(bb.assetid,'.',bb.contactid)
           )bback on esend.UniqueBounceID = bback.UniqueBounceID

left join ( //joining total emails opened by UniqueSendID to main esend cohort.     
             select 
                  concat(eo.campaignid,'.', eo.assetid, '.', eo.contactid) as UniqueSendID
                  ,count(eo.activityid) EmailsOpened
                  
             from dev_edw.cust360.t_s_emailopen eo
                  
             group by concat(eo.campaignid,'.', eo.assetid, '.', eo.contactid)
                  
            ) topen on esend.uniquesendid = topen.uniquesendid
            
left join ( //joining total emails clicked through by UniqueSendID to main esend cohort.
           select  
                 concat(ec.campaignid, '.', ec.assetid, '.', ec.contactid) as UniqueSendID
                 ,count(ec.activityid) EmailsClicked
                 
           from dev_edw.cust360.t_s_emailclickthrough ec
                 
           group by concat(ec.campaignid, '.', ec.assetid, '.', ec.contactid)
                 
              ) tclick on esend.uniquesendid = tclick.uniquesendid
              
left join ( //joining total unsubscribes through by UniqueSendID to main esend cohort.
            select 
                  concat(u.campaignid, '.', u.assetid, '.', u.contactid) as UniqueSendID,
                  count(u.activityid) as Unsubscribed
                   
             from dev_edw.cust360.t_s_unsubscribe u
                   
             group by concat(u.campaignid, '.', u.assetid, '.', u.contactid)
              
              )Tunsub on esend.uniquesendid = tunsub.uniquesendid 
              
 Order by   esend.activitydate desc

;


