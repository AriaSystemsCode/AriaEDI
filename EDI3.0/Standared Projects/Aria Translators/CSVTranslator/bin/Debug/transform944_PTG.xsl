<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    
    <!-- Match the root element and create the output -->
    <xsl:output method="xml" indent="yes"/>

    <!-- Template for the root element -->
    <xsl:template match="/">
	<root>
        <!-- Loop through each HEADER -->
        <xsl:for-each select="RECEIPTUPLOAD/HEADER">
            
            <!-- ShippingHeader_T record -->
            <ShippingHeader_T>
                <SenderID><xsl:value-of select="WAREHOUSE_ID"/></SenderID>
                <PartnerID><xsl:value-of select="WAREHOUSE_ID"/></PartnerID>
                <ShippingID><xsl:value-of select="VENDOR_ORDER"/></ShippingID>
                <TransactionPurpose><xsl:value-of select="PICK_DOC_FORM_ID"/></TransactionPurpose>
                <DepositorOrderNumber><xsl:value-of select="RELEASE_NUM"/></DepositorOrderNumber>
                <PurchaseOrderNumber><xsl:value-of select="PO"/></PurchaseOrderNumber>
                <EquipmentTypeCode><xsl:value-of select="PICK_DOC_FORM_ID"/></EquipmentTypeCode>
                <EquipmentType><xsl:value-of select="TRUCK_ID"/></EquipmentType>
                <QuantityOrdered><xsl:value-of select="TOT_PIECES"/></QuantityOrdered>
                <Weight><xsl:value-of select="TOT_WEIGHT"/></Weight>
                <WarehouseReceiptId><xsl:value-of select="RECEIPT_TYPE"/></WarehouseReceiptId>

               
                <!-- ShippingItem_T records as children of ShippingHeader_T -->
                <xsl:for-each select="DETAIL">
                    <ShippingItem_T>
                        <ShippingID><xsl:value-of select="../VENDOR_ORDER"/></ShippingID>
                        <SenderID><xsl:value-of select="../WAREHOUSE_ID"/></SenderID>
                        <PartnerID><xsl:value-of select="../WAREHOUSE_ID"/></PartnerID>
                        <Shipping><xsl:value-of select="../VENDOR_ORDER"/></Shipping>
						<AssignedNumber><xsl:value-of select="substring(translate(RECEIPT_LINE, translate(RECEIPT_LINE, '0123456789', ''), ''), 1, 1)" /></AssignedNumber>
                        <QuantityOrdered><xsl:value-of select="PIECES_RECEIVED"/></QuantityOrdered>
                        <QuantityUOMCode><xsl:value-of select="USR_UOM"/></QuantityUOMCode>
                        <FreightClassCode><xsl:value-of select="FREIGHT_COSTS"/></FreightClassCode>
                        <Pack><xsl:value-of select="TOT_LINES"/></Pack>
                        <PackSize><xsl:value-of select="TOT_PIECES"/></PackSize>
                        <PackUOM><xsl:value-of select="TOT_CUBE"/></PackUOM>
                        <Volume><xsl:value-of select="TOT_CUBE"/></Volume>
                        <ItemUPC><xsl:value-of select="ITEM_ID"/></ItemUPC>
                        <VendorItemNumber><xsl:value-of select="VENDOR_ITEM_ID"/></VendorItemNumber>
                        <PurchaseOrderNumber><xsl:value-of select="../PO"/></PurchaseOrderNumber>
                    </ShippingItem_T>
                </xsl:for-each>

                
            </ShippingHeader_T>

        </xsl:for-each>
</root>
    </xsl:template>
    
</xsl:stylesheet>
