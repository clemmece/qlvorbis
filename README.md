qlvorbis
========

A QuickLook plugin for ogg vorbis files.

###Build Instructions
In order to build this project, you will need to do the following:

1. Download and build the libogg and libvorbis frameworks from [xiph.org](http://xiph.org/downloads/)
	- The qlvorbis project is set up to use dynamic libraries by default so make sure the Xcode **Install Path** build setting is set to **@rpath** for both frameworks.
	- If using Xcode v4.x+ you will have to make some additional changes to the project build settings for each framework in order for them to build.
2. Download and open the **qlvorbis** Xcode project
	- add the libogg.framework and libvorbis.framework files to the project
	- add both frameworks to the **Copy files to Frameworks** build phase.
3. Copy the resulting **qlvorbis.qlgenerator** file to **~/Library/QuickLook**
	- The qlvorbis project has a build phase to do this for you.

***NOTE:*** When running the .qlgenerator form within Xcode, LLDB occasionally reports that the **the bundle qlvorbis couldn't be loaded**. The debugger error is vague and the system console doesn't report anything meaningful (to me). As a result, I don't have a good answer for the cause, but the problem seems to go away if the libogg and libvorbis frameworks are removed from the project, rebuilt, and then re-added. I see this behavior when using both the release and debug versions of the frameworks.  

###Credits
This project drew heavily from the following:

- [Dave Dribin](http://www.dribin.org/dave/blog/archives/2009/11/15/rpath/) and [Mike Ash's](http://www.mikeash.com/pyblog/friday-qa-2009-11-06-linking-and-install-names.html) blog articles on OS X framework linking.

- [Bluish Coder](http://bluishcoder.co.nz/tags/ogg/) and [IOSDevZone's](https://github.com/iosdevzone/IDZAQAudioPlayer) blog articles and source code examples for working with libogg and libvorbis.

- The Apple [QuickLook Programming](https://developer.apple.com/library/mac/documentation/userexperience/conceptual/quicklook_programming_guide/Introduction/Introduction.html) and [Audio Queue Services Programming](https://developer.apple.com/library/mac/documentation/MusicAudio/Conceptual/AudioQueueProgrammingGuide/Introduction/Introduction.html) guides.

For testing, this project includes Rondo_Alla_Turka.ogg from the Wikipedia [article](http://en.wikipedia.org/wiki/File:Rondo_Alla_Turka.ogg) on Vorbis. This file is from [WikiMedia Commons](http://commons.wikimedia.org/wiki/Main_Page), a freely licensed media repository.

###License
This project uses the [MIT License](http://opensource.org/licenses/MIT) for its source code. The libogg and libvorbis frameworks are licensed according to their respective [licenses](http://www.xiph.org/licenses/bsd/) included in each source bundle.