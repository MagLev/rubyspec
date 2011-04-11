#include <string.h>

#include "ruby.h"
#include "rubyspec.h"

#ifdef __cplusplus
extern "C" {
#endif

#if defined(HAVE_DATA_WRAP_STRUCT)
struct sample_wrapped_struct {
    int foo;
};

VALUE sdaf_alloc_func(VALUE klass) {
    struct sample_wrapped_struct* bar = (struct sample_wrapped_struct *)malloc(sizeof(struct sample_wrapped_struct));
    bar->foo = 42;
    return Data_Wrap_Struct(klass, NULL, NULL, bar);
}

VALUE sdaf_get_struct(VALUE self) {
    struct sample_wrapped_struct* bar;
    Data_Get_Struct(self, struct sample_wrapped_struct, bar);

    return INT2FIX((*bar).foo);
}

VALUE sws_wrap_struct(VALUE self, VALUE val) {
    struct sample_wrapped_struct* bar = (struct sample_wrapped_struct *)malloc(sizeof(struct sample_wrapped_struct));
    bar->foo = FIX2INT(val);
    return Data_Wrap_Struct(rb_cObject, NULL, NULL, bar);
}

VALUE sws_get_struct(VALUE self, VALUE obj) {
    struct sample_wrapped_struct* bar;
    Data_Get_Struct(obj, struct sample_wrapped_struct, bar);

    return INT2FIX((*bar).foo);
}

VALUE sws_get_struct_rdata(VALUE self, VALUE obj) {
  struct sample_wrapped_struct* bar;
#if defined(HAVE_RDATA)
  bar = (struct sample_wrapped_struct*) RDATA(obj)->data;
#else
  bar = (struct sample_wrapped_struct*) rb_rdata_fetch(obj);
#endif
  return INT2FIX(bar->foo);
}

VALUE sws_change_struct(VALUE self, VALUE obj, VALUE new_val) {
  struct sample_wrapped_struct* new_struct = (struct sample_wrapped_struct *)malloc(sizeof(struct sample_wrapped_struct));
  new_struct->foo = FIX2INT(new_val);
#if defined(HAVE_RDATA)
  RDATA(obj)->data = new_struct;
#else
  rb_rdata_store(obj, new_struct);
#endif
  return Qnil;
}

void Init_data_spec() {
  VALUE cls;
  cls = rb_define_class("CApiAllocSpecs", rb_cObject);

  rb_define_alloc_func(cls, sdaf_alloc_func);
  rb_define_method(cls, "wrapped_data", sdaf_get_struct, 0);

  cls = rb_define_class("CApiWrappedStructSpecs", rb_cObject);
  rb_define_method(cls, "wrap_struct", sws_wrap_struct, 1);
  rb_define_method(cls, "get_struct", sws_get_struct, 1);
  rb_define_method(cls, "get_struct_rdata", sws_get_struct_rdata, 1);
  rb_define_method(cls, "change_struct", sws_change_struct, 2);
}
#endif

#ifdef __cplusplus
}
#endif
