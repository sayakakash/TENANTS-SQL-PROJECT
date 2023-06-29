Database Setup
1) Create a database 'Tenant'
2) Create tables with following specifications
2.1) Tenancy_histories
Field Type Null Key Default
id int(11) NO PRI auto_increment
profile_id int(11) NO FK
house_id int(11) NO FK
move_in_date date NO
move_out_date date YES
rent int(11) NO
Bed_type varchar(255) YES
move_out_reason varchar(255) YES

2.2) Profiles
Field Type Null Key Default
profile_id int(11) NO PRI auto_increment
first_name varchar(255) YES
last_name varchar(255) YES
email varchar(255) NO
phone varchar(255) NO
city(hometown) varchar(255) YES
pan_card varchar(255) YES
created_at date NO
gender varchar(255) NO
referral_code varchar(255) YES
marital_status varchar(255) YES

2.3) Houses
Field Type Null Key Default
house_id int(11) NO PRI auto_increment
house_type varchar(255) YES
bhk_details varchar(255) YES
bed_count int(11) NO
furnishing_type varchar(255) YES
Beds_vacant int(11) NO

2.4) Addresses
Field Type Null Key Default
ad_id int(11) NO PRI auto_increment
name varchar(255) YES
description text YES
pincode int(11) YES
city varchar(255) YES
house_id int(11) NO FK

2.5) Referrals
Field Type Null Key Default
ref_id int(11) NO PRI auto_increment
referrer_id(same as profile id) int(11) NO FK
referrer_bonus_amount float YES
referral_valid tinyint(1) YES 0/1
valid_from date YES
valid_till date YES

2.6) Employment_details
Field Type Null Key Default
id int(11) NO PRI auto_increment
profile_id int(11) NO FK
latest_employer varchar(255) YES
official_mail_id varchar(255) YES
yrs_experience int(11) YES
Occupational_category varchar(255) YES





1)
 Write a query to get Profile ID, Full Name and Contact Number of the tenant who has stayed
with us for the longest time period in the past

2)
Write a query to get the Full name, email id, phone of tenants who are married and paying
rent > 9000 using subqueries

3)
Write a query to display profile id, full name, phone, email id, city , house id, move_in_date ,
move_out date, rent, total number of referrals made, latest employer and the occupational
category of all the tenants living in Bangalore or Pune in the time period of jan 2015 to jan
2016 sorted by their rent in descending order

4)
Write a sql snippet to find the full_name, email_id, phone number and referral code of all
the tenants who have referred more than once.

5)Also find the total bonus amount they should receive given that the bonus gets calculated
only for valid referrals.

6)
  Write a query to find the rent generated from each city and also the total of all cities.Create a view 'vw_tenant' find
profile_id,rent,move_in_date,house_type,beds_vacant,description and city of tenants who
shifted on/after 30th april 2015 and are living in houses having vacant beds and its address.

7)
Write a code to extend the valid_till date for a month of tenants who have referred more
than two times

8)
Write a query to get Profile ID, Full Name , Contact Number of the tenants along with a new
column 'Customer Segment' wherein if the tenant pays rent greater than 10000, tenant falls
in Grade A segment, if rent is between 7500 to 10000, tenant falls in Grade B else in Grade C

9)
Write a query to get Fullname, Contact, City and House Details of the tenants who have not
referred even once

10 Write a query to get the house details of the house having highest occupancy
