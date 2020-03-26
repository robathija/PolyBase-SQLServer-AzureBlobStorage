-- Configure PolyBase (Sample Retail Planogram Data)

-- Values map to various external data sources.  
-- Example: value 7 stands for Hortonworks HDP 2.1 to 2.6 on Linux,
-- 2.1 to 2.3 on Windows Server, and Azure blob storage  
sp_configure @configname = 'hadoop connectivity', @configvalue = 7;
GO

RECONFIGURE
GO

/*Configuire External tables*/

--Create Master Key on the Db to encrypt the credential secret
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'N0T!meT0D!e';

--Database scoped credential for Azure blob storage
-- IDENTITY: any string (this is not used for authentication to Azure storage).  
-- SECRET: your Azure storage account key.  
CREATE DATABASE SCOPED CREDENTIAL AzurePlanogramStorageCredential 
WITH IDENTITY = 'user', Secret = '<azure_storage_account_key>'; --Can get it from MASE (Azure Stogare Explorer)

--Create external data source
-- LOCATION:  Azure account storage account name and blob container name.  
-- CREDENTIAL: The database scoped credential created above.  
CREATE EXTERNAL DATA SOURCE AzurePlanogramStorage with (  
      TYPE = HADOOP,
      LOCATION ='wasbs://<SRDPlanogramblob_container_name>@<azure_storage_account_name>.blob.core.windows.net',  
      CREDENTIAL = AzurePlanogramStorageCredential  
);


--Create external file format
-- FORMAT TYPE: Type of format in Hadoop (DELIMITEDTEXT,  RCFILE, ORC, PARQUET).
CREATE EXTERNAL FILE FORMAT csvformat 
WITH ( 
    FORMAT_TYPE = DELIMITEDTEXT, 
    FORMAT_OPTIONS ( 
        FIELD_TERMINATOR = ','
    ) 
);

--Create External Table 
-- LOCATION: path to file or directory that contains the data (relative to HDFS root).  
CREATE EXTERNAL TABLE [dbo].[POG_Data] (  
      [POG_DBKey] int NOT NULL,
      [POG_Name] NVARCHAR(MAX),
      [DisplayGroup] NVARCHAR,
      [DBStatus] int NOT NULL,
      [PendingDate] int NOT NULL,
      [LiveDate] int NOT NULL,
      [FinishedDate] int  
)  
WITH (LOCATION='/Demo/POGData',
      DATA_SOURCE = AzurePlanogramStorage,  
      FILE_FORMAT = csvformat  
);

--Create statistics on External Table (Maybe optional - I dunno, should check)
CREATE STATISTICS POGStats on POG_Data(POG_DBKey)

/*Querying Data*/

--Ad-hoc queries
SELECT *
FROM POG_Data POG
INNER JOIN SampleExistingRelationalDbTable TBL
ON POG.POG_DBKey = TBL.POG_DBKey
where POG.DisplayGroup = 'XYZ'
OPTION (FORCE EXTERNALPUSHDOWN);   -- or OPTION (DISABLE EXTERNALPUSHDOWN)  

--Importing external Data into SQL Server
SELECT COL1,COL2,POG_DBkey,POG_Name,DisplayGroup
INTO stg_POGSpecificData
FROM SampleExistingRelationalDbTable TBL
INNER JOIN
(SELECT *
FROM POG_Data POG where POG.DisplayGroup = 'XYZ') as PD
ON POG.POG_DBKey = TBL.POG_DBKey;

CREATE CLUSTERED COLUMNSTORE INDEX CCI_POG_Data ON stg_POGSpecificData; 

--Export Data from SQL Server into Azure Blob, coud be for archiving/logging/Data Lake Storage
-- Enable INSERT into external table
sp_configure 'allow polybase export', 1;  
reconfigure  

-- Create an external table.
CREATE EXTERNAL TABLE [dbo].[Historic_POG_Data] (  
      [POG_DBKey] int NOT NULL,
      [POG_Name] NVARCHAR(MAX),
      [DisplayGroup] NVARCHAR,
      [DBStatus] int NOT NULL,
      [PendingDate] int NOT NULL,
      [LiveDate] int NOT NULL,
      [FinishedDate] int  
)  
WITH (LOCATION='/Demo/Archive/POGData',
      DATA_SOURCE = AzurePlanogramStorage,  
      FILE_FORMAT = csvformat  
);

INSERT INTO dbo.Historic_POG_Data
SELECT *
FROM POG_Data POG
INNER JOIN SampleExistingRelationalDbTable TBL
ON POG.POG_DBKey = TBL.POG_DBKey
where POG.DBStatus = 'Historic';