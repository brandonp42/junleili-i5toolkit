
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
 * @file mic-main.cpp
 *
 * i'm main :p
 * @todo exception handling
 */

# include <mic.hpp>

# include <unistd.h>

void
make_symbol_link(mic_shell_param_t *shell_parm);
void
accept_input_parms(
                   mic_cmd_param_t& mic_parm,
                   bool& from_shell,
                   char *parm_str
                   );

void
load_inc_dirs(
              mic::stringlist_t& inc_dirs,
              mic_cmd_param_t& mic_parm
              );

int main(int argc, char *argv[]) {

  using namespace std;
  using namespace mic;

  if(argc < 2)
    return 1; // do NOT call me directly :p

  int r = 0;  // mic's return value
  mic_cmd_param_t mic_parm;
  char *parm_str = argv[1];
  mic_shell_param_t *shell_parm = (mic_shell_param_t*)argv[1];
  bool from_shell = false;
  string ex_info;
  char when_start[13 + 1] = {0};

  try {

    accept_input_parms(mic_parm, from_shell, parm_str);

    stmtlist_t stmts;
    stringlist_t inc_dirs;

    string src_path(mic_parm.ifs_src_.path_, mic_parm.ifs_src_.len_);
    load_inc_dirs(inc_dirs, mic_parm);

    // read target source file
    string source;
    if(from_shell && shell_parm->read_stdin_[0] == '1') {

      char ch = 0;
      while(read(STDIN_FILENO, &ch, 1) > 0)
        source += ch;

    } else
      source = read_source_file(src_path, inc_dirs);

    // deny empty source
    if(source.size() == 0) {

      ex_info = "empty source file -- ";
      ex_info += src_path;
      throw compiler_ex_t(ex_info);
    }

    phase_a(source.c_str(), stmts, inc_dirs);

    // phase b
    builtinmap_t b_map;
    load_builtins(b_map);
    phase_b(stmts, b_map);

    // phase c
    // record when phase C starts: when_start
    get_current_time13(when_start);
    phase_c(stmts, mic_parm);

  } catch(compiler_ex_t& ex) {

    report_exception(exbase_t::compiler, ex.what(), from_shell);
    r = 1;
  } catch(internal_ex_t& ex) {

    if(from_shell)
      print_listinfo(when_start, mic_parm.output_);
    report_exception(exbase_t::internal, ex.what(), from_shell);
    r = 1;
  } catch(exbase_t& ex) {

    report_exception(exbase_t::unknown, ex.what(), from_shell);
    r = 1;
  }

  // other function: e.g print_listinfo()
  if(from_shell && shell_parm->verbose_[0] == '1')
    print_listinfo(when_start, mic_parm.output_);

  if(r != 0) {

    report_exception(exbase_t::information, "compilation failed :(", from_shell);
    return r;
  }

  // last: if everything's okey
  //   shell: determine pgm name, make symbol link
  //   if(from_shell) { symbol_link is parm_str + 128K; symlink('/qsys.lib/LIB.lib/PGM.pgm', symbol_link);}
  if(from_shell) {

    mic_shell_param_t *shell_parm = (mic_shell_param_t*)parm_str;
    make_symbol_link(shell_parm);
  }

  char greeting[64] = {0};
  sprintf(greeting,
          "program %10.10s is placed in library %10.10s",
          mic_parm.pgm_,
          mic_parm.pgm_ + 10);
  report_exception(exbase_t::information, greeting, from_shell);
  return r;
}

void
accept_input_parms(
                   mic_cmd_param_t& mic_parm,
                   bool& from_shell,
                   char *parm_str
                   ) {

  using namespace mic;

  int i = 0;
  size_t len = 0;
  char *pos = NULL;

  // is invoked from qshell
  from_shell = false;
  if(*parm_str == 0) {

    from_shell = true;
    parm_str += _SHELL_PARM_HEADER_LENGTH;
  }

  // pgm_, ifs_src_, text_, output_, public_auth_
  pos = parm_str;
  memcpy(&mic_parm, pos, _MIC_CMD_PARAM_FIXED_LENGTH);
  mic_parm.ifs_src_.path_[mic_parm.ifs_src_.len_] = 0;

  pos = parm_str + _MIC_CMD_PARAM_FIXED_LENGTH;
  mic_parm.incdirs_.num_ = *(unsigned short*)pos;
  pos += 2;

  len = sizeof(path_parm_t) * mic_parm.incdirs_.num_;
  memcpy(mic_parm.incdirs_.dirs_, pos, len);
  if(from_shell)  // so tricky! :(
    pos = parm_str + _MIC_CMD_PARM_OPTION_OFFSET;
  else
    pos += len;

  for(i = 0; len != 0 && i < mic_parm.incdirs_.num_; i++) {

    char *dir = mic_parm.incdirs_.dirs_[i].path_;
    dir[mic_parm.incdirs_.dirs_[i].len_] = 0;
  }

  mic_parm.options_.num_ = *(unsigned short*)pos;
  pos += 2;

  len = _COMPILER_OPTION_LEN * mic_parm.options_.num_;
  memcpy(mic_parm.options_.opts_, pos, len);

  // set value for default parameters
  if(memcmp(mic_parm.public_auth_, _WS_10, 10) == 0)
    memcpy(mic_parm.public_auth_, _MIC_AUTH_ALL, 10);

  // library name
  if(memcmp(mic_parm.pgm_ + 10, _WS_10, 10) == 0)
    get_cur_lib(mic_parm.pgm_ + 10);

  if(memcmp(mic_parm.output_, _WS_20, 20) == 0)
    memcpy(mic_parm.output_, _QSYSPRT, 20);

  if(from_shell) {

    mic_cmd_param_t *feedback = (mic_cmd_param_t*)parm_str;
    memcpy(feedback->public_auth_, mic_parm.public_auth_, 20);
    memcpy(feedback->pgm_, mic_parm.pgm_, 20);
    memcpy(feedback->output_, mic_parm.output_, 20);
  }

} // end of accept_input_parms

const char *_mic_spec_incdirs[] = {
  "/usr/local/include/emi/api",
  "/usr/local/include/emi/mi"
};

void
load_inc_dirs(
              mic::stringlist_t& inc_dirs,
              mic_cmd_param_t& mic_parm
              ) {

  using namespace std;

  int i = 0;

  inc_dirs.clear();
  include_dirs_t& dirs = mic_parm.incdirs_;
  for(i = 0; i < dirs.num_; i++) {

    string dir(dirs.dirs_[i].path_, dirs.dirs_[i].len_);
    inc_dirs.push_back(dir);
  } // end of for()

  // append mic internal/special include dirs
  for(i = 0; i < _NUM_SPECIAL_INCDIRS; i++) {

    inc_dirs.push_back(_mic_spec_incdirs[i]);
  }

} // end of load_inc_dirs()

void
make_symbol_link(mic_shell_param_t *shell_parm) {

  using namespace std;
  using namespace mic;

  char *start = (char*)shell_parm;
  string path(start + shell_parm->symbol_link_offset_,
              shell_parm->symbol_link_length_);
  unlink(path.c_str());

  char ifs_path[64] = {0};
  char pgm[11] = {0};
  char lib[11] = {0};
  memcpy(pgm, shell_parm->cmd_parm_.pgm_, 10);
  memcpy(lib, shell_parm->cmd_parm_.pgm_ + 10, 10);
  trimr(pgm);
  trimr(lib);
  sprintf(ifs_path,
          _SLASHS "qsys.lib" _SLASHS "%s.lib" _SLASHS "%s.pgm",
          lib, pgm);
  symlink(ifs_path, path.c_str());
}

/*
  test:

  char* l = "hu.c";
  char* o = "b.c";

  int r = unlink(l);
  printf("unlink() returns: %d\n", r);

  r = symlink(o, l);
  printf("symlink() returns: %d\n", r);

*/
