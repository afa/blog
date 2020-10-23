<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
  <livejournal>
    <xsl:for-each select='livejournal/entry'>
    <!-- <entry> -->
      <itemid>
      </itemid>
    <!-- </entry> -->
    </xsl:for-each>
  </livejournal>
</xsl:template>
