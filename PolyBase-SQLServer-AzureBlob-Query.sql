/********** PolyBase **********/
/*

PolyBase enables your SQL Server instance to process T-SQL queries that read data from external data sources. 
SQL Server 2016 and higher can access external data in Hadoop and Azure Blob Storage,
From SQL Server 2019, PolyBase can access external data in SQL Server, Oracle, Teradata, and MongoDB.

PolyBase enables the following scenarios in SQL Server:

-Query data stored in Hadoop from SQL Server or PDW. Users are storing data in cost-effective distributed and scalable systems,
such as Hadoop. PolyBase makes it easy to query the data by using T-SQL.

-Query data stored in Azure Blob Storage. Azure blob storage is a convenient place to store data for use by Azure services.
PolyBase makes it easy to access the data by using T-SQL.

-Import data from Hadoop, Azure Blob Storage, or Azure Data Lake Store.
Leverage the speed of Microsoft SQL's columnstore technology and analysis capabilities by importing data from Hadoop,
Azure Blob Storage, or Azure Data Lake Store into relational tables. There is no need for a separate ETL or import tool.

-Export data to Hadoop, Azure Blob Storage, or Azure Data Lake Store. Archive data to Hadoop, Azure Blob Storage,
or Azure Data Lake Store to achieve cost-effective storage and keep it online for easy access.

-Integrate with BI tools. Use PolyBase with Microsoft's business intelligence and analysis stack,
or use any third party tools that are compatible with SQL Server.

Note:
Requires JRE installation while setting up SQL Server

In SSMS, it's accessible at: 
Databases > DBName > External Data Sources (myBlob)
Databases > DBName > External File Formats (exaple csvFormat)
Databases > DBName

Main source: https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-azure-blob-storage?view=sql-server-ver15


*/