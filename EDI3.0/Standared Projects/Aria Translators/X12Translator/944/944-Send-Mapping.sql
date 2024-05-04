/****** Object:  Table [dbo].[TRANSACTION_SEGMENTS_T]    Script Date: 07/22/2018 11:22:33 ******/
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'944', N'RLM', N'004010', N'02', 1, N'ST', N'M', 50)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'944', N'RLM', N'004010', N'02', 2, N'W17', N'M', 51)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'944', N'RLM', N'004010', N'03', 1, N'W07', N'M', 52)
INSERT [dbo].[TRANSACTION_SEGMENTS_T] ([DIRECTION], [TRANSACTION_TYPE], [MAP_SET], [VERSION], [LOOP_ID], [SEGMENT_ORDER], [SEGMENT_ID], [USAGE], [TRANSACTION_SEGMENTS_KEY]) VALUES (N'S', N'944', N'RLM', N'004010', N'04', 2, N'SE', N'M', 53)

/****** Object:  Table [dbo].[TRANSACTION_MAP_T]    Script Date: 07/22/2018 11:22:33 ******/
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (50, 1, 0, 0, N'', N'', N'''944''', N'C ', N'M', 357, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (50, 2, 0, 0, N'', N'', N'TRANS_SET', N'C ', N'M', 358, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (51, 1, 0, 0, N'', N'', N'SHIPMENT_ID', N'C ', N'M', 359, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (51, 2, 0, 0, N'', N'', N'WARE_REC', N'C ', N'M', 360, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (51, 3, 0, 0, N'', N'', N'MSHIP_REF', N'C ', N'M', 361, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (51, 4, 0, 0, N'', N'', N'MSHIP_REF', N'C ', N'M', 362, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (52, 1, 0, 0, N'', N'', N'SEQ_NO', N'N ', N'M', 363, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (52, 2, 0, 0, N'', N'', N'[XQTY] WHERE [XQTY] != ''''', N'N ', N'M', 364, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (52, 3, 0, 0, N'', N'', N'[MUOM] WHERE [MUOM] !=''''', N'C ', N'M', 365, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (52, 4, 0, 0, N'', N'', N'[MUPC] WHERE [MUPC] != ''''', N'C ', N'M', 366, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (52, 5, 0, 0, N'', N'', N'[MSTYLE] WHERE [MSTYLE] != ''''', N'C ', N'M', 367, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (52, 6, 0, 0, N'', N'', N'MWARE_NO', N'C ', N'M', 368, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (52, 7, 0, 0, N'', N'', N'PONUMBER', N'C ', N'M', 369, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (53, 1, 0, 0, N'', N'', N'CAST(MSEGNO AS INT)+1', N'N ', N'M', 370, 0)
INSERT [dbo].[TRANSACTION_MAP_T] ([TRANSACTION_SEGMENTS_KEY], [FIELD_ORDER], [START_POSITION], [FIELD_LENGTH], [FIELD_NAME], [CONDITION], [VALUE], [DATA_TYPE], [USAGE], [TRANSACTION_MAP_KEY], [IS_KEY]) VALUES (53, 2, 0, 0, N'', N'', N'TRANS_SET', N'C ', N'M', 371, 0)
