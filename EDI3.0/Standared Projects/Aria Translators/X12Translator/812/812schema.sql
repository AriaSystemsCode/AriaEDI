USE [SHA13_LDBCH]
GO
/****** Object:  Table [dbo].[CreditDebitAdjustmentCharges]    Script Date: 03/02/2021 05:43:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditDebitAdjustmentCharges]') AND type in (N'U'))
DROP TABLE [dbo].[CreditDebitAdjustmentCharges]
GO
/****** Object:  Table [dbo].[CreditDebitAdjustmentHeader]    Script Date: 03/02/2021 05:43:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditDebitAdjustmentHeader]') AND type in (N'U'))
DROP TABLE [dbo].[CreditDebitAdjustmentHeader]
GO
/****** Object:  Table [dbo].[CreditDebitAdjustmentLine]    Script Date: 03/02/2021 05:43:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditDebitAdjustmentLine]') AND type in (N'U'))
DROP TABLE [dbo].[CreditDebitAdjustmentLine]
GO
/****** Object:  Table [dbo].[CreditDebitAdjustmentLocation]    Script Date: 03/02/2021 05:43:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditDebitAdjustmentLocation]') AND type in (N'U'))
DROP TABLE [dbo].[CreditDebitAdjustmentLocation]
GO
/****** Object:  Table [dbo].[CreditDebitAdjustmentLocationAmount]    Script Date: 03/02/2021 05:43:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditDebitAdjustmentLocationAmount]') AND type in (N'U'))
DROP TABLE [dbo].[CreditDebitAdjustmentLocationAmount]
GO
/****** Object:  Table [dbo].[CreditDebitAdjustmentLocationAmount]    Script Date: 03/02/2021 05:43:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditDebitAdjustmentLocationAmount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CreditDebitAdjustmentLocationAmount](
	[OID] [uniqueidentifier] NULL,
	[CreditDebitAdjustmentLocationOID] [uniqueidentifier] NULL,
	[Location] [varchar](255) NULL,
	[Type] [varchar](255) NULL,
	[Amount] [real] NULL,
	[Percent] [real] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CreditDebitAdjustmentLocation]    Script Date: 03/02/2021 05:43:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditDebitAdjustmentLocation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CreditDebitAdjustmentLocation](
	[OID] [uniqueidentifier] NULL,
	[CreditDebitAdjustmentHeaderOID] [uniqueidentifier] NULL,
	[CreditDebitAdjustmentNumber] [varchar](255) NULL,
	[CreditDebitAdjustmentLineOID] [uniqueidentifier] NULL,
	[LocationType] [varchar](255) NULL,
	[Location] [varchar](255) NULL,
	[GLNNumber] [varchar](255) NULL,
	[DUNSNumber] [varchar](255) NULL,
	[Name] [varchar](255) NULL,
	[Address] [varchar](255) NULL,
	[AddressRest] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[State] [varchar](255) NULL,
	[ZIP] [varchar](255) NULL,
	[Country] [varchar](255) NULL,
	[Contact] [varchar](255) NULL,
	[Phone] [varchar](255) NULL,
	[Fax] [varchar](255) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CreditDebitAdjustmentLine]    Script Date: 03/02/2021 05:43:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditDebitAdjustmentLine]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CreditDebitAdjustmentLine](
	[OID] [uniqueidentifier] NULL,
	[CreditDebitAdjustmentHeaderOID] [uniqueidentifier] NULL,
	[CreditDebitAdjustmentNumber] [varchar](22) NULL,
	[AdjustmentReasonCode] [varchar](2) NULL,
	[CreditDebitFlag] [varchar](1) NULL,
	[Amount] [real] NULL,
	[UPC] [varchar](30) NULL,
	[GTIN] [varchar](255) NULL,
	[VendorStyleNumber] [varchar](30) NULL,
	[VendorColor] [varchar](30) NULL,
	[VendorSize] [varchar](30) NULL,
	[SizeNRFCode] [varchar](30) NULL,
	[BuyerStyleNumber] [varchar](255) NULL,
	[BuyerColor] [varchar](255) NULL,
	[BuyerSizeCode] [varchar](255) NULL,
	[ColorNRFCode] [varchar](30) NULL,
	[Pack] [real] NULL,
	[InnerPack] [real] NULL,
	[GrossWeight] [real] NULL,
	[PackWeightUOM] [varchar](255) NULL,
	[PackVolume] [real] NULL,
	[PackVolumeUOM] [varchar](255) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CreditDebitAdjustmentHeader]    Script Date: 03/02/2021 05:43:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditDebitAdjustmentHeader]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CreditDebitAdjustmentHeader](
	[OID] [uniqueidentifier] NULL,
	[CreditDebitAdjustmentNumber] [varchar](22) NULL,
	[CreditDebitDate] [datetime] NULL,
	[CreditDebitType] [varchar](1) NULL,
	[CreditDebitAmount] [real] NULL,
	[HandlingCode] [varchar](2) NULL,
	[InvoiceNumber] [varchar](22) NULL,
	[VendorOrderNumber] [varchar](255) NULL,
	[PurchaseOrderNumber] [varchar](255) NULL,
	[Currency] [varchar](3) NULL,
	[ExchangeRate] [real] NULL,
	[InternalVendorNumber] [varchar](30) NULL,
	[TermsTypeCode] [varchar](6) NULL,
	[TermsBasisDateCode] [varchar](255) NULL,
	[TermsDiscountPercent] [varchar](255) NULL,
	[TermsDiscountDueDate] [varchar](255) NULL,
	[TermsDiscountDaysDue] [varchar](255) NULL,
	[TermsNetDueDate] [varchar](255) NULL,
	[TermsNetDays] [varchar](255) NULL,
	[TermsDiscountAmount] [varchar](255) NULL,
	[TermsDeferredDueDate] [varchar](255) NULL,
	[DeferredAmountDue] [varchar](255) NULL,
	[PercentofInvoicePayable] [varchar](255) NULL,
	[TermsDescription] [varchar](255) NULL,
	[ShipmentMethodofPayment] [varchar](255) NULL,
	[LocationQualifier] [varchar](2) NULL,
	[FOBDescription] [varchar](255) NULL,
	[NumberofUnitsShipped] [real] NULL,
	[QuantityReceived] [real] NULL,
	[UnitOrBasisForMeasurement] [varchar](255) NULL,
	[Account] [varchar](10) NULL,
	[CheckNumber] [varchar](30) NULL,
	[EffectiveDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ContractNumber] [varchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CreditDebitAdjustmentCharges]    Script Date: 03/02/2021 05:43:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditDebitAdjustmentCharges]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CreditDebitAdjustmentCharges](
	[OID] [uniqueidentifier] NULL,
	[CreditDebitAdjustmentHeaderOID] [uniqueidentifier] NULL,
	[CreditDebitAdjustmentNumber] [varchar](255) NULL,
	[CreditDebitAdjustmentLineOID] [uniqueidentifier] NULL,
	[ServiceType] [varchar](255) NULL,
	[Amount] [real] NULL,
	[Percent] [real] NULL,
	[HandlingMethod] [varchar](255) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
