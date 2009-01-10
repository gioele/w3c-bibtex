<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:contact="http://www.w3.org/2000/10/swap/pim/contact#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:doc="http://www.w3.org/2000/10/swap/pim/doc#"
    xmlns:mat="http://www.w3.org/2002/05/matrix/vocab#"
    xmlns:org="http://www.w3.org/2001/04/roadmap/org#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rec="http://www.w3.org/2001/02pd/rec54#"
    xmlns:exsl="http://exslt.org/common"
    version="1.0">

  <xsl:output method="text"/>
  <xsl:preserve-space elements="rec:REC"/>

  <xsl:template match="rdf:RDF">
    <xsl:apply-templates select="rec:REC"/>
  </xsl:template>

  <xsl:template match="rec:REC">
    @TechReport{<xsl:apply-templates mode="bibtex-label" select="."/>,
        author = {<xsl:apply-templates select="rec:editor[1]"/><xsl:for-each select="rec:editor[position() &gt; 1]"> and <xsl:apply-templates select="."/></xsl:for-each>},
        title  = {{<xsl:apply-templates select="dc:title"/>}},
        note = {\url{<xsl:value-of select="@rdf:about"/>}. Latest version available at \url{<xsl:value-of select="doc:versionOf/@rdf:resource"/>}},
        year = {<xsl:apply-templates mode="bibtex-year" select="dc:date"/>},
        month = <xsl:apply-templates mode="bibtex-month" select="dc:date"/>,
	bibsource = "http://www.w3.org/2002/01/tr-automation/tr.rdf",
	type = "Recommendation",
	institution = "W3C",
    }
  </xsl:template>

  <xsl:template match="rec:editor"><xsl:value-of select="contact:fullName"/></xsl:template>

  <xsl:template match="*" mode="bibtex-label">
    <xsl:variable name="surname"
		  select="substring-after(rec:editor[1]/contact:fullName, ' ')"/>
    <xsl:variable name="safeSurname"
		  select="translate($surname,
			  'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.- 0123456789ñÑçÇáéíóúÁÉÍÓÚäëïöüÄËÏÖÜ',
			  'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
    
    <xsl:value-of select="$safeSurname"/>:<xsl:apply-templates select="dc:date" mode="bibtex-year"/>
  </xsl:template>

  <xsl:template match="dc:date" mode="bibtex-year"><xsl:value-of select="substring-before(text(), '-')"/></xsl:template>

  <xsl:template match="dc:date" mode="bibtex-month">
    <xsl:variable name="month" select="number(substring-before(substring-after(text(),'-'),'-'))"/>
    <xsl:variable name="monthNames">
      <m>jan</m>
      <m>feb</m>
      <m>mar</m>
      <m>apr</m>
      <m>may</m>
      <m>jun</m>
      <m>jul</m>
      <m>aug</m>
      <m>sep</m>
      <m>nov</m>
      <m>dec</m>
    </xsl:variable>

    <xsl:value-of select="exsl:node-set($monthNames)/m[$month]/text()"/>
  </xsl:template>

</xsl:stylesheet>
