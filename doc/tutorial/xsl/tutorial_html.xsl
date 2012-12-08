<?xml version='1.0'?> 
<xsl:stylesheet  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:custom="custom" exclude-result-prefixes="custom"> 
<xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl/html/chunk.xsl"/>
<xsl:import href="tutorial_strings.xsl"/>

<custom:supported-langs>
 <lang code="en">English</lang>
 <lang code="fr">Français</lang>
 <lang code="de">Deutsch</lang>
 <lang code="it">Italiano</lang>
 <lang code="es">Español</lang>
</custom:supported-langs>

<xsl:template name="chunk-element-content">
  <xsl:param name="prev"/>
  <xsl:param name="next"/>
  <xsl:param name="nav.context"/>
  <xsl:param name="content">
    <xsl:apply-imports/>
  </xsl:param>

  <xsl:call-template name="user.preroot"/>---
layout: default
title: "TODO: construct appropriate title"
section: manual
headstuff: |
  <link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/base/jquery-ui.css" />
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js" type="text/javascript"></script>
  <script type="text/javascript" src="/script/images.js"></script>

---
      <xsl:call-template name="user.header.navigation"/>
      <xsl:call-template name="header.navigation">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
        <xsl:with-param name="nav.context" select="$nav.context"/>
      </xsl:call-template>

      <xsl:call-template name="user.header.content"/>

      <xsl:copy-of select="$content"/>
  <xsl:value-of select="$chunk.append"/>
</xsl:template>

<xsl:param name="chunker.output.encoding" select="UTF-8"/>
<xsl:param name="use.id.as.filename" select="'1'"/>
<xsl:param name="chunk.first.sections" select="'1'"/>
<xsl:param name="toc.section.depth" select="'1'"/>
<xsl:param name="suppress.footer.navigation" select="1"/>
<xsl:param name="formal.object.break.after" select="0"/>

<!-- no title attribute for sections -->
<xsl:template name="generate.html.title"/>

<!-- we do not display a title since it is visible from the navigation select box -->
<xsl:template name="sect1.titlepage.recto"/>

<xsl:template name="header.navigation">
  <xsl:variable name="doclang" select="/article/articleinfo/title/phrase/@lang"/>
  <xsl:variable name="chunkname">
    <xsl:apply-templates select="." mode="recursive-chunk-filename"/>
  </xsl:variable>
  <h2>
  <span id="pdflink">
  <xsl:text> </xsl:text>
  <a href="tutorial_r4.pdf" target="_top">
    <img style="vertical-align: middle;" title="PDF" src="/visuals/pdf.png"/>
  </a>
  </span>
  <xsl:value-of select="title"/>
  </h2>
  <div class="toc">
    <select onchange="window.location=this.value;">
        <option>Go to chapter</option>
      <xsl:apply-templates select="../sect1" mode="toc">
        <xsl:with-param name="toc-context" select="."/>
      </xsl:apply-templates>
    </select>
    <select onchange="window.location=this.value;">
      <option>Switch language</option>
      <xsl:for-each select="document('')/*/custom:supported-langs/lang">
        <option>
          <xsl:choose>
            <xsl:when test="@code != $doclang">
              <xsl:attribute name="value">/<xsl:value-of select="@code"/>/tutorial_r4/<xsl:value-of select="$chunkname"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
               <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="."/>
        </option>
      </xsl:for-each>
    </select>
  </div>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="/article/articleinfo/releaseinfo[not(@role) or @role!='generate-for-pdf']"/>
</xsl:template>

<xsl:template name="make.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="nodes" select="/NOT-AN-ELEMENT"/>
  <div class="toc">
    <select onchange="window.location=this.value;">
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </select>
  </div>
</xsl:template>
<!-- add separator between entries in toc and do not create link for current section-->
<xsl:template name="toc.line">
  <xsl:param name="toc-context" select="."/>
  <option>
  <xsl:choose>
  <xsl:when test="$toc-context/@id != @id">
    <xsl:attribute name="value">
      <xsl:call-template name="href.target">
        <xsl:with-param name="context" select="$toc-context"/>
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:call-template>
    </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
    <xsl:attribute name="disabled">disabled</xsl:attribute>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="." mode="titleabbrev.markup"/>
    </option>
</xsl:template>

<xsl:template match="phrase[@role='br']">
<br />
</xsl:template>

<xsl:template name="inline.charseq">
  <xsl:param name="content">
    <xsl:call-template name="inline.content"/>
  </xsl:param>
  <!-- * if you want output from the inline.charseq template wrapped in -->
  <!-- * something other than a Span, call the template with some value -->
  <!-- * for the 'wrapper-name' param -->
  <xsl:param name="wrapper-name">span</xsl:param>
  <xsl:element name="{$wrapper-name}">
    <xsl:attribute name="class">
      <xsl:value-of select="local-name(.)"/>
    </xsl:attribute>
    <xsl:call-template name="dir"/>
    <xsl:call-template name="generate.html.title"/>
    <xsl:copy-of select="$content"/>
    <xsl:call-template name="apply-annotations"/>
  </xsl:element>
</xsl:template>

<xsl:template name="inline.monoseq">
  <xsl:param name="content">
    <xsl:call-template name="inline.content"/>
  </xsl:param>
  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:copy-of select="$content"/>
    <xsl:call-template name="apply-annotations"/>
  </code>
</xsl:template>

<xsl:template name="inline.boldseq">
  <xsl:param name="content">
    <xsl:call-template name="inline.content"/>
  </xsl:param>

  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>

    <!-- don't put <strong> inside figure, example, or table titles -->
    <xsl:choose>
      <xsl:when test="local-name(..) = 'title'
                      and (local-name(../..) = 'figure'
                      or local-name(../..) = 'example'
                      or local-name(../..) = 'table')">
        <xsl:copy-of select="$content"/>
      </xsl:when>
      <xsl:otherwise>
        <strong>
          <xsl:copy-of select="$content"/>
        </strong>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="apply-annotations"/>
  </span>
</xsl:template>

<xsl:template name="inline.italicseq">
  <xsl:param name="content">
    <xsl:call-template name="inline.content"/>
  </xsl:param>
  <em>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:copy-of select="$content"/>
    <xsl:call-template name="apply-annotations"/>
  </em>
</xsl:template>

<xsl:template name="inline.boldmonoseq">
  <xsl:param name="content">
    <xsl:call-template name="inline.content"/>
  </xsl:param>
  <!-- don't put <strong> inside figure, example, or table titles -->
  <!-- or other titles that may already be represented with <strong>'s. -->
  <xsl:choose>
    <xsl:when test="local-name(..) = 'title'
                    and (local-name(../..) = 'figure'
                         or local-name(../..) = 'example'
                         or local-name(../..) = 'table'
                         or local-name(../..) = 'formalpara')">
      <code>
        <xsl:call-template name="common.html.attributes"/>
        <xsl:copy-of select="$content"/>
        <xsl:call-template name="apply-annotations"/>
      </code>
    </xsl:when>
    <xsl:otherwise>
      <strong>
        <xsl:call-template name="common.html.attributes"/>
        <code>
          <xsl:call-template name="generate.html.title"/>
          <xsl:call-template name="dir"/>
          <xsl:copy-of select="$content"/>
        </code>
        <xsl:call-template name="apply-annotations"/>
      </strong>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline.italicmonoseq">
  <xsl:param name="content">
    <xsl:call-template name="inline.content"/>
  </xsl:param>
  <em>
    <xsl:call-template name="common.html.attributes"/>
    <code>
      <xsl:call-template name="generate.html.title"/>
      <xsl:call-template name="dir"/>
      <xsl:copy-of select="$content"/>
      <xsl:call-template name="apply-annotations"/>
    </code>
  </em>
</xsl:template>

<xsl:template name="inline.superscriptseq">
  <xsl:param name="content">
    <xsl:call-template name="inline.content"/>
  </xsl:param>
  <sup>
    <xsl:call-template name="generate.html.title"/>
    <xsl:call-template name="dir"/>
    <xsl:copy-of select="$content"/>
    <xsl:call-template name="apply-annotations"/>
  </sup>
</xsl:template>

<xsl:template name="inline.subscriptseq">
  <xsl:param name="content">
    <xsl:call-template name="inline.content"/>
  </xsl:param>
  <sub>
    <xsl:call-template name="generate.html.title"/>
    <xsl:call-template name="dir"/>
    <xsl:copy-of select="$content"/>
    <xsl:call-template name="apply-annotations"/>
  </sub>
</xsl:template>

<!-- do not float figures and suppress caption-->
<xsl:template name="floatstyle"/>
<xsl:template name="formal.object.heading"/>
</xsl:stylesheet>