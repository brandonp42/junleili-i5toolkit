/*
This file is part of i5/OS Programmer's Toolkit.

Copyright (C) 2010, 2011  Junlei Li (李君磊).

i5/OS Programmer's Toolkit is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

i5/OS Programmer's Toolkit is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with i5/OS Programmer's Toolkit.  If not, see <http://www.gnu.org/licenses/>.
*/
/**
 * @file runmic.c
 *
 * qshell wrapper for mic
 */

# include <stdlib.h>
# include <stdio.h>
# include <string.h>

# include <unistd.h>

# include <mic-def.h>
# include <utils-in.hpp>
# include <ctype.h>  // toupper()

# ifdef __OS400__  // 400

extern "OS"
int MIC(void*);

char *
basename(char *path) {

  char *r = path;
  char *pos = strrchr(path, _SLASH);
  if(pos != NULL)
    r = pos + 1;

  return r;
}

# else  // linux

int MIC(void*) {

  printf("call program MIC ... \n");
  return 0;
}

#   include <libgen.h>

# endif

# define _ERROR "error: "

void
make_upper(char* str, size_t len) {

  int i = 0;

  if(str == NULL)
    return;

  for(i = 0; i < len; i++)
    str[i] = (char)toupper(str[i]);

}

void
make_object_name20(
		   const char *source,
		   char *name20
		   ) {

  using namespace mic;

  char *p = NULL;
  char *src = strdup(source);

  // find '/'
  p = strchr(src, _SLASH);
  if(p == NULL) // no slash
    copy_bytes_with_padding(name20, src, 20, _WS);
  else {

    src[p - src] = 0;
    // library name
    copy_bytes_with_padding(name20 + 10, src, 10, _WS);
    copy_bytes_with_padding(name20, p + 1, 10, _WS);
  }

}

/**
 * command options
    - -v <br> Verbose
    - -V <br> Show version information
    - -h <br> Show help information
    - -o <br> Program name
    - -t <br> Text description
    - -l <br> Output printer file name
    - -a <br> Public authority
    - -I <br> Include path
    - -q <br> Compiler options

   @remark call MIC时，仅传一个参数: mic_shell_param_t
   @remark library选取优先顺序是：-L option, env var OUTPUTDIR, default value *CURLIB

 */
int main(int argc, char *argv[]) {

  using namespace mic;

  mic_shell_param_t* shell_parm = NULL;
  extern char *optarg;
  extern int optind, opterr, optopt;
  int opt;
  int r = 0;
  char *pgm_name = NULL;
  char *lib_name = NULL;
  char *ifs_src  = NULL;
  char *pos_ptr  = NULL;
  path_parm_t *path = NULL;
  compiler_options_t *options = NULL;

  shell_parm = (mic_shell_param_t*)malloc(_MAX_SHELL_PARAM_LENGTH);
  memset(shell_parm, 0, _MAX_SHELL_PARAM_LENGTH);
  // init flags of shell_parm_t
  shell_parm->verbose_[0] = '0';
  shell_parm->read_stdin_[0] = '0';
  options = (compiler_options_t*)((char*)shell_parm + _SHELL_PARM_HEADER_LENGTH + _MIC_CMD_PARM_OPTION_OFFSET);

  // init text_, output_, public_auth_
  copy_bytes_with_padding(shell_parm->cmd_parm_.text_, "", 50, _WS);
  copy_bytes_with_padding(shell_parm->cmd_parm_.output_, "", 20, _WS);
  copy_bytes_with_padding(shell_parm->cmd_parm_.public_auth_, "", 10, _WS);

  // parse command line
  while(r == 0 && (opt = getopt(argc, argv, _MIC_SHELL_OPTIONS)) != EOF) {

    switch(opt) {
    case 'v':
      shell_parm->verbose_[0] = '1';
      break;
    case 'V':
      printf(_MIC_VERSION);
      free(shell_parm);
      return 0;
    case 'h':
      printf(_MIC_USAGE);
      free(shell_parm);
      return 0;
    case 'o':  // shell_parm->cmd_parm_.pgm_
      pgm_name = strdup(optarg);
      break;
    case 't':
      copy_bytes_with_padding(
                              shell_parm->cmd_parm_.text_,
                              optarg,
                              50,
                              _WS
                              );
      break;
    case 'l':
      make_object_name20(optarg, shell_parm->cmd_parm_.output_);
      make_upper(shell_parm->cmd_parm_.output_, 20);
      if(memcmp(shell_parm->cmd_parm_.output_ + 10, _WS_10, 10) == 0)
        memcpy(shell_parm->cmd_parm_.output_ + 10, _SV_LIBL, 10);
      break;
    case 'a':
      copy_bytes_with_padding(
                              shell_parm->cmd_parm_.public_auth_,
                              optarg,
                              10,
                              _WS
                              );
      make_upper(shell_parm->cmd_parm_.public_auth_, 10);
      break;
    case 'I':
      path = &shell_parm->cmd_parm_.incdirs_.dirs_[shell_parm->cmd_parm_.incdirs_.num_];
      path->len_ = strlen(optarg);
      copy_bytes_with_padding(
                              path->path_,
                              optarg,
                              _MAX_IFS_PATH_LEN,
                              _WS
                              );
      shell_parm->cmd_parm_.incdirs_.num_++;
      break;
    case 'q':
      copy_bytes_with_padding(
                              options->opts_[options->num_],
                              optarg,
                              _COMPILER_OPTION_LEN,
                              _WS
                              );
      make_upper(options->opts_[options->num_], _COMPILER_OPTION_LEN);
      options->num_++;
      break;
    case 'L':
      lib_name = strdup(optarg);
      // lib_name will be converted to upper case at 'handle_lib_name:'
      break;
    case '?':
      // invalid option value
      printf(_ERROR"invalid command option %c."_NLS, (char)opt);
      r = 1;
      break;
    case ':':
      // missing OPTION VALUE
      printf(_ERROR"option requires an argument -- -%d."_NLS, (char)opt);
      r = 1;
    default:
      break;
    }
  }

  // get source unit name
  if(optind < argc) {

    ifs_src = strdup(argv[optind]);
    shell_parm->cmd_parm_.ifs_src_.len_ = strlen(ifs_src);
    copy_bytes_with_padding(
                            shell_parm->cmd_parm_.ifs_src_.path_,
                            ifs_src,
                            _MAX_IFS_PATH_LEN,
                            _WS
                            );

  } else {

    // read source from stdin
    shell_parm->read_stdin_[0] = '1';

    // set pgm_name to a.out
    if(pgm_name == NULL)
      pgm_name = _A_OUT;
  }

  // determine ifs program name and name of the real *pgm object
 handle_pgm_name:
  if(pgm_name == NULL && ifs_src != NULL) {

    // check ifs_src
    pgm_name = basename(ifs_src);
    pos_ptr = strchr(pgm_name, _DOT);
    if(pos_ptr != NULL)
      pgm_name[pos_ptr - pgm_name] = 0;

  }

  // if strlen(pgm_name) > 10, truncate it, warning
  if(pgm_name != NULL && strlen(pgm_name) > 10) {

    printf(_ERROR"program name too long, should be less than or equal" \
           " to 10 characters -- %s."_NLS,
           pgm_name
           );
    r = 1;
  }

  // determine program library name
 handle_lib_name:
  if(lib_name == NULL)
    lib_name = getenv(_OUTPUTDIR);

  if(lib_name != NULL && strlen(lib_name) > 10) {

    printf(_ERROR"library name too long, should be less than or equal" \
           " to 10 characters -- %s."_NLS,
           lib_name
           );
    r = 1;
  }

 end_of_check:
  // 如果解析command line过程哪里不对了，就该退了
  if(r != 0) {

    free(shell_parm);
    return r;
  }

  shell_parm->symbol_link_offset_ = _SHELL_SPECIFIC_PARAM_START;
  shell_parm->symbol_link_length_ = strlen(pgm_name);
  memcpy((char*)shell_parm + shell_parm->symbol_link_offset_,
         pgm_name,
         shell_parm->symbol_link_length_);

  // shell_parm->cmd_parm_.pgm_
  copy_bytes_with_padding(
                          shell_parm->cmd_parm_.pgm_,
                          pgm_name,
                          10,
                          _WS
                          );
  make_upper(shell_parm->cmd_parm_.pgm_, 10);

  // library name
  if(lib_name != NULL) {

    copy_bytes_with_padding(
                            shell_parm->cmd_parm_.pgm_ + 10,
                            lib_name,
                            10,
                            _WS
                            );
    make_upper(shell_parm->cmd_parm_.pgm_ + 10, 10);

  } else
    memset(shell_parm->cmd_parm_.pgm_ + 10, _WS, 10);

  // call mic
  r = MIC(shell_parm);
  free(shell_parm);

  return r;
}
