#include <ruby.h>
#include <wkhtmltox/pdf.h>
#include <wkhtmltox/image.h>

static VALUE mWkHtml = Qnil;
static VALUE mWkHtmlToPdf = Qnil;
static VALUE cWkHtmlToPdfGlobalSettings = Qnil;
static VALUE cWkHtmlToImageConverter = Qnil;
static VALUE mWkHtmlToImage = Qnil;

void Init_wkhtml();

//WkHtml::ToPdf
VALUE wkhtml_topdf_init(VALUE self, VALUE use_graphics);
VALUE wkhtml_topdf_deinit(VALUE self);

//WkHtml::ToPdf::GlobalSettings
VALUE wkhtml_topdf_globalsettings_alloc(VALUE self);
VALUE wkhtml_topdf_globalsettings_aset(VALUE self, VALUE key, VALUE val);
VALUE wkhtml_topdf_globalsettings_aref(VALUE self, VALUE key);

//WkHtml::ToImage
VALUE wkhtml_toimage_init(VALUE self, VALUE use_graphics);
VALUE wkhtml_toimage_deinit(VALUE self);