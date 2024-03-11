/*

Cleaning Data in SQL Queries

*/


Select *
From PorfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------

-- Standardize Data Format 


Select SaleDateConverted, CONVERT(Date,SaleDateConverted)
From PorfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDateConverted)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDateConverted)


------------------------------------------------------------------------------------------------------

--Populate Property Address Data


Select *
From PorfolioProject.dbo.NashvilleHousing
--Where PropertyAddres
order by ParcelID


Select a.ParcelID, a.PropertySplitAddress, b.ParcelID, b.PropertySplitAddress, ISNULL(a.PropertySplitAddress,b.PropertySplitAddress)
From PorfolioProject.dbo.NashvilleHousing a
JOIN PorfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertySplitAddress is null


UPDATE a
SET PropertySplitAddress = ISNULL(a.PropertySplitAddress,b.PropertySplitAddress)
From PorfolioProject.dbo.NashvilleHousing a
JOIN PorfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertySplitAddress is null




-----------------------------------------------------------------------------------------------

-- Break out  Address individual Columns (Address, City, State)


Select PropertySplitAddress
From PorfolioProject.dbo.NashvilleHousing
--Where PropertyAddres
--order by ParcelID

Select
SUBSTRING(PropertySplitAddress, 1, CHARINDEX(',', PropertySplitAddress) -1 ) as Address
, SUBSTRING(PropertySplitAddress, CHARINDEX(',', PropertySplitAddress)  +1 , LEN(PropertySplitAddress)) as Address

From PorfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertySplitAddress, 1, CHARINDEX(',', PropertySplitAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertySplitAddress, CHARINDEX(',', PropertySplitAddress) -1 , LEN(PropertySplitAddress)) 


Select *
From PorfolioProject.dbo.NashvilleHousing




Select OwnerSplitAddress
From PorfolioProject.dbo.NashvilleHousing



Select
PARSENAME(REPLACE(OwnerSplitAddress, ',', ',') ,3)
,PARSENAME(REPLACE(OwnerSplitAddress, ',', ',') ,2)
,PARSENAME(REPLACE(OwnerSplitAddress, ',', ',') ,1)
From PorfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerSplitAddress, ',', ',') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerSplitAddress, ',', ',') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerSplitAddress, ',', ',') , 1)


Select *
From PorfolioProject.dbo.NashvilleHousing




-----------------------------------------------------------------------------------------------------------


--Change Y and N to Yes and No in Sold as Vacant Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PorfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PorfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
      When SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END







-----------------------------------------------------------------------------------------------------------

---Remuve Duplicates

WITH RowNumCTE AS(
Select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				    UniqueID
					) row_num


From PorfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertySplitAddress



Select *
From PorfolioProject.dbo.NashvilleHousing 












----------------------------------------------------------------------------------------------

--Delete Unused Columns



Select *
From PorfolioProject.dbo.NashvilleHousing 


ALTER TABLE PorfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerSplitAddress, TaxDistrict, PropertyAddress

ALTER TABLE PorfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDateConverted