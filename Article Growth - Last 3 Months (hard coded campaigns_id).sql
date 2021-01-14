
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
                ,'' as campaign_name
                ,'' as job_number
                ,c.country
                ,c.ORCID_ID1
                
                
        from prod_edw.cust360.t_s_emailsend esend
        join prod_edw.cust360.t_s_contact c on esend.contactid = c.contact_id 
                                           and cast(esend.activitydate as datetime)  > '2020-03-01 00:00:00.000'
                                           //and esend.campaignid = '25441'     
                                           and esend.campaignid in (
                                                                     '25441', '25644', '25648', '26112', '26406', '26432', '26488', '26520', '26777', '26866', '26965', '26999', '27006',
                                                                     '27016', '27034', '27044', '27072', '27102', '27194', '27217', '27249', '27262', '27437', '27460', '27475', '27578',
                                                                     '27625', '27769', '27790', '27793', '27836', '27672', '27857', '28183', '28210', '28221', '28267','27317','27532',
                                                                     '28036','28063','28273','28352','28358','28381','28453','28543','28600','28630','28650','28660','28744','28778',
                                                                     '28803','28807')
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
 
 
               
      
       
  
