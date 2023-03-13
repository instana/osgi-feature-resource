<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
xmlns:karaf="http://karaf.apache.org/xmlns/features/v1.3.0"
>
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
      <xsl:value-of select="/karaf:features/karaf:feature[@name='FEATURE_NAME']/karaf:bundle"/>
    </xsl:template>
</xsl:stylesheet>
