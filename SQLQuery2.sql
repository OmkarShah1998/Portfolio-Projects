/*
Cleaning Data in SQL Queries
*/

select *
from PortfolioProject.dbo.NashvilleHousing

-- Standardize Date Format

select SaleDateConverted , convert(date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate= convert(date, SaleDate)

alter table NashvilleHousing
add SaleDateConverted date; 
update NashvilleHousing
set SaleDateConverted= convert(date, SaleDate)

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select*
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID , a.PropertyAddress, b.ParcelID, b. PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress= isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
substring (PropertyAddress ,1, charindex(',' , PropertyAddress)-1) as Address
,substring (PropertyAddress , charindex(',' , PropertyAddress)+1, len(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress varchar(255); 

update NashvilleHousing
set PropertySplitAddress = substring (PropertyAddress ,1, charindex(',' , PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity varchar(255);

update NashvilleHousing
set PropertySplitCity = substring (PropertyAddress , charindex(',' , PropertyAddress)+1, len(PropertyAddress))

select*
from PortfolioProject.dbo.NashvilleHousing

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select 
parsename(replace(owneraddress, ',' , '.' ), 3)
,parsename(replace(owneraddress, ',' , '.' ), 2)
,parsename(replace(owneraddress, ',' , '.' ), 1)
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress varchar(255); 

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(owneraddress, ',' , '.' ), 3)

alter table NashvilleHousing
add OwnerSplitCity varchar(255);

update NashvilleHousing
set OwnerSplitCity = parsename(replace(owneraddress, ',' , '.' ), 2)

alter table NashvilleHousing
add OwnerSplitState varchar(255);

update NashvilleHousing
set OwnerSplitState = parsename(replace(owneraddress, ',' , '.' ), 1)

select*
from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

with RowNumCTE AS(

select*,
	row_number () over (
	partition by ParcelID,
				 PropertyAddress,
				 Saleprice,
				 Saledate,
				 LegalReference
				 Order by
				       uniqueID
                    ) Row_Num

from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select*
from RowNumCTE
where Row_Num > 1
--order by PropertyAddress

select*
from PortfolioProject.dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select*
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress , Taxdistrict , PropertyAddress , Saledate

alter table PortfolioProject.dbo.NashvilleHousing
drop column Saledate
