Automated string obfuscation. Sample written for my iOS security related articles on my [blog](http://robertvojta.pro/).

* `source` - command line utility for obfuscation
* `sample` - sample project with automated obfuscation

**Sample**

How to integrate it in your application.

Create strings file. Simple text file, UTF-8 encoding, one string per line. Check [sample.txt](https://github.com/robertvojta/RVStringObfuscator/blob/master/sample/StringObfuscatorSample/sample.txt). This file is included in project file to have it accessible and editable in Xcode, but it's **not** included in any target.

Create your own obfuscation script or copy [obfuscate-strings.sh](https://github.com/robertvojta/RVStringObfuscator/blob/master/sample/scripts/obfuscate-strings.sh). Run this script manually to generate header file for the first time. Add it to your application. In our sample, generated header file is [SOStrings.h](https://github.com/robertvojta/RVStringObfuscator/blob/master/sample/StringObfuscatorSample/SOStrings.h).

Copy [RVScriptObfuscator.h](https://github.com/robertvojta/RVStringObfuscator/blob/master/source/StringObfuscator/RVStringObfuscator.h) 
to your project and add it to your project as well.

Check sample application [main.m](https://github.com/robertvojta/RVStringObfuscator/blob/master/sample/StringObfuscatorSample/main.m) to see how you can decrypt these strings.

Every time you do update strings file, you must run this script to update generated header file. Or you can do it automatically. Go to Build Phases, add new Run Script phase and run obfuscation script with:

	$SRCROOT/scripts/obfuscate-strings.sh

Do not forget to **move** this Run Script phase **before** Compile Sources phase. Just to be sure that auto generated header file is updated before your application is compiled.

Open [sample application](https://github.com/robertvojta/RVStringObfuscator/tree/master/sample) in Xcode and try it. Edit `sample.txt` file, add some strings, modify them, save it and run sample application. You should see all decrypted strings in console.


