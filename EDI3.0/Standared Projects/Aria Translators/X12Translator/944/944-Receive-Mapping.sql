/***944-Receive*** Object:  Table [dbo].[TRANSACTION_SEGMENTS_T]    Script Date: 06/26/2018 09:09:33 ******/
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'944', N'RLM', N'004010', N'02', 1, N'W17', N'M', 58)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'R', N'944', N'RLM', N'004010', N'03', 1, N'W07', N'M', 59)
/***944-Receive*** Object:  Table [dbo].[TRANSACTION_MAP_T]    Script Date: 06/26/2018 09:09:33 ******/
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (58, 1, 0, 0, N'SENDER_ID', N'', N'[M1].[Sender_Id] WHERE [M1].[Loop_id]=''02''', N'C ', N'M', 80, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (58, 1, 0, 0, N'SHIPMENT_ID', N'', N'', N'C ', N'M', 81, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (58, 2, 0, 0, N'WARE_REC', N'', N'', N'C ', N'M', 82, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (58, 3, 0, 0, N'MSHIP_REF', N'', N'', N'C ', N'M', 83, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (59, 1, 0, 0, N'SEQ_NO', N'', N'', N'N ', N'M', 84, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (59, 1, 0, 0, N'SENDER_ID', N'', N'[M1].[Sender_Id] WHERE [M1].[Loop_id]=''03''', N'C ', N'M', 85, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (59, 2, 0, 0, N'XQTY', N'', N'', N'N ', N'M', 86, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (59, 3, 0, 0, N'MUOM', N'', N'', N'C ', N'M', 87, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (59, 4, 0, 0, N'MUPC', N'', N'', N'C ', N'M', 88, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (59, 5, 0, 0, N'MSTYLE', N'', N'', N'C ', N'M', 89, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (59, 6, 0, 0, N'MWARE_NO', N'', N'', N'C ', N'M', 90, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (59, 7, 0, 0, N'PONUMBER', N'', N'', N'C ', N'M', 91, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (58, 1, 0, 0, N'TRAN_PURPOSE_CODE', N'', N'''F'' WHERE 1=1', N'C ', N'M', 92, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (58, 1, 0, 0, N'TRAN_PURPOSE', N'', N'''Original'' WHERE 1=1', N'C ', N'M', 93, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (59, 1, 0, 0, N'SHIPMENT_ID', N'', N'[M1].[1] WHERE [M1].[Loop_Seg]=''02W17''', N'C ', N'M', 94, 0)
