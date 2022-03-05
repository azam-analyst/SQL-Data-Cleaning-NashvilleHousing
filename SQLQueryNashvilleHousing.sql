--SQL DATA CLEANING WITH NASHVILLE HOUSING--

SELECT * from NashvilleHousing;

--Standardize Date format

SELECT SaleDate,CONVERT(Date,SaleDate)
FROM NashvilleHousing

ALTER table NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted= CONVERT(Date,SaleDate)

______________________________________________________________________________________________________________________

--Populate PropertyAddress 

SELECT *
FROM dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER by ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress IS NULL

______________________________________________________________________________________________________________

--Breaking Out PropertyAddress into Individual Column

SELECT PropertyAddress,PropertySplitAddress,PropertySplitCity
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
--ORDER by ParcelID


SELECT 
PropertyAddress
,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) As City
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(50)

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(50)

UPDATE NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

________________________________________________________________________________________________________________________

--Breaking Out OWNER ADDRESS into Individual Column

SELECT OwnerAddress
FROM NashvilleHousing

SELECT OwnerAddress
,PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(250)

UPDATE NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(250)

UPDATE NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(250)

UPDATE NashvilleHousing
SET OwnersplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM NashvilleHousing


____________________________________________________________________________________________________________________

--CASE statement(Chaning Y and N to Yes and No in SoldAsVacant Column)

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant
Order by 1

SELECT 
SoldAsVacant
, CASE 
	WHEN SoldAsVacant= 'Y' THEN 'Yes'
	WHEN SoldAsVacant='N' THEN 'No'
	ELSE SoldAsvacant
END as SoldAsvacantCorrected
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsvacant=CASE 
					WHEN SoldAsVacant= 'Y' THEN 'Yes'
					WHEN SoldAsVacant='N' THEN 'No'
					ELSE SoldAsvacant
					END


___________________________________________________________________________________________________________________

--REMOVING DUPLICATES with CTE

SELECT * from Nashvillehousing

With List_rownumbers As
(
	SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY	ParcelID,
					PropertyAddress,
					SaleDate,
					SalePrice,
					LegalReference
					ORDER BY
					UniqueID
					) row_number
	FROM NashvilleHousing
	)
SELECT * 
FROM List_rownumbers
WHERE row_number>1

_________________________________________________________________________________________________________________

--REMOVING UNUSED COLUMNS

ALTER TABLE NashvilleHousing
DROP COLUMN 
	PropertyAddress,
	SaleDate,
	OwnerAddress,
	TaxDistrict

SELECT * FROM NashvilleHousing









