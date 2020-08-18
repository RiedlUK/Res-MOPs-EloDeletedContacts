Select distinct 
case when gpe.Email_address not like '%/%' or gpe.Email_address not like '%__%'
        then gpe.Email_address 
     when gpe.Email_address like '%WOS%'
        then ''
        else GPe.EMAIL_DOI_CONCATENATED
end as Email_Address
                
,case when c.SUBSCRIPTION_STATUS1 is null
        then c2.SUBSCRIPTION_STATUS1
                else c.SUBSCRIPTION_STATUS1
 End as ContactSubscription
 
,case when gp.GLOBALLY_SUBSCRIPTION_STATUS is null 
        then gp2.GLOBALLY_SUBSCRIPTION_STATUS
                else gp.GLOBALLY_SUBSCRIPTION_STATUS
 end as PrefSubscription

from T_S_GLOBAL_AUTHORS_EMAIL gpe

Left join T_S_CONTACT c on c.emailaddress = gpe.email_address
        and c.SUBSCRIPTION_STATUS1 not in ( 'Unsubscribed','unsubscribed')
        
Left join T_S_ONEWILEY_GLOB_PREFERENCE gp on gp.Email_address = GPE.Email_address
        and gp.GLOBALLY_SUBSCRIPTION_STATUS = 'subscribed'
        
Left join T_S_CONTACT c2 on c2.emailaddress = GPe.EMAIL_DOI_CONCATENATED
        and c.SUBSCRIPTION_STATUS1 not in ( 'Unsubscribed','unsubscribed')
        
Left join T_S_ONEWILEY_GLOB_PREFERENCE gp2 on gp2.Email_address = GPe.EMAIL_DOI_CONCATENATED
        and gp2.GLOBALLY_SUBSCRIPTION_STATUS = 'subscribed'
      

;
        
        
       