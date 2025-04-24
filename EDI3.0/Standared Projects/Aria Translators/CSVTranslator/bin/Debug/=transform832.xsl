<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <ITEMDOWNLOAD>
            <xsl:apply-templates select="NewDataSet/STYLEMAJOR"/>
            <xsl:apply-templates select="NewDataSet/STYLEDETAIL"/>
        </ITEMDOWNLOAD>
    </xsl:template>

    <!-- Mapping STYLEMAJOR to MASTER -->
    <xsl:template match="STYLEMAJOR">
        <MASTER>
            <ITEM_ID>
                <xsl:value-of select="normalize-space(style)"/>
            </ITEM_ID>
            <DESCRIPTION>
                <xsl:value-of select="normalize-space(desc1)"/>
            </DESCRIPTION>
            <STYLE_ID>
                <xsl:value-of select="normalize-space(cstymajor)"/>
            </STYLE_ID>
            <COLOR_ID>
                <xsl:value-of select="normalize-space(COLORSCODES)"/>
            </COLOR_ID>
            <SIZE_X>
                <xsl:value-of select="normalize-space(SizesCODES)"/>
            </SIZE_X>
            <PRICE1>
                <xsl:value-of select="format-number(totcost, '#.00')"/>
            </PRICE1>
            <SEASON_CLASS>
                <xsl:value-of select="normalize-space(season)"/>
            </SEASON_CLASS>
            <DEFAULT_COO>
                <xsl:value-of select="normalize-space(cdutycur)"/>
            </DEFAULT_COO>
            <PRICE2>
                <xsl:value-of select="format-number(nmcost1, '#.00')"/>
            </PRICE2>
        </MASTER>
    </xsl:template>

    <!-- Mapping STYLEDETAIL to UPC -->
    <xsl:template match="STYLEDETAIL">
        <UPC>
            <ITEM_ID>
                <xsl:value-of select="normalize-space(style)"/>
            </ITEM_ID>
            <UPC_CODE>
                <xsl:value-of select="normalize-space(UPC)"/>
            </UPC_CODE>
            <CFG_CODE>
                <xsl:value-of select="normalize-space(SizesCODES)"/>
            </CFG_CODE>
            <COLOR_ID>
                <xsl:value-of select="normalize-space(COLORSNAMES)"/>
            </COLOR_ID>
            <PIECES>
                <xsl:value-of select="normalize-space(SizesNAMES)"/>
            </PIECES>
        </UPC>
    </xsl:template>

</xsl:stylesheet>
