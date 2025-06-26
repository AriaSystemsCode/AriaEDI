<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes"/>
	<!-- Declare this at top-level (outside templates) -->
	<xsl:template name="replace-product-group">
	  <xsl:param name="text" />
	  <xsl:choose>
		<xsl:when test="contains($text, 'Product Group:')">
		  <xsl:value-of select="substring-before($text, 'Product Group:')" />
		  <xsl:text></xsl:text>
		  <xsl:call-template name="replace-product-group">
			<xsl:with-param name="text" select="substring-after($text, 'Product Group:')" />
		  </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="$text" />
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:template>

	<xsl:template match="/NewDataSet">
		<ORDERDOWNLOAD>
			<HEADER>
				<!-- Store CORDERCAT value from header -->
				<xsl:variable name="cordercat" select="ShippingOrderHeader_T/CORDERCAT"/>
				<ORDER_ID>
					<xsl:value-of select="ShippingOrderHeader_T/ShippingOrder"/>
				</ORDER_ID>
				<xsl:choose>
					<xsl:when test="
      
    normalize-space(ShippingOrderHeader_T/CARRIERSERVICETYPE) != '' 
    and normalize-space(ShippingOrderHeader_T/CARRIER) != ''
    and normalize-space(ShippingOrderHeader_T/UPSBILLING) != ''">
						<CARRIER_ID>
							<xsl:choose>
								<xsl:when test="translate(ShippingOrderHeader_T/CARRIER, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'UPS'">UPS</xsl:when>
								<xsl:when test="translate(ShippingOrderHeader_T/CARRIER, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'FEDEX'">FDX</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</CARRIER_ID>
						<SHIP_METHOD>
							<xsl:choose>
								<xsl:when test="translate(ShippingOrderHeader_T/CARRIERSERVICETYPE, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'UPS NEXT DAY'">U01</xsl:when>
								<xsl:when test="translate(ShippingOrderHeader_T/CARRIERSERVICETYPE, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'UPS 2ND DAY AIR'">U02</xsl:when>
								<xsl:when test="translate(ShippingOrderHeader_T/CARRIERSERVICETYPE, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'UPS GROUND US'">U03</xsl:when>
								<xsl:when test="ShippingOrderHeader_T/CARRIERSERVICETYPE = '01'">U01</xsl:when>
								<xsl:when test="ShippingOrderHeader_T/CARRIERSERVICETYPE = '02'">U02</xsl:when>
								<xsl:when test="ShippingOrderHeader_T/CARRIERSERVICETYPE = '03'">U03</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</SHIP_METHOD>
					</xsl:when>
					<xsl:otherwise>
						<CARRIER_ID/>
						<SHIP_METHOD/>
					</xsl:otherwise>
				</xsl:choose>
				<S_COMPANY>
					<xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/Name1"/>
				</S_COMPANY>
				<S_ADDRESS1>
					<xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/Address2"/>
				</S_ADDRESS1>
				<S_CITY>
					<xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/City"/>
				</S_CITY>
				<S_STATE>
					<xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/State"/>
				</S_STATE>
				<S_ZIP>
					<xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/PostalCode"/>
				</S_ZIP>
				<S_COUNTRY>
					<xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/Country"/>
				</S_COUNTRY>
				<F_COMPANY>
					<xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/Name1"/>
				</F_COMPANY>
				<F_ADDRESS1>
					<xsl:value-of select="ShippingOrderAddress_T[Type='SHIPTOADDRESS']/Address2"/>
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
					<xsl:value-of select="ShippingOrderDates_T[Type='PIKDATE']/Date"/>
				</MIN_DELIVERY_DATE>
				<LATE_DELIVERY_DATE>
					<xsl:value-of select="ShippingOrderDates_T[Type='Complete']/Date"/>
				</LATE_DELIVERY_DATE>
				<CUST_ID>
					<xsl:value-of select="ShippingOrderHeader_T/DISTRIBUTIONNUMBER"/>
				</CUST_ID>
				<xsl:choose>
					<xsl:when test="
      
    normalize-space(ShippingOrderHeader_T/CARRIERSERVICETYPE) != '' 
    and normalize-space(ShippingOrderHeader_T/CARRIER) != ''
    and normalize-space(ShippingOrderHeader_T/UPSBILLING) != ''">
						<FREIGHT_TERMS>
							<xsl:choose>
								<xsl:when test="translate(ShippingOrderHeader_T/UPSBILLING, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'PREPAID'">P</xsl:when>
								<xsl:when test="translate(ShippingOrderHeader_T/UPSBILLING, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'FREIGHT COLLECT'">C</xsl:when>
								<xsl:when test="translate(ShippingOrderHeader_T/UPSBILLING, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'BILL TO THIRD PARTY'">T</xsl:when>
								<xsl:when test="translate(ShippingOrderHeader_T/UPSBILLING, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'CONSIGNEE BILLED'">R</xsl:when>
								<xsl:when test="translate(ShippingOrderHeader_T/UPSBILLING, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'UPSBLP'">P</xsl:when>
								<xsl:when test="translate(ShippingOrderHeader_T/UPSBILLING, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'UPSBLF'">C</xsl:when>
								<xsl:when test="translate(ShippingOrderHeader_T/UPSBILLING, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'UPSBLB'">T</xsl:when>
								<xsl:when test="translate(ShippingOrderHeader_T/UPSBILLING, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 'UPSBLC'">R</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</FREIGHT_TERMS>
					</xsl:when>
					<xsl:otherwise>
						<FREIGHT_TERMS/>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <DIVISION_ID><xsl:value-of select="ShippingOrderReference_T[ReferenceType='Cdivision']/ReferenceNo"/></DIVISION_ID> -->
				<DIVISION_ID>
					<xsl:choose>
						<!-- NOR Group -->
						<xsl:when test="ShippingOrderHeader_T/CORDERCAT = 'RACK' or ShippingOrderHeader_T/CORDERCAT = 'NORC' or ShippingOrderHeader_T/CORDERCAT = 'NORF' or ShippingOrderHeader_T/CORDERCAT = 'NORAC' or ShippingOrderHeader_T/CORDERCAT = 'NORAF' or ShippingOrderHeader_T/CORDERCAT = 'RACKC' or ShippingOrderHeader_T/CORDERCAT = 'RACKF'">NOR</xsl:when>
						<!-- NEI Group -->
						<xsl:when test="ShippingOrderHeader_T/CORDERCAT = 'NEIC' or ShippingOrderHeader_T/CORDERCAT = 'NEIF'">NEI</xsl:when>
						<!-- BERG Group -->
						<xsl:when test="ShippingOrderHeader_T/CORDERCAT = 'BERGC' or ShippingOrderHeader_T/CORDERCAT = 'BERGS'">BERG</xsl:when>
						<!-- RUE Group -->
						<xsl:when test="ShippingOrderHeader_T/CORDERCAT = 'RUE'">RUE</xsl:when>
						<!-- Default (optional) -->
						<xsl:otherwise>UNKNOWN</xsl:otherwise>
					</xsl:choose>
				</DIVISION_ID>
				<STORE_ID>
					<xsl:value-of select="ShippingOrderHeader_T/STORENUMBER"/>
				</STORE_ID>
				<DEPT_NUMBER>
					<xsl:value-of select="ShippingOrderReference_T[ReferenceType=' Department Number']/ReferenceNo"/>
				</DEPT_NUMBER>
				<VENDOR_NUMBER>
					<xsl:value-of select="ShippingOrderReference_T[ReferenceType='Vendor Number']/ReferenceNo"/>
				</VENDOR_NUMBER>
				<!-- OR_CUST11 Logic -->
				<OR_CUST11>
				  <xsl:choose>
					<xsl:when test="contains(ShippingOrderHeader_T/ORDERNOTE1, 'Product Group:')">
					  <xsl:call-template name="replace-product-group">
						<xsl:with-param name="text" select="ShippingOrderHeader_T/ORDERNOTE1" />
					  </xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
					  <xsl:value-of select="ShippingOrderHeader_T/ORDERNOTE1"/>
					</xsl:otherwise>
				  </xsl:choose>
				</OR_CUST11>

				<xsl:for-each select="ShippingOrderItem_T">
					<xsl:choose>
						<!-- If ItemUPC is not empty -->
						<xsl:when test="normalize-space(ItemUPC) != ''">
							<LINE>
								<ORDER_LINE>
									<xsl:value-of select="AssignedNumber"/>
								</ORDER_LINE>
								<ITEM_ID>
									<xsl:value-of select="ItemUPC"/>
								</ITEM_ID>
								<INV_TYPE>
									<xsl:value-of select="$cordercat"/>
								</INV_TYPE>
								<PIECES_ORDERED>
									<xsl:value-of select="QuantityOrdered"/>
								</PIECES_ORDERED>
								<PIECES_TO_PICK>
									<xsl:value-of select="QuantityOrdered"/>
								</PIECES_TO_PICK>
							</LINE>
						</xsl:when>
						<!-- If ItemUPC is empty -->
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</HEADER>
			<!-- Output all errors at the end -->
			<ERRORS>
				<xsl:for-each select="ShippingOrderItem_T[normalize-space(ItemUPC) = '']">
					<ERROR>
						<MESSAGE>Missing ItemUPC for AssignedNumber 
							
							
							
							
							<xsl:value-of select="AssignedNumber"/>
						</MESSAGE>
					</ERROR>
				</xsl:for-each>
			</ERRORS>
		</ORDERDOWNLOAD>
	</xsl:template>
</xsl:stylesheet>
