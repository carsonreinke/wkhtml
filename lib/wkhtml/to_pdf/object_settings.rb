module WkHtml
  module ToPdf
    class ObjectSettings
      include Settings

      KEYS = %w(
        toc.useDottedLines
        toc.captionText
        toc.forwardLinks
        toc.backLinks
        toc.indentation
        toc.fontScale
        page
        useExternalLinks
        useLocalLinks
        replacements TODO
        produceForms
        includeInOutline
        pagesCount
        tocXsl
      )
      DEFAULTS = {}

      self.settings = HeaderSettings::KEYS + WebSettings::KEYS + LoadSettings::KEYS + KEYS
      self.default_settings = DEFAULTS

      def page=(v)
        v = CommonSettings::cleanup_path(v)
        raise ArgumentError.new("#{v} is missing or not readable") unless CommonSettings::readable?(v)
        self['page'] = v
      end

      def stdin=(v)
        self.in = v ? CommonSettings::STDIN : ''
      end
    end
  end
end


__END__
toc.useDottedLines Should we use a dotted line when creating a table of content? Must be either "true" or "false".
toc.captionText The caption to use when creating a table of content.
toc.forwardLinks Should we create links from the table of content into the actual content? Must be either "true or "false.
toc.backLinks Should we link back from the content to this table of content.
toc.indentation The indentation used for every table of content level, e.g. "2em".
toc.fontScale How much should we scale down the font for every toc level? E.g. "0.8"
page The URL or path of the web page to convert, if "-" input is read from stdin.
header.* Header specific settings see Header and footer settings.
footer.* Footer specific settings see Header and footer settings.
useExternalLinks Should external links in the HTML document be converted into external pdf links? Must be either "true" or "false.
useLocalLinks Should internal links in the HTML document be converted into pdf references? Must be either "true" or "false"
replacements TODO
produceForms Should we turn HTML forms into PDF forms? Must be either "true" or file".
load.* Page specific settings related to loading content, see Object Specific loading settings.
web.* See Web page specific settings.
includeInOutline Should the sections from this document be included in the outline and table of content?
pagesCount Should we count the pages of this document, in the counter used for TOC, headers and footers?
tocXsl If not empty this object is a table of content object, "page" is ignored and this xsl style sheet is used to convert the outline XML into a table of content.