module WkHtml
  module ToPdf
    class GlobalSettings
    end
  end
end


__END__
size.paperSize The paper size of the output document, e.g. "A4".
size.width The with of the output document, e.g. "4cm".
size.height The height of the output document, e.g. "12in".
orientation The orientation of the output document, must be either "Landscape" or "Portrait".
colorMode Should the output be printed in color or gray scale, must be either "Color" or "Grayscale"
resolution Most likely has no effect.
dpi What dpi should we use when printing, e.g. "80".
pageOffset A number that is added to all page numbers when printing headers, footers and table of content.
copies How many copies should we print?. e.g. "2".
collate Should the copies be collated? Must be either "true" or "false".
outline Should a outline (table of content in the sidebar) be generated and put into the PDF? Must be either "true" or false".
outlineDepth The maximal depth of the outline, e.g. "4".
dumpOutline If not set to the empty string a XML representation of the outline is dumped to this file.
out The path of the output file, if "-" output is sent to stdout, if empty the output is stored in a buffer.
documentTitle The title of the PDF document.
useCompression Should we use loss less compression when creating the pdf file? Must be either "true" or "false".
margin.top Size of the top margin, e.g. "2cm"
margin.bottom Size of the bottom margin, e.g. "2cm"
margin.left Size of the left margin, e.g. "2cm"
margin.right Size of the right margin, e.g. "2cm"
imageDPI The maximal DPI to use for images in the pdf document.
imageQuality The jpeg compression factor to use when producing the pdf document, e.g. "92".
load.cookieJar Path of file used to load and store cookies.
Pdf object settings
