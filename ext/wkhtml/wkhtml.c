#include "wkhtml.h"

void Init_wkhtml() {
rb_warning("Here");
  mWkHtml = rb_define_module("WkHtml");
  rb_define_const(mWkHtml, "LIBRARY_VERSION", rb_obj_freeze(rb_str_new_cstr(wkhtmltopdf_version())));
}