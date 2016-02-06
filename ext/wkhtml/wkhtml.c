#include "wkhtml.h"

#define BUFFER_SIZE 10240

#define INT2BOOL(v) ((int)v) ? Qtrue : Qfalse
#define BOOL2INT(v) ((VALUE)v) ? 1 : 0

void Init_wkhtml() {
  int use_graphics;
  #ifdef USE_GRAPHICS
  use_graphics = 1;
  #else
  use_graphics = 0;
  #endif
  
  //Genesis
  wkhtmltopdf_init(use_graphics); //wkhtmltopdf_deinit will not be called ever
  wkhtmltoimage_init(use_graphics); //Duplicate, but could change in future
    
  mWkHtml = rb_define_module("WkHtml");
  rb_define_const(mWkHtml, "LIBRARY_VERSION", rb_obj_freeze(rb_str_new_cstr(wkhtmltopdf_version())));
  
  mWkHtmlToPdf = rb_define_module_under(mWkHtml, "ToPdf");
  
  cWkHtmlToPdfGlobalSettings = rb_define_class_under(mWkHtmlToPdf, "GlobalSettings", rb_cObject);
  rb_define_alloc_func(cWkHtmlToPdfGlobalSettings, wkhtml_topdf_globalsettings_alloc);
  rb_define_method(cWkHtmlToPdfGlobalSettings, "[]=", wkhtml_topdf_globalsettings_aset, 2);
  rb_define_method(cWkHtmlToPdfGlobalSettings, "[]", wkhtml_topdf_globalsettings_aref, 1);
  
  cWkHtmlToPdfConverter = rb_define_class_under(mWkHtmlToPdf, "Converter", rb_cObject);
  rb_define_singleton_method(cWkHtmlToPdfConverter, "create", wkhtml_topdf_converter_create, 1);
  rb_undef_alloc_func(cWkHtmlToPdfConverter); //Have to use the factory method
  
  mWkHtmlToImage = rb_define_module_under(mWkHtml, "ToImage");
}

VALUE wkhtml_topdf_globalsettings_alloc(VALUE self) {
  wkhtmltopdf_global_settings* settings = wkhtmltopdf_create_global_settings();
  
  return Data_Wrap_Struct(self, NULL, wkhtmltopdf_destroy_global_settings, settings);
}

#define wkhtml_setting_aset(setting_type, setting_func) ({ \
  setting_type* settings;\
  \
  key = StringValue(key); \
  val = StringValue(val); \
  \
  Data_Get_Struct(self, setting_type, settings); \
  \
  char* key_cstr = StringValueCStr(key); \
  if( setting_func(settings, key_cstr, StringValueCStr(val)) ) { \
    return val; \
  } \
  \
  rb_raise(rb_eArgError, "Unable to set: %s", key_cstr); \
}) //TODO force UTF-8 encoding

#define wkhtml_setting_aref(setting_type, setting_func) ({ \
  key = StringValue(key); \
  \
  setting_type* settings; \
  \
  Data_Get_Struct(self, setting_type, settings); \
  \
  char* key_cstr = StringValueCStr(key); \
  char* val_cstr = ALLOC_N(char, BUFFER_SIZE); \
  VALUE val = Qnil; \
  int result = setting_func(settings, key_cstr, val_cstr, BUFFER_SIZE); \
  \
  if(result) { \
    val = rb_str_new_cstr(val_cstr); \
  } \
  xfree(val_cstr); \
  \
  if(val == Qnil) { \
    rb_raise(rb_eArgError, "Unable to get: %s", key_cstr); \
  } \
  \
  return val; \
}) //#TODO force UTF-8

VALUE wkhtml_topdf_globalsettings_aset(VALUE self, VALUE key, VALUE val) {
  wkhtml_setting_aset(wkhtmltopdf_global_settings, wkhtmltopdf_set_global_setting);
}

VALUE wkhtml_topdf_globalsettings_aref(VALUE self, VALUE key) {
  wkhtml_setting_aref(wkhtmltopdf_global_settings, wkhtmltopdf_get_global_setting);
}

VALUE wkhtml_topdf_converter_create(VALUE self, VALUE settings) {
  wkhtmltopdf_global_settings* global_settings;
  wkhtmltopdf_converter* converter;
  
  Data_Get_Struct(settings, wkhtmltopdf_global_settings, global_settings);
  
  converter = wkhtmltopdf_create_converter(global_settings);
  
  return Data_Wrap_Struct(self, NULL, wkhtmltopdf_destroy_converter, converter);
}