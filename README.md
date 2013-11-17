qlvorbis
========

A QuickLook plugin for ogg vorbis files.

###Build Instructions
In order to build this project, you will need to do the following:

1. Download and build the libogg and libvorbis from [xiph.org](http://xiph.org/downloads/)
	- **MAKE SURE** the Xcode **Install Path** build setting is set to **@rpath** 
2. Open the **qlvorbis** Xcode project
	- add the libogg.framework and libvorbis.framework files to the project
	- add both frameworks to the **Copy files to Frameworks** build phase.
3. Copy the resulting **qlvorbis.qlgenerator** file to **~/Library/Frameworks**

###Credits
This project drew heavily from the following:

[Dave Dribin](http://www.dribin.org/dave/blog/archives/2009/11/15/rpath/) and [Mike Ash's](http://www.mikeash.com/pyblog/friday-qa-2009-11-06-linking-and-install-names.html) blog articles on OS X framework linking.

[Bluish Coder](http://bluishcoder.co.nz/tags/ogg/) and [IOSDevZone's](https://github.com/iosdevzone/IDZAQAudioPlayer) blog articles and source code examples for working with libogg and libvorbis.

The Apple [QuickLook Programming](https://developer.apple.com/library/mac/documentation/userexperience/conceptual/quicklook_programming_guide/Introduction/Introduction.html) and [Audio Queue Services Programming](https://developer.apple.com/library/mac/documentation/MusicAudio/Conceptual/AudioQueueProgrammingGuide/Introduction/Introduction.html) guides.

For testing, this project includes Rondo_Alla_Turka.ogg from the Wikipedia [article](http://en.wikipedia.org/wiki/File:Rondo_Alla_Turka.ogg) on Vorbis. This file is from [WikiMedia Commons](http://commons.wikimedia.org/wiki/Main_Page), a freely licensed media repository.

###License
In keeping with the open source nature of Ogg/Vorbis, this project uses the MIT License for its source code.

	The MIT License (MIT)
	
	Copyright (c) 2013 Everette Clemmer

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
