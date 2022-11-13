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
 * @file mic-def.h
 *
 * definitions ...
 */

# ifndef __mic_def_h__
# define __mic_def_h__

// limitations
/// maxinum include depth
#   define MAX_INCLUDE_DEPTH 10

// character constants
#   ifdef __OS400__
#     define _CH_NL  '\x25'
#     define _NLS "\x25"
#     define _TAB "\x05"
#     define _WS  '\x40'
#     define _WSS "\x40"
#     define _WS_10 "\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40"
#     define _WS_20 "\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40"
#     define _DOT '\x4B'
#     define _CONTROL_CHARS "\x2F\x16\x05\x0C\x25\x0D\x0B\x27"
#     define _END_OF_COMMENT "\x5C\x61"
#     define _BEGIN_OF_COMMENT "\x61\x5C"
#     define _STMT_DELIMITER "\x5E"
#     define _SLASH '\x61'
#     define _SLASHS "\x61"
#     define _KEYWORD_INCLUDE "\x89\x95\x83\x93\xA4\x84\x85"
#     define _KEYWORD_DEFINE "\xC4\xC5\xC6\xC9\xD5\xC5"
#     define _KEYWORD_UNDEF "\xE4\xD5\xC4\xC5\xC6"
#     define _KEYWORD_IFDEF "\xC9\xC6\xC4\xC5\xC6"
#     define _KEYWORD_IFNDEF "\xC9\xC6\xD5\xC4\xC5\xC6"
#     define _KEYWORD_ENDIF "\xC5\xD5\xC4\xC9\xC6"
#     define _KEYWORD_ELSE "\xC5\xD3\xE2\xC5"
#     define _PEND "\xD7\xC5\xD5\xC4"
#     define _COLON '\x7A'
#     define _LEFT_BRAKET '\x4D'
#     define _RIGHT_BRAKET '\x5D'
#     define _OUTPUTDIR "\xD6\xE4\xE3\xD7\xE4\xE3\xC4\xC9\xD9"
#     define _MIC_AUTH_ALL "\x5C\xC1\xD3\xD3\x40\x40\x40\x40\x40\x40"
#     define _QSYSPRT  "\xD8\xE2\xE8\xE2\xD7\xD9\xE3\x40\x40\x40\x5C\xD3\xC9\xC2\xD3\x40\x40\x40\x40\x40"
#     define _SV_LIBL  "\x5C\xD3\xC9\xC2\xD3\x40\x40\x40\x40\x40"
#     define _MIC_SHELL_OPTIONS "\xA5\xE5\x88\x96\x7A\xA3\x7A\x93\x7A\x81\x7A\xC9\x7A\x98\x7A\xD3\x7A"
#     define _A_OUT "\x81\x4B\x96\xA4\xA3"
#   else
#     define _CH_NL  '\n'
#     define _NLS "\n"
#     define _TAB "\t"
#     define _WS ' '
#     define _WSS " "
#     define _WS_10 "          "
#     define _WS_20 "                    "
#     define _DOT '.'
// \a, \b, \t, \f, \n, \r, x"0B", x"1B"
// bel, bs, ht, np, nl, cr, vt, esc
#     define _CONTROL_CHARS "\x07\x08\x09\x0C\x0A\x0D\x0B\x1B"
#     define _END_OF_COMMENT "*/"
#     define _BEGIN_OF_COMMENT "/*"
#     define _STMT_DELIMITER ";"
#     define _SLASH '/'
#     define _SLASHS "/"
#     define _KEYWORD_INCLUDE "include"
#     define _KEYWORD_DEFINE "DEFINE"
#     define _KEYWORD_UNDEF "UNDEF"
#     define _KEYWORD_IFDEF "IFDEF"
#     define _KEYWORD_IFNDEF "IFNDEF"
#     define _KEYWORD_ENDIF "ENDIF"
#     define _KEYWORD_ELSE "ELSE"
#     define _PEND "PEND"
#     define _COLON ':'
#     define _LEFT_BRAKET '('
#     define _RIGHT_BRAKET ')'
#     define _OUTPUTDIR "OUTPUTDIR"
#     define _MIC_AUTH_ALL "*ALL      "
#     define _SV_LIBL  "*LIBL     "
#     define _QSYSPRT  "QSYSPRT   *LIBL     "
#     define _MIC_SHELL_OPTIONS "vVho:t:l:a:I:q:L:"
#     define _A_OUT "a.out"
#   endif

/**
 * number of special inc dirs
 */
#  define _NUM_SPECIAL_INCDIRS 2
extern const char *_mic_spec_incdirs[];

/// usgae info
#  define _MIC_USAGE \
  "Usage: mic [options] file"_NLS \
  "Options:"_NLS \
  _TAB"-v"_TAB"Verbose"_NLS \
  _TAB"-V"_TAB"Show version information"_NLS \
  _TAB"-h"_TAB"Show help information"_NLS \
  _TAB"-o program-name"_TAB"Name of created program object"_NLS \
  _TAB"-t text"_TAB"Text description"_NLS \
  _TAB"-l printer-file"_TAB"Output printer file name"_NLS \
  _TAB"-a public-authority"_TAB"Public authority"_NLS \
  _TAB"-I include-path"_TAB"Include path"_NLS \
  _TAB"-q compiler-option"_TAB"Compiler options"_NLS \
  _TAB"-L library-name"_TAB"Library name of created program object"_NLS \
  _NLS \
  "Report bugs to junleili-cn@users.sourceforge.net"_NLS

/// project name
#  define _I5TOOLKIT "i5/OS Programmer's Toolkit"

/// verion number of project i5toolkit
#  define _I5TOOLKIT_VERSION "0.2.10"

/// mic's version info
#  define _MIC_VERSION \
 "mic (" _I5TOOLKIT ") " _I5TOOLKIT_VERSION _NLS \
 "Copyright (C) 2010, 2011  Junlei Li"_NLS \
 _NLS                                                                   \
 "i5/OS Programmer's Toolkit is distributed in the hope that it will"_NLS \
 "be useful, but WITHOUT ANY WARRANTY; without even the implied warranty"_NLS \
 "of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU"_NLS \
 "General Public License for more details."_NLS                         \
 _NLS

/// maxinum length of a ifs path name
#  define _MAX_IFS_PATH_LEN          512

/// length of a compiler option string
#  define _COMPILER_OPTION_LEN       11

#  define _LISTINFO_PF               "*LIBL/MICLSTINF"

#  define _ENV_OUTPUTDIR             "OUTPUTDIR"

/// max number of INC dirs, 15
#  define _MAX_INCDIRS        15

#  define _MIC_ECLEN          256

/* SPACE used to recieved list info */
# define _MIC_LIST_SPC "MICLSTINF QTEMP     "

# define _MIC_LIST_SPC_SIZE 0x100000  // 1Mb

# define _MIC_LIST_FILE "QTEMP/MICLSTINF"

# define _MIC_LIST_FILE_RLEN 132

/**
 * ifs path parameter
 */
typedef
#  ifdef __OS400__
_Packed
#  endif
struct _tag_path_parm {

  unsigned short len_;
  char path_[_MAX_IFS_PATH_LEN];

} path_parm_t;

/**
 * include directories
 */
typedef
#  ifdef __OS400__
_Packed
#  endif
struct _tag_include_dirs {

  unsigned short num_;
  path_parm_t dirs_[_MAX_INCDIRS];

} include_dirs_t;

/// max number of compiler options, 38
#  define _MAX_COMPILER_OPTIONS       38
/**
 * mic compiler options
 */
typedef
#  ifdef __OS400__
_Packed
#  endif
struct  _tag_compiler_options {

  unsigned short num_;
  char           opts_[_MAX_COMPILER_OPTIONS][_COMPILER_OPTION_LEN];

} compiler_options_t;

/**
 * cpp parameter
 */
typedef
#  ifdef __OS400__
_Packed
#  endif
struct _tag_mic_cmd_param {

  char                 pgm_[20];           // argv[1]
  path_parm_t          ifs_src_;           // argv[2]
  char                 text_[50];          // argv[3]
  char                 output_[20];        // argv[4]
  char                 public_auth_[10];   // argv[5]
  include_dirs_t       incdirs_;           // argv[6]
  compiler_options_t   options_;           // argv[7]

} mic_cmd_param_t;

/// length of the fixed length portion of MIC's command params
# define _MIC_CMD_PARAM_FIXED_LENGTH 614
# define _MIC_CMD_PARM_INCDIRS_OFFSET _MIC_CMD_PARAM_FIXED_LENGTH
# define _MIC_CMD_PARM_OPTION_OFFSET (_MIC_CMD_PARAM_FIXED_LENGTH + 7712)

/// number of ...
# define _MIC_PARM_NUMBER 7

/**
 * qshell parameter
 *
 * @remark header保留16 bytes
 * @remark 额外内容，如STMF symbol link name，放在128K之后
 */
typedef
#  ifdef __OS400__
_Packed
#  endif
struct _tag_mic_shell_param {

  /// must be hex 00
  char shell_parm_flag_[1];

  /// verbose or not. '0' - silent, '1' - verbose
  char verbose_[1];

  /// read stdin or not: '0' - not, '1' - yes
  char read_stdin_[1];

  /// reserved
  char rev_0_[5];

  /// offset to the name of the symbol link in IFS of target program
  unsigned int symbol_link_offset_;

  /// length of the name of the symbol link in IFS of target program
  unsigned int symbol_link_length_;

  /// reserved, must be hex 00
  char reserved_header_[48];

  // with offset 0x20000 (128K)
  // char *symbol_link;

  mic_cmd_param_t cmd_parm_;

} mic_shell_param_t;

# define _SHELL_PARM_HEADER_LENGTH 64

# define _MAX_SHELL_PARAM_LENGTH 0x40000 // 256K
# define _SHELL_SPECIFIC_PARAM_START 0x20000 // 128K

#   include <builtin-fmt.hpp>

# endif // !defined __mic_def_h__
