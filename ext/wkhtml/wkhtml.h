#include <ruby.h>
#include <wkhtmltox/pdf.h>
#include <wkhtmltox/image.h>

static ID idReady;
static VALUE mWkHtml = Qnil;
static VALUE mWkHtmlToPdf = Qnil;
static VALUE cWkHtmlToPdfGlobalSettings = Qnil;
static VALUE cWkHtmlToPdfObjectSettings = Qnil;
static VALUE cWkHtmlToPdfConverter = Qnil;
static VALUE mWkHtmlToImage = Qnil;

void Init_wkhtml();

//WkHtml::ToPdf

//WkHtml::ToPdf::GlobalSettings
VALUE wkhtml_topdf_globalsettings_alloc(VALUE self);
VALUE wkhtml_topdf_globalsettings_aset(VALUE self, VALUE key, VALUE val);
VALUE wkhtml_topdf_globalsettings_aref(VALUE self, VALUE key);

//WkHtml::ToPdf::ObjectSettings
VALUE wkhtml_topdf_objectsettings_alloc(VALUE self);
VALUE wkhtml_topdf_objectsettings_aset(VALUE self, VALUE key, VALUE val);
VALUE wkhtml_topdf_objectsettings_aref(VALUE self, VALUE key);

//WkHtml::ToPdf::Converter
VALUE wkhtml_topdf_converter_create(VALUE self, VALUE settings);
VALUE wkhtml_topdf_converter_add_object(VALUE self, VALUE settings, VALUE data);
VALUE wkhtml_topdf_converter_convert(VALUE self);
VALUE wkhtml_topdf_converter_http_error_code(VALUE self);
VALUE wkhtml_topdf_converter_get_output(VALUE self);

//WkHtml::ToImage