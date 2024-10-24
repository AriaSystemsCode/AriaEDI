USE [System.Master]
GO
/****** Object:  Table [dbo].[CLIENT_OUTSOURCING_PRICE_LIST_T]    Script Date: 09/02/2013 11:01:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CLIENT_OUTSOURCING_PRICE_LIST_T](
	[client_ID] [varchar](10) NOT NULL,
	[Order_Line_Price] [numeric](18, 5) NOT NULL,
	[ASN_Price] [numeric](18, 5) NOT NULL,
	[Invoice_Line] [numeric](18, 5) NOT NULL,
	[UPC_Line] [numeric](18, 5) NOT NULL,
	[Price_Ticket_Line] [numeric](18, 5) NOT NULL,
	[Label_Price] [numeric](18, 5) NOT NULL,
	[Tax_Amount] [numeric](18, 5) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[CLIENT_OUTSOURCING_PRICE_LIST_T] ([client_ID], [Order_Line_Price], [ASN_Price], [Invoice_Line], [UPC_Line], [Price_Ticket_Line], [Label_Price], [Tax_Amount]) VALUES (N'FYEDI', CAST(0.48000 AS Numeric(18, 5)), CAST(0.48000 AS Numeric(18, 5)), CAST(0.48000 AS Numeric(18, 5)), CAST(1.75000 AS Numeric(18, 5)), CAST(0.06000 AS Numeric(18, 5)), CAST(0.64000 AS Numeric(18, 5)), CAST(0.08875 AS Numeric(18, 5)))
INSERT [dbo].[CLIENT_OUTSOURCING_PRICE_LIST_T] ([client_ID], [Order_Line_Price], [ASN_Price], [Invoice_Line], [UPC_Line], [Price_Ticket_Line], [Label_Price], [Tax_Amount]) VALUES (N'REV03', CAST(0.48000 AS Numeric(18, 5)), CAST(0.48000 AS Numeric(18, 5)), CAST(0.48000 AS Numeric(18, 5)), CAST(1.75000 AS Numeric(18, 5)), CAST(0.06000 AS Numeric(18, 5)), CAST(0.64000 AS Numeric(18, 5)), CAST(0.08875 AS Numeric(18, 5)))
INSERT [dbo].[CLIENT_OUTSOURCING_PRICE_LIST_T] ([client_ID], [Order_Line_Price], [ASN_Price], [Invoice_Line], [UPC_Line], [Price_Ticket_Line], [Label_Price], [Tax_Amount]) VALUES (N'TPS10', CAST(0.48000 AS Numeric(18, 5)), CAST(0.48000 AS Numeric(18, 5)), CAST(0.48000 AS Numeric(18, 5)), CAST(1.75000 AS Numeric(18, 5)), CAST(0.06000 AS Numeric(18, 5)), CAST(0.64000 AS Numeric(18, 5)), CAST(0.08875 AS Numeric(18, 5)))
