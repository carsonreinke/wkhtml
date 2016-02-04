#include "wkhtml.h"

#define BUFFER_SIZE 10240

#define INT2BOOL(v) ((int)v) ? Qtrue : Qfalse
#define BOOL2INT(v) ((VALUE)v) ? 1 : 0

void Init_wkhtml() {
  mWkHtml = rb_define_module("WkHtml");
  rb_define_const(mWkHtml, "LIBRARY_VERSION", rb_obj_freeze(rb_str_new_cstr(wkhtmltopdf_version())));
  
  mWkHtmlToPdf = rb_define_module_under(mWkHtml, "ToPdf");
  rb_define_singleton_method(mWkHtmlToPdf, "init", wkhtml_topdf_init, 1);
  rb_define_singleton_method(mWkHtmlToPdf, "deinit", wkhtml_topdf_deinit, 0);
  
  cWkHtmlToPdfGlobalSettings = rb_define_class_under(mWkHtmlToPdf, "GlobalSettings", rb_cObject);
  rb_define_alloc_func(cWkHtmlToPdfGlobalSettings, wkhtml_topdf_globalsettings_alloc);
  rb_define_method(cWkHtmlToPdfGlobalSettings, "[]=", wkhtml_topdf_globalsettings_aset, 2);
  rb_define_method(cWkHtmlToPdfGlobalSettings, "[]", wkhtml_topdf_globalsettings_aref, 1);
  
  //cWkHtmlToImageConverter = rb_define_class_under(mWkHtmlToPdf, "Converter", rb_cObject);
  //rb_define_method(cWkHtmlToImageConverter, "initialize", wkhtml_topdf_converter_initialize, 1);
  
  mWkHtmlToImage = rb_define_module_under(mWkHtml, "ToImage");
  rb_define_singleton_method(mWkHtmlToPdf, "init", wkhtml_toimage_init, 1);
  rb_define_singleton_method(mWkHtmlToPdf, "deinit", wkhtml_toimage_deinit, 0);
}

VALUE wkhtml_topdf_init(VALUE self, VALUE use_graphics) {
  return INT2BOOL(wkhtmltopdf_init(BOOL2INT(use_graphics)));
}

VALUE wkhtml_topdf_deinit(VALUE self) {
  return INT2BOOL(wkhtmltopdf_deinit());
}

VALUE wkhtml_topdf_globalsettings_alloc(VALUE self) {
  wkhtmltopdf_global_settings* settings = wkhtmltopdf_create_global_settings();
  
  return Data_Wrap_Struct(self, NULL, wkhtmltopdf_destroy_global_settings, settings);
}

#define wkhtml_setting_aset(setting_type, setting_func) ({ \
  setting_type* settings;\
  \
  Check_Type(key, T_STRING); \
  Check_Type(val, T_STRING); \
  \
  Data_Get_Struct(self, setting_type, settings); \
  \
  char* key_cstr = StringValueCStr(key); \
  if( setting_func(settings, key_cstr, StringValueCStr(val)) ) { \
    return val; \
  } \
  \
  rb_raise(rb_eArgError, "Unable to assign setting: %s", key_cstr); \
}) //TODO #to_s

#define wkhtml_setting_aref(setting_type, setting_func) ({ \
  Check_Type(key, T_STRING); \
  \
  setting_type* settings; \
  \
  Data_Get_Struct(self, setting_type, settings); \
  \
  char* key_cstr = StringValueCStr(key); \
  char* val_cstr = malloc(sizeof(char) * BUFFER_SIZE); \
  VALUE val = Qnil; \
  int result = setting_func(settings, key_cstr, val_cstr, BUFFER_SIZE); \
  \
  if(result) { \
    val = rb_str_new_cstr(val_cstr); \
  } \
  free(val_cstr); \
  \
  if(val == Qnil) { \
    rb_raise(rb_eArgError, "unknown setting: %s", key_cstr); \
  } \
  \
  return val; \
})

VALUE wkhtml_topdf_globalsettings_aset(VALUE self, VALUE key, VALUE val) {
  wkhtml_setting_aset(wkhtmltopdf_global_settings, wkhtmltopdf_set_global_setting);
}

VALUE wkhtml_topdf_globalsettings_aref(VALUE self, VALUE key) {
  wkhtml_setting_aref(wkhtmltopdf_global_settings, wkhtmltopdf_get_global_setting);
}


VALUE wkhtml_toimage_init(VALUE self, VALUE use_graphics) {
  return INT2BOOL(wkhtmltoimage_init(BOOL2INT(use_graphics)));
}

VALUE wkhtml_toimage_deinit(VALUE self) {
  return INT2BOOL(wkhtmltoimage_deinit());
}