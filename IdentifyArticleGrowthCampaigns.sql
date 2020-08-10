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
                                      
      ;

Select max(activitydate)
from t_s_EMAILSEND