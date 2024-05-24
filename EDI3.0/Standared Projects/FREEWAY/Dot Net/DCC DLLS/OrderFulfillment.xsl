<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <AmazonEnvelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="amzn-envelope.xsd">
            <xsl:copy-of  select="//Header"/>
            <xsl:copy-of  select="//MessageType"/>
            <xsl:copy-of  select="//Message"/>
        </AmazonEnvelope>
    </xsl:template>

</xsl:stylesheet>