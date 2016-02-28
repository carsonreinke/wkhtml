#include <ruby.h>
#include <ruby/encoding.h>
#include <wkhtmltox/pdf.h>
#include <wkhtmltox/image.h>

static ID idReady;
static VALUE mWkHtml = Qnil;
static VALUE mWkHtmlToPdf = Qnil;
static VALUE cWkHtmlToPdfGlobalSettings = Qnil;
static VALUE cWkHtmlToPdfObjectSettings = Qnil;
static VALUE cWkHtmlToPdfConverter = Qnil;
static VALUE mWkHtmlToImage = Qnil;
static VALUE cWkHtmlToImageGlobalSettings = Qnil;
static VALUE cWkHtmlToImageConverter = Qnil;

void Init_wkhtml();
void Deinit_wkhtml_native(VALUE data);

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
void wkhtml_topdf_converter_free(wkhtmltopdf_converter* converter);
VALUE wkhtml_topdf_converter_create(VALUE self, VALUE settings);
VALUE wkhtml_topdf_converter_add_object(VALUE self, VALUE settings, VALUE data);
VALUE wkhtml_topdf_converter_convert(VALUE self);
VALUE wkhtml_topdf_converter_http_error_code(VALUE self);
VALUE wkhtml_topdf_converter_get_output(VALUE self);

//WkHtml::ToImage

//WkHtml::ToImage::GlobalSettings
VALUE wkhtml_toimage_globalsettings_alloc(VALUE self);
VALUE wkhtml_toimage_globalsettings_aset(VALUE self, VALUE key, VALUE val);
VALUE wkhtml_toimage_globalsettings_aref(VALUE self, VALUE key);

//WkHtml::ToImage::Converter
void wkhtml_toimage_converter_free(wkhtmltoimage_converter* converter);
VALUE wkhtml_toimage_converter_create(VALUE self, VALUE settings, VALUE data);
VALUE wkhtml_toimage_converter_convert(VALUE self);
VALUE wkhtml_toimage_converter_http_error_code(VALUE self);
VALUE wkhtml_toimage_converter_get_output(VALUE self);