<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/NewDataSet">
        <ORDERDOWNLOAD>
            <HEADER>
                <ORDER_ID>
                    <xsl:value-of select="ShippingOrderHeader_T/ShippingOrder"/>
                </ORDER_ID>
                <CARRIER_ID>
                    <xsl:value-of select="ShippingOrderHeader_T/StandardCarrierAlphaCode"/>
                </CARRIER_ID>
                <SHIP_METHOD>
                    <xsl:value-of select="ShippingOrderHeader_T/TransportationMethodCode"/>
                </SHIP_METHOD>
                <S_COMPANY>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPFROMADDRESS']/Name1"/>
                </S_COMPANY>
                <S_ADDRESS1>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPFROMADDRESS']/Address1"/>
                </S_ADDRESS1>
                <S_CITY>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPFROMADDRESS']/City"/>
                </S_CITY>
                <S_STATE>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPFROMADDRESS']/State"/>
                </S_STATE>
                <S_ZIP>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPFROMADDRESS']/PostalCode"/>
                </S_ZIP>
                <S_COUNTRY>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPFROMADDRESS']/Country"/>
                </S_COUNTRY>
                <S_CONTACT>
                    <xsl:value-of select="DoumentContacts_T[ContactType='SHIPFROM']/ContactName"/>
                </S_CONTACT>
                <S_PHONE>
                    <xsl:value-of select="DoumentContacts_T[ContactType='SHIPFROM']/Telephone"/>
                </S_PHONE>
                <F_COMPANY>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/Name1"/>
                </F_COMPANY>
                <F_ADDRESS1>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/Address1"/>
                </F_ADDRESS1>
                <F_CITY>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/City"/>
                </F_CITY>
                <F_STATE>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/State"/>
                </F_STATE>
                <F_ZIP>
                    <xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/PostalCode"/>
                </F_ZIP>
                <PO_NUM>
                    <xsl:value-of select="ShippingOrderHeader_T/PurchaseOrderNumber"/>
                </PO_NUM>
                <DATE_ORDERED>
                    <xsl:value-of select="ShippingOrderDates_T[Type='Start']/Date"/>
                </DATE_ORDERED>
                <MIN_DELIVERY_DATE>
                    <xsl:value-of select="ShippingOrderDates_T[Type='Complete']/Date"/>
                </MIN_DELIVERY_DATE>
                <LATE_DELIVERY_DATE>
                    <xsl:value-of select="ShippingOrderDates_T[Type='PIKDATE']/Date"/>
                </LATE_DELIVERY_DATE>
                <DEPT_NUMBER>
                    <xsl:value-of select="ShippingOrderReference_T[ReferenceType=' Department Number']/ReferenceNo"/>
                </DEPT_NUMBER>
                <VENDOR_NUMBER>
                    <xsl:value-of select="ShippingOrderReference_T[ReferenceType='Vendor Number']/ReferenceNo"/>
                </VENDOR_NUMBER>
            </HEADER>
            <xsl:for-each select="ShippingOrderItem_T">
                <DETAIL>
                    <ORDER_LINE>
                        <xsl:value-of select="AssignedNumber"/>
                    </ORDER_LINE>
                    <ITEM_ID>
                        <xsl:value-of select="ItemUPC"/>
                    </ITEM_ID>
                    <PIECES_ORDERED>
                        <xsl:value-of select="QuantityOrdered"/>
                    </PIECES_ORDERED>
                    <PIECES_TO_PICK>
                        <xsl:value-of select="QuantityOrdered"/>
                    </PIECES_TO_PICK>
                </DETAIL>
            </xsl:for-each>
        </ORDERDOWNLOAD>
    </xsl:template>
</xsl:stylesheet>
