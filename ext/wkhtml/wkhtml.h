#include <ruby.h>
#include <wkhtmltox/pdf.h>
#include <wkhtmltox/image.h>

static VALUE mWkHtml = Qnil;
static VALUE mWkHtmlToPdf = Qnil;
static VALUE cWkHtmlToPdfGlobalSettings = Qnil;
static VALUE cWkHtmlToPdfConverter = Qnil;
static VALUE mWkHtmlToImage = Qnil;

void Init_wkhtml();

//WkHtml::ToPdf

//WkHtml::ToPdf::GlobalSettings
VALUE wkhtml_topdf_globalsettings_alloc(VALUE self);
VALUE wkhtml_topdf_globalsettings_aset(VALUE self, VALUE key, VALUE val);
VALUE wkhtml_topdf_globalsettings_aref(VALUE self, VALUE key);

//WkHtml::ToPdf::Converter
//VALUE wkhtml_topdf_converter_alloc(VALUE self);
//VALUE wkhtml_topdf_converter_initialize(VALUE self, VALUE settings);
VALUE wkhtml_topdf_converter_create(VALUE self, VALUE settings);

//WkHtml::ToImage