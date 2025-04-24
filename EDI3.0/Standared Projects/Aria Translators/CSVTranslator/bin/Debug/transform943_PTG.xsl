<?xml version="1.0" encoding="utf-8"?> 
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/NewDataSet">
        <RECEIPTDOWNLOAD>
            <!-- Only output PO if not empty -->
            <xsl:if test="normalize-space(ShippingItem_T[1]/PurchaseOrderNumber) != ''">
                
                <!-- Loop through each ShippingItem_T and group the lines under HEADER -->
                <xsl:for-each select="ShippingItem_T">
                    <!-- Only output HEADER once for each PurchaseOrderNumber -->
                     
                        <HEADER>
                            <PO>
                                <xsl:value-of select="PurchaseOrderNumber"/>
                            </PO>
                            <vendor_order>
                                <xsl:value-of select="/NewDataSet/ShippingHeader_T/ShipmentID"/>
                            </vendor_order>
                            
                            <!-- Now output all LINEs under this HEADER -->
                             
									<!-- Only print lines where ItemUPC is not empty -->
                                    <LINE>
                                        <RECEIPT_LINE>
                                            <xsl:value-of select="concat(AssignedNumber, SequenceNumber)" />
                                        </RECEIPT_LINE>
                                        <PurchaseOrderNumber>
                                            <xsl:value-of select="PurchaseOrderNumber"/>
                                        </PurchaseOrderNumber>
										 
										
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
