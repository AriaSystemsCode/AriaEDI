/**USE [MariamDerbyTest]**/
GO
/****** Object:  Table [dbo].[TRANSACTION_SEGMENTS_T]    Script Date: 06/12/2018 11:42:01 ******/
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'943', N'RLM', N'004010', N'03', 1, N'W06', N'M', 32)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'943', N'RLM', N'004010', N'03', 2, N'N1', N'M', 33)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'943', N'RLM', N'004010', N'03', 3, N'N9', N'M', 34)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'943', N'RLM', N'004010', N'03', 4, N'G62', N'M', 35)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'943', N'RLM', N'004010', N'04', 1, N'W04', N'M', 36)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'943', N'RLM', N'004010', N'04', 2, N'N9', N'M', 37)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'943', N'RLM', N'004010', N'05', 1, N'W03', N'M', 38)
/****** Object:  Table [dbo].[TRANSACTION_MAP_T]    Script Date: 06/12/2018 11:42:01 ******/
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (32, 1, 0, 0, N'TRAN_PURPOSE_CODE', N'', N'', N'C ', N'M', 5, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (32, 1, 0, 0, N'TRAN_PURPOSE', N'', N'''Original'' WHERE [M1].[1]=''J'' AND [M1].[Loop_Seg] = ''03W06''', N'C ', N'M', 6, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (32, 2, 0, 0, N'SHIP_REFERENCE', N'', N'', N'C ', N'M', 7, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (32, 3, 0, 0, N'CRDATE', N'', N'', N'D ', N'M', 8, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (32, 4, 0, 0, N'SHIPMENT_ID', N'', N'', N'C ', N'M', 9, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (32, 4, 0, 0, N'SENDER_ID', N'', N'[M1].[Sender_Id] WHERE [M1].[Loop_id]=''03''', N'C ', N'M', 10, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (33, 2, 0, 0, N'COMP_NAME', N'', N'[M1].[2] WHERE [M1].[1] = ''ZL'' AND [M1].[Loop_Seg]=''03N1''', N'C ', N'M', 11, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (34, 2, 0, 0, N'SHIP_VIA', N'', N'[M1].[2] WHERE [M1].[1] = ''ABS'' AND [M1].[Loop_Seg]=''03N9''', N'C ', N'M', 12, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (34, 2, 0, 0, N'CONTAINER_ID', N'', N'[M1].[2] WHERE [M1].[1] = ''MAN'' AND [M1].[Loop_Seg]=''03N9''', N'C ', N'M', 13, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (35, 2, 0, 0, N'Est_Delivery_DATE', N'', N'[M1].[2] WHERE [M1].[1] = ''17'' AND [M1].[Loop_Seg]=''03G62''', N'D ', N'M', 14, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 1, 0, 0, N'SEQ_NO', N'', N'[M1].[1] WHERE [M1].[Loop_Seg]=''04W04''', N'N ', N'M', 15, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 1, 0, 0, N'SENDER_ID', N'', N'[M1].[Sender_Id] WHERE [M1].[Loop_id]=''04''', N'C ', N'M', 16, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 1, 0, 0, N'SHIPMENT_ID', N'', N'[M1].[4] WHERE [M1].[Loop_id]=''03W06''', N'C ', N'M', 17, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 2, 0, 0, N'QTY_Shipped', N'', N'', N'N ', N'M', 18, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 3, 0, 0, N'MUOM', N'', N'', N'C ', N'M', 19, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 5, 0, 0, N'UPC', N'', N'[M1].[5] WHERE [M1].[4] = ''UP'' AND [M1].[Loop_Seg]=''04W04''', N'C ', N'M', 20, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 7, 0, 0, N'MSTYLE', N'', N'[M1].[7] WHERE [M1].[6] = ''VN'' AND [M1].[Loop_Seg]=''04W04''', N'C ', N'M', 21, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 9, 0, 0, N'CUST_PO', N'', N'[M1].[9] WHERE [M1].[8] = ''PO'' AND [M1].[Loop_Seg]=''04W04''', N'C ', N'M', 22, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 10, 0, 0, N'STSCACOD', N'', N'', N'C ', N'M', 23, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 11, 0, 0, N'STSZCOD', N'', N'', N'C ', N'M', 24, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 12, 0, 0, N'STSZNO', N'', N'', N'C ', N'M', 25, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 13, 0, 0, N'STSHDESC', N'', N'', N'C ', N'M', 26, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 14, 0, 0, N'STLODESC', N'', N'', N'C ', N'M', 27, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 15, 0, 0, N'STSEASON', N'', N'', N'C ', N'M', 28, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 16, 0, 0, N'STDIVISON', N'', N'', N'C ', N'M', 29, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 17, 0, 0, N'STPGROUP', N'', N'', N'C ', N'M', 30, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (36, 18, 0, 0, N'STCOLOR', N'', N'', N'C ', N'M', 31, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (37, 2, 0, 0, N'WAREHOUSE_NO', N'', N'[M1].[2] WHERE [M1].[1] = ''WH'' AND [M1].[Loop_Seg]=''04N9''', N'C ', N'M', 32, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (38, 1, 0, 0, N'XTOTQTY', N'', N'', N'N ', N'M', 33, 0)
