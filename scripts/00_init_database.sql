/* 
====================================
Create Database & Schemas
====================================

Script Purpose:
		This script used to create new database 'DataWarehouse' after checking if it 
		already exists. Additionally, it is also used to create three schemas titled
		'bronze', 'silver' and 'gold'

Warning:
		Running this script will drop database 'DataWarehouse'
*/

USE master;

-- Drop and recreate Database 'DataWarehouse'
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	DROP DATABASE DataWarehouse;
END
GO

-- Create Database 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO


-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO