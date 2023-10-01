
--Data Cleaning Portfolio Project
SELECT * 
FROM NashvillePropertyProject..NashvilleHousing

--Standardize the sale date Format
SELECT SaleDate, CONVERT(DATE, SaleDate) AS SaleDateTransformed
FROM NashvillePropertyProject..NashvilleHousing

--Updating Table with the new column Sale_Date
UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE, SaleDate)

--Removing the original SaleDate Column to SaleDateTransformed in the Table
ALTER TABLE NashvilleHousing
ADD SaleDateTransformed DATE;

UPDATE NashvilleHousing
SET SaleDateTransformed = CONVERT(DATE, SaleDate)

SELECT SaleDateTransformed, CONVERT(DATE, SaleDate) AS SaleDateTransformed
FROM NashvillePropertyProject..NashvilleHousing

--Populate Property Address
SELECT PropertyAddress
FROM NashvillePropertyProject..NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT *
FROM NashvillePropertyProject..NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT *
FROM NashvillePropertyProject..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

--The NULL PropertyAddress is having the repeated ParcelID (We can copy the PropertyAddress from there for the NULL values)
SELECT *
FROM NashvillePropertyProject..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT *
FROM NashvillePropertyProject..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY 2 --2(ParcelID) is a direct reference to the column no which we want to ORDER BY

--USing JOIN self Join to populate the address with NULL values & same ParcelID
SELECT *
FROM NashvillePropertyProject..NashvilleHousing a
JOIN NashvillePropertyProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID


SELECT a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress
FROM NashvillePropertyProject..NashvilleHousing a
JOIN NashvillePropertyProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL

--Now I'll copy the PropertAddress from b to a where Propert address is NULL
SELECT a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvillePropertyProject..NashvilleHousing a
JOIN NashvillePropertyProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL

--Here I'm copying Prperty Address and updating in the column
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvillePropertyProject..NashvilleHousing a
JOIN NashvillePropertyProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Breaking out PropertAddress into Individual Columns(Address, City, State) 
--SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address --1 here is the Part of address before comma (,)
--FROM NashvillePropertyProject..NashvilleHousing
----The above query will return the outpput with a comma(,) in order to remove the (,) we need to -1 as CHARINDEX(',', PropertyAddress) defines the length or position of (,) which is in 19th place of the string.
--SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address,
--CHARINDEX(',', PropertyAddress) --This will return 19 which is the Length.
--FROM NashvillePropertyProject..NashvilleHousing

--We will get the 1st Part of the Address before the comma (,)
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
--, CHARINDEX(',', PropertyAddress) 
FROM NashvillePropertyProject..NashvilleHousing


SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
	, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
--, CHARINDEX(',', PropertyAddress) 
FROM NashvillePropertyProject..NashvilleHousing

--Creating two separate columns for address
ALTER TABLE NashvilleHousing
ADD Property_Address NVARCHAR(255);

UPDATE NashvilleHousing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD Property_City NVARCHAR(255);

UPDATE NashvilleHousing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT * 
FROM NashvillePropertyProject..NashvilleHousing

--Now we i'll separate the OwnerAddress
--However, this time we will use PARSENAME function in the place of SUBSTRING
--One thing which will differ in writing the query with parse function is that the parse function dosen't take comma(,) as a delimiter
--Hence, I'll replace the comma(,) wit a dot(.)

SELECT OwnerAddress,
PARSENAME(OwnerAddress, 1)
FROM NashvillePropertyProject..NashvilleHousing
--This query will not cause the desired change in the output as I mentioned earlier PARSENAME dose not take COMMA(,) as delimiter
--Hence, I'm going to replace the comma(,) with Dot(.)
SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1) AS OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2) AS OwnerCity,
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3) AS OwnerState
FROM NashvillePropertyProject..NashvilleHousing

--This will return the desired result but values separated in opposite order as PARSENAME do the thing in opposite as compared to SUBSTRING function.
SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM NashvillePropertyProject..NashvilleHousing

--Trying to do the same thing with SUBSTRING function now
SELECT OwnerAddress,
SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress)-1)
, SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress)+1, LEN(OwnerAddress))
, SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress)+1, LEN(OwnerAddress))
--PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
--PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM NashvillePropertyProject..NashvilleHousing


--SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
--	, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address

--Adding Columns into table
ALTER TABLE NashvilleHousing
ADD Owner_Address NVARCHAR(255);

UPDATE NashvilleHousing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE NashvilleHousing
ADD Owner_State NVARCHAR(255);

UPDATE NashvilleHousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)


SELECT * 
FROM NashvillePropertyProject..NashvilleHousing


--Change Y & N to Yes & No in "Sold as vacant" field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvillePropertyProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant --or OEDER BY 2(which is column number)

--Use of CASE and END Satement
SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'N' THEN 'No'
	   WHEN SoldAsVacant = 'Y' THEN 'YES'
	   ELSE SoldAsVacant
	   END
FROM NashvillePropertyProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'No'
	   WHEN SoldAsVacant = 'Y' THEN 'YES'
	   ELSE SoldAsVacant
	   END

--Remove Duplicates
SELECT * FROM NashvillePropertyProject..NashvilleHousing

SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 Legalreference
				 ORDER BY 
					UniqueID
					) row_num
FROM NashvillePropertyProject..NashvilleHousing
ORDER BY ParcelID

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 Legalreference
				 ORDER BY 
					UniqueID
					) row_num
FROM NashvillePropertyProject..NashvilleHousing
--ORDER BY ParcelID
)
SELECT * FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

--Now deleting
DELETE 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 Legalreference
				 ORDER BY 
					UniqueID
					) row_num
FROM NashvillePropertyProject..NashvilleHousing
--ORDER BY ParcelID
)
--SELECT * FROM RowNumCTE
--WHERE row_num > 1
--ORDER BY PropertyAddress

--Now deleting
DELETE 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

---------------------------------------------------
WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 Legalreference
				 ORDER BY 
					UniqueID
					) row_num
FROM NashvillePropertyProject..NashvilleHousing
--ORDER BY ParcelID
)
SELECT * FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

--Delete unused columns
SELECT * FROM NashvillePropertyProject..NashvilleHousing

ALTER TABLE NashvillePropertyProject..NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, OwnerCity

ALTER TABLE NashvillePropertyProject..NashvilleHousing
DROP COLUMN SaleDate