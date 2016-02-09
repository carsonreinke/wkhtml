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

  idReady = rb_intern("ready");

  mWkHtml = rb_define_module("WkHtml");
  rb_define_const(mWkHtml, "LIBRARY_VERSION", rb_obj_freeze(rb_str_new_cstr(wkhtmltopdf_version())));

  mWkHtmlToPdf = rb_define_module_under(mWkHtml, "ToPdf");

  cWkHtmlToPdfGlobalSettings = rb_define_class_under(mWkHtmlToPdf, "GlobalSettings", rb_cObject);
  rb_define_alloc_func(cWkHtmlToPdfGlobalSettings, wkhtml_topdf_globalsettings_alloc);
  rb_define_method(cWkHtmlToPdfGlobalSettings, "[]=", wkhtml_topdf_globalsettings_aset, 2);
  rb_define_method(cWkHtmlToPdfGlobalSettings, "[]", wkhtml_topdf_globalsettings_aref, 1);

  cWkHtmlToPdfObjectSettings = rb_define_class_under(mWkHtmlToPdf, "ObjectSettings", rb_cObject);
  rb_define_alloc_func(cWkHtmlToPdfObjectSettings, wkhtml_topdf_objectsettings_alloc);
  rb_define_method(cWkHtmlToPdfObjectSettings, "[]=", wkhtml_topdf_objectsettings_aset, 2);
  rb_define_method(cWkHtmlToPdfObjectSettings, "[]", wkhtml_topdf_objectsettings_aref, 1);

  cWkHtmlToPdfConverter = rb_define_class_under(mWkHtmlToPdf, "Converter", rb_cObject);
  rb_define_singleton_method(cWkHtmlToPdfConverter, "create", wkhtml_topdf_converter_create, 1);
  rb_define_method(cWkHtmlToPdfConverter, "add_object", wkhtml_topdf_converter_add_object, 2);
  rb_define_method(cWkHtmlToPdfConverter, "convert", wkhtml_topdf_converter_convert, 0);
  rb_define_method(cWkHtmlToPdfConverter, "http_error_code", wkhtml_topdf_converter_http_error_code, 0);
  rb_define_method(cWkHtmlToPdfConverter, "get_output", wkhtml_topdf_converter_get_output, 0);
  //Force use of factory method
  rb_undef_alloc_func(cWkHtmlToPdfConverter);
  rb_undef_method(rb_singleton_class(cWkHtmlToPdfConverter), "new");

  mWkHtmlToImage = rb_define_module_under(mWkHtml, "ToImage");

  cWkHtmlToImageGlobalSettings = rb_define_class_under(mWkHtmlToImage, "GlobalSettings", rb_cObject);
  rb_define_alloc_func(cWkHtmlToImageGlobalSettings, wkhtml_toimage_globalsettings_alloc);
  rb_define_method(cWkHtmlToImageGlobalSettings, "[]=", wkhtml_toimage_globalsettings_aset, 2);
  rb_define_method(cWkHtmlToImageGlobalSettings, "[]", wkhtml_toimage_globalsettings_aref, 1);

  cWkHtmlToImageConverter = rb_define_class_under(mWkHtmlToImage, "Converter", rb_cObject);
  rb_define_singleton_method(cWkHtmlToImageConverter, "create", wkhtml_toimage_converter_create, 2);
  rb_define_method(cWkHtmlToImageConverter, "convert", wkhtml_toimage_converter_convert, 0);
  rb_define_method(cWkHtmlToImageConverter, "http_error_code", wkhtml_toimage_converter_http_error_code, 0);
  rb_define_method(cWkHtmlToImageConverter, "get_output", wkhtml_toimage_converter_get_output, 0);
  //Force use of factory method
  rb_undef_alloc_func(cWkHtmlToImageConverter);
  rb_undef_method(rb_singleton_class(cWkHtmlToImageConverter), "new");
}

#define _wkhtml_setting_aset(setting_type, setting_func) ({ \
  setting_type* settings;\
  \
  rb_check_frozen(self); \
  \
  key = rb_obj_as_string(key); \
  val = rb_obj_as_string(val); \
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

#define _wkhtml_setting_aref(setting_type, setting_func) ({ \
  key = rb_obj_as_string(key); \
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

/*
* WkHtml::ToPdf::GlobalSettings
*/
VALUE wkhtml_topdf_globalsettings_alloc(VALUE self) {
  wkhtmltopdf_global_settings* settings = wkhtmltopdf_create_global_settings();
  return Data_Wrap_Struct(self, NULL, wkhtmltopdf_destroy_global_settings, settings);
}
VALUE wkhtml_topdf_globalsettings_aset(VALUE self, VALUE key, VALUE val) {
  _wkhtml_setting_aset(wkhtmltopdf_global_settings, wkhtmltopdf_set_global_setting);
}
VALUE wkhtml_topdf_globalsettings_aref(VALUE self, VALUE key) {
  _wkhtml_setting_aref(wkhtmltopdf_global_settings, wkhtmltopdf_get_global_setting);
}

/*
* WkHtml::ToPdf::ObjectSettings
*/
VALUE wkhtml_topdf_objectsettings_alloc(VALUE self) {
  wkhtmltopdf_object_settings* settings = wkhtmltopdf_create_object_settings();
  return Data_Wrap_Struct(self, NULL, wkhtmltopdf_destroy_object_settings, settings);
}
VALUE wkhtml_topdf_objectsettings_aset(VALUE self, VALUE key, VALUE val) {
  _wkhtml_setting_aset(wkhtmltopdf_object_settings, wkhtmltopdf_set_object_setting);
}
VALUE wkhtml_topdf_objectsettings_aref(VALUE self, VALUE key) {
  _wkhtml_setting_aref(wkhtmltopdf_object_settings, wkhtmltopdf_get_object_setting);
}

/*
* WkHtml::ToPdf::Converter
*/
VALUE wkhtml_topdf_converter_create(VALUE self, VALUE settings) {
  wkhtmltopdf_global_settings* global_settings;
  wkhtmltopdf_converter* converter;
  VALUE obj;

  if(rb_obj_is_kind_of(settings, cWkHtmlToPdfGlobalSettings) == Qfalse) {
    rb_raise(rb_eArgError, "Wrong argument type, must be a GlobalSettings");
  }

  Data_Get_Struct(settings, wkhtmltopdf_global_settings, global_settings);

  converter = wkhtmltopdf_create_converter(global_settings);

  OBJ_FREEZE(settings);

  return Data_Wrap_Struct(self, NULL, wkhtmltopdf_destroy_converter, converter);
}

VALUE wkhtml_topdf_converter_add_object(VALUE self, VALUE settings, VALUE data) {
  wkhtmltopdf_converter* converter;
  wkhtmltopdf_object_settings* object_settings;
  char* data_cstr = NULL;
  
  if(rb_obj_is_kind_of(settings, cWkHtmlToPdfObjectSettings) == Qfalse) {
    rb_raise(rb_eArgError, "Wrong argument type, must be a ObjectSettings");
  }

  rb_check_frozen(self);

  if(!NIL_P(data)) {
    Check_Type(data, T_STRING);
    data_cstr = StringValueCStr(data);
  }

  Data_Get_Struct(settings, wkhtmltopdf_object_settings, object_settings);
  Data_Get_Struct(self, wkhtmltopdf_converter, converter);

  wkhtmltopdf_add_object(converter, object_settings, data_cstr);

  //From wkhtmltox:
  //"Once the object has been added, the supplied settings may no longer be accessed, it Wit eventually be freed by wkhtmltopdf."
  OBJ_FREEZE(settings);

  rb_ivar_set(self, idReady, Qtrue);

  return data;
}

VALUE wkhtml_topdf_converter_convert(VALUE self) {
  wkhtmltopdf_converter* converter;

  //Checks
  if(rb_ivar_get(self, idReady) != Qtrue) rb_raise(rb_eRuntimeError, "Object must be added first");
  rb_check_frozen(self);

  Data_Get_Struct(self, wkhtmltopdf_converter, converter);

  if(wkhtmltopdf_convert(converter)) {
    //Freeze converter if successful
    OBJ_FREEZE(self);
    
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

VALUE wkhtml_topdf_converter_http_error_code(VALUE self) {
  wkhtmltopdf_converter* converter;

  Data_Get_Struct(self, wkhtmltopdf_converter, converter);

  return INT2NUM(wkhtmltopdf_http_error_code(converter));
}

VALUE wkhtml_topdf_converter_get_output(VALUE self) {
  wkhtmltopdf_converter* converter;
  const unsigned char* data;
  long length;

  Data_Get_Struct(self, wkhtmltopdf_converter, converter);

  length = wkhtmltopdf_get_output(converter, &data);

  return rb_str_new((char*)data, length);
}

//CAPI(void) wkhtmltopdf_set_warning_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_str_callback cb)
//CAPI(void) wkhtmltopdf_set_error_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_str_callback cb)
//CAPI(void) wkhtmltopdf_set_phase_changed_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_void_callback cb)
//CAPI(void) wkhtmltopdf_set_progress_changed_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_int_callback cb)
//CAPI(void) wkhtmltopdf_set_finished_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_int_callback cb)
//CAPI(int) wkhtmltopdf_current_phase(wkhtmltopdf_converter * converter)
//CAPI(int) wkhtmltopdf_phase_count(wkhtmltopdf_converter * converter)

/*
* WkHtml::ToImage::GlobalSettings
*/
VALUE wkhtml_toimage_globalsettings_alloc(VALUE self) {
  wkhtmltoimage_global_settings* settings = wkhtmltoimage_create_global_settings();
  return Data_Wrap_Struct(self, NULL, NULL, settings); //TODO
}
VALUE wkhtml_toimage_globalsettings_aset(VALUE self, VALUE key, VALUE val) {
  _wkhtml_setting_aset(wkhtmltoimage_global_settings, wkhtmltoimage_set_global_setting);
}
VALUE wkhtml_toimage_globalsettings_aref(VALUE self, VALUE key) {
  _wkhtml_setting_aref(wkhtmltoimage_global_settings, wkhtmltoimage_get_global_setting);
}

/*
* WkHtml::ToImage::Converter
*/
VALUE wkhtml_toimage_converter_create(VALUE self, VALUE settings, VALUE data) {
  wkhtmltoimage_global_settings* global_settings;
  wkhtmltoimage_converter* converter;
  VALUE obj;
  char* data_cstr = NULL;

  if(rb_obj_is_kind_of(settings, cWkHtmlToImageGlobalSettings) == Qfalse) {
    rb_raise(rb_eArgError, "Wrong argument type, must be a GlobalSettings");
  }
  rb_check_frozen(self);

  if(!NIL_P(data)) {
    Check_Type(data, T_STRING);
    data_cstr = StringValueCStr(data);
  }

  Data_Get_Struct(settings, wkhtmltoimage_global_settings, global_settings);

  converter = wkhtmltoimage_create_converter(global_settings, data_cstr);

  OBJ_FREEZE(settings);

  return Data_Wrap_Struct(self, NULL, wkhtmltoimage_destroy_converter, converter);
}

VALUE wkhtml_toimage_converter_convert(VALUE self) {
  wkhtmltoimage_converter* converter;

  //Checks
  rb_check_frozen(self);

  Data_Get_Struct(self, wkhtmltoimage_converter, converter);

  if(wkhtmltoimage_convert(converter)) {
    //Freeze converter if successful
    OBJ_FREEZE(self);
    
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

VALUE wkhtml_toimage_converter_http_error_code(VALUE self) {
  wkhtmltoimage_converter* converter;

  Data_Get_Struct(self, wkhtmltoimage_converter, converter);

  return INT2NUM(wkhtmltoimage_http_error_code(converter));
}

VALUE wkhtml_toimage_converter_get_output(VALUE self) {
  wkhtmltoimage_converter* converter;
  const unsigned char* data;
  long length;

  Data_Get_Struct(self, wkhtmltoimage_converter, converter);

  length = wkhtmltoimage_get_output(converter, &data);

  return rb_str_new((char*)data, length);
}

//CAPI(void) wkhtmltoimage_set_warning_callback(wkhtmltoimage_converter * converter, wkhtmltoimage_str_callback cb);
//CAPI(void) wkhtmltoimage_set_error_callback(wkhtmltoimage_converter * converter, wkhtmltoimage_str_callback cb);
//CAPI(void) wkhtmltoimage_set_phase_changed_callback(wkhtmltoimage_converter * converter, wkhtmltoimage_void_callback cb);
//CAPI(void) wkhtmltoimage_set_progress_changed_callback(wkhtmltoimage_converter * converter, wkhtmltoimage_int_callback cb);
//CAPI(void) wkhtmltoimage_set_finished_callback(wkhtmltoimage_converter * converter, wkhtmltoimage_int_callback cb);
//CAPI(int) wkhtmltoimage_current_phase(wkhtmltoimage_converter * converter);
//CAPI(int) wkhtmltoimage_phase_count(wkhtmltoimage_converter * converter);
//CAPI(const char *) wkhtmltoimage_phase_description(wkhtmltoimage_converter * converter, int phase);
//CAPI(const char *) wkhtmltoimage_progress_string(wkhtmltoimage_converter * converter);