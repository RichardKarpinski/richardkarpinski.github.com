<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="file"/>
<xsl:output method="html"/>

<!-- pass things through unchanged -->

<xsl:template match="*">
  <xsl:element name="{name()}">
    <xsl:for-each select="@*">
      <xsl:attribute name="{name()}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- with some exceptions... -->

<xsl:template match="html">
  <xsl:element name="{name()}">
    <xsl:for-each select="@*">
      <xsl:attribute name="{name()}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
    <xsl:attribute name="page">
      <xsl:value-of select="substring-before(substring-after($file,'/'),'.')"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="html/head">
  <xsl:element name="{name()}">
    <xsl:for-each select="@*">
      <xsl:attribute name="{name()}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
    <xsl:apply-templates/>
    <link rel="stylesheet" type="text/css" href="style.css"/>
  </xsl:element>
</xsl:template>

<xsl:template match="html/head/title">
  <xsl:element name="{name()}">
    <xsl:for-each select="@*">
      <xsl:attribute name="{name()}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
    <xsl:text>Richard Karpinski, MD - </xsl:text>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="html/body">
  <xsl:element name="{name()}">
    <xsl:for-each select="@*">
      <xsl:attribute name="{name()}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
    <div id="header">
      <div id="name">
        <b>Richard Karpinski, MD</b>
      </div>
      <div class="navbar">
        <xsl:apply-templates mode="navbar"
          select="document('navbar.html')"/>
      </div>
    </div>
    <div id="content">
      <h1><xsl:value-of select="/html/head/title"/></h1><hr/>
      <xsl:apply-templates/>
      <div class="copyright">
        &#169; Richard Karpinski | 2003 - 2006
      </div>
    </div>
    <!--
    <div id="footer">
      <div class="navbar">
        <xsl:apply-templates mode="navbar"
          select="document('navbar.html')"/>
      </div>
    </div>
    -->
  </xsl:element>
</xsl:template>

<xsl:template match="img">
  <xsl:element name="{name()}">
    <xsl:for-each select="@*">
      <xsl:attribute name="{name()}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
    <xsl:attribute name="class">
      <xsl:text>image</xsl:text>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<!--
<xsl:template match="img">
  <div class="image">
    <xsl:element name="{name()}">
      <xsl:for-each select="@*">
        <xsl:attribute name="{name()}">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
    </xsl:element>
    <b><div class="caption">
      <xsl:value-of select="@alt"/>
    </div></b>
  </div>
</xsl:template>
-->

<!-- navbar-specific stuff -->
<!--
  this shouldn't be necessary but
   match="*[@class='navbar']//a"
   doesn't work for some reason
-->

<xsl:template match="*" mode="navbar">
  <xsl:element name="{name()}">
    <xsl:for-each select="@*">
      <xsl:attribute name="{name()}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
    <xsl:apply-templates mode="navbar"/>
  </xsl:element>
</xsl:template>

<xsl:template match="a" mode="navbar">
  <xsl:element name="{name()}">
    <xsl:for-each select="@*">
      <xsl:attribute name="{name()}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
    <xsl:if test="substring-before(@href,'.')=substring-before(substring-after($file,'/'),'.')">
      <xsl:attribute name="class">
        <xsl:text>current</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="navbar"/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>

