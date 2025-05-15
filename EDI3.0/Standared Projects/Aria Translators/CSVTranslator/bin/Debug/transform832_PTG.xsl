<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>


    <xsl:template match="/">
        <ITEMDOWNLOAD>
            <xsl:apply-templates select="NewDataSet/STYLEMAJOR"/>
            <ERRORS>
                <xsl:apply-templates select="NewDataSet/STYLEMAJOR" mode="error"/>
                <xsl:apply-templates select="NewDataSet/STYLEDETAIL" mode="error"/>
            </ERRORS>
        </ITEMDOWNLOAD>
    </xsl:template>
<!-- Define special character replacements -->
<xsl:variable name="specialChars" select="'!@#$%^&amp;*()_+=[]|:;.,?/~`'"/>
    <xsl:variable name="replacementChars" select="'                '"/>
	
    <!-- Mapping STYLEMAJOR to MASTER -->
    <xsl:template match="STYLEMAJOR">
        <xsl:if test="normalize-space(style) != ''">
 <!-- Find related UPCs using starts-with() -->
            <xsl:apply-templates select="//STYLEDETAIL[starts-with(normalize-space(style), normalize-space(current()/style))]"/>
        </xsl:if>
    </xsl:template>

    <!-- Mapping STYLEDETAIL to UPC -->
    <xsl:template match="STYLEDETAIL">
        <xsl:if test="normalize-space(UPC) != ''">
            <MASTER>
			    <IF_ACTION_ID>Y</IF_ACTION_ID>
				<OWNER_ID />
                <ITEM_ID>
                    <xsl:value-of select="normalize-space(UPC)"/>
                </ITEM_ID>
                <DESCRIPTION>
                    <xsl:choose>
                        <xsl:when test="normalize-space(desc1) != ''">
							<xsl:value-of select="translate(normalize-space(desc1), $specialChars, $replacementChars)"/>

                        </xsl:when>
                        <xsl:otherwise>N/A</xsl:otherwise>
                    </xsl:choose>
                </DESCRIPTION>
				<ALT_ITEM_ID1>
                    <xsl:value-of select="normalize-space(style)"/>
                </ALT_ITEM_ID1>				   
				   <DEFAULT_INV_TYPE>STK</DEFAULT_INV_TYPE>
    <STYLE_ID><xsl:value-of select="normalize-space(cstymajor)"/></STYLE_ID>
    <COLOR_ID><xsl:value-of select="normalize-space(COLORSCODES)"/></COLOR_ID>
    <SIZE_X><xsl:value-of select="normalize-space(SizesCODES)"/></SIZE_X>
                
            </MASTER>
 <CONFIG>
    <ITEM_ID>  <xsl:value-of select="normalize-space(UPC)"/></ITEM_ID>
  </CONFIG>
                    


		 <UPC>
                <ITEM_ID>
                    <xsl:value-of select="normalize-space(UPC)"/>
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

     
 <!-- Function to replace special characters -->
    <xsl:template name="replaceSpecialChars">
        <xsl:param name="text"/>
        
        <xsl:choose>
            <xsl:when test="contains($text, '&amp;')">
                <xsl:call-template name="replaceSpecialChars">
                    <xsl:with-param name="text" select="concat(substring-before($text, '&amp;'), 'and', substring-after($text, '&amp;'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($text, '@')">
                <xsl:call-template name="replaceSpecialChars">
                    <xsl:with-param name="text" select="concat(substring-before($text, '@'), ' at ', substring-after($text, '@'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($text, '#')">
                <xsl:call-template name="replaceSpecialChars">
                    <xsl:with-param name="text" select="concat(substring-before($text, '#'), ' number ', substring-after($text, '#'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
