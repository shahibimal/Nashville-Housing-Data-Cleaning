/*
-----------------------------------------------------------------------------------------------
Nashville Housing Data Cleaning Project
Tool used: SQL Server (T-SQL)
Description: Standardizing raw housing data to improve quality for analysis.
Author: Bimal Shahi
-----------------------------------------------------------------------------------------------
*/

-- 01. Initial Data Inspection
SELECT * FROM portfoilioproject..NashvilleHousing;

-----------------------------------------------------------------------------------------------

-- 02. Standardize Date Format
-- Removing the timestamp from SaleDate to keep only the Date component.

ALTER TABLE portfoilioproject..NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE portfoilioproject..NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate);

-----------------------------------------------------------------------------------------------

-- 03. Populate Missing Property Address Data
-- Using a Self-Join to fill NULL PropertyAddress values based on matching ParcelIDs.

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM portfoilioproject..NashvilleHousing a
JOIN portfoilioproject..NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

-----------------------------------------------------------------------------------------------

-- 04. Breaking Property Address into Individual Columns (Street, City)
-- Using SUBSTRING and CHARINDEX for structured address columns.

SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Street,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM portfoilioproject..NashvilleHousing;

-----------------------------------------------------------------------------------------------

-- 05. Breaking Owner Address into Individual Columns (Street, City, State)
-- Using PARSENAME and REPLACE for more efficient string parsing.

ALTER TABLE portfoilioproject..NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255), OwnerSplitCity Nvarchar(255), OwnerSplitState Nvarchar(255);

UPDATE portfoilioproject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

-----------------------------------------------------------------------------------------------

-- 06. Standardize "Sold as Vacant" Field
-- Changing Y/N to Yes/No for data consistency.

UPDATE portfoilioproject..NashvilleHousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END;

-----------------------------------------------------------------------------------------------

-- 07. Remove Duplicates
-- Utilizing a CTE and ROW_NUMBER() to identify and isolate redundant records.

WITH MYDUPLICATEBUCKET AS (
	SELECT *,
	ROW_NUMBER() OVER( 
	PARTITION BY ParcelID, 
				  PropertyAddress, 
				  SalePrice, 
				  SaleDate, 
				  LegalReference
				  ORDER BY UniqueID
				  ) AS row_num
	FROM portfoilioproject..NashvilleHousing
)
-- To delete: DELETE FROM MYDUPLICATEBUCKET WHERE row_num > 1;
SELECT * FROM MYDUPLICATEBUCKET
WHERE row_num > 1;

-----------------------------------------------------------------------------------------------

-- 08. Final Review of Cleaned Data
SELECT * FROM portfoilioproject..NashvilleHousing;
