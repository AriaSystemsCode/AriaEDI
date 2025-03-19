<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/NewDataSet">
        <RECEIPTDOWNLOAD>
            <HEADER>
                <PO>
                    <xsl:value-of select="ShippingHeader_T/PurchaseOrderNumber"/>
                </PO>
                <vendor_order>
                    <xsl:value-of select="ShippingHeader_T/ShipmentID"/>
                </vendor_order>
                
                <xsl:for-each select="ShippingItem_T">
                    <LINE>
                        <RECEIPT_LINE>
                            <xsl:value-of select="ShipmentID"/>
                        </RECEIPT_LINE>
                        <ITEM_ID>
                            <xsl:value-of select="VendorStyleNumber"/>
                        </ITEM_ID>
                        <PIECES_ORDERED>
                            <xsl:value-of select="QuantityOrdered"/>
                        </PIECES_ORDERED>
                        <PIECES_EXPECTED>
                            <xsl:value-of select="QuantityOrdered"/>
                        </PIECES_EXPECTED>
                    </LINE>
                </xsl:for-each>
            </HEADER>
        </RECEIPTDOWNLOAD>
    </xsl:template>
</xsl:stylesheet>
