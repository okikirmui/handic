#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.69)
AC_INIT([handic], [20220214], [sugaiy@kindai.ac.jp])
AM_INIT_AUTOMAKE([foreign])

# Checks for programs.
AC_PROG_INSTALL
AC_PROG_LN_S

AC_PATH_PROG(MECAB_CONFIG, mecab-config, no)
AS_IF(test "x${MECAB_CONFIG}" = "xno", AC_MSG_ERROR(mecab-config required))

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

# Other variables
AC_ARG_WITH(dicdir,
  AS_HELP_STRING(
    [--with-dicdir@<:@=DIR@:>@], [set dic install directory [[MECAB_DIC_DIR/handic]]]),
  [DIC_DIR=$withval], [DIC_DIR=])
AS_IF(test "x${DIC_DIR}" = "x", DIC_DIR=`${MECAB_CONFIG} --dicdir`/${PACKAGE_NAME})
AC_SUBST(DIC_DIR)

AC_ARG_WITH(user-dic,
  AS_HELP_STRING(
    [--with-user-dic@<:@=FILE@:>@], [use FILE as user dictionary]),
  [USER_DIC=$withval], [USER_DIC=])
AC_SUBST(USER_DIC)

AC_ARG_WITH(model-file,
  AS_HELP_STRING(
    [--with-model-file@<:@=FILE@:>@], [use FILE as model file]),
  [MODEL_FILE=$withval], [MODEL_FILE=])
AS_IF(test "x${USER_DIC}" != "x" -a "x${MODEL_FILE}" = "x", AC_MSG_ERROR(model-file required when user-dic is set))
AC_SUBST(MODEL_FILE)

MECAB_USER_DATA=
MECAB_DIC=" `echo *.csv` "
for d in `echo ${USER_DIC} | sed 's%,% %g'`
do
    MECAB_USER_DATA=`echo "${MECAB_USER_DATA} ${d}.dic"`
    MECAB_DIC=`echo "${MECAB_DIC}" | sed -e "s% ${d} % %"`
done
MECAB_DEF="char.def unk.def matrix.def"
MECAB_PRE_DATA="dicrc"
MECAB_SYS_DATA="char.bin unk.dic sys.dic matrix.bin"
AC_SUBST(MECAB_DIC)
AC_SUBST(MECAB_DEF)
AC_SUBST(MECAB_PRE_DATA)
AC_SUBST(MECAB_SYS_DATA)
AC_SUBST(MECAB_USER_DATA)

MECAB_DICT_INDEX="`${MECAB_CONFIG} --libexecdir`/mecab-dict-index"
MECAB_MECABRC="`${MECAB_CONFIG} --sysconfdir`/mecabrc"
AC_SUBST(MECAB_DICT_INDEX)
AC_SUBST(MECAB_MECABRC)

AC_CONFIG_FILES([Makefile
	seed/Makefile])
AC_OUTPUT
