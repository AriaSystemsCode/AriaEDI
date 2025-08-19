<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>
    <xsl:key name="linesByPO" match="ShippingItem_T" use="PurchaseOrderNumber"/>

    <xsl:template match="/NewDataSet">
        <RECEIPTDOWNLOAD>
		  <!-- Only generate HEADERs and LINEs if ALL INV_TYPE are present -->
            <xsl:if test="not(ShippingItem_T[normalize-space(ProfileValue1) = ''])">
			
            <!-- Group by distinct PO -->
            <xsl:for-each select="ShippingItem_T[generate-id() = generate-id(key('linesByPO', PurchaseOrderNumber)[1])]">
                <HEADER>
                    <PO>
                        <xsl:value-of select="PurchaseOrderNumber"/>
                    </PO>
                    <VENDOR_ORDER>
                        <xsl:value-of select="ShipmentID"/>
                    </VENDOR_ORDER>
                    <!-- Lines belonging to this PO -->
                    <xsl:for-each select="key('linesByPO', PurchaseOrderNumber)">
                        <LINE>
								<RECEIPT_LINE>
								  <xsl:value-of select="concat('1', format-number(AssignedNumber, '000'), SequenceNumber)" />
								</RECEIPT_LINE>

                            <xsl:if test="string(ProfileValue1)">
                                <INV_TYPE>
                                    <xsl:value-of select="ProfileValue1"/>
                                </INV_TYPE>
                            </xsl:if>
                            <ITEM_ID>
                                <xsl:value-of select="ItemUPC"/>
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
            </xsl:for-each>
    </xsl:if>
            <!-- Error Handling Block -->
            <ERRORS>
                <!-- If PO is empty, log error -->
                <xsl:if test="normalize-space(ShippingItem_T[1]/PurchaseOrderNumber) = ''">
                    <ERROR>
                        <MESSAGE>Missing PurchaseOrderNumber</MESSAGE>
                    </ERROR>
                </xsl:if>
                <!-- For each missing ItemUPC, log error -->
                <xsl:for-each select="ShippingItem_T[normalize-space(ItemUPC) = '']">
                    <ERROR>
                        <MESSAGE>Missing ItemUPC for SequenceNumber 
                            <xsl:value-of select="SequenceNumber"/>
                        </MESSAGE>
                    </ERROR>
                </xsl:for-each>
            </ERRORS>
        </RECEIPTDOWNLOAD>
    </xsl:template>
</xsl:stylesheet>
