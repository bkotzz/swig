cmake_minimum_required(VERSION 3.0)

include("cmake/HunterGate.cmake")
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.23.68.tar.gz"
    SHA1 "d7365dfaf3db5c0939f3c62141a2ec1eac660962"
)

project(swig LANGUAGES C CXX VERSION "4.0.0")

# Used in swigconfig.cmake.in
set(SWIG_VERSION ${PROJECT_VERSION})
set(SWIG_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/Source")

hunter_add_package(libpcre)
find_package(libpcre CONFIG REQUIRED)
# include_directories(${PCRE_INCLUDE_DIRS})
set(HAVE_PCRE 1)

configure_file(
    cmake/swigconfig.h.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/GeneratedInclude/swigconfig.h
)

hunter_add_package(bison)
find_package(BISON REQUIRED)

include_directories(
    "${SWIG_SOURCE_DIR}/CParse"
    "${SWIG_SOURCE_DIR}/DOH"
    "${SWIG_SOURCE_DIR}/Doxygen"
    "${SWIG_SOURCE_DIR}/Include"
    "${SWIG_SOURCE_DIR}/Modules"
    "${SWIG_SOURCE_DIR}/Preprocessor"
    "${SWIG_SOURCE_DIR}/Swig"
    "${PROJECT_BINARY_DIR}/GeneratedInclude"
)

file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/GeneratedSource)
BISON_TARGET(swig_parser
    ${SWIG_SOURCE_DIR}/CParse/parser.y
    ${PROJECT_BINARY_DIR}/GeneratedSource/parser.c
)

file(READ ${SWIG_SOURCE_DIR}/Include/swigwarn.h SWIG_WARN_H)
string(REGEX REPLACE "#define WARN([^ \\t]*)[ \\t]*([0-9]+)" "%define SWIGWARN\\1 \\2 %enddef" SWIG_WARN_SWG ${SWIG_WARN_H})
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/swigwarn.swg ${SWIG_WARN_SWG})

# install lib
# Has to match the path of `swig -swiglib`
#set(SWIG_LIB ${CMAKE_CURRENT_BINARY_DIR}/share/swig/${PROJECT_VERSION})
#install(DIRECTORY ${SWIG_ROOT}/Lib/ DESTINATION ${SWIG_LIB})
#install(FILES ${CMAKE_CURRENT_BINARY_DIR}/swigwarn.swg DESTINATION ${SWIG_LIB})

# Libraries
# ---------

add_library(cparse
    "${SWIG_SOURCE_DIR}/CParse/cscanner.c"
    "${SWIG_SOURCE_DIR}/CParse/templ.c"
    "${SWIG_SOURCE_DIR}/CParse/util.c"
    "${PROJECT_BINARY_DIR}/GeneratedSource/parser.c"
)

add_library(preprocessor
    "${SWIG_SOURCE_DIR}/Preprocessor/cpp.c"
    "${SWIG_SOURCE_DIR}/Preprocessor/expr.c"
)

add_library(doh
    "${SWIG_SOURCE_DIR}/DOH/base.c"
    "${SWIG_SOURCE_DIR}/DOH/file.c"
    "${SWIG_SOURCE_DIR}/DOH/fio.c"
    "${SWIG_SOURCE_DIR}/DOH/hash.c"
    "${SWIG_SOURCE_DIR}/DOH/list.c"
    "${SWIG_SOURCE_DIR}/DOH/memory.c"
    "${SWIG_SOURCE_DIR}/DOH/string.c"
    "${SWIG_SOURCE_DIR}/DOH/void.c"
)

add_library(core
    "${SWIG_SOURCE_DIR}/Swig/cwrap.c"
    "${SWIG_SOURCE_DIR}/Swig/deprecate.c"
    "${SWIG_SOURCE_DIR}/Swig/error.c"
    "${SWIG_SOURCE_DIR}/Swig/extend.c"
    "${SWIG_SOURCE_DIR}/Swig/fragment.c"
    "${SWIG_SOURCE_DIR}/Swig/getopt.c"
    "${SWIG_SOURCE_DIR}/Swig/include.c"
    "${SWIG_SOURCE_DIR}/Swig/misc.c"
    "${SWIG_SOURCE_DIR}/Swig/naming.c"
    "${SWIG_SOURCE_DIR}/Swig/parms.c"
    "${SWIG_SOURCE_DIR}/Swig/scanner.c"
    "${SWIG_SOURCE_DIR}/Swig/stype.c"
    "${SWIG_SOURCE_DIR}/Swig/symbol.c"
    "${SWIG_SOURCE_DIR}/Swig/tree.c"
    "${SWIG_SOURCE_DIR}/Swig/typemap.c"
    "${SWIG_SOURCE_DIR}/Swig/typeobj.c"
    "${SWIG_SOURCE_DIR}/Swig/typesys.c"
    "${SWIG_SOURCE_DIR}/Swig/wrapfunc.c"
)

target_link_libraries(core PUBLIC PkgConfig::libpcre)

add_library(modules
    "${SWIG_SOURCE_DIR}/Modules/allegrocl.cxx"
    "${SWIG_SOURCE_DIR}/Modules/allocate.cxx"
    "${SWIG_SOURCE_DIR}/Modules/browser.cxx"
    "${SWIG_SOURCE_DIR}/Modules/cffi.cxx"
    "${SWIG_SOURCE_DIR}/Modules/chicken.cxx"
    "${SWIG_SOURCE_DIR}/Modules/clisp.cxx"
    "${SWIG_SOURCE_DIR}/Modules/contract.cxx"
    "${SWIG_SOURCE_DIR}/Modules/csharp.cxx"
    "${SWIG_SOURCE_DIR}/Modules/d.cxx"
    "${SWIG_SOURCE_DIR}/Modules/directors.cxx"
    "${SWIG_SOURCE_DIR}/Modules/emit.cxx"
    "${SWIG_SOURCE_DIR}/Modules/go.cxx"
    "${SWIG_SOURCE_DIR}/Modules/guile.cxx"
    "${SWIG_SOURCE_DIR}/Modules/interface.cxx"
    "${SWIG_SOURCE_DIR}/Modules/java.cxx"
    "${SWIG_SOURCE_DIR}/Modules/javascript.cxx"
    "${SWIG_SOURCE_DIR}/Modules/lang.cxx"
    "${SWIG_SOURCE_DIR}/Modules/lua.cxx"
    "${SWIG_SOURCE_DIR}/Modules/modula3.cxx"
    "${SWIG_SOURCE_DIR}/Modules/module.cxx"
    "${SWIG_SOURCE_DIR}/Modules/mzscheme.cxx"
    "${SWIG_SOURCE_DIR}/Modules/nested.cxx"
    "${SWIG_SOURCE_DIR}/Modules/ocaml.cxx"
    "${SWIG_SOURCE_DIR}/Modules/octave.cxx"
    "${SWIG_SOURCE_DIR}/Modules/overload.cxx"
    "${SWIG_SOURCE_DIR}/Modules/perl5.cxx"
    "${SWIG_SOURCE_DIR}/Modules/php.cxx"
    "${SWIG_SOURCE_DIR}/Modules/pike.cxx"
    "${SWIG_SOURCE_DIR}/Modules/python.cxx"
    "${SWIG_SOURCE_DIR}/Modules/r.cxx"
    "${SWIG_SOURCE_DIR}/Modules/ruby.cxx"
    "${SWIG_SOURCE_DIR}/Modules/s-exp.cxx"
    "${SWIG_SOURCE_DIR}/Modules/scilab.cxx"
    "${SWIG_SOURCE_DIR}/Modules/tcl8.cxx"
    "${SWIG_SOURCE_DIR}/Modules/typepass.cxx"
    "${SWIG_SOURCE_DIR}/Modules/uffi.cxx"
    "${SWIG_SOURCE_DIR}/Modules/utils.cxx"
    "${SWIG_SOURCE_DIR}/Modules/xml.cxx"
)

add_library(doxygen
    "${SWIG_SOURCE_DIR}/Doxygen/doxyentity.cxx"
    "${SWIG_SOURCE_DIR}/Doxygen/doxyparser.cxx"
    "${SWIG_SOURCE_DIR}/Doxygen/doxytranslator.cxx"
    "${SWIG_SOURCE_DIR}/Doxygen/javadoc.cxx"
    "${SWIG_SOURCE_DIR}/Doxygen/pydoc.cxx"
)

add_executable(swig
    "${SWIG_SOURCE_DIR}/Modules/main.cxx"
    "${SWIG_SOURCE_DIR}/Modules/swigmain.cxx"
)

target_link_libraries(swig cparse preprocessor doh core modules doxygen)

# Introduce variables:
# * CMAKE_INSTALL_LIBDIR
# * CMAKE_INSTALL_BINDIR
# * CMAKE_INSTALL_INCLUDEDIR
# * CMAKE_INSTALL_DATAROOTDIR
include(GNUInstallDirs)

set(GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(VERSION_CONFIG "${GENERATED_DIR}/${PROJECT_NAME}ConfigVersion.cmake")
set(PROJECT_CONFIG "${GENERATED_DIR}/${PROJECT_NAME}Config.cmake")

set(CONFIG_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
set(NAMESPACE "${PROJECT_NAME}::")

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${VERSION_CONFIG}" COMPATIBILITY ExactVersion
)

configure_package_config_file(
  "cmake/Config.cmake.in"
  "${PROJECT_CONFIG}"
  INSTALL_DESTINATION "${CONFIG_INSTALL_DIR}"
)

install(
  TARGETS swig
  EXPORT "${TARGETS_EXPORT_NAME}"
  INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  RESOURCE DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}"
)

install(
  DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/Lib/"
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/${PROJECT_VERSION}
)

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/swigwarn.swg
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/${PROJECT_VERSION}
)

install(
  FILES "${PROJECT_CONFIG}" "${VERSION_CONFIG}"
  DESTINATION "${CONFIG_INSTALL_DIR}"
)

install(
  EXPORT "${TARGETS_EXPORT_NAME}"
  NAMESPACE "${NAMESPACE}"
  DESTINATION "${CONFIG_INSTALL_DIR}"
)
