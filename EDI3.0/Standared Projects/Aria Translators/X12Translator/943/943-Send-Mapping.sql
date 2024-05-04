/****** Object:  Table [dbo].[TRANSACTION_SEGMENTS_T]    Script Date: 06/26/2018 09:13:34 ******/

INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'943', N'RLM', N'004010', N'03', 1, N'ST', N'M', 39)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'943', N'RLM', N'004010', N'03', 1, N'W06', N'M', 40)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'943', N'RLM', N'004010', N'03', 2, N'N1', N'O', 41)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'943', N'RLM', N'004010', N'03', 3, N'N9', N'M', 42)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'943', N'RLM', N'004010', N'03', 3, N'N9', N'M', 43)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'943', N'RLM', N'004010', N'03', 4, N'G62', N'M', 44)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'943', N'RLM', N'004010', N'04', 1, N'W04', N'M', 45)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'943', N'RLM', N'004010', N'04', 2, N'N9', N'M', 46)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'943', N'RLM', N'004010', N'05', 1, N'W03', N'M', 47)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'943', N'RLM', N'004010', N'05', 2, N'SE', N'M', 48)

/****** Object:  Table [dbo].[TRANSACTION_MAP_T]    Script Date: 06/26/2018 09:13:34 ******/
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (39, 1, 0, 0, N'', N'', N'''943''', N'C ', N'M', 34, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (39, 2, 0, 0, N'', N'', N'TRANS_SET', N'C ', N'M', 35, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (40, 1, 0, 0, N'', N'', N'''J''', N'C ', N'O', 36, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (40, 2, 0, 0, N'', N'', N'SHIP_REFERENCE', N'C ', N'O', 37, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (40, 3, 0, 0, N'', N'', N'CRDATE', N'D ', N'M', 38, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (40, 4, 0, 0, N'', N'', N'SHIPMENT_ID', N'C ', N'M', 39, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (41, 1, 0, 0, N'', N'', N'''ZL''', N'C ', N'M', 40, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (41, 2, 0, 0, N'', N'', N'COMP_NAME', N'C ', N'O', 41, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (42, 1, 0, 0, N'', N'', N'''ABS''', N'C ', N'M', 42, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (42, 2, 0, 0, N'', N'', N'SHIP_VIA', N'C ', N'M', 43, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (43, 1, 0, 0, N'', N'', N'''MAN''', N'C ', N'M', 44, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (43, 2, 0, 0, N'', N'', N'CONTAINER_ID', N'C ', N'O', 45, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (44, 1, 0, 0, N'', N'', N'''17''', N'C ', N'M', 46, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (44, 2, 0, 0, N'', N'', N'Est_Delivery_DATE', N'D ', N'M', 47, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 1, 0, 0, N'', N'', N'SEQ_NO', N'N ', N'M', 48, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 2, 0, 0, N'', N'', N'QTY_Shipped', N'N ', N'M', 49, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 3, 0, 0, N'', N'', N'MUOM', N'C ', N'M', 50, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 4, 0, 0, N'', N'', N'''UP''', N'C ', N'M', 51, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 5, 0, 0, N'', N'', N'UPC', N'C ', N'M', 52, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 6, 0, 0, N'', N'', N'''VN''', N'C ', N'M', 53, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 7, 0, 0, N'', N'', N'MSTYLE', N'C ', N'M', 54, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 8, 0, 0, N'', N'', N'''PO''', N'C ', N'M', 55, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 9, 0, 0, N'', N'', N'CUST_PO', N'C ', N'M', 56, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 10, 0, 0, N'', N'', N'STSCACOD', N'C ', N'M', 57, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 11, 0, 0, N'', N'', N'STSZCOD', N'C ', N'M', 58, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 12, 0, 0, N'', N'', N'STSZNO', N'C ', N'M', 59, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 13, 0, 0, N'', N'', N'STSHDESC', N'C ', N'M', 60, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 14, 0, 0, N'', N'', N'STLODESC', N'C ', N'M', 61, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 15, 0, 0, N'', N'', N'STSEASON', N'C ', N'M', 62, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 16, 0, 0, N'', N'', N'STDIVISON', N'C ', N'M', 63, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 17, 0, 0, N'', N'', N'STPGROUP', N'C ', N'O', 64, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (45, 18, 0, 0, N'', N'', N'STCOLOR', N'C ', N'M', 65, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (46, 1, 0, 0, N'', N'', N'''WH''', N'C ', N'M', 66, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (46, 2, 0, 0, N'', N'', N'WAREHOUSE_NO', N'C ', N'M', 67, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (47, 1, 0, 0, N'', N'', N'XTOTQTY', N'N ', N'M', 68, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (48, 1, 0, 0, N'', N'', N'CAST(MSEGNO AS INT)+1', N'N ', N'M', 69, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (48, 2, 0, 0, N'', N'', N'TRANS_SET', N'C ', N'M', 70, 0)