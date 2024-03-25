
-- Standardize Date Format
SELECT Saleconverted, CONVERT(SaleDate, date)
FROM housing.`nashville housing data for data cleaning`;


ALTER TABLE housing.`nashville housing data for data cleaning`
ADD Saleconverte DATE;

----------------------------------------------------------------------------------------------------------------

-- Popululate Property Address Data

SELECT *
FROM housing.`nashville housing data for data cleaning`
-- WHERE PropertyAddress is not null;
ORDER BY ParcelID;


SELECT a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, coalesce(a.PropertyAddress, b.PropertyAddress)
FROM housing.`nashville housing data for data cleaning` AS A
JOIN housing.`nashville housing data for data cleaning` AS b
	ON a.ParcelID = b.ParcelID
	WHERE a.PropertyAddress is not null
	AND a.UniqueID <> b.UniqueID;
    
UPDATE housing.`nashville housing data for data cleaning` AS a
JOIN housing.`nashville housing data for data cleaning` AS b
    ON a.ParcelID = b.ParcelID
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NOT NULL
    AND a.UniqueID <> b.UniqueID
    AND a.ParcelID = a.UniqueID; 

----------------------------------------------------------------------------------------------------------------

-- Breaking out address into individual columns(Address, City, State)   

 
SELECT PropertyAddress
FROM housing.`nashville housing data for data cleaning`;
-- WHERE PropertyAddress is not null;
-- ORDER BY ParcelID;




SELECT 
  SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1) AS AddressPart1, 
  SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1) AS AddressPart2 
FROM housing.`nashville housing data for data cleaning` 
LIMIT 1000;

ALTER TABLE housing.`nashville housing data for data cleaning`
ADD PropertySplitAddress varchar(255);

UPDATE housing.`nashville housing data for data cleaning`
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1);

ALTER TABLE housing.`nashville housing data for data cleaning`
ADD PropertySplitCity varchar(255);

UPDATE housing.`nashville housing data for data cleaning`
SET PropertySplitCity =  SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1);

SELECT *
FROM housing.`nashville housing data for data cleaning`;

SELECT OwnerAddress
FROM housing.`nashville housing data for data cleaning`;

SELECT 
SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', 3), '.', -1) AS Part3,
SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', 2), '.', -1) AS Part2,
SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', 1), '.', -1) AS Part1
FROM housing.`nashville housing data for data cleaning`;


ALTER TABLE housing.`nashville housing data for data cleaning`
ADD OwnerSplitAddress varchar(255);

UPDATE housing.`nashville housing data for data cleaning`
SET OwnerSplitAddress = SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', 3), '.', -1) ;


ALTER TABLE housing.`nashville housing data for data cleaning`
ADD OwnerSplitCity varchar(255);

UPDATE housing.`nashville housing data for data cleaning`
SET OwnerSplitCity =  SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', 2), '.', -1) ;


ALTER TABLE housing.`nashville housing data for data cleaning`
ADD OwnerSplitState varchar(255);

UPDATE housing.`nashville housing data for data cleaning`
SET OwnerSplitState =  SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', 1), '.', -1) ;

select *
from housing.`nashville housing data for data cleaning`;

----------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No "Sold as vacant" field

select 
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
     end As TransformSoldVacant
from housing.`nashville housing data for data cleaning`;
     
----------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM housing.`nashville housing data for data cleaning`
)
select *
FROM RowNumCTE
Where row_num > 1
order by PropertyAddress;

-- Delete unused columns

select *
FROM housing.`nashville housing data for data cleaning`;


ALTER TABLE housing.`nashville housing data for data cleaning`
DROP COLUMN OwnerAddress;

ALTER TABLE housing.`nashville housing data for data cleaning`
DROP COLUMN TaxDistrict;

ALTER TABLE housing.`nashville housing data for data cleaning`
DROP COLUMN PropertyAddress;

ALTER TABLE housing.`nashville housing data for data cleaning`
DROP COLUMN SaleDate;
            

            

            
            

            



