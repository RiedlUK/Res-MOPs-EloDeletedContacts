 select
cm.id as campaign_member_id
,cm.campaignid
,cm.leadorcontactid
,cm.email
,cm.leadsource
,cm.companyoraccount
,cm.type as lead_or_contact
,cm.CAMPAIGN_MEMBER_TO_OPPORTUNITY_STATUS__C
,cm.LEAD_CONTACT_COUNTRY__C
,cm.LEAD_SOURCE__C
,cm.CAMPAIGN_BUSINESS_UNIT__C
,c.ULTIMATE_PARENT_ID__C
,c.CAMPAIGN_NAME Campaign 
,cm.CAMPAIGN_MEMBER_ASSIGNED_DATE__C 
,cm.UNQUALIFIED_REASON__C
,cm.PRIMARY_PRODUCT_INTEREST__C as Primary_Product
,u.name as Owner_Name
,u.title as Owner_Role

   from T_S_SFDC_CAMPAINGN_MEM cm
   join 
   
   (select id as campaignid, ULTIMATE_PARENT_ID__C,  name as campaign_name, max(lastmodifieddate) lastmodifieddate
       
       from t_s_sfdc_campaign
       where ULTIMATE_PARENT_ID__C in ('7010W000002efsq','7010W0000023vOE','7010W0000027yf2')
        group by id, ULTIMATE_PARENT_ID__C, campaign_name
       ) c on cm.campaignid = c.campaignid
     
     left join t_s_sfdc_user u on cm.leadorcontactownerid = u.id
   
  where cm.CAMPAIGN_BUSINESS_UNIT__C != 'Research - SM - Society Marketing Strategy'
    and lower(cm.email) not like '%@wiley.com%'
    and u.lastname not like '%Test'
    and (u.title is null or lower(u.title) not like '%marketing%')
  
  
  