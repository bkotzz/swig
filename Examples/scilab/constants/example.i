/* File : example.i */
%module example

#define ICONST 42
#define FCONST 2.1828
#define SCONST "Hello World"

// Constants expressions are also accepted
#define EXPR ICONST + 3*FCONST

// SWIG also offers to define constants
%constant int iconst = 37;
%constant double fconst = 42.2;

