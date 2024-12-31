
SELECT * 
FROM nashvile_housing
;

-- changing saledate to year and month in separate columns
ALTER TABLE
	nashvile_housing
ADD COLUMN year INT,
ADD COLUMN month INT;

UPDATE 
	nashvile_housing
SET year = EXTRACT(YEAR FROM saledate::date),
	month=EXTRACT(MONTH FROM saledate::date);
----
-- dealing with missing values for propertyaddress based on parcelid
UPDATE NASHVILE_HOUSING AS t1
SET propertyaddress = subquery.propertyaddress
FROM (
	SELECT PARCELID,
	propertyaddress
	FROM nashvile_housing
	WHERE propertyaddress is not null
)as subquery
WHERE t1.parcelid = subquery.parcelid
	AND t1.propertyaddress is null;

--Changing address to address and city
SELECT propertyaddress,
regexp_replace(propertyaddress, '^.*\s','') as CITY
FROM nashvile_housing 

SELECT propertyaddress, 
	regexp_replace(propertyaddress, '\s[^ ]+$','') as address
FROM nashvile_housing;

ALTER TABLE
	nashvile_housing
ADD COLUMN PropertySplitCity varchar(150);

UPDATE nashvile_housing
SET PropertySplitCity=regexp_replace(propertyaddress, '^.*\s','');

ALTER TABLE
	nashvile_housing
ADD COLUMN propertySplitAddress varchar(150);

UPDATE nashvile_housing
SET propertySplitAddress=regexp_replace(propertyaddress, '\s[^ ]+$','');

--Change owner address to address, city, state 
SELECT owneraddress,
regexp_replace(owneraddress, '^.*\s','') as owner_split_state
FROM nashvile_housing; 

SELECT owneraddress,
regexp_replace(owneraddress, '^.*\s([^ ]+)\s[^ ]+$', '\1','') as owner_split_CITY
FROM nashvile_housing; 

SELECT owneraddress,
regexp_replace(owneraddress, '\s[^ ]+\s[^ ]+$', '\1','') as owner_split_Address
FROM nashvile_housing;

ALTER TABLE
	nashvile_housing
ADD COLUMN owner_split_state VARCHAR(100),
ADD COLUMN owner_split_CITY VARCHAR(50),
ADD COLUMN owner_split_Address VARCHAR(50);

UPDATE nashvile_housing
SET owner_split_state=regexp_replace(owneraddress, '^.*\s',''),
owner_split_CITY=regexp_replace(owneraddress, '^.*\s([^ ]+)\s[^ ]+$', '\1',''),
owner_split_Address=regexp_replace(owneraddress, '\s[^ ]+\s[^ ]+$', '\1','');

-- change soldasvacant to yes or no. (deleting y or n)
SELECT DISTINCT soldasvacant, count(soldasvacant)
FROM nashvile_housing
GROUP BY soldasvacant
ORDER BY 2;

SELECT soldasvacant
, CASE WHEN soldasvacant = 'Y' THEN 'YES'
	   WHEN soldasvacant = 'N'	THEN 'NO'
	   ELSE soldasvacant 
	   END
FROM nashvile_housing;

UPDATE nashvile_housing
SET soldasvacant = CASE WHEN soldasvacant = 'YES' THEN 'Yes'
	   WHEN soldasvacant = 'NO'	THEN 'No'
	   ELSE soldasvacant 
	   END;

--Remove unused cols


ALTER TABLE nashvile_housing
DROP COLUMN taxdistrict;

SELECT * FROM nashvile_housing;