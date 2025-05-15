<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    
    <xsl:template match="/Orders/result/order">
        <!-- Start of EDI 810 Invoice -->
        <xsl:text>ST*810*0001~&#10;</xsl:text>
        <xsl:text>BIG*</xsl:text>
        <xsl:value-of select="substring(creationTime, 1, 10)"/>
        <xsl:text>*</xsl:text>
        <xsl:value-of select="reference"/>
        <xsl:text>~~&#10;</xsl:text>
        
        <!-- Buyer Info -->
        <xsl:text>N1*BT*</xsl:text>
        <xsl:value-of select="buyerCompanyName"/>
        <xsl:text>~&#10;</xsl:text>
        
        <!-- Seller Info -->
        <xsl:text>N1*ST*</xsl:text>
        <xsl:value-of select="sellerCompanyName"/>
        <xsl:text>~&#10;</xsl:text>
        
        <!-- Line Items -->
        <xsl:for-each select="appTransactionsDetails">
            <xsl:text>IT1*</xsl:text>
            <xsl:value-of select="lineNo"/>
            <xsl:text>*</xsl:text>
            <xsl:value-of select="quantity"/>
            <xsl:text>**</xsl:text>
            <xsl:value-of select="netPrice"/>
            <xsl:text>**UP*</xsl:text>
            <xsl:value-of select="itemCode"/>
            <xsl:text>~&#10;</xsl:text>
        </xsl:for-each>
        
        <!-- Total Amount -->
        <xsl:text>TDS*</xsl:text>
        <xsl:value-of select="totalAmount * 100"/>
        <xsl:text>~&#10;</xsl:text>
        
        <!-- End of EDI Transaction -->
        <xsl:text>SE*6*0001~&#10;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
