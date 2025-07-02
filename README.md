General structure

This codebase is an example of building a small data warehouse pipeline with Azure Data Factory and Azure SQL Data Warehouse. Understanding each directory’s role will help when extending or modifying the ETL process.

The pipeline depends on Azure Data Factory. Linked services describe how to connect to the SQL warehouse and blob storage. Datasets define the schema for both the input files and the SQL table.

The mapping data flow loads CSV files from the sales folder, captures the original file path, then stages them into the file_upload_info table after clearing it.

Stored procedures upsert_f_transaction_put and upsert_f_event_sale_metric_put read from file_upload_info, update existing fact records, insert new ones, and refresh statistics. The INSTR helper function helps parse reseller IDs from the source file name.

This repository is an example of an Azure based ETL pipeline. Key components are organized by directory:

Database/        -- SQL scripts that create and seed tables and define stored procs
dataset/         -- Azure Data Factory dataset definitions
dataflow/        -- A Data Factory mapping data flow
linkedService/   -- ADF linked service (connection) definitions
pipeline/        -- ADF pipeline definition
sample_input_file/ -- Example CSV files used as input

Database setup

Database/1_table.sql 

defines all tables used in the warehouse
including dimension tables (d_country, d_city, etc.)
fact tables (f_transaction, f_event_sale_metric) and the staging table file_upload_info.

Database/2_seed.sql 

populates dimensions and provides a few initial transactions for testing

Database/3_date_seed.sql and Database/4_date_seed.sql 

create a number helper table and populate a d_date dimension with calculated fields such as day suffix, week of year, etc..

Database/5_instr.sql defines a small INSTR helper function used in the stored procedures

Database/6_upsert_f_event_sale_metric_put.sql 

Database/7_upsert_f_transaction_put.sql contain the stored procedures executed after ingestion to upsert into the fact tables.

Data Factory definitions

dataset/ 

holds dataset declarations for example 

reseller_thirdparty_source.json describes the CSV format stored in blob storage
file_upload_info.json maps the destination SQL table schema.

linkedService/ 

defines connections to the SQL Data Warehouse and to blob storage

dataflow/reseller_file_upload_dataflow.json 

contains the mapping data flow that reads from blob storage, moves files from the sales folder to history, and writes to file_upload_info while truncating the table first.

pipeline/reseller_file_upload.json orchestrates the entire process

it runs the data flow, then executes the two stored procedures sequentially to load f_transaction and f_event_sale_metric.

Sample data

sample_input_file/ contains CSV examples showing the expected input format: Transaction_Id, Event_Name, ticket counts, etc.
