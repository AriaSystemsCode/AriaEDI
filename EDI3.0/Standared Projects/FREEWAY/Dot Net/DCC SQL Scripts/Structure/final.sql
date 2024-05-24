
--Table dbo.INVENTORY_DETAILS_T

--Create table and its columns
CREATE TABLE [dbo].[INVENTORY_DETAILS_T] (
	[PARTNER_ID] [varchar](20) NULL,
	[INVINTORY_ADVICE_ID] [varchar](20) NULL,
	[BUYER_STYLE] [varchar](30) NULL,
	[VENDOR_STYLE] [varchar](30) NULL,
	[VENDOR_STYLE_DESCRIPTION] [varchar](100) NULL,
	[QUANTITY] [int] NULL,
	[AVAILABLE] [bit] NULL,
	[UNIT_PRICE] [decimal](13, 2) NULL,
	[RETAIL_PRICE] [decimal](13, 2) NULL,
	[UPC] [varchar](100) NULL,
	[INVENTORY_HEADER_KEY] [bigint] NOT NULL,
	[INVENTORY_DETAILS_KEY] [bigint] NOT NULL IDENTITY (1, 1));


--Table dbo.INVENTORY_HEADER_T


--Create table and its columns
CREATE TABLE [dbo].[INVENTORY_HEADER_T] (
	[PARTNER_ID] [varchar](20) NOT NULL,
	[INVINTORY_ADVICE_ID] [varchar](20) NOT NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[PURPOSE_CODE] [varchar](30) NULL,
	[PURPOSE_DESCRIPTION] [varchar](100) NULL,
	[INVENTORY_NAME] [varchar](100) NULL,
	[INVENTORY_ADDRESS_1] [varchar](100) NULL,
	[INVENTORY_ADDRESS_2] [varchar](100) NULL,
	[INVENTORY_CITY] [varchar](30) NULL,
	[INVENTORY_STATE] [varchar](30) NULL,
	[INVENTORY_ZIP] [varchar](30) NULL,
	[INVENTORY_COUNTRY] [varchar](30) NULL,
	[CONTACT_NAME] [varchar](100) NULL,
	[CONTACT_PHONE] [varchar](30) NULL,
	[CONTACT_FAX] [varchar](30) NULL,
	[CONTACT_EMAIL] [varchar](100) NULL,
	[INVENTORY_HEADER_KEY] [bigint] NOT NULL IDENTITY (1, 1));

--Table dbo.INVOICE_CHARGES_T


--Create table and its columns
CREATE TABLE [dbo].[INVOICE_CHARGES_T] (
	[INVOICE_HEADER_KEY] [int] NULL,
	[PARTNER_ID] [varchar](20) NOT NULL,
	[INVOICE_NUMBER] [varchar](30) NOT NULL,
	[SERVICE_TYPE] [varchar](2) NULL,
	[SERVICE_CODE] [varchar](20) NULL,
	[SERVICE_DESCRIPTION] [text] NULL,
	[AMOUNT] [decimal](13, 2) NULL,
	[PERCENT] [decimal](6, 2) NULL,
	[HANDLING_METHOD] [char](2) NULL,
	[INVOICE_CHARGES_KEY] [int] NOT NULL IDENTITY (1, 1));


--Table dbo.INVOICE_DETAILS_T

--Create table and its columns
CREATE TABLE [dbo].[INVOICE_DETAILS_T] (
	[INVOICE_HEADER_KEY] [int] NULL,
	[PARTNER_ID] [varchar](20) NOT NULL,
	[INVOICE_NUMBER] [varchar](30) NOT NULL,
	[ARSTATUS] [varchar](50) NULL,
	[VENDOR_ITEM] [varchar](50) NULL,
	[VENDOR_STYLE] [varchar](50) NULL,
	[VENDOR_COLOR] [varchar](50) NULL,
	[VENDOR_SIZE] [varchar](50) NULL,
	[ITEM_DESCRIPTION] [varchar](80) NULL,
	[ITEM_DESCRIPTION1] [varchar](80) NULL,
	[COLOR_DESCRIPTION] [varchar](80) NULL,
	[SIZE_DESCRIPTION] [varchar](80) NULL,
	[BUYER_ITEM] [varchar](50) NULL,
	[BUYER_STYLE] [varchar](50) NULL,
	[BUYER_COLOR] [varchar](50) NULL,
	[BUYER_SIZE] [varchar](50) NULL,
	[COLOR_NRF] [varchar](50) NULL,
	[SIZE_NRF] [varchar](50) NULL,
	[UPC_NUMBER] [varchar](50) NULL,
	[QUANTITY_INVOICED] [int] NULL,
	[PACK] [int] NULL,
	[INNER_PACK] [int] NULL,
	[UOM] [varchar](20) NULL,
	[UNIT_PRICE] [decimal](15, 2) NULL,
	[GROSS_PRICE] [decimal](15, 2) NULL,
	[DISCOUNT_PERCENT] [decimal](6, 2) NULL,
	[RETAIL_PRICE] [decimal](15, 2) NULL,
	[UNIT_COST] [decimal](15, 2) NULL,
	[CATALOG_PRICE] [decimal](15, 2) NULL,
	[PROMOTIONAL_PRICE] [decimal](15, 2) NULL,
	[INVOICE_DETAILS_KEY] [int] NOT NULL IDENTITY (1, 1));


--Table dbo.INVOICE_HEADER_T




--Create table and its columns
CREATE TABLE [dbo].[INVOICE_HEADER_T](
	[SENDER_ID] [varchar](20) NULL,
	[PARTNER_ID] [varchar](20) NOT NULL,
	[INVOICE_NUMBER] [varchar](30) NOT NULL,
	[DATE] [datetime] NULL,
	[SHIP_DATE] [datetime] NULL,
	[RETAILER_PO] [varchar](30) NULL,
	[RETAILER_PO_RELEASE] [varchar](30) NULL,
	[RETAILER_PO_DATE] [datetime] NULL,
	[CONSOLIDATED_INVOICE] [varchar](30) NULL,
	[BOL] [varchar](30) NULL,
	[PURCHASER_CURRENCY] [varchar](10) NULL,
	[SELLING_CURRENCY] [varchar](10) NULL,
	[EXCHANGE_RATE] [decimal](13, 4) NULL,
	[EFFECTIVE_DATE] [datetime] NULL,
	[CONTRACT_NUMBER] [varchar](20) NULL,
	[DEPARTMENT] [varchar](30) NULL,
	[PROMOTION_CODE] [varchar](30) NULL,
	[MERCHANDISE_TYPE] [varchar](30) NULL,
	[VENDOR_ORDER] [varchar](30) NULL,
	[VENDOR_NUMBER] [varchar](30) NULL,
	[TERMS_DISCOUNT_PERCENT] [decimal](6, 2) NULL,
	[TERMS_DISCOUNT_AMOUNT] [decimal](13, 2) NULL,
	[TERMS_DISCOUNT_DUE_DATE] [datetime] NULL,
	[TERMS_DISCOUNT_DAYS_DUE] [int] NULL,
	[TERMS_NET_DUE_DATE] [datetime] NULL,
	[TERMS_NET_DAYS] [int] NULL,
	[TERMS_DESCRIPTION] [text] NULL,
	[CARTONS] [int] NULL,
	[PIECES] [int] NULL,
	[WEIGHT] [decimal](13, 2) NULL,
	[WEIGHT_UOM] [varchar](20) NULL,
	[VOLUME] [decimal](13, 2) NULL,
	[VOLUME_UOM] [varchar](20) NULL,
	[INVOICE_AMOUNT] [decimal](13, 2) NULL,
	[SHIP_AMOUNT] [decimal](13, 2) NULL,
	[TRANSPORTATION] [text] NULL,
	[EQUIPMENT_NUMBER] [varchar](20) NULL,
	[ROUTING] [text] NULL,
	[INVOICE_HEADER_KEY] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_INVOICE_HEADER_T] PRIMARY KEY CLUSTERED 
(
	[PARTNER_ID] ASC,
	[INVOICE_NUMBER] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


--Table dbo.INVOICE_LOCATIONS_T




--Create table and its columns
CREATE TABLE [dbo].[INVOICE_LOCATIONS_T] (
	[INVOICE_HEADER_KEY] [int] NULL,
	[PARTNER_ID] [varchar](20) NOT NULL,
	[INVOICE_NUMBER] [varchar](30) NOT NULL,
	[LOCATION_TYPE] [varchar](2) NULL,
	[LOCATION] [varchar](20) NULL,
	[GLN_NUMBER] [varchar](13) NULL,
	[DUNS_NUMBER] [varchar](9) NULL,
	[NAME] [varchar](100) NULL,
	[ADDRESS_1] [varchar](100) NULL,
	[ADDRESS_2] [varchar](100) NULL,
	[CITY] [varchar](30) NULL,
	[STATE] [varchar](30) NULL,
	[ZIP] [varchar](30) NULL,
	[COUNTRY] [varchar](30) NULL,
	[CONTACT] [varchar](100) NULL,
	[PHONE] [varchar](30) NULL,
	[FAX] [varchar](30) NULL,
	[INVOICE_LOCATIONS_KEY] [int] NOT NULL IDENTITY (1, 1));


--Table dbo.PO_ADDRESS_T




--Create table and its columns
CREATE TABLE [dbo].[PO_ADDRESS_T] (
	[PARTNER_ID] [char](20) NULL,
	[RETAILER_PO] [char](30) NULL,
	[ADDRESS_TYPE] [char](10) NULL,
	[LOCATION_CODE] [char](20) NULL,
	[NAME] [char](100) NULL,
	[ADDRESS_LINE_1] [char](100) NULL,
	[ADDRESS_LINE_2] [char](100) NULL,
	[CITY] [char](30) NULL,
	[STATE] [char](30) NULL,
	[ZIP_CODE] [char](30) NULL,
	[COUNTRY] [char](30) NULL,
	[CONTACT] [char](30) NULL,
	[PHONE] [char](30) NULL,
	[EMAIL_ADDRESS] [char](100) NULL,
	[GLN_NUMBER] [char](20) NULL,
	[DUNS_NUMBER] [char](20) NULL,
	[PO_ADDRESS_KEY] [uniqueidentifier] NULL);


--Table dbo.PO_CHARGES_T




--Create table and its columns
CREATE TABLE [dbo].[PO_CHARGES_T] (
	[PARTNER_ID] [char](20) NULL,
	[RETAILER_PO] [char](30) NULL,
	[ITEM_LINE_NO] [bigint] NULL,
	[CHARGE_TYPE] [char](20) NULL,
	[CHARGE_CODE] [char](50) NULL,
	[CHARGE_DESCRIPTION] [text] NULL,
	[CHARGE_AMOUNT] [decimal](13, 2) NULL,
	[METHOD_OF_HANDLING] [char](20) NULL,
	[PO_CHARGES_KEY] [uniqueidentifier] NULL);


--Table dbo.PO_HEADER_T




--Create table and its columns
CREATE TABLE [dbo].[PO_HEADER_T] (
	[PARTNER_ID] [char](20) NOT NULL,
	[RETAILER_PO] [char](30) NOT NULL,
	[TRANSACTION_TYPE] [char](2) NOT NULL,
	[ENTERED] [datetime] NULL,
	[RELEASE_NUMBER] [char](30) NULL,
	[BLANKET_NUMBER] [char](30) NULL,
	[CONTRACT_NUMBER] [char](30) NULL,
	[MERCHANDISE_TYPE] [char](30) NULL,
	[PROMOTION_CODE] [char](30) NULL,
	[PO_TYPE] [char](30) NULL,
	[VENDOR_NUMBER] [char](30) NULL,
	[DEPARTMENT] [char](30) NULL,
	[BUYER] [char](100) NULL,
	[ORDER_CONTACT] [char](30) NULL,
	[DELIVERY_CONTACT] [char](30) NULL,
	[DELIVERY_REQUESTED] [datetime] NULL,
	[CANCEL_AFTER] [datetime] NULL,
	[REQUESTED_SHIP] [datetime] NULL,
	[SHIP_NOT_BEFORE] [datetime] NULL,
	[DONT_DELIVER_AFTER] [datetime] NULL,
	[DONT_DELIVER_BEFORE] [datetime] NULL,
	[HANDLING_INSTRUCTIONS] [text] NULL,
	[FULFILLMENTSERVICELEVEL] [char](30) NULL,
	[PO_HEADER_KEY] [uniqueidentifier] NULL);


--Table dbo.PO_ITEM_DISTENTION_T




--Create table and its columns
CREATE TABLE [dbo].[PO_ITEM_DISTENTION_T] (
	[PARTNER_ID] [char](20) NULL,
	[RETAILER_PO] [char](30) NULL,
	[ITEM_LINE_NO] [bigint] NULL,
	[LOCATION_ID] [char](20) NULL,
	[QUANTITY_ORDERED] [int] NULL,
	[UOM] [char](20) NULL,
	[PO_ITEM_DISTENTION_KEY] [uniqueidentifier] NULL);


--Table dbo.PO_ITEMS_T




--Create table and its columns
CREATE TABLE [dbo].[PO_ITEMS_T] (
	[PARTNER_ID] [char](20) NULL,
	[RETAILER_PO] [char](30) NULL,
	[ITEM_LINE_NO] [bigint] NULL,
	[VENDOR_ITEM] [char](50) NULL,
	[VENDOR_STYLE] [char](50) NULL,
	[VENDOR_COLOR] [char](50) NULL,
	[VENDOR_SIZE] [char](50) NULL,
	[BUYER_ITEM] [char](50) NULL,
	[BUYER_STYLE] [char](50) NULL,
	[BUYER_COLOR] [char](50) NULL,
	[BUYER_SIZE] [char](50) NULL,
	[COLOR_NRF] [char](50) NULL,
	[SIZE_NRF] [char](50) NULL,
	[UPC_NUMBER] [char](50) NULL,
	[ITEM_DESCRIPTION] [text] NULL,
	[INNER_CONTAINERS] [int] NULL,
	[CONTAINER_EACHES] [int] NULL,
	[QUANTITY_ORDERED] [int] NULL,
	[UOM] [char](20) NULL,
	[UNIT_PRICE] [decimal](13, 2) NULL,
	[CATALOGUE_PRICE] [decimal](13, 2) NULL,
	[RETAIL_PRICE] [decimal](13, 2) NULL,
	[SUGGESTED_RETAIL_PRICE] [decimal](13, 2) NULL,
	[PROMOTIONAL_PRICE] [decimal](13, 2) NULL,
	[REQUEST_SHIP_DATE] [datetime] NULL,
	[DELIVERY_REQUESTED_DATE] [datetime] NULL,
	[HANDLING_INSTRUCTIONS] [text] NULL,
	[PO_ITEMS_KEY] [uniqueidentifier] NULL);


--Table dbo.PO_MESSAGES_T




--Create table and its columns
CREATE TABLE [dbo].[PO_MESSAGES_T] (
	[PARTNER_ID] [char](20) NULL,
	[RETAILER_PO] [char](30) NULL,
	[ITEM_LINE_NO] [bigint] NULL,
	[MESSAGE_NO] [int] NULL,
	[MESSAGE_TITLE] [char](50) NULL,
	[MESSAGE] [text] NULL,
	[PO_MESSAGES_KEY] [uniqueidentifier] NULL);


--Table dbo.PO_SUBLINE_ITEM_T




--Create table and its columns
CREATE TABLE [dbo].[PO_SUBLINE_ITEM_T] (
	[PARTNER_ID] [char](20) NULL,
	[RETAILER_PO] [char](30) NULL,
	[ITEM_LINE_NO] [bigint] NULL,
	[SUB_ITEM_LINE_NO] [int] NULL,
	[VENDOR_ITEM] [char](50) NULL,
	[VENDOR_STYLE] [char](50) NULL,
	[VENDOR_COLOR] [char](50) NULL,
	[VENDOR_SIZE] [char](50) NULL,
	[BUYER_ITEM] [char](50) NULL,
	[BUYER_STYLE] [char](50) NULL,
	[BUYER_COLOR] [char](50) NULL,
	[BUYER_SIZE] [char](50) NULL,
	[COLOR_NRF] [char](50) NULL,
	[SIZE_NRF] [char](50) NULL,
	[UPC_NUMBER] [char](50) NULL,
	[QUANTITY_ORDERED] [int] NULL,
	[UOM] [char](20) NULL,
	[UNIT_PRICE] [decimal](13, 2) NULL,
	[PO_SUBLINE_ITEM_KEY] [uniqueidentifier] NULL);


--Table dbo.PO_TERMS_T




--Create table and its columns
CREATE TABLE [dbo].[PO_TERMS_T] (
	[PARTNER_ID] [char](20) NULL,
	[RETAILER_PO] [char](30) NULL,
	[TERM_CODE] [char](30) NULL,
	[TERM_DESCRIPTION] [text] NULL,
	[BASIC_DATE_CODE] [char](10) NULL,
	[DISCOUNT_PERCENT] [decimal](5, 2) NULL,
	[DISCOUNT_DUE_DATE] [datetime] NULL,
	[DISCOUNT_DAYS_DUE] [int] NULL,
	[NET_DUE_DATE] [datetime] NULL,
	[NET_DAYS] [int] NULL,
	[DISCOUNT_AMOUNT] [decimal](13, 2) NULL,
	[DEFERRED_DUE_DATE] [datetime] NULL,
	[DEFERRED_AMOUNT_DUE] [decimal](13, 2) NULL,
	[PERCENT_INVOICE_PAYABLE] [int] NULL,
	[DAY_OF_MONTH] [int] NULL,
	[PAYMENT_METHOD] [char](10) NULL,
	[PO_TERMS_KEY] [uniqueidentifier] NULL);


--Table dbo.SHIPMENT_CONTAINERS_T




--Create table and its columns
CREATE TABLE [dbo].[SHIPMENT_CONTAINERS_T] (
	[PARTNER_ID] [varchar](20) NULL,
	[SHIPMENT_ID] [varchar](30) NULL,
	[SSCC_18] [varchar](18) NULL,
	[SSCC_20] [varchar](20) NULL,
	[UPC_SHIPPING_CODE] [varchar](14) NULL,
	[CARRIER_PACKAGE_ID] [varchar](50) NULL,
	[SHIPPER_ID] [varchar](50) NULL,
	[QUANTITY_SHIPPED] [int] NULL,
	[UOM] [varchar](20) NULL,
	[WIDTH] [decimal](13, 2) NULL,
	[HEIGHT] [decimal](13, 2) NULL,
	[LENGTH] [decimal](13, 2) NULL,
	[DIMENSIONS_UOM] [varchar](20) NULL,
	[WEIGHT] [decimal](13, 2) NULL,
	[WEIGHT_UOM] [varchar](20) NULL,
	[PACKAGE_TYPE] [varchar](50) NULL,
	[BUYING_PARTY_LOCATION] [varchar](20) NULL,
	[BUYING_PARTY_GLN_NUMBER] [varchar](20) NULL,
	[BUYING_PARTY_DUNS_NUMBER] [varchar](20) NULL,
	[BUYING_PARTY_NAME] [varchar](100) NULL,
	[BUYING_PARTY_ADDRESS_1] [varchar](100) NULL,
	[BUYING_PARTY_ADDRESS_2] [varchar](100) NULL,
	[BUYING_PARTY_CITY] [varchar](30) NULL,
	[BUYING_PARTY_STATE] [varchar](30) NULL,
	[BUYING_PARTY_ZIP] [varchar](30) NULL,
	[BUYING_PARTY_COUNTRY] [varchar](30) NULL,
	[BUYING_PARTY_CONTACT] [varchar](100) NULL,
	[BUYING_PARTY_PHONE] [varchar](30) NULL,
	[BUYING_PARTY_FAX] [varchar](30) NULL,
	[SHIPMENT_HEADER_KEY] [bigint] NOT NULL,
	[SHIPMENT_DETAILS_KEY] [bigint] NOT NULL,
	[SHIPMENT_CONTAINERS_KEY] [bigint] NOT NULL IDENTITY (1, 1));


--Table dbo.SHIPMENT_DETAILS_T




--Create table and its columns
CREATE TABLE [dbo].[SHIPMENT_DETAILS_T] (
	[PARTNER_ID] [varchar](20) NULL,
	[SHIPMENT_ID] [varchar](30) NULL,
	[RETAILER_PO] [varchar](30) NULL,
	[RETAILER_PO_RELEASE] [varchar](30) NULL,
	[RETAILER_PO_DATE] [datetime] NULL,
	[BOL_NO] [varchar](30) NULL,
	[SELLER_INVOICE] [varchar](30) NULL,
	[VENDOR_ORDER] [varchar](30) NULL,
	[VENDOR_NUMBER] [varchar](30) NULL,
	[MERCHANDISE_TYPE] [varchar](30) NULL,
	[PROMOTION_CODE] [varchar](30) NULL,
	[DEPARTMENT] [varchar](30) NULL,
	[SHIPMENT_HEADER_KEY] [bigint] NOT NULL,
	[SHIPMENT_DETAILS_KEY] [bigint] NOT NULL IDENTITY (1, 1));


--Table dbo.SHIPMENT_HEADER_T




--Create table and its columns
CREATE TABLE [dbo].[SHIPMENT_HEADER_T] (
	[SENDER_ID] [varchar](20) NULL,
	[PARTNER_ID] [varchar](20) NOT NULL,
	[SHIPMENT_ID] [varchar](20) NOT NULL,
	[DATE] [datetime] NULL,
	[BOL] [varchar](30) NULL,
	[MASTER_BOL] [varchar](30) NULL,
	[ALTERNATE_BOL] [varchar](30) NULL,
	[LADING_QUANTITY] [int] NULL,
	[GROSS_WEIGHT] [decimal](13, 2) NULL,
	[WEIGHT_UOM] [varchar](20) NULL,
	[SHIP_FROM_LOCATION] [varchar](20) NULL,
	[SHIP_FROM_GLN_NUMBER] [varchar](20) NULL,
	[SHIP_FROM_DUNS_NUMBER] [varchar](20) NULL,
	[SHIP_FROM_NAME] [varchar](100) NULL,
	[SHIP_FROM_ADDRESS_1] [varchar](100) NULL,
	[SHIP_FROM_ADDRESS_2] [varchar](100) NULL,
	[SHIP_FROM_CITY] [varchar](30) NULL,
	[SHIP_FROM_STATE] [varchar](30) NULL,
	[SHIP_FROM_ZIP] [varchar](30) NULL,
	[SHIP_FROM_COUNTRY] [varchar](30) NULL,
	[SHIP_FROM_CONTACT] [varchar](100) NULL,
	[SHIP_FROM_PHONE] [varchar](30) NULL,
	[SHIP_FROM_FAX] [varchar](30) NULL,
	[SHIP_TO_LOCATION] [varchar](20) NULL,
	[SHIP_TO_GLN_NUMBER] [varchar](20) NULL,
	[SHIP_TO_DUNS_NUMBER] [varchar](20) NULL,
	[SHIP_TO_NAME] [varchar](100) NULL,
	[SHIP_TO_ADDRESS_1] [varchar](100) NULL,
	[SHIP_TO_ADDRESS_2] [varchar](100) NULL,
	[SHIP_TO_CITY] [varchar](30) NULL,
	[SHIP_TO_STATE] [varchar](30) NULL,
	[SHIP_TO_ZIP] [varchar](30) NULL,
	[SHIP_TO_COUNTRY] [varchar](30) NULL,
	[SHIP_TO_CONTACT] [varchar](100) NULL,
	[SHIP_TO_PHONE] [varchar](30) NULL,
	[SHIP_TO_FAX] [varchar](30) NULL,
	[SHIPMENT_HEADER_KEY] [bigint] NOT NULL IDENTITY (1, 1));


--Table dbo.SHIPMENT_ITEM_CONTAINERS_T




--Create table and its columns
CREATE TABLE [dbo].[SHIPMENT_ITEM_CONTAINERS_T] (
	[PARTNER_ID] [varchar](20) NULL,
	[SHIPMENT_ID] [varchar](30) NULL,
	[RETAILER_PO] [varchar](30) NULL,
	[QUANTITY_SHIPPED] [int] NULL,
	[UOM] [varchar](20) NULL,
	[SHIPMENT_STATUS] [varchar](100) NULL,
	[SHIPMENT_HEADER_KEY] [bigint] NOT NULL,
	[SHIPMENT_ITEMS_KEY] [bigint] NOT NULL,
	[SHIPMENT_CONTAINERS_KEY] [bigint] NOT NULL,
	[SHIPMENT_ITEM_CONTAINERS_KEY] [bigint] NOT NULL IDENTITY (1, 1));


--Table dbo.SHIPMENT_ITEMS_T




--Create table and its columns
CREATE TABLE [dbo].[SHIPMENT_ITEMS_T] (
	[PARTNER_ID] [varchar](20) NULL,
	[SHIPMENT_ID] [varchar](30) NULL,
	[VENDOR_ITEM] [varchar](50) NULL,
	[VENDOR_STYLE] [varchar](50) NULL,
	[VENDOR_COLOR] [varchar](50) NULL,
	[VENDOR_SIZE] [varchar](50) NULL,
	[BUYER_ITEM] [varchar](50) NULL,
	[BUYER_STYLE] [varchar](50) NULL,
	[BUYER_COLOR] [varchar](50) NULL,
	[BUYER_SIZE] [varchar](50) NULL,
	[COLOR_NRF] [varchar](50) NULL,
	[SIZE_NRF] [varchar](50) NULL,
	[UPC_NUMBER] [varchar](50) NULL,
	[INNER_CONTAINERS] [int] NULL,
	[QUANTITY_SHIPPED] [int] NULL,
	[QUANTITY_ORDERED] [int] NULL,
	[UOM] [varchar](20) NULL,
	[SHIPMENT_HEADER_KEY] [bigint] NOT NULL,
	[SHIPMENT_ITEMS_KEY] [bigint] NOT NULL IDENTITY (1, 1));


--Table dbo.SHIPMENT_ROUTING_T




--Create table and its columns
CREATE TABLE [dbo].[SHIPMENT_ROUTING_T] (
	[PARTNER_ID] [varchar](20) NULL,
	[SHIPMENT_ID] [varchar](30) NULL,
	[ROUTING_SEQUENCE] [varchar](50) NULL,
	[CARRIER_CODE] [varchar](50) NULL,
	[TRANSPORTATION_METHOD] [varchar](50) NULL,
	[ROUTING_DESCRIPTION] [text] NULL,
	[SHIPPER_TRACKING_NUMBER] [varchar](50) NULL,
	[TRANSIT_TIME] [varchar](20) NULL,
	[SERVICE_LEVEL] [varchar](30) NULL,
	[SHIPMENT_HEADER_KEY] [bigint] NOT NULL,
	[SHIPMENT_ROUTING_KEY] [bigint] NOT NULL IDENTITY (1, 1));


--Indexes of table dbo.INVENTORY_HEADER_T
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

ALTER TABLE [dbo].[INVENTORY_HEADER_T] ADD CONSTRAINT [PK_INVENTORY_HEADER_T_1] PRIMARY KEY CLUSTERED ([PARTNER_ID], [INVINTORY_ADVICE_ID]) 


--Indexes of table dbo.INVOICE_HEADER_T
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

ALTER TABLE [dbo].[INVOICE_HEADER_T] ADD CONSTRAINT [PK_INVOICE_HEADER_T] PRIMARY KEY CLUSTERED ([PARTNER_ID], [INVOICE_NUMBER]) 


--Indexes of table dbo.SHIPMENT_HEADER_T
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

ALTER TABLE [dbo].[SHIPMENT_HEADER_T] ADD CONSTRAINT [PK_SHIPMENT_HEADER_T] PRIMARY KEY CLUSTERED ([PARTNER_ID], [SHIPMENT_ID]) 

