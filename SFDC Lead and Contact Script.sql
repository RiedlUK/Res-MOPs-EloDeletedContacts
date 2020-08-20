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

from T_S_SFDC_CAMPAINGN_MEM cm
left join t_s_sfdc_campaign c on c.id = cm.campaignid
left join t_s_sfdc_user u on cm.OWNERID__C = u.id

where  c.ULTIMATE_PARENT_ID__C in ('7010W000002efsq','7010W0000023vOE','7010W0000027yf2')
and cm.CAMPAIGN_BUSINESS_UNIT__C != 'Research - SM - Society Marketing Strategy'
and lower(cm.email) not like '%@wiley.com%'
and cm.lastname not like '%Test'
and (u.title is null or cm.OWNERID__C != '005d0000002eSQVAA2') -- Eloqua Marketing USER
and cm.CAMPAIGN_MEMBER_ASSIGNED_DATE__C >= '2020-05-01'
and (u.USERROLEID is Null or u.USERROLEID not in ('00Ed0000000ieKCEAY' --RES Library Americas Marketing
                                                ,'00Ed0000000ibBlEAI'--RES Marketing
                                                ,'00E0W000001qIVfUAM'--RES Corporate Marketing
                                                ,'00Ed0000000ibBmEAI'--RES Marketing Manager	
                                                ,'00E0W000001qIVaUAM'--APAC Marketing
                                                ,'00Ed0000001hh9OEAQ'--Society Marketing
                                                ,'00E0W0000023QaYUAU'--APAC China Marketing
                                                ,'00Ed0000000eHPQEA2'--APAC Marketing
                                                ,'00Ed0000000hY27EAE'--Executive Management
                                                ,'00E0W000001qIVVUA2' --RES Library EMEA Marketing
                                                ))


;


---filter on USERROLEID in User table for "Marketing & Executive. Jimmy to send the IDs. 
--Role	15digitid	18digitid
--RES Library Americas Marketing	00Ed0000000ieKC	00Ed0000000ieKCEAY
--RES Marketing	00Ed0000000ibBl	00Ed0000000ibBlEAI
--RES Corporate Marketing	00E0W000001qIVf	00E0W000001qIVfUAM
--APAC Marketing	00E0W000001qIVa	00E0W000001qIVaUAM
--RES Marketing Manager	00Ed0000000ibBm	00Ed0000000ibBmEAI
--Society Marketing	00Ed0000001hh9O	00Ed0000001hh9OEAQ
--APAC China Marketing	00E0W0000023QaY	00E0W0000023QaYUAU
--APAC Marketing	00Ed0000000eHPQ	00Ed0000000eHPQEA2
--Executive Management	00Ed0000000hY27	00Ed0000000hY27EAE
--RES Library EMEA Marketing  00E0W000001qIVV  00E0W000001qIVVUA2

select count (ID)

from T_S_SFDC_CAMPAINGN_MEM


//where ID = '005d0000002eSQVAA2'

