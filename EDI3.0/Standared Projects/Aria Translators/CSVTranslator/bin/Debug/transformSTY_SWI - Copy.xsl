<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <ITEMDOWNLOAD>
            <xsl:apply-templates select="NewDataSet/STYLEMAJOR"/>
            <ERRORS>
                <xsl:apply-templates select="NewDataSet/STYLEMAJOR" mode="error"/>
                <xsl:apply-templates select="NewDataSet/STYLEDETAIL" mode="error"/>
            </ERRORS>
        </ITEMDOWNLOAD>
    </xsl:template>

    <!-- Mapping STYLEMAJOR to MASTER -->
    <xsl:template match="STYLEMAJOR">
        <xsl:if test="normalize-space(style) != ''">
 <!-- Find related UPCs using starts-with() -->
            <xsl:apply-templates select="//STYLEDETAIL[starts-with(normalize-space(style), normalize-space(current()/style))]"/>
        </xsl:if>
    </xsl:template>

    <!-- Mapping STYLEDETAIL to UPC -->
    <xsl:template match="STYLEDETAIL">
        <xsl:if test="normalize-space(style) != ''">
            <MASTER>
			    <IF_ACTION_ID>Y</IF_ACTION_ID>
				<OWNER_ID />
                <ITEM_ID>
                    <xsl:value-of select="normalize-space(style)"/>
                </ITEM_ID>
                <DESCRIPTION>
                    <xsl:choose>
                        <xsl:when test="normalize-space(desc1) != ''">
                            <xsl:value-of select="normalize-space(desc1)"/>
                        </xsl:when>
                        <xsl:otherwise>N/A</xsl:otherwise>
                    </xsl:choose>
                </DESCRIPTION>
				    <DEFAULT_INV_TYPE>STK</DEFAULT_INV_TYPE>
    <STYLE_ID><xsl:value-of select="normalize-space(style)"/></STYLE_ID>
    <COLOR_ID><xsl:value-of select="normalize-space(COLORSCODES)"/></COLOR_ID>
    <SIZE_X><xsl:value-of select="normalize-space(SizesCODES)"/></SIZE_X>
                
            </MASTER>
 <CONFIG>
    <ITEM_ID>  <xsl:value-of select="normalize-space(style)"/></ITEM_ID>
  </CONFIG>
                    


		 <UPC>
                <ITEM_ID>
                    <xsl:value-of select="normalize-space(style)"/>
                </ITEM_ID>
                <UPC_CODE>
                    <xsl:choose>
                        <xsl:when test="normalize-space(UPC) != ''">
                            <xsl:value-of select="normalize-space(UPC)"/>
                        </xsl:when>
                        <xsl:otherwise>000000000000</xsl:otherwise>
                    </xsl:choose>
                </UPC_CODE>
            </UPC>
        </xsl:if>
    </xsl:template>

    <!-- Error Handling: Capture missing fields inside <ERRORS> -->
    <xsl:template match="STYLEMAJOR" mode="error">
        <xsl:if test="normalize-space(style) = ''">
            <ERROR>
                <MESSAGE>Missing STYLE in STYLEMAJOR</MESSAGE>
            </ERROR>
        </xsl:if>

        <!-- Warning for description length > 25 characters -->
        <xsl:if test="string-length(desc1) > 25">
            <WARNING>
                <MESSAGE>Description is too long for STYLE: <xsl:value-of select="style"/></MESSAGE>
            </WARNING>
        </xsl:if>
    </xsl:template>

    <xsl:template match="STYLEDETAIL" mode="error">
        <xsl:if test="normalize-space(style) = ''">
            <ERROR>
                <MESSAGE>Missing STYLE in STYLEDETAIL</MESSAGE>
            </ERROR>
        </xsl:if>
        <xsl:if test="normalize-space(UPC) = ''">
            <ERROR>
                <MESSAGE>Missing UPC for style <xsl:value-of select="normalize-space(style)"/></MESSAGE>
            </ERROR>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
