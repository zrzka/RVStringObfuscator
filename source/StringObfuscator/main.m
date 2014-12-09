//
//  main.m
//  StringObfuscator
//
//  Created by Robert Vojta on 07.12.14.
//  Copyright (c) 2014 Robert Vojta. All rights reserved.
//

@import Foundation;
@import Foundation.NSString;

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    if ( arguments.count != 7 ) {
      fprintf( stderr, "Wrong number of arguments - 6 required.\n" );
      fprintf( stderr, "\n" );
      fprintf( stderr, "Usage: StringObfuscator input-file.txt output-file.h macro-prefix primer primer-char-increment primer-line-increment\n" );
      fprintf( stderr, "\n" );
      fprintf( stderr, " - input-file.txt        - path to the UTF-8 text file with strings, one per line\n" );
      fprintf( stderr, " - output-file.h         - path to the header file which will be generated (output)\n" );
      fprintf( stderr, " - macro-prefix          - string prefix for all macros generated in header file\n" );
      fprintf( stderr, " - primer                - starting value for obfuscation" );
      fprintf( stderr, " - primer-char-increment - increment value per each character, you can pass 0\n" );
      fprintf( stderr, " - primer-line-increment - increment value per each string line, you can pass 0\n" );
      fprintf( stderr, "\n" );

      return 1;
    }

    NSString *inputFileName = arguments[1];
    NSString *outputFileName = arguments[2];
    NSString *macroPrefix = arguments[3];
    char primer = [arguments[4] intValue];
    char primerCharIncrement = [arguments[5] intValue];
    char primerLineIncrement = [arguments[6] intValue];

    NSError *error;
    NSString *input = [NSString stringWithContentsOfFile:inputFileName
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
    if ( input == nil ) {
      fprintf( stderr, "Failed to read input file\n" );
      return -1;
    }

    NSMutableString *output = [[NSMutableString alloc] init];

    [output appendString:@"//\n"];
    [output appendString:@"// Auto generated - DO NOT MODIFY\n"];
    [output appendString:@"//\n\n"];

    NSString *ifMacroFileName = [[outputFileName lastPathComponent] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    [output appendFormat:@"#ifndef __%@\n", ifMacroFileName];
    [output appendFormat:@"#define __%@\n", ifMacroFileName];
    [output appendString:@"\n"];

    [output appendFormat:@"#define %@_PRIMER %d\n", macroPrefix, primer];
    [output appendFormat:@"#define %@_PRIMER_CHAR_INCREMENT %d\n", macroPrefix, primerCharIncrement];
    [output appendFormat:@"#define %@_PRIMER_LINE_INCREMENT %d\n", macroPrefix, primerLineIncrement];
    [output appendFormat:@"#define %@_STRINGS {\\\n", macroPrefix];

    NSScanner *scanner = [[NSScanner alloc] initWithString:input];
    NSString *currentLine;
    char currentLinePrimer = primer;
    int obfuscatedStringsCounter = 0;

    fprintf( stdout, "Obfuscating strings from file \"%s\"\n", [inputFileName UTF8String] );
    NSMutableString *plainStrings = [[NSMutableString alloc] init];
    while ( [scanner scanUpToString:@"\n" intoString:&currentLine] ) {
      if ( currentLine.length == 0 ) {
        continue;
      }

      [plainStrings appendFormat:@"// \"%@\"\n", currentLine];
      [output appendString:@"  "];

      const char *UTF8String = currentLine.UTF8String;
      size_t length = strlen( UTF8String );
      char currentPrimer = currentLinePrimer;

      for ( int i = 0 ; i < length ; i++ ) {
        char currentValue = UTF8String[i];
        char obfuscated = currentValue ^ currentPrimer;
        if ( obfuscated == 0 ) {
          fprintf( stderr, "Failed to obfuscate with current primers. Choose different ones.\n" );
          return -1;
        }
        [output appendFormat:@"%d,", obfuscated];
        currentPrimer += primerCharIncrement;
      }

      [output appendString:@"0, \\\n"];
      currentLinePrimer += primerLineIncrement;
      obfuscatedStringsCounter++;
      fprintf( stdout, " - obfuscated \"%s\"\n", [currentLine UTF8String] );
    }

    [plainStrings appendString:@"// Terminator\n"];
    [output appendString:@"  0 }\n"];

    [output appendString:@"\n"];
    [output appendString:@"//\n"];
    [output appendString:@"// Plain strings\n"];
    [output appendString:@"//\n"];
    [output appendString:plainStrings];
    [output appendString:@"\n"];

    [output appendFormat:@"#endif // defined(__%@)\n", ifMacroFileName];

    error = nil;
    if ( ![output writeToFile:outputFileName
                   atomically:YES
                     encoding:NSUTF8StringEncoding
                        error:&error] ) {
      fprintf( stderr, "Failed to write output file\n" );
      return -1;
    }

    fprintf( stdout, "Total %d string(s) obfuscated\n", obfuscatedStringsCounter );
  }
  return 0;
}
