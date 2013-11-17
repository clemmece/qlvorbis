/*
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
*/

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <vorbisfile.h>
#import <Ogg.h>

typedef struct {
    AudioQueueRef                 mAudioQueue;
    AudioQueueBufferRef           mAudioQueueBuffers[3]; // 3 "is typically a good number" according to the Apple docs
    AudioStreamPacketDescription  *mPacketDescs;
    bool                          mIsRunning;
    OggVorbis_File                mOVFile;
    vorbis_info*                  mInfo;
    FILE*                         mOggFile;
    AudioStreamBasicDescription   mDescription;
    long                          mBytesRead;
}EngineState;

@interface Engine : NSObject
{
    EngineState myState;
}

- (id)initWithContentsOfURL:(NSURL*)url;
- (void)prepareAudioBuffers;
- (void)playAudio;

@end
