<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xsl">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/SHIPMENTUPLOAD">
    
      <xsl:for-each select="HEADER">
        <xsl:variable name="headerOrderId" select="normalize-space(ORDER_ID)"/>

         
          <ShippingOrderHeader_T>
            <OID><xsl:value-of select="$headerOrderId"/></OID>
            <SenderID><xsl:value-of select="WAREHOUSE_ID"/></SenderID>
            <PartnerID><xsl:value-of select="OWNER_ID"/></PartnerID>
            <PurchaseOrderNumber><xsl:value-of select="PO_NUM"/></PurchaseOrderNumber>
            <PaymentMethodCode><xsl:value-of select="BILL_METHOD"/></PaymentMethodCode>
            <StandardCarrierAlphaCode><xsl:value-of select="CARRIER_ID"/></StandardCarrierAlphaCode>
            <QuantityOrdered><xsl:value-of select="PIECES_ORDERED"/></QuantityOrdered>
            <Weight><xsl:value-of select="TOTAL_WEIGHT"/></Weight>
            <WeightUOMCode><xsl:value-of select="TOTAL_CUBE"/></WeightUOMCode>
            <TransportationMethodCode><xsl:value-of select="SHIP_METHOD"/></TransportationMethodCode>
            <TransportationMethod><xsl:value-of select="SHIP_METHOD_DESC"/></TransportationMethod>
            <PalletExchangeCode><xsl:value-of select="PALLET_ID_FROM"/></PalletExchangeCode>
            <PalletExchangeInstruction><xsl:value-of select="PALLET_TYPE"/></PalletExchangeInstruction>
            <CODPaymentMethod><xsl:value-of select="COD_CASH_ONLY_FLAG"/></CODPaymentMethod>
          
		            <xsl:for-each select="/SHIPMENTUPLOAD/HEADER/DETAIL[normalize-space(ORDER_ID) = $headerOrderId]">
            <ShippingOrderItem_T>
              <SenderID><xsl:value-of select="WAREHOUSE_ID"/></SenderID>
              <OID><xsl:value-of select="ORDER_ID"/></OID>
              <QuantityOrdered><xsl:value-of select="PIECES_ORDERED"/></QuantityOrdered>
              <PartnerID><xsl:value-of select="OWNER_ID"/></PartnerID>
              <FreightClassCode><xsl:value-of select="FREIGHT_TERMS"/></FreightClassCode>
              <PalletBlockandTiers><xsl:value-of select="ORIG_PALLET_ID"/></PalletBlockandTiers>
              <WarehouseLotNumber><xsl:value-of select="LOT_ID"/></WarehouseLotNumber>
              <ItemDescription><xsl:value-of select="ITEM_DESC"/></ItemDescription>
              <UnitWeight><xsl:value-of select="UOM_MEASURED_WEIGHT"/></UnitWeight>
              <ItemUPC><xsl:value-of select="ITEM_ID"/></ItemUPC>
              <GrossWeight><xsl:value-of select="TOTAL_WEIGHT"/></GrossWeight>
              <VendorItemNumber><xsl:value-of select="VENDOR_NUMBER"/></VendorItemNumber>
              <VendorStyleNumber><xsl:value-of select="STYLE_ID"/></VendorStyleNumber>
              <VendorColor><xsl:value-of select="COLOR_ID"/></VendorColor>
              <VendorSizeCode><xsl:value-of select="SIZE_X"/></VendorSizeCode>
              <SizeNRFCode><xsl:value-of select="SIZE_Y"/></SizeNRFCode>
            </ShippingOrderItem_T>
          </xsl:for-each>

		  
		  </ShippingOrderHeader_T>

          <!-- FIXED: Use variable inside the DETAIL filter -->

 
      </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
