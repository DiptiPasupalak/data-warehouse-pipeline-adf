CREATE TABLE [file_upload_info]
(
	[source_file_name] [varchar](100) NOT NULL,
	[Transaction_Id] [varchar](100) NULL,
	[Event_Name] [varchar](100) NULL,
	[Ticket_Count] [varchar](100) NULL,
	[Total_Amount] [varchar](100) NULL,
	[channel] [varchar](100) NULL,
	[First_Name] [varchar](100) NULL,
	[Last_Name] [varchar](100) NULL,
	[Office_Location] [varchar](100) NULL,
	[Created_Date] [varchar](100) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

CREATE TABLE [d_country]
(
	[country_id] [int] NOT NULL,
	[country_code] [nvarchar](4000) NULL,
	[country_name] [nvarchar](4000) NULL,
	[iso_currency] [nvarchar](4000) NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [d_region]
(
	[id] [int] NOT NULL,
	[region_name] [varchar](32) NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [d_city]
(
	[id] [int] NOT NULL,
	[city_name] [varchar](32) NOT NULL,
	[city_code] [varchar](5) NOT NULL,
	[country_id] [int] NOT NULL,
	[region_id] [int] NOT NULL,
	[latitude] [float] NOT NULL,
	[longitude] [float] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [d_channel]
(
	[id] [int] NOT NULL,
	[channel_name] [varchar](32) NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [d_date]
(
	[id] [int] NOT NULL,
	[date] [date] NOT NULL,
	[day] [tinyint] NOT NULL,
	[day_suffix] [char](2) NOT NULL,
	[weekday] [tinyint] NOT NULL,
	[weekday_name] [varchar](10) NOT NULL,
	[day_of_week_in_month] [tinyint] NOT NULL,
	[day_of_year] [smallint] NOT NULL,
	[week_of_month] [tinyint] NOT NULL,
	[week_of_year] [tinyint] NOT NULL,
	[iso_week_of_year] [tinyint] NOT NULL,
	[month] [tinyint] NOT NULL,
	[month_name] [varchar](10) NOT NULL,
	[quarter] [tinyint] NOT NULL,
	[quarter_name] [varchar](6) NOT NULL,
	[year] [smallint] NOT NULL,
	[mmyyyy] [char](6) NOT NULL,
	[month_year] [char](8) NOT NULL,
	[first_day_of_month] [date] NOT NULL,
	[last_day_of_month] [date] NOT NULL,
	[first_day_of_quarter] [date] NOT NULL,
	[last_day_of_quarter] [date] NOT NULL,
	[first_day_of_year] [date] NOT NULL,
	[last_day_of_year] [date] NOT NULL,
	[first_day_of_next_month] [date] NOT NULL,
	[first_day_of_next_year] [date] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [d_organiser]
(
	[id] [int] NOT NULL,
	[organiser_name] [varchar](100) NOT NULL,
	[city_id] [int] NOT NULL,    
	[address_id] [int] NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [d_reseller]
(
	[id] [int] NOT NULL,
	[reseller_name] [varchar](100) NOT NULL,
	[city_id] [int] NOT NULL,    
	[address_id] [int] NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [d_event]
(
	[id] [int] NOT NULL,
	[event_name] [varchar](100) NOT NULL,
	[city_id] [int] NOT NULL,    
	[address_id] [int] NOT NULL,
	[start_date] [datetime2](7) NULL,
	[end_date]   [datetime2](7) NULL,
	[event_type] [varchar](50) NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [d_customer]
(
	[id] [int] NOT NULL,
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[address_id] [int] NOT NULL,
	[city_id] [int] NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [d_address]
(
	[id] [int] NOT NULL,
	[addressline1] [varchar](100) NOT NULL,
	[addressline2] [varchar](100) NOT NULL,
	[latitude] [float] NOT NULL,
	[longitude] [float] NOT NULL,
	[homephonenumber] [varchar](100) NOT NULL,
	[phonenumber] [varchar](100) NOT NULL,
	[emailaddress] [varchar](100) NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [d_event_seller]
(
	[id] [int] NOT NULL,
	[event_id] [int] NOT NULL,
	[organiser_id] [int] NOT NULL,
	[reseller_id] [int] NOT NULL,
	[seller_type] [varchar](100) NOT NULL,
	[commission_pct] [float] NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO

CREATE TABLE [f_transaction]
(
	[transaction_id] [int] NOT NULL,
	[event_id] [int] NOT NULL,
	[event_seller_id] [int] NOT NULL,
	[customer_id] [int]  NULL,
	[channel_id] [int]  NULL,
	[ticket_count] [int]  NULL,
	[ticket_amount] [float]  NULL,
	[commission_amount] [float]  NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = HASH(transaction_id),
	CLUSTERED COLUMNSTORE INDEX
)
GO

CREATE TABLE [f_event_sale_metric]
(
	[event_id] [int] NOT NULL,
	[date_id] [int] NOT NULL,
	[channel_id] [int] NOT NULL,
	[region_id] [int] NOT NULL,
	[city_id] [int] NOT NULL,
	[country_id] [int] NOT NULL,
	[organiser_id] [int] NOT NULL,
	[reseller_id] [int] NOT NULL,
	[ticket_count] [int]  NULL,
	[ticket_amount] [float]  NULL,
	[commission_amount] [float]  NULL
)
WITH
(
	DISTRIBUTION = HASH(event_id),
	CLUSTERED COLUMNSTORE INDEX
)
GO