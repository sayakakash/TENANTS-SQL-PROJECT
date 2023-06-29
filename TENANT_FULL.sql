/*a query to get Profile ID, Full Name and Contact Number of the tenant who has stayed
with us for the longest time period in the past*/

SELECT TOP 1 TH.profile_id, CONCAT(P.first_name, ' ', P.last_name) AS full_name, P.phone,
    DATEDIFF(day, TRY_CAST(TH.move_in_date AS date), TRY_CAST(TH.move_out_date AS date)) AS time_period, P.email_id
FROM [master].[dbo].[Tenancy History] TH
INNER JOIN [master].[dbo].[Profiles] P ON TH.profile_id = P.profile_id
WHERE TH.move_out_date IS NOT NULL
ORDER BY DATEDIFF(day, TRY_CAST(TH.move_in_date AS date), TRY_CAST(TH.move_out_date AS date)) DESC;



/*Write a query to get the Full name, email id, phone of tenants who are married and paying
rent > 9000 using subqueries*/

CREATE VIEW MarriedTenants_9000 AS
SELECT CONCAT(P.first_name, ' ', P.last_name) AS full_name, P.email_id, P.phone
FROM [master].[dbo].[Profiles] P
INNER JOIN [master].[dbo].[Tenancy History] TH ON P.profile_id = TH.profile_id
WHERE TH.rent > 9000 AND P.marital_status = 'Y';
GO

SELECT DISTINCT full_name, email_id, phone
FROM NewMarriedTenants;




/*Write a query to display profile id, full name, phone, email id, city , house id, move_in_date ,
move_out date, rent, total number of referrals made, latest employer and the occupational
category of all the tenants living in Bangalore or Pune in the time period of jan 2015 to jan
2016 sorted by their rent in descending order*/
SELECT
    DISTINCT(T.profile_id),
    T.full_name,
    T.phone,
    T.email_id,
    T.city,
    T.house_id,
    T.move_in_date,
    T.move_out_date,
    T.rent,
    T.total_referrals,
    T.latest_employer,
    T.occupational_category
FROM
    (
        SELECT
            P.profile_id,
            CONCAT(P.first_name, ' ', P.last_name) AS full_name,
            P.phone,
            P.email_id,
            P.city,
            TH.house_id,
            TH.move_in_date,
            TH.move_out_date,
            TH.rent,
            (
                SELECT COUNT(referral_valid)
                FROM [dbo].[Referral] R
                WHERE R.profile_id = P.profile_id
            ) AS total_referrals,
            E.latest_employer,
            E.occupational_category
        FROM
            [dbo].[Profiles] P
        INNER JOIN
            [dbo].[Referral] R ON R.profile_id = P.profile_id
        INNER JOIN
            [dbo].[Tenancy History] TH ON P.profile_id = TH.profile_id
        INNER JOIN
            (
                SELECT
                    profile_id,
                    latest_employer,
                    occupational_category
                FROM
                    [dbo].[Employee Status]
            ) E ON P.profile_id = E.profile_id
        WHERE
            P.city IN ('Bangalore', 'Pune')
            AND TH.move_in_date BETWEEN '2015-01-01' AND '2016-01-31'
            AND TH.move_out_date BETWEEN '2015-02-01' AND '2016-01-31'
    ) T
WHERE
    T.move_out_date IS NOT NULL 
ORDER BY
    T.rent DESC;



	/*Write a sql snippet to find the full_name, email_id, phone number and referral code of all
the tenants who have referred more than once.
Also find the total bonus amount they should receive given that the bonus gets calculated
only for valid referrals.*/
CREATE VIEW BonusView AS
SELECT
    full_name,
    email_id,
    phone,
    referral_code,
    total_referrals,
    SUM(CASE WHEN total_referrals > 0 THEN total_referrals * referrer_bonus_amount END) AS total_bonus_amount
FROM (
    SELECT
        CONCAT(P.first_name, ' ', P.last_name) AS full_name,
        P.email_id,
        P.phone,
        P.referral_code,
        COUNT(*) AS total_referrals,
        R.referrer_bonus_amount
    FROM
        [dbo].[Profiles] P
    INNER JOIN
        [dbo].[Referral] R ON P.profile_id = R.profile_id
    GROUP BY
        CONCAT(P.first_name, ' ', P.last_name),
        P.email_id,
        P.phone,
        P.referral_code,
        R.referrer_bonus_amount
) AS subquery
GROUP BY
    full_name,
    email_id,
    phone,
    referral_code,
    total_referrals;

SELECT * FROM BonusView




--Write a query to find the rent generated from each city and also the total of all cities.

CREATE VIEW allcitysum AS

SELECT
    city,
    total_of_each_city,
    total_of_all_cities
FROM (
    SELECT
        P.city,
        SUM(CONVERT(decimal(10, 2), TH.rent)) AS total_of_each_city,
        SUM(SUM(CONVERT(decimal(10, 2), TH.rent))) OVER () AS total_of_all_cities
    FROM
        [dbo].[Profiles] P
    INNER JOIN
        [dbo].[Tenancy History] TH ON P.profile_id = TH.profile_id
    GROUP BY
        P.city
) AS subquery;
select* from allcitysum




/*Create a view 'vw_tenant' find
profile_id,rent,move_in_date,house_type,beds_vacant,description and city of tenants who
shifted on/after 30th april 2015 and are living in houses having vacant beds and its address.*/
ALTER TABLE [dbo].[Addresses]
ADD city VARCHAR(100);


UPDATE [dbo].[Addresses]
SET city = 
    CASE
        WHEN description LIKE '%Bangalore%' THEN 'Bangalore'
        WHEN city LIKE '%Bangalore%' THEN 'Bangalore'
        WHEN pincode LIKE '%Bangalore%' THEN 'Bangalore'
        WHEN house_id LIKE '%Bangalore%' THEN 'Bangalore'
        WHEN ID LIKE '%Bangalore%' THEN 'Bangalore'
        WHEN description LIKE '%Delhi%' THEN 'Delhi'
        WHEN city LIKE '%Delhi%' THEN 'Delhi'
        WHEN pincode LIKE '%Delhi%' THEN 'Delhi'
        WHEN house_id LIKE '%Delhi%' THEN 'Delhi'
        WHEN ID LIKE '%Delhi%' THEN 'Delhi'
        WHEN description LIKE '%Pune%' THEN 'Pune'
        WHEN city LIKE '%Pune%' THEN 'Pune'
        WHEN pincode LIKE '%Pune%' THEN 'Pune'
        WHEN house_id LIKE '%Pune%' THEN 'Pune'
        WHEN ID LIKE '%Pune%' THEN 'Pune'
    END;



	CREATE VIEW vacantbed AS
	
SELECT distinct
    TH.profile_id,
    TH.rent,
    TH.move_in_date,
    H.house_type,
    H.beds_vacant,
    CONCAT(P.first_name, ' ', P.last_name) AS full_name,
	A.city
	
    
FROM
    [dbo].[Tenancy History] TH
INNER JOIN
    [dbo].[Houses] H ON TH.house_id = H.house_id
INNER JOIN
    [master].[dbo].[Profiles] P ON TH.profile_id = P.profile_id
 INNER JOIN
    [master].[dbo].[Addresses] A ON P.city = A.city
   
WHERE
    TH.move_in_date >= '2015-04-30'
    AND H.beds_vacant != 0;

	select* from vacantbed




	--Write a code to extend the valid_till date for a month of tenants who have referred more than two times

--people having more than 3 referrals
SELECT *
FROM (
    SELECT
       ( P.profile_id),
        (
            SELECT COUNT(referral_valid)
            FROM [dbo].[Referral] R
            WHERE R.profile_id = P.profile_id
        ) AS total_referrals
    FROM
        [dbo].[Profiles] P
    INNER JOIN
        [dbo].[Referral] R ON R.profile_id = P.profile_id
) AS subquery
WHERE total_referrals >2



--to extend the valid_till date for a month
WITH TempReferrals AS (
    SELECT referrer_bonus_amount, referral_valid, valid_from, valid_till, profile_id, ID
    FROM [dbo].[Referral]
)
SELECT  valid_from, DATEADD(MONTH, 1, valid_till) AS extended_valid_till, profile_id, ID
FROM TempReferrals
WHERE profile_id IN (
    SELECT profile_id
    FROM TempReferrals
    GROUP BY profile_id
    HAVING COUNT(referral_valid) > 2
);





/*Write a query to get Fullname, Contact, City and House Details of the tenants who have not
referred even once*/

 SELECT
    CONCAT(P.first_name, ' ', P.last_name) AS full_name,
    P.phone,
    P.city,
    H.house_id,
    H.house_type
FROM
    [dbo].[Profiles] P
INNER JOIN
    [dbo].[Tenancy History] T ON P.profile_id = T.profile_id
INNER JOIN
    [dbo].[Houses] H ON T.house_id = H.house_id
LEFT JOIN
    [dbo].[Referral] R ON P.profile_id = R.profile_id
WHERE
   (
        SELECT COUNT(referral_valid)
        FROM [dbo].[Referral] R
        WHERE R.profile_id = P.profile_id
    ) = 0;




	-- Write a query to get the house details of the house having highest occupancy
SELECT TOP 1 H.[house_type], H.[bhk_type], H.[bed_count], H.[furnishing_type], H.[beds_vacant], H.[house_id]
FROM [master].[dbo].[Houses] H
INNER JOIN (
    SELECT TH.[house_id], (CAST(H.[bed_count] AS INT) - CAST(H.[beds_vacant] AS INT)) AS occupancy
    FROM [master].[dbo].[Tenancy History] TH
    INNER JOIN [master].[dbo].[Houses] H ON TH.[house_id] = H.[house_id]
) AS O ON H.[house_id] = O.[house_id]
ORDER BY O.occupancy DESC;



