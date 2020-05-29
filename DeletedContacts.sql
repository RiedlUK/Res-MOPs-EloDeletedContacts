///Header

Select distinct * 


From

(
      Select "ContactID" //This is Contact ID
    ,"Email Address" // This is an Email Address
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_BLANKDATA_DEC_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_BLANKDATA_DEC_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_BLANKDATA_NOV_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_BLANKDATA_NOV_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_HARDBOUNCEBACK_DEC_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_HARDBOUNCEBACK_DEC_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_HARDBOUNCEBACK_NOV_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_HARDBOUNCEBACK_NOV_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_HARDBOUNCEBACK_OCT_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_HARDBOUNCEBACK_OCT_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_HARDBOUNCEBACK_SEP_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_HARDBOUNCEBACK_SEP_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_KL_LEADS_SEP_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_KL_LEADS_SEP_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_NEVERMAILED1YR_OCT_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_NEVERMAILED1YR_OCT_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_NEVERMAILED2YR_DEC_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_NEVERMAILED2YR_DEC_2019"


    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_NEVERMAILED2YR_NOV_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_NEVERMAILED2YR_NOV_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_NONRESPONSIVES_DEC_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_NONRESPONSIVES_DEC_2019"


    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_NONRESPONSIVES_NOV_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_NONRESPONSIVES_NOV_2019"


    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_UNCATEGORIZED_DEC_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_UNCATEGORIZED_DEC_2019"


    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_UNCATEGORIZED_NOV_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_UNCATEGORIZED_NOV_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_UNCATEGORIZED_OCT_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_UNCATEGORIZED_OCT_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_UNCATEGORIZED_SEP_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_UNCATEGORIZED_SEP_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_UNSUBSCRIBES_DEC_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_UNSUBSCRIBES_DEC_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_UNSUBSCRIBES_NOV_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_UNSUBSCRIBES_NOV_2019"


    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_UNSUBSCRIBES_OCT_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_UNSUBSCRIBES_OCT_2019"

    Union

    Select "ContactID"
    ,"Email Address"
    ,"First Name"
    ,"Last Name"
    ,"Country"
    ,'DEL_CONTACT_UNSUBSCRIBES_SEP_2019' as "Segment"


    from "ELOQUA"."ELOQUA_PROD_SCHEMA"."DEL_CONTACT_UNSUBSCRIBES_SEP_2019"
  ) 
  
// where "Email Address" = 'e.aram@tavinstitute.org'
  ;
  
select *

from "ELOQUA"."ELOQUA_PROD_SCHEMA"."CONTACT_OCT_2019"


