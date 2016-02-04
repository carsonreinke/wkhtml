#include <ruby.h>
#include <wkhtmltox/pdf.h>
#include <wkhtmltox/image.h>

static VALUE mWkHtml = Qnil;

void Init_wkhtml();