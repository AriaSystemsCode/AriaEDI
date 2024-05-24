drop table [dbo].[TRANSACTION_MAP_T]

CREATE TABLE [dbo].[TRANSACTION_MAP_T](
	[TRANSACTION_SEGMENTS_KEY] [int] NOT NULL,
	[FIELD_ORDER] [smallint] NOT NULL CHECK(FIELD_ORDER>0),
	[START_POSITION] [smallint] NULL,
	[FIELD_LENGTH] [smallint] NULL,
	[FIELD_NAME] [varchar](20) NOT NULL,
	[CONDITION] [text] NULL,
	[VALUE] [text] NULL,
	[DATA_TYPE] [char](2) NULL,
	[USAGE] [char](1) NULL,
	[TRANSACTION_MAP_KEY] [int] NOT NULL,
	[IS_KEY] [bit] NULL CONSTRAINT [DF_TRANSACTION_MAP_T_IS_KEY]  DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]





GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 1, 0, 0, N'MWAREHOUSE', N'', N' ', N'C ', N'M', 108, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 16, 0, 0, N'MSTYLE', N'', N' ', N'C ', N'M', 123, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 3, 0, 0, N'MACCOUNTID', N'', N' ', N'C ', N'M', 110, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 4, 0, 0, N'MPIKTKT', N'', N' ', N'C ', N'M', 111, 1)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 5, 0, 0, N'MCUSTPO', N'', N' ', N'C ', N'M', 112, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 6, 0, 0, N'MBOL', N'', N' ', N'C ', N'M', 113, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 7, 0, 0, N'MSHIP', N'', N' ', N'D ', N'M', 114, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 8, 0, 0, N'MTOTQTYSH', N'', N' ', N'N ', N'M', 115, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 9, 0, 0, N'MTOTWGHT', N'', N' ', N'N ', N'M', 116, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 10, 0, 0, N'MTOTCART', N'', N' ', N'N ', N'M', 117, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 11, 0, 0, N'MTRANMTHD', N'', N' ', N'C ', N'O', 118, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 12, 0, 0, N'MCACODE', N'', N' ', N'C ', N'O', 119, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 13, 0, 0, N'MCARRIER', N'', N' ', N'C ', N'O', 120, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 14, 0, 0, N'XBOX_SER', N'', N' ', N'C ', N'M', 121, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 15, 0, 0, N'MLINE', N'', N' ', N'N ', N'M', 122, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 17, 0, 0, N'MUPC', N'', N' ', N'C ', N'M', 124, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 18, 0, 0, N'MSKU', N'', N' ', N'C ', N'M', 125, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 19, 0, 0, N'MUOM', N'', N' ', N'C ', N'M', 126, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 20, 0, 0, N'MQTY', N'', N' ', N'N ', N'M', 127, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 21, 0, 0, N'MSHQTY', N'', N' ', N'N ', N'M', 128, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 1, 0, 0, N'AFIELDS(1)', N'', N'[PTnumber]', N'C ', N'M', 129, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 2, 0, 0, N'AFIELDS(2)', N'', N'[CustomerPO]', N'C ', N'M', 130, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 3, 0, 0, N'AFIELDS(3)', N'', N'[ConsigneePO]', N'C ', N'M', 131, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 4, 0, 0, N'AFIELDS(4)', N'', N'[ConsigneeName]', N'C ', N'M', 132, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 5, 0, 0, N'AFIELDS(5)', N'', N'[ShipTo]', N'C ', N'M', 133, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 6, 0, 0, N'AFIELDS(6)', N'', N'[ShipAdd1]', N'C ', N'M', 134, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 7, 0, 0, N'AFIELDS(7)', N'', N'[ShipAdd2]', N'C ', N'M', 135, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 8, 0, 0, N'AFIELDS(8)', N'', N'[ShipCity]', N'C ', N'M', 136, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 9, 0, 0, N'AFIELDS(9)', N'', N'[ShipState]', N'C ', N'M', 137, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 10, 0, 0, N'AFIELDS(10)', N'', N'[ShipZip]', N'C ', N'M', 138, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 11, 0, 0, N'AFIELDS(11)', N'', N'[BillTo]', N'C ', N'M', 139, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 12, 0, 0, N'AFIELDS(12)', N'', N'[BillAdd1]', N'C ', N'M', 140, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 13, 0, 0, N'AFIELDS(13)', N'', N'[BillAdd2]', N'C ', N'M', 141, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 14, 0, 0, N'AFIELDS(14)', N'', N'[BillCity]', N'C ', N'M', 142, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 15, 0, 0, N'AFIELDS(15)', N'', N'[BillState]', N'C ', N'M', 143, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 16, 0, 0, N'AFIELDS(16)', N'', N'[BillZip]', N'C ', N'M', 144, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 17, 0, 0, N'AFIELDS(17)', N'', N'[ProdID]', N'C ', N'M', 145, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 18, 0, 0, N'AFIELDS(18)', N'', N'[RetailerItemNumber]', N'C ', N'M', 146, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 19, 0, 0, N'AFIELDS(19)', N'', N'[ProductIDAlt]', N'C ', N'M', 147, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 20, 0, 0, N'AFIELDS(20)', N'', N'[UPC]', N'C ', N'M', 148, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 21, 0, 0, N'AFIELDS(21)', N'', N'[CasePack]', N'C ', N'M', 149, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 22, 0, 0, N'AFIELDS(22)', N'', N'[OrderQtyInpieces]', N'C ', N'M', 150, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 23, 0, 0, N'AFIELDS(23)', N'', N'[ShipDate]', N'C ', N'M', 151, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 24, 0, 0, N'AFIELDS(24)', N'', N'[CancelDate]', N'C ', N'M', 152, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 25, 0, 0, N'AFIELDS(25)', N'', N'[FreightTerms]', N'C ', N'M', 153, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 26, 0, 0, N'AFIELDS(26)', N'', N'[ShipVia]', N'C ', N'M', 154, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 27, 0, 0, N'AFIELDS(27)', N'', N'[Dept]', N'C ', N'M', 155, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 28, 0, 0, N'AFIELDS(28)', N'', N'[PoType]', N'C ', N'M', 156, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 29, 0, 0, N'AFIELDS(29)', N'', N'[VendorNum]', N'C ', N'M', 157, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 30, 0, 0, N'AFIELDS(30)', N'', N'[ColorCode]', N'C ', N'M', 158, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 31, 0, 0, N'AFIELDS(31)', N'', N'[Color]', N'C ', N'M', 159, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 32, 0, 0, N'AFIELDS(32)', N'', N'[SmallParcelAccount]', N'C ', N'M', 160, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 33, 0, 0, N'AFIELDS(33)', N'', N'[CustomerID]', N'C ', N'M', 161, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 34, 0, 0, N'AFIELDS(34)', N'', N'[SIZE]', N'C ', N'M', 162, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 35, 0, 0, N'AFIELDS(35)', N'', N'[Vicsbol]', N'C ', N'M', 163, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 36, 0, 0, N'AFIELDS(36)', N'', N'[storeNo]', N'C ', N'M', 164, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 37, 0, 0, N'AFIELDS(37)', N'', N'[storestate]', N'C ', N'M', 165, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (17, 38, 0, 0, N'AFIELDS(38)', N'', N'[deptdescreption]', N'C ', N'M', 166, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 1, 0, 0, N'AFIELDS(1)', N'', N'PACK_NO', N'C ', N'M', 167, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 2, 0, 0, N'AFIELDS(2)', N'', N'STYLE_PO_NO', N'C ', N'O', 168, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 3, 0, 0, N'AFIELDS(3)', N'', N'CUST_PO', N'C ', N'M', 169, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 4, 0, 0, N'AFIELDS(4)', N'', N'SHIP_NAME', N'C ', N'M', 170, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 5, 0, 0, N'AFIELDS(5)', N'', N'ST_DIST_CTR', N'C ', N'M', 171, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 6, 0, 0, N'AFIELDS(6)', N'', N'SHIP_TO_ADD1', N'C ', N'M', 172, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 7, 0, 0, N'AFIELDS(7)', N'', N'SHIP_TO_ADD2', N'C ', N'M', 173, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 8, 0, 0, N'AFIELDS(8)', N'', N'SHIP_TO_CITY', N'C ', N'M', 174, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 9, 0, 0, N'AFIELDS(9)', N'', N'SHIP_TO_STATE', N'C ', N'M', 175, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 10, 0, 0, N'AFIELDS(10)', N'', N'SHIP_TO_ZIP', N'C ', N'M', 176, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 11, 0, 0, N'AFIELDS(11)', N'', N'BILL_TO', N'C ', N'O', 177, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 12, 0, 0, N'AFIELDS(12)', N'', N'BILL_ADD1', N'C ', N'O', 178, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 13, 0, 0, N'AFIELDS(13)', N'', N'BILL_ADD2', N'C ', N'O', 179, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 14, 0, 0, N'AFIELDS(14)', N'', N'BILL_CITY', N'C ', N'O', 180, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 15, 0, 0, N'AFIELDS(15)', N'', N'BILL_STATE', N'C ', N'O', 181, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 16, 0, 0, N'AFIELDS(16)', N'', N'BILL_ZIP', N'C ', N'O', 182, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 17, 0, 0, N'AFIELDS(17)', N'', N'STYLE', N'C ', N'M', 183, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 18, 0, 0, N'AFIELDS(18)', N'', N'SKU', N'C ', N'O', 184, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 19, 0, 0, N'AFIELDS(19)', N'', N'ALT_STYLE', N'C ', N'O', 185, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 20, 0, 0, N'AFIELDS(20)', N'', N'UPC', N'C ', N'O', 186, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 21, 0, 0, N'AFIELDS(21)', N'', N'CASE_PACK', N'N ', N'M', 187, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 22, 0, 0, N'AFIELDS(22)', N'', N'TOTAL_QTY', N'N ', N'M', 188, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 23, 0, 0, N'AFIELDS(23)', N'', N'SHIP_DATE', N'D ', N'M', 189, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 24, 0, 0, N'AFIELDS(24)', N'', N'CANCELLED_DATE', N'D ', N'M', 190, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 25, 0, 0, N'AFIELDS(25)', N'', N'FREIGHT_TERMS', N'C ', N'M', 191, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 26, 0, 0, N'AFIELDS(26)', N'', N'CARRIER', N'C ', N'M', 192, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 27, 0, 0, N'AFIELDS(27)', N'', N'DEPT', N'C ', N'O', 193, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 28, 0, 0, N'AFIELDS(28)', N'', N'PO_TYPE', N'C ', N'O', 194, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 29, 0, 0, N'AFIELDS(29)', N'', N'INT_VEND', N'C ', N'O', 195, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 30, 0, 0, N'AFIELDS(30)', N'', N'NRF_CODE', N'C ', N'O', 196, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 31, 0, 0, N'AFIELDS(31)', N'', N'COLOR_DESC', N'C ', N'O', 197, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 32, 0, 0, N'AFIELDS(32)', N'', N'CUST_FRT_ACCT', N'C ', N'O', 198, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 33, 0, 0, N'AFIELDS(33)', N'', N'CUSTOMER_ACC_NUM', N'C ', N'M', 199, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 34, 0, 0, N'AFIELDS(34)', N'', N'CARTON_SIZE_QTY', N'C ', N'M', 200, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 35, 0, 0, N'AFIELDS(35)', N'', N'VICS_BOL', N'C ', N'M', 201, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 36, 0, 0, N'AFIELDS(36)', N'', N'ST_STORE', N'C ', N'M', 202, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 37, 0, 0, N'AFIELDS(37)', N'', N'ST_STORE_STATE', N'C ', N'M', 203, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (18, 38, 0, 0, N'AFIELDS(38)', N'', N'DEPT_DESC', N'C ', N'O', 204, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (16, 2, 0, 0, N'MTRANNO', N'', N' ', N'C ', N'M', 109, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 1, 0, 0, N'MACCOUNTID', N'', N'', N'C ', N'M', 205, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 2, 0, 0, N'MTRANNO', N'', N'', N'C ', N'M', 206, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 3, 0, 0, N'MISPACK', N'', N'', N'C ', N'M', 207, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 4, 0, 0, N'MRECDATE', N'', N'', N'D ', N'M', 208, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 5, 0, 0, N'MCLIENT', N'', N'', N'C ', N'M', 209, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 6, 0, 0, N'MCONTNO', N'', N'', N'C ', N'O', 210, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 7, 0, 0, N'MRECNO', N'', N'', N'C ', N'O', 211, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 8, 0, 0, N'MSEAL', N'', N'', N'C ', N'O', 212, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 9, 0, 0, N'MSHIPNO', N'', N'', N'C ', N'M', 213, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 10, 0, 0, N'MCUSTPO', N'', N'', N'C ', N'M', 214, 1)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 11, 0, 0, N'MSTOREPO', N'', N'', N'C ', N'O', 215, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 12, 0, 0, N'MSTYLE', N'', N'', N'C ', N'M', 216, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 13, 0, 0, N'MCOLOR', N'', N'', N'C ', N'O', 217, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 14, 0, 0, N'MSIZE', N'', N'', N'C ', N'M', 218, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 15, 0, 0, N'MUNITSPERPACK', N'', N'', N'N ', N'O', 219, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 16, 0, 0, N'MTOTNOCRTNS', N'', N'', N'N ', N'O', 220, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 17, 0, 0, N'MTOTAL', N'', N'', N'N ', N'M', 221, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 18, 0, 0, N'MHANGER', N'', N'', N'C ', N'O', 222, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 19, 0, 0, N'MTICKET', N'', N'', N'C ', N'O', 223, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 20, 0, 0, N'MLENGTH', N'', N'', N'N ', N'O', 224, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 21, 0, 0, N'MWIDTH', N'', N'', N'N ', N'O', 225, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 22, 0, 0, N'MHEIGHT', N'', N'', N'N ', N'O', 226, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 23, 0, 0, N'MWIGHT', N'', N'', N'N ', N'O', 227, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 24, 0, 0, N'MTOTUNTIS', N'', N'', N'N ', N'O', 228, 0)
GO
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (19, 25, 0, 0, N'MTOTCRTNS', N'', N'', N'N ', N'O', 229, 0)
GO


INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'944', N'TAT', N'1.000.0000', N'D-01', 1, N'LINE', N'M', 19)
GO
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'945', N'TAT', N'1.000.0000', N'D-01', 1, N'LINE', N'M', 16)
GO
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'940', N'TAT', N'1.000.0000', N'D-01', 1, N'LINE', N'M', 18)
GO