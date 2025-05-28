<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xsl">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="/SHIPMENTUPLOAD">
		<Root>
			<xsl:for-each select="HEADER">
				<xsl:variable name="headerOrderId" select="normalize-space(ORDER_ID)"/>
				<!-- ShippingOrderHeader_T block -->
				<ShippingOrderHeader_T>
					<OID>
						<xsl:value-of select="$headerOrderId"/>
					</OID>
					<ShippingOrder>
						<xsl:value-of select="$headerOrderId"/>
					</ShippingOrder>
					<SenderID>
						<xsl:value-of select="WAREHOUSE_ID"/>
					</SenderID>
					<PartnerID>
						<xsl:value-of select="OWNER_ID"/>
					</PartnerID>
					<PurchaseOrderNumber>
						<xsl:value-of select="PO_NUM"/>
					</PurchaseOrderNumber>
					<PaymentMethodCode>
						<xsl:value-of select="BILL_METHOD"/>
					</PaymentMethodCode>
					<StandardCarrierAlphaCode>
						<xsl:value-of select="CARRIER_ID"/>
					</StandardCarrierAlphaCode>
					<xsl:if test="PIECES_ORDERED != '' and PIECES_ORDERED">
						<QuantityOrdered>
							<xsl:value-of select="PIECES_ORDERED"/>
						</QuantityOrdered>
					</xsl:if>
					<Weight>
						<xsl:value-of select="TOTAL_WEIGHT"/>
					</Weight>
					<xsl:if test="USR_UOM != '' and USR_UOM">
						<WeightUOMCode>
							<xsl:value-of select="USR_UOM"/>
						</WeightUOMCode>
					</xsl:if>
					<TransportationMethodCode>
						<xsl:value-of select="SHIP_METHOD"/>
					</TransportationMethodCode>
					<TransportationMethod>
						<xsl:value-of select="SHIP_METHOD_DESC"/>
					</TransportationMethod>
					<xsl:if test="PALLET_ID_FROM != '' and PALLET_ID_FROM">
						<PalletExchangeCode>
							<xsl:value-of select="PALLET_ID_FROM"/>
						</PalletExchangeCode>
					</xsl:if>
					<xsl:if test="PALLET_TYPE != '' and PALLET_TYPE">
						<PalletExchangeInstruction>
							<xsl:value-of select="PALLET_TYPE"/>
						</PalletExchangeInstruction>
					</xsl:if>
					<CODPaymentMethod>
						<xsl:value-of select="COD_CASH_ONLY_FLAG"/>
					</CODPaymentMethod>
					<CPUA></CPUA>
					<CSEAL_NO></CSEAL_NO>
					<CFCHRGTRM></CFCHRGTRM>
					<TRAILER_NO></TRAILER_NO>
					<CPRO_NO></CPRO_NO>
					<CARRAUTHNO></CARRAUTHNO>
				</ShippingOrderHeader_T>
				<!-- ShippingOrderDates_T records -->
				<xsl:if test="normalize-space(START_PICK_DATE) != ''">
					<ShippingOrderDates_T>
						<Date>
							<xsl:value-of select="normalize-space(START_PICK_DATE)" />
						</Date>
						<Type>Start</Type>
						<OID>
							<xsl:value-of select="$headerOrderId"/>
						</OID>
						<ShippingOrder>
							<xsl:value-of select="$headerOrderId"/>
						</ShippingOrder>
					</ShippingOrderDates_T>
				</xsl:if>
				<xsl:if test="normalize-space(DATE_SHIPPED) != ''">
					<ShippingOrderDates_T>
						<Date>
							<xsl:value-of select="normalize-space(DATE_SHIPPED)" />
						</Date>
						<Type>ship date</Type>
						<OID>
							<xsl:value-of select="$headerOrderId"/>
						</OID>
						<ShippingOrder>
							<xsl:value-of select="$headerOrderId"/>
						</ShippingOrder>
					</ShippingOrderDates_T>
				</xsl:if>
				<!-- ShippingOrderItem_T entries -->
				<xsl:for-each select="/SHIPMENTUPLOAD/HEADER/DETAIL[normalize-space(ORDER_ID) = $headerOrderId]">
					<ShippingOrderItem_T>
						<OID>
							<xsl:value-of select="ITEM_ID"/>
						</OID>
						<ShippingOrder>
							<xsl:value-of select="ORDER_ID"/>
						</ShippingOrder>
						<BuyerStyleNumber></BuyerStyleNumber>
						<SenderID>
							<xsl:value-of select="WAREHOUSE_ID"/>
						</SenderID>
						<QuantityOrdered>
							<xsl:value-of select="PIECES_ORDERED"/>
						</QuantityOrdered>
						<ItemUPC>
							<xsl:value-of select="ITEM_ID"/>
						</ItemUPC>
						<PartnerID>
							<xsl:value-of select="OWNER_ID"/>
						</PartnerID>
						<xsl:if test="VENDOR_NUMBER != '' and VENDOR_NUMBER">
							<FreightClassCode>
								<xsl:value-of select="FREIGHT_TERMS"/>
							</FreightClassCode>
							<PalletBlockandTiers>
								<xsl:value-of select="ORIG_PALLET_ID"/>
							</PalletBlockandTiers>
							<WarehouseLotNumber>
								<xsl:value-of select="LOT_ID"/>
							</WarehouseLotNumber>
							<ItemDescription>
								<xsl:value-of select="ITEM_DESC"/>
							</ItemDescription>
							<UnitWeight>
								<xsl:value-of select="UOM_MEASURED_WEIGHT"/>
							</UnitWeight>
							<GrossWeight>
								<xsl:value-of select="TOTAL_WEIGHT"/>
							</GrossWeight>
							<VendorItemNumber>
								<xsl:value-of select="VENDOR_NUMBER"/>
							</VendorItemNumber>
							<VendorStyleNumber>
								<xsl:value-of select="STYLE_ID"/>
							</VendorStyleNumber>
							<VendorColor>
								<xsl:value-of select="COLOR_ID"/>
							</VendorColor>
							<VendorSizeCode>
								<xsl:value-of select="SIZE_X"/>
							</VendorSizeCode>
							<SizeNRFCode>
								<xsl:value-of select="SIZE_Y"/>
							</SizeNRFCode>
						</xsl:if>
					</ShippingOrderItem_T>
				</xsl:for-each>
			<!-- ShippingOrderItem_T entries -->
				<xsl:for-each select="/SHIPMENTUPLOAD/HEADER/CARTON[normalize-space(ORDER_ID) = $headerOrderId]">
					<ShippingOrderCarton_T>
						<OID>
							<xsl:value-of select="CARTON_X"/>
						</OID>
						<ShippingOrder>
							<xsl:value-of select="ORDER_ID"/>
						</ShippingOrder>
						<SenderID>
							<xsl:value-of select="WAREHOUSE_ID"/>
						</SenderID>
						<PartnerID>
							<xsl:value-of select="OWNER_ID"/>
						</PartnerID>
						<ShippingorderID>
							<xsl:value-of select="ORDER_ID"/>
						</ShippingorderID>
						<CartonSerialNumber>
							<xsl:value-of select="CARTON_ID_FROM"/>
						</CartonSerialNumber>
						<Location>
							<xsl:value-of select="LOCATION_ID_FROM"/>
						</Location>
						</ShippingOrderCarton_T>
			        <xsl:for-each select="/SHIPMENTUPLOAD/HEADER/CARTON/CARTONDETAIL[normalize-space(ORDER_ID) = $headerOrderId]">
					<ShippingOrderItemCartons_T>
						<OID>
							<xsl:value-of select="$headerOrderId"/>
						</OID>
						<Packno>
							<xsl:value-of select="ORDER_ID"/>
						</Packno>
						<CartonID>
							<xsl:value-of select="CARTON_X"/>
						</CartonID>
						<ItemID>
							<xsl:value-of select="ITEM_ID"/>
						</ItemID>
						<QTY>
							<xsl:value-of select="PIECES_TO_MOVE"/>
						</QTY>
						</ShippingOrderItemCartons_T>
						</xsl:for-each>
			      </xsl:for-each>
			
			</xsl:for-each>
		</Root>
	</xsl:template>
</xsl:stylesheet>
