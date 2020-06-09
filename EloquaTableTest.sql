 ///Developer:Chris Riedl\
///Name:Eloqua Table Test\
///Created:2020-05-26\
///TEST DATA FOR TRAINING
//Last recorded Runtime: 26.68 secs

Select Min("EC"."ACTIVITYDATE") as "MinDate"
,Max("EC"."ACTIVITYDATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_EMAILCLICKTHROUGH"' as "Table"

from "DEV_EDW"."CUST360"."T_S_EMAILCLICKTHROUGH" as "EC"

UNION ALL

Select Min("EB"."ACTIVITYDATE") as "MinDate"
,Max("EB"."ACTIVITYDATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_BOUNCEBACK"' as "Table"

from "DEV_EDW"."CUST360"."T_S_BOUNCEBACK" as "EB"

Union All

Select Min("EO"."ACTIVITYDATE") as "MinDate"
,Max("EO"."ACTIVITYDATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_EMAILOPEN"' as "Table"

from "DEV_EDW"."CUST360"."T_S_EMAILOPEN" as "EO"

UNION ALL

Select Min("ES"."ACTIVITYDATE") as "MinDate"
,Max("ES"."ACTIVITYDATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_EMAILSEND"' as "Table"

from "DEV_EDW"."CUST360"."T_S_EMAILSEND" as "ES"

Union All

Select Min("FS"."ACTIVITYDATE") as "MinDate"
,Max("FS"."ACTIVITYDATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_FORMSUBMIT"' as "Table"

from "DEV_EDW"."CUST360"."T_S_FORMSUBMIT" as "FS"

Union All

Select Min("PV"."ACTIVITYDATE") as "MinDate"
,Max("PV"."ACTIVITYDATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_PAGEVIEW" ' as "Table"

from "DEV_EDW"."CUST360"."T_S_PAGEVIEW" as "PV"

union all

Select Min("Sub"."ACTIVITYDATE") as "MinDate"
,Max("Sub"."ACTIVITYDATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_SUBSCRIBE"' as "Table"

from "DEV_EDW"."CUST360"."T_S_SUBSCRIBE" as "Sub"

Union All

Select Min("UnSub"."ACTIVITYDATE") as "MinDate"
,Max("UnSub"."ACTIVITYDATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_UNSUBSCRIBE"' as "Table"

from "DEV_EDW"."CUST360"."T_S_UNSUBSCRIBE" as "UnSub"

Union all

Select Min("WV"."ACTIVITYDATE") as "MinDate"
,Max("WV"."ACTIVITYDATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_WEBVISIT"' as "Table"

from "DEV_EDW"."CUST360"."T_S_WEBVISIT" as "WV"

Union All

Select Min("ACC"."DATE_CREATED") as "MinDate"
,Max("ACC"."DATE_CREATED") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_ACCOUNT"' as "Table"

from "DEV_EDW"."CUST360"."T_S_ACCOUNT" as "ACC"

Union all

Select Min("Camp"."CAMPAIGN_START_DATE") as "MinDate"
,Max("Camp"."CAMPAIGN_START_DATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_CAMPAIGN"' as "Table"

from "DEV_EDW"."CUST360"."T_S_CAMPAIGN" as "Camp"

Union all

Select Min("Camp"."CAMPAIGN_START_DATE") as "MinDate"
,Max("Camp"."CAMPAIGN_START_DATE") as "MaxDate"
,'"DEV_EDW"."CUST360"."T_S_CAMPAIGN_APR"' as "Table"

from "DEV_EDW"."CUST360"."T_S_CAMPAIGN_APR" as "Camp"

;
