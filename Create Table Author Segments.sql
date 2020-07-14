

SELECT
adr.AUTHOR_STANDARDIZED_NAME AS AUTHOR,
AUTHOR.EMAIL_ADDRESS,
adr.PRID_ID,
adr.INSTITUTE,
COUNT(DISTINCT arts.UID) AS TOTAL_JOURNAL_ARTICLES,
product.DATASALON_CODE,
product.DATASALON_PRODUCT_TITLE,
--Frequency buckets
CASE WHEN frequency.AVERAGE_ARTICLES >= 5 THEN 'High Frequency'
WHEN frequency.AVERAGE_ARTICLES BETWEEN 2 AND 5 THEN  'Medium Frequency'
WHEN frequency.AVERAGE_ARTICLES BETWEEN 1 AND 2 THEN 'Low Frequency'
ELSE 'Occasional' END ALL_JOURNALS_FREQUENCY_SCORE,
--journal loyalty buckets
CASE WHEN (journal_loyalty.ONEYEAR_PAPERS > 0 AND journal_loyalty.TWOYEAR_PAPERS > 0 AND journal_loyalty.THREEYEAR_PAPERS > 0 AND journal_loyalty.FOURYEAR_PAPERS > 0) THEN 'Loyal' 
WHEN journal_loyalty.Current_Papers + journal_loyalty.ONEYEAR_PAPERS + journal_loyalty.TWOYEAR_PAPERS + journal_loyalty.THREEYEAR_PAPERS + journal_loyalty.FOURYEAR_PAPERS > 1 THEN 'Current'
WHEN (journal_loyalty.ONEYEAR_PAPERS = 1 OR journal_loyalty.Current_Papers = 1) AND journal_loyalty.TWOYEAR_PAPERS = 0 AND journal_loyalty.THREEYEAR_PAPERS = 0 AND journal_loyalty.FOURYEAR_PAPERS = 0 THEN 'New to Journal' 
ELSE 'One-time' end JOURNAL_LOYALTY_SCORE,
--impact buckets
CASE WHEN (AVG(cite_quartile.CITATION_QUARTILE) < 2) THEN 'High Impact'
WHEN (AVG(cite_quartile.CITATION_QUARTILE) < 3) THEN 'Mid Impact'
WHEN (AVG(cite_quartile.CITATION_QUARTILE) <= 4) THEN 'Low Impact'
ELSE 'No Impact' END ALL_JOURNALS_IMPACT_QUARTILE,
--Wiley/Non-Wiley split
CASE WHEN (wileyarts.WILEY_ARTS IS NULL) THEN 'No Wiley Papers'
WHEN ((wileyarts.WILEY_ARTS/CAST(COUNT(arts.UID) as numeric(15,6))) < 0.5) THEN  'Mostly Non-Wiley Papers'
WHEN ((wileyarts.WILEY_ARTS/CAST(COUNT(arts.UID) as numeric(15,6))) < 1) THEN 'Mostly Wiley Papers'
ELSE 'Only Wiley Papers' END WILEY_PAPER_SPLIT,

--Publisher loyalty buckets
CASE WHEN (publisher_loyalty.ONEYEAR_PAPERS > 0 AND publisher_loyalty.TWOYEAR_PAPERS > 0 AND publisher_loyalty.THREEYEAR_PAPERS > 0 AND publisher_loyalty.FOURYEAR_PAPERS > 0) THEN 'Loyal' 
WHEN publisher_loyalty.Current_Papers + publisher_loyalty.ONEYEAR_PAPERS + publisher_loyalty.TWOYEAR_PAPERS + publisher_loyalty.THREEYEAR_PAPERS + publisher_loyalty.FOURYEAR_PAPERS > 1 THEN 'Current'
WHEN (publisher_loyalty.ONEYEAR_PAPERS = 1 OR publisher_loyalty.Current_Papers = 1) AND publisher_loyalty.TWOYEAR_PAPERS = 0 AND publisher_loyalty.THREEYEAR_PAPERS = 0 AND publisher_loyalty.FOURYEAR_PAPERS = 0 THEN 'New to Publisher' 
ELSE 'One-time' end publisher_Loyalty_score

----------------------------------------------------------------------------------------------------------------
    
FROM prod_edw.ebac.DW_ARTICLE_EXTN arts
INNER JOIN prod_edw.ds.STG_LKP_PRODUCT product ON arts.JOURNAL_ID = product.EBAC_JOURNAL_ID
LEFT OUTER JOIN prod_edw.ebac.DW_AUTHOR_ADDRESS_EXTN adr ON adr.ARTICLE_ID = arts.ARTICLE_ID
LEFT OUTER JOIN prod_edw.ebac.DW_AUTHOR author ON arts.ARTICLE_ID = author.ARTICLE_ID


--Inline query creates the author frequency based on average papers in last 4 years. Joined on name/institute/PRID
---------------------------------------------------------------------------------------------------------------
LEFT OUTER JOIN (
    Select
    adr.AUTHOR_STANDARDIZED_NAME,
    adr.PRID_ID,
    adr.INSTITUTE,
    COUNT(distinct arts.UID)/4 AS AVERAGE_ARTICLES       
    FROM 
    prod_edw.ebac.DW_ARTICLE_EXTN arts
    INNER JOIN prod_edw.ebac.DW_AUTHOR_ADDRESS_EXTN Adr ON arts.ARTICLE_ID = adr.ARTICLE_ID    
    WHERE 
    arts.YEAR_PUBLISHED >= YEAR(CURRENT_DATE) - 4
    AND arts.YEAR_PUBLISHED < YEAR(CURRENT_DATE)
    AND arts.CITABLE_ITEM = 1
    AND adr.AUTHOR_STANDARDIZED_NAME IS NOT NULL
    AND adr.PRID_ID IS NOT NULL
    AND adr.INSTITUTE IS NOT NULL    
    GROUP BY
    adr.AUTHOR_STANDARDIZED_NAME,
    adr.PRID_ID,
    adr.INSTITUTE) frequency on (frequency.AUTHOR_STANDARDIZED_NAME = adr.AUTHOR_STANDARDIZED_NAME AND frequency.PRID_ID = adr.PRID_ID AND frequency.INSTITUTE = adr.INSTITUTE)
---------------------------------------------------------------------------------------------------------------


--Inline query creates the author journal loyalty based on papers/journal in the last 4 years + current. Joined on name/institute/PRID
---------------------------------------------------------------------------------------------------------------
LEFT OUTER JOIN (
    SELECT
    adr.AUTHOR_STANDARDIZED_NAME,
    adr.PRID_ID,
    adr.INSTITUTE,
    product.DATASALON_CODE,
    COUNT(DISTINCT(CASE WHEN arts.YEAR_PUBLISHED = YEAR(CURRENT_DATE) THEN arts.UID END)) AS Current_Papers,
    COUNT(DISTINCT(CASE WHEN arts.YEAR_PUBLISHED = YEAR(CURRENT_DATE)-1 THEN arts.UID END)) AS OneYear_Papers,
    COUNT(DISTINCT(CASE WHEN arts.YEAR_PUBLISHED = YEAR(CURRENT_DATE)-2 THEN arts.UID END)) AS TwoYear_Papers,
    COUNT(DISTINCT(CASE WHEN arts.YEAR_PUBLISHED = YEAR(CURRENT_DATE)-3 THEN arts.UID END)) AS ThreeYear_Papers,
    COUNT(DISTINCT(CASE WHEN arts.YEAR_PUBLISHED = YEAR(CURRENT_DATE)-4 THEN arts.UID END)) AS FourYear_Papers
    FROM
    prod_edw.ebac.DW_ARTICLE_EXTN arts
    INNER JOIN prod_edw.ds.STG_LKP_PRODUCT product ON arts.JOURNAL_ID = product.EBAC_JOURNAL_ID
    INNER JOIN prod_edw.ebac.DW_AUTHOR_ADDRESS_EXTN Adr ON arts.ARTICLE_ID = adr.ARTICLE_ID
    WHERE arts.CITABLE_ITEM = 1
    AND arts.YEAR_PUBLISHED >= YEAR(CURRENT_DATE) - 4
    AND adr.AUTHOR_STANDARDIZED_NAME IS NOT NULL
    AND adr.PRID_ID IS NOT NULL
    AND adr.INSTITUTE IS NOT NULL
    GROUP BY
    adr.AUTHOR_STANDARDIZED_NAME,
    adr.PRID_ID,
    adr.INSTITUTE,
    Product.Datasalon_Code) journal_loyalty ON (journal_loyalty.AUTHOR_STANDARDIZED_NAME = adr.AUTHOR_STANDARDIZED_NAME AND journal_loyalty.PRID_ID = adr.PRID_ID AND journal_loyalty.INSTITUTE = adr.INSTITUTE AND journal_loyalty.DATASALON_CODE = product.DATASALON_CODE)
---------------------------------------------------------------------------------------------------------------


--Inline query creates impact quartlies by article. Joined on article UID
---------------------------------------------------------------------------------------------------------------
LEFT OUTER JOIN (
        Select
        arts.ARTICLE_ID,
        NTILE(4) OVER (PARTITION BY subs.SUBJECT_CAT_DESC, arts.YEAR_PUBLISHED, arts.PRIMARY_TYPE ORDER BY COUNT(DISTINCT cites.CITED_UID || cites.CITING_UID) ASC) AS Citation_Quartile    
        FROM prod_edw.ebac.DW_ARTICLE_EXTN Arts
        INNER JOIN prod_edw.ebac.DW_SUBJECT_CATEGORY subs ON subs.ARTICLE_ID = arts.ARTICLE_ID
        INNER JOIN prod_edw.ds.STG_LKP_PRODUCT product ON arts.JOURNAL_ID = product.EBAC_JOURNAL_ID
        INNER JOIN prod_edw.ebac.DW_CITED_REFERENCE_EXTN cites ON arts.ARTICLE_ID = cites.CITED_ARTICLE_ID
        INNER JOIN prod_edw.ebac.DW_AUTHOR_ADDRESS_EXTN Adr ON arts.ARTICLE_ID = adr.ARTICLE_ID
        WHERE
        arts.CITABLE_ITEM = 1
        AND arts.YEAR_PUBLISHED >= YEAR(CURRENT_DATE) - 4
        AND adr.AUTHOR_STANDARDIZED_NAME IS NOT NULL
        AND adr.PRID_ID IS NOT NULL
        AND adr.INSTITUTE IS NOT NULL
        
        Group by 
        arts.ARTICLE_ID,
        subs.SUBJECT_CAT_DESC,
        arts.YEAR_PUBLISHED,
        arts.PRIMARY_TYPE) Cite_Quartile On Cite_Quartile.ARTICLE_ID = arts.ARTICLE_ID
---------------------------------------------------------------------------------------------------------------
        
        
--Inline query creates Wiley articles based on papers/journal in the last 4 years + current. Joined on name/institute/PRID
---------------------------------------------------------------------------------------------------------------
LEFT OUTER JOIN(
        SELECT
        adr.AUTHOR_STANDARDIZED_NAME,
        adr.PRID_ID,
        adr.INSTITUTE,
        COUNT(DISTINCT arts.UID) AS WILEY_ARTS
        
        FROM
        prod_edw.ebac.DW_ARTICLE_EXTN arts
        
        INNER JOIN prod_edw.ebac.DW_AUTHOR_ADDRESS_EXTN Adr ON arts.ARTICLE_ID = adr.ARTICLE_ID
        
        WHERE arts.CITABLE_ITEM = 1
        AND arts.PUBLISHER_GROUP = 'WILEY'
        AND arts.YEAR_PUBLISHED >= YEAR(CURRENT_DATE) - 4
        AND adr.AUTHOR_STANDARDIZED_NAME IS NOT NULL
        AND adr.PRID_ID IS NOT NULL
        AND adr.INSTITUTE IS NOT NULL        
        
        GROUP BY
        adr.AUTHOR_STANDARDIZED_NAME,
        adr.PRID_ID,
        adr.INSTITUTE) wileyarts ON (wileyarts.AUTHOR_STANDARDIZED_NAME = adr.AUTHOR_STANDARDIZED_NAME AND wileyarts.PRID_ID = adr.PRID_ID AND wileyarts.INSTITUTE = adr.INSTITUTE)
---------------------------------------------------------------------------------------------------------------


--Inline query creates the author publisher loyalty based on papers/journal in the last 4 years + current. Joined on name/institute/PRID
---------------------------------------------------------------------------------------------------------------
LEFT OUTER JOIN(
    SELECT
    adr.AUTHOR_STANDARDIZED_NAME,
    adr.PRID_ID,
    adr.INSTITUTE,
    arts.PUBLISHER_GROUP,
    COUNT(DISTINCT(CASE WHEN arts.YEAR_PUBLISHED = YEAR(CURRENT_DATE) THEN arts.UID END)) AS Current_Papers,
    COUNT(DISTINCT(CASE WHEN arts.YEAR_PUBLISHED = YEAR(CURRENT_DATE)-1 THEN arts.UID END)) AS OneYear_Papers,
    COUNT(DISTINCT(CASE WHEN arts.YEAR_PUBLISHED = YEAR(CURRENT_DATE)-2 THEN arts.UID END)) AS TwoYear_Papers,
    COUNT(DISTINCT(CASE WHEN arts.YEAR_PUBLISHED = YEAR(CURRENT_DATE)-3 THEN arts.UID END)) AS ThreeYear_Papers,
    COUNT(DISTINCT(CASE WHEN arts.YEAR_PUBLISHED = YEAR(CURRENT_DATE)-4 THEN arts.UID END)) AS FourYear_Papers
    FROM
    prod_edw.ebac.DW_ARTICLE_EXTN arts
    INNER JOIN prod_edw.ebac.DW_AUTHOR_ADDRESS_EXTN Adr ON arts.ARTICLE_ID = adr.ARTICLE_ID
    WHERE arts.CITABLE_ITEM = 1
    AND arts.YEAR_PUBLISHED >= YEAR(CURRENT_DATE) - 4
    AND adr.AUTHOR_STANDARDIZED_NAME IS NOT NULL
    AND adr.PRID_ID IS NOT NULL
    AND adr.INSTITUTE IS NOT NULL
    GROUP BY
    adr.AUTHOR_STANDARDIZED_NAME,
    adr.PRID_ID,
    adr.INSTITUTE,
    arts.PUBLISHER_GROUP) publisher_loyalty ON (publisher_loyalty.AUTHOR_STANDARDIZED_NAME = adr.AUTHOR_STANDARDIZED_NAME AND publisher_loyalty.PRID_ID = adr.PRID_ID AND publisher_loyalty.INSTITUTE = adr.INSTITUTE AND publisher_loyalty.PUBLISHER_GROUP = arts.PUBLISHER_GROUP)
---------------------------------------------------------------------------------------------------------------


WHERE
arts.YEAR_PUBLISHED >= YEAR(CURRENT_DATE) - 4
AND arts.CITABLE_ITEM = 1
AND adr.AUTHOR_STANDARDIZED_NAME IS NOT NULL
AND adr.PRID_ID IS NOT NULL
AND adr.INSTITUTE IS NOT NULL

Group by
AUTHOR,
adr.PRID_ID,
adr.INSTITUTE,
product.DATASALON_CODE,
product.DATASALON_PRODUCT_TITLE,
All_Journals_Frequency_score,
Journal_Loyalty_score,
publisher_Loyalty_score,
wileyarts.WILEY_ARTS;

select *

FROM prod_edw.ebac.DW_ARTICLE_EXTN arts

