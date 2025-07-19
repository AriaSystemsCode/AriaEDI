<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    
    <!-- Match the root element and create the output -->
    <xsl:output method="xml" indent="yes"/>

    <!-- Template for the root element -->
    <xsl:template match="/">

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

                <!-- ShippingAddress_T for WH_COMPANY as a child of ShippingHeader_T -->
                <ShippingAddress_T>
                    <ShippingID><xsl:value-of select="VENDOR_ORDER"/></ShippingID>
                    <Name1><xsl:value-of select="WH_COMPANY"/></Name1>
                    <Address1><xsl:value-of select="WH_ADDRESS1"/></Address1>
                    <State><xsl:value-of select="WH_STATE"/></State>
                    <PostalCode><xsl:value-of select="WH_ZIP"/></PostalCode>
                    <Country><xsl:value-of select="WH_COUNTRY"/></Country>
                    <Type><xsl:value-of select="RECEIPT_SHIPTO_ID"/></Type>
                </ShippingAddress_T>

                <!-- ShippingAddress_T for T_COMPANY as a child of ShippingHeader_T -->
                <ShippingAddress_T>
                    <ShippingID><xsl:value-of select="VENDOR_ORDER"/></ShippingID>
                    <Name1><xsl:value-of select="T_COMPANY"/></Name1>
                    <Address1><xsl:value-of select="T_ADDRESS1"/></Address1>
                    <City><xsl:value-of select="T_CITY"/></City>
                    <State><xsl:value-of select="T_STATE"/></State>
                    <PostalCode><xsl:value-of select="T_ZIP"/></PostalCode>
                    <Country><xsl:value-of select="T_COUNTRY"/></Country>
                    <Type><xsl:value-of select="RECEIPT_SHIPTO_ID"/></Type>
                </ShippingAddress_T>

                <!-- ShippingDates_T for STAT_DATE as a child of ShippingHeader_T -->
                <ShippingDates_T>
                    <ShippingID><xsl:value-of select="VENDOR_ORDER"/></ShippingID>
                    <Type>STAT_DATE</Type>
                    <Date><xsl:value-of select="STAT_DATE"/></Date>
                </ShippingDates_T>

                <!-- ShippingDates_T for CLOSED_DATETIME as a child of ShippingHeader_T -->
                <ShippingDates_T>
                    <ShippingID><xsl:value-of select="VENDOR_ORDER"/></ShippingID>
                    <Type>CLOSED_DATETIME</Type>
                    <Date><xsl:value-of select="CLOSED_DATETIME"/></Date>
                </ShippingDates_T>

                <!-- ShippingDates_T for FIRST_REC_DATE as a child of ShippingHeader_T -->
                <ShippingDates_T>
                    <ShippingID><xsl:value-of select="VENDOR_ORDER"/></ShippingID>
                    <Type>FIRST_REC_DATE</Type>
                    <Date><xsl:value-of select="FIRST_REC_DATE"/></Date>
                </ShippingDates_T>
 
                <!-- ShippingItem_T records as children of ShippingHeader_T -->
                <xsl:for-each select="DETAIL">
                    <ShippingItem_T>
                        <ShippingID><xsl:value-of select="../VENDOR_ORDER"/></ShippingID>
                        <SenderID><xsl:value-of select="../WAREHOUSE_ID"/></SenderID>
                        <PartnerID><xsl:value-of select="../WAREHOUSE_ID"/></PartnerID>
                        <Shipping><xsl:value-of select="../VENDOR_ORDER"/></Shipping>
                        <AssignedNumber><xsl:value-of select="RECEIPT_LINE"/></AssignedNumber>
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

                <!-- ShippingReference_T records as children of ShippingHeader_T -->
                <xsl:for-each select="DETAIL">
                    <ShippingReference_T>
                        <ShippingID><xsl:value-of select="VENDOR_ORDER"/></ShippingID>
                        <ReferenceType><xsl:value-of select="VENDOR_ID"/></ReferenceType>
                        <ReferenceNo><xsl:value-of select="SERIAL_NUMBER"/></ReferenceNo>
                    </ShippingReference_T>
                </xsl:for-each>

            </ShippingHeader_T>

        </xsl:for-each>

    </xsl:template>
    
</xsl:stylesheet>
