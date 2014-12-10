//
//  main.m
//  StringObfuscatorSample
//
//  Created by Robert Vojta on 07.12.14.
//  Copyright (c) 2014 Robert Vojta. All rights reserved.
//

@import Foundation;

// Include auto generated
#include "SOStrings.h"

// Include "lib" to "decrypt" strings
#include "RVStringObfuscator.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    // Store strings from auto generated header file
    char strings[] = SO_STRINGS_STRINGS;

    // Get number of obfuscated strings, no need to initialize `count`, will be
    // set to `0` if there's an error
    int count;
    RV_STRING_OBFUSCATOR_COUNT( strings, &count );
    fprintf( stdout, "Found %d obfuscated strings, trying to decrypt them ...\n", count );

    for ( int i = 0 ; i < count ; i++ ) {
      // "Decrypt" obfuscated string, no need to initialize `decrypted`, will be
      // set to `NULL` if there's an error, index out of range, ...
      char *decrypted;
      RV_STRING_OBFUSCATOR_COPY_STRING_PREFIX( strings, i, &decrypted, SO_STRINGS );

      if ( decrypted == NULL ) {
        // You did pass `NULL` instead of `strings`, `index` is out of range
        fprintf( stdout, "%d: can't decrypt string\n", i );
      } else {
        // We've got decrypted string, just print it
        fprintf( stdout, "%d: decrypted string \"%s\"\n", i, decrypted );

        // We own it now, we have to release it when we no longer need it
        free( decrypted );

        //
        // Conversion to NSString ...
        //
        // NSString *foundationString = [[NSString alloc] initWithCString:decrypted encoding:NSUTF8StringEncoding];
        // free( decrypted );
        //
        // ... or ...
        //
        // NSString *foundationString = [[NSString alloc] initWithBytesNoCopy:(void *)decrypted
        //                                                             length:(NSUInteger)strlen( decrypted )
        //                                                           encoding:NSUTF8StringEncoding
        //                                                       freeWhenDone:YES];
        //
        // ... to avoid bytes copy and to free it automatically.
        //
      }
    }
  }
  return 0;
}
