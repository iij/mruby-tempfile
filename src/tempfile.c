/*
** tempfile.c - Tempfile
**
** See Copyright Notice in mruby.h
*/
#include "mruby.h"
#include "mruby/class.h"


//#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>


mrb_value
mrb_tempfile_getpid(mrb_state *mrb, mrb_value self)
{
  mrb_value value;

  value = mrb_fixnum_value(getpid());

  return value;
}

void
mrb_mruby_tempfile_gem_init(mrb_state *mrb)
{
  struct RClass *tempfile_class;
  struct RClass *file;

  file = mrb_class_get(mrb, "File");
  tempfile_class = mrb_define_class(mrb, "Tempfile", file);

  MRB_SET_INSTANCE_TT(tempfile_class, MRB_TT_DATA);

  mrb_define_class_method(mrb, tempfile_class, "_getpid", mrb_tempfile_getpid, ARGS_NONE());
}

void
mrb_mruby_tempfile_gem_final(mrb_state* mrb) {
}
