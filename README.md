# PolyBase-SQLServer-AzureBlobStorage

## /********** My PolyBase Mind Map **********/
/*

PolyBase enables your SQL Server instance to process T-SQL queries that read data from external data sources. 
SQL Server 2016 and higher - external data in Hadoop and Azure Blob Storage,
From SQL Server 2019- external data in SQL Server, Oracle, Teradata, and MongoDB.

PolyBase enables the following scenarios in SQL Server:

-Query data stored in Hadoop from SQL Server or PDW.

-Query data stored in Azure Blob Storage.

-Import data from Hadoop, Azure Blob Storage, or Azure Data Lake Store.
To Leverage the speed of Microsoft SQL's columnstore technology and analysis capabilities by importing data from Hadoop,
Azure Blob Storage, or Azure Data Lake Store into relational tables.

-No need for a separate ETL or import tool.

-Archive or export data to Hadoop, Azure Blob Storage,
or Azure Data Lake Store to achieve cost-effective storage and keep it online for easy access.

-PolyBase is compatible with Microsoft's BI stack,
or use any third party tools that are compatible with SQL Server.

Note:
Requires JRE installation while setting up SQL Server

In SSMS, it's accessible at: 
Databases > DBName > External Data Sources (myBlob)
Databases > DBName > External File Formats (exaple csvFormat)
Databases > DBName > Tables > External Tables > schema.tableName

Main source: https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-azure-blob-storage?view=sql-server-ver15


*/
