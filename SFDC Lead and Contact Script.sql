select distinct

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
,c.name 
,cm.CAMPAIGN_MEMBER_ASSIGNED_DATE__C 
,cm.UNQUALIFIED_REASON__C
,cm.PRIMARY_PRODUCT_INTEREST__C as Primary_Product
,u.lastname
,u.title

from T_S_SFDC_CAMPAINGN_MEM cm
left join T_s_sfdc_campaign c on c.id = cm.campaignid
left join t_s_sfdc_user u on cm.leadorcontactownerid = u.id


where  c.ULTIMATE_PARENT_ID__C in ('7010W000002efsq','7010W0000023vOE','7010W0000027yf2')
and cm.CAMPAIGN_BUSINESS_UNIT__C != 'Research - SM - Society Marketing Strategy'
and lower(cm.email) not like '%@wiley.com%'
and cm.lastname not like '%Test'
--and (u.title is null or (lower(u.title) not like '%marketing%' ) ) 

and cm.CAMPAIGN_MEMBER_ASSIGNED_DATE__C >= '2020-05-01'