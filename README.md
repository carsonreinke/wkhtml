## WkHtml
[![Build Status](https://travis-ci.org/carsonreinke/wkhtml.svg?branch=master)](https://travis-ci.org/carsonreinke/wkhtml)

Ruby bindings for [wkhtmltox (wkhtmltopdf)](http://wkhtmltopdf.org/)

### Installation

Add this line to your application's Gemfile:

    gem 'wkhtml'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wkhtml

And if it can't find wkhtmltox/wkhtmltopdf, you can supply `--with-wkhtmltox-dir`, `--with-wkhtmltox-include`, `--with-wkhtmltox-lib` for location variations.

To use a windowing system for rendering, can be enabled with option `--enable-use-graphics`.  For more information, [see `GUIEnabled` portion of Qt QApplication](http://doc.qt.io/qt-4.8/qapplication.html#QApplication-2).

### Usage

```ruby
#PDF
WkHtml::Converter.new('http://example.com/').to_pdf()
#JPEG
WkHtml::Converter.new('http://example.com/').to_jpg()
#PNG
WkHtml::Converter.new('http://example.com/').to_png()
#SVG
WkHtml::Converter.new('http://example.com/').to_svg()
```

The `#new` will take either a url, HTML content, or a `File`.

Secondary argument takes a `Hash` of options, a list of these options can be found [here](http://wkhtmltopdf.org/libwkhtmltox/pagesettings.html).

### Todo

* Edge case file paths and nils may cause a seg fault
* Memory leak with any image conversion :disappointed: ([see](https://github.com/wkhtmltopdf/wkhtmltopdf/issues/2700))
* Due to wkhtmltopdf C api limitation, seg fault when try to use library from fork :disappointed:
* Due to wkhtmltopdf C api limitation, must be used within main Ruby VM thread :disappointed:
* Some [settings](http://wkhtmltopdf.org/libwkhtmltox/pagesettings.html) for image generation just do not work :sob: ([see](https://github.com/wkhtmltopdf/wkhtmltopdf/issues/2802))