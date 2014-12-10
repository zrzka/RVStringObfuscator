//
//  RVStringObfuscator.h
//  StringObfuscator
//
//  Created by Robert Vojta on 07.12.14.
//  Copyright (c) 2014 Robert Vojta. All rights reserved.
//

#ifndef __RVStringObfuscator_h
#define __RVStringObfuscator_h

#include <string.h>

/**
 * Get number of obfuscated strings from strings table.
 *
 * There's no need to initialize `count` before usage. If there's an
 * error, it's always set to 0.
 *
 * @param strings `char strings[]` obfuscated strings table
 * @param count `int *count` number of obfuscated strings
 *
 */
#define RV_STRING_OBFUSCATOR_COUNT( strings, count ) \
  do { \
    int *__rvso_output = count; \
    if ( strings == NULL ) { \
      *__rvso_output = 0; \
      break; \
    } \
    \
    int __rvso_count = 0; \
    char *__rvso_next_string = strings; \
    \
    while ( strlen( __rvso_next_string ) > 0 ) { \
      __rvso_count++; \
      __rvso_next_string += strlen( __rvso_next_string ) + 1; \
    } \
    \
    *__rvso_output = __rvso_count; \
  } while (0)

/**
 * Copy plaintext string from strings table.
 *
 * There's no need to initialize `output` before usage. If there's an
 * error, index is out of range, it's always set to `NULL`.
 *
 * If output is set (`!= NULL`), you're owner of this buffer and you
 * must `free()` it somewhere.
 *
 * @param strings `char strings[]` obfuscated strings table
 * @param index `int index` string index to get
 * @param output `char **` pointer to pointer to plaintext string or `NULL`
 * @param prefix prefix used in header generation
 */
#define RV_STRING_OBFUSCATOR_COPY_STRING_PREFIX( strings, index, output, prefix ) \
  RV_STRING_OBFUSCATOR_COPY_STRING( strings, index, output, prefix ## _PRIMER, prefix ## _PRIMER_CHAR_INCREMENT, prefix ## _PRIMER_LINE_INCREMENT )

/**
 * Copy plaintext string from strings table.
 *
 * There's no need to initialize `output` before usage. If there's an
 * error, index is out of range, it's always set to `NULL`.
 *
 * If output is set (`!= NULL`), you're owner of this buffer and you
 * must `free()` it somewhere.
 *
 * @param strings `char strings[]` obfuscated strings table
 * @param index `int index` string index to get
 * @param output `char **` pointer to pointer to plaintext string or `NULL`
 * @param primer `char` primer
 * @param primer_char_increment `char` primer char increment
 * @param primer_line_increment `char` primer line increment
 *
 */
#define RV_STRING_OBFUSCATOR_COPY_STRING( strings, index, output, primer, primer_char_increment, primer_line_increment ) \
  do { \
    char **__rvso_output = output; \
    int __rvso_strings_count; \
    RV_STRING_OBFUSCATOR_COUNT( strings, &__rvso_strings_count ); \
    if ( index < 0 || index >= __rvso_strings_count ) { \
      *__rvso_output = NULL; \
      break; \
    } \
    \
    char __rvso_string_primer = primer; \
    char *__rvso_string = strings; \
    int __rvso_string_index = index; \
    while ( __rvso_string_index-- > 0 ) { \
      __rvso_string += strlen( __rvso_string ) + 1; \
      __rvso_string_primer += primer_line_increment; \
    } \
    \
    size_t __rvso_string_length = strlen( __rvso_string ); \
    if ( __rvso_string_length == 0 ) { \
      *__rvso_output = NULL; \
      break; \
    } \
    \
    char *__rvso_decrypted = malloc( __rvso_string_length + 1 ); \
    if ( __rvso_decrypted == NULL ) { \
      *__rvso_output = NULL; \
      break; \
    } \
    \
    for ( int i = 0 ; i < __rvso_string_length ; i++ ) { \
      __rvso_decrypted[i] = __rvso_string[i] ^ __rvso_string_primer; \
      __rvso_string_primer += primer_char_increment; \
    } \
    __rvso_decrypted[__rvso_string_length] = 0; \
    *__rvso_output = __rvso_decrypted; \
  } while(0)

#endif // defined( __RVStringObfuscator_h )
