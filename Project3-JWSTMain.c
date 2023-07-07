#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include "library.h"
#define XFIRST 1.503e9//changed to 1.5 //then changed again narrow window even further 
#define XLAST 1.504e9 // changed 1.6 // then changed again

extern void JWST(float *,float *,float,float);
float x[11],f[11];

int main(void) {
  int i;

  InitializeHardware(HEADER,"James Webb Space Telescope");
  JWST(x,f,XFIRST,XLAST);
  printf("    x         f(x)\n---------- ---------\n");
  i = 0;
  while (i < 11) {
    printf("%.4e %.4e\n",x[i],f[i]);
    i++;
  }
}
