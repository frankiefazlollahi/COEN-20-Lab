#include <stdio.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <stdint.h>
#include <stdarg.h>
#include "library.h"
#include "graphics.h"

// Convert array of bits to signed int.
int32_t Bits2Signed(int8_t bits[8])
{
  int i;
  uint32_t val = 0;
  val += (-1 * bits[7] * pow(2,7));
  for (i = 0; i < 7; i++)
  {
    val += (bits[i] * pow(2,i));
  }
  return val;
}

// Convert array of bits to unsigned int
uint32_t Bits2Unsigned(int8_t bits[8])
{
  int i;
  uint32_t val = 0;
  for(i = 0; i < 8; i++)
  {
    val += (bits[i] * pow(2,i));
  }
  return val;
}

// Add 1 to value represented by bit pattern
void Increment(int8_t bits[8])
{
  int i;
  for(i = 0; i < 8; i++)
  {
    if(bits[i] == 0)
    {
      bits[i] = 1;
      break;
    }
    bits[i] = 0;
  }
}

// Opposite of Bits2Unsigned
void Unsigned2Bits(uint32_t n, int8_t bits[8])
{
  int i;
  for(i = 0; i < 8; i++)
  {
    bits[i] = n%2;
    n = n/2;
  }
}
