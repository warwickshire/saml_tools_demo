module ServiceHelper
  
    # From http://vitobotta.com/more-methods-format-beautify-ruby-output-console-logs
  def prettify(xml)

    xsl =<<XSL
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/">
    <xsl:copy-of select="."/>
  </xsl:template>
</xsl:stylesheet>
XSL
 
    doc  = Nokogiri::XML(xml.to_s)
    xslt = Nokogiri::XSLT(xsl)
    out  = xslt.transform(doc)
 
    out.to_xml
  end
  
end
