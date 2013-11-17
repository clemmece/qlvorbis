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

#import "Engine.h"

@implementation Engine

- (id) initWithContentsOfURL:(NSURL*) url
{
    if (self = [super init]) {
        if( (myState.mOggFile = fopen([[url path] UTF8String], "r")) )
        {
            //lots of assumptions for these magic parameters ... probably need to detect/calculate these values at some point
            int err =  (ov_open_callbacks(myState.mOggFile, &(myState.mOVFile), NULL, 0, OV_CALLBACKS_NOCLOSE));
            if(err == 0)
            {
                myState.mInfo = ov_info(&(myState.mOVFile), -1);
                FillOutASBDForLPCM(myState.mDescription, myState.mInfo->rate, myState.mInfo->channels, 16, 16, false, false);
            } else
            {
                NSLog(@"Input %@ doesn't appear to be an OGG bitstream", [url path]);
                return nil;
            }
        } else
        {
            NSLog(@"FOPEN error while opening %@", [url path]);
            return nil;
        }
    }
    return self;
}


-(void) prepareAudioBuffers
{
    OSStatus status = AudioQueueNewOutput(&(myState.mDescription),
                                          outputCallback,
                                          &myState,
                                          CFRunLoopGetCurrent(),
                                          kCFRunLoopCommonModes,
                                          0, //reserved, must be 0 according to docs
                                          &(myState.mAudioQueue));
    
    if(status != noErr)
    {
        NSLog(@"Error AudioQueueNewOutput");
        exit(EXIT_FAILURE);
    }
    
    //assume constant bit rate
    myState.mPacketDescs = NULL;
    
    //320kb, approx 5 seconds of stereo, 24 bit audio @ 96kHz sample rate
    static const int maxBufferSize = 0x50000;
    
    myState.mIsRunning = true;
    
    //allocate queues and pre-fetch some data to prime the audio buffers
    for( int i = 0; i <3; i++)
    {
        status = AudioQueueAllocateBuffer(myState.mAudioQueue,
                                          maxBufferSize,
                                          &(myState.mAudioQueueBuffers[i]));
        if(status != noErr)
        {
            AudioQueueDispose(myState.mAudioQueue, true);
            myState.mAudioQueue = 0;
            NSLog(@"Error allocating audio queue buffer %d\n", i);
            exit(EXIT_FAILURE);
        }
        outputCallback(&myState, myState.mAudioQueue, myState.mAudioQueueBuffers[i]);
    }
}

-(void)playAudio
{
    //set gain and start queue
    AudioQueueSetParameter(myState.mAudioQueue, kAudioQueueParam_Volume, 1.0);
    AudioQueueStart(myState.mAudioQueue, NULL);

    //maintain run loop
    do {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.25, false);
    } while (myState.mIsRunning);
    
    //run a bit longer to fully flush audio buffers
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, false);
}

static void outputCallback(void *                       aqData,
                              AudioQueueRef             inAQ,
                              AudioQueueBufferRef       pcmOut)
{
    if(((EngineState*)aqData)->mIsRunning == 0) return;
    
    long numBytesReadFromFile = 0;
    long totalBytesReadFromFile = 0; //effectively the offset into the file
    
    //deals with the current logical bitstream of the vorbis file
    //currently unused here but probably needs to be supported at some point
    int currentSection = -1;

    
    //read from file into audio queue buffer
    do {
        numBytesReadFromFile = ov_read(&(((EngineState*)aqData)->mOVFile), //OggVorbis_File structure
                                       (char*)pcmOut->mAudioData + totalBytesReadFromFile, //output buffer
                                       pcmOut->mAudioDataBytesCapacity - (int)totalBytesReadFromFile, //number of bytes to read into the buffer
                                       FALSE, //boolean to indicate bigendian-ness
                                       2, //1 = 8bit samples, 2 = 16bit samples; 2 is typical
                                       1,  //0 for unsigned data, 1 for signed; 1 is typical
                                       &currentSection);

        if( numBytesReadFromFile > 0){
            totalBytesReadFromFile += numBytesReadFromFile;
        }
        
    }while(totalBytesReadFromFile <= pcmOut->mAudioDataBytesCapacity && numBytesReadFromFile > 0);

    
    if(numBytesReadFromFile <= 0)
    {
        if(numBytesReadFromFile == OV_EBADLINK)
        {
            NSLog(@"Corrupt Bitstream; exiting");
            exit(EXIT_FAILURE);
        }
        
        //other errors don't matter, but report in case we care
        NSLog(@"OV_READ error %ld; continuing", numBytesReadFromFile);
        
        pcmOut->mAudioDataByteSize = (UInt32)totalBytesReadFromFile;
        pcmOut->mPacketDescriptionCount = 0;
        
        //enqueue an audio buffer after reading from disk
        OSStatus status = AudioQueueEnqueueBuffer(((EngineState*)aqData)->mAudioQueue,
                                                  pcmOut,
                                                  0, 0); //always 0 for our purposes
        
        if (status != noErr) {
            //something has gone horribly wrong, stop now
            AudioQueueStop(((EngineState*)aqData)->mAudioQueue, true);
            ((EngineState*)aqData)->mIsRunning = false;
            NSLog(@"Error %d AudioQueueEnqueueBuffer", status);
            exit(EXIT_FAILURE);
        }
        
        if (numBytesReadFromFile == 0) {
            //we've reached EOF, let buffers drain before stopping
            AudioQueueStop(((EngineState*)aqData)->mAudioQueue, false);
            ((EngineState*)aqData)->mIsRunning = false;
        }
    }
}

- (void) dealloc
{
    ov_clear(&(myState.mOVFile));
    if (myState.mOggFile) {
        fclose(myState.mOggFile);
        myState.mOggFile = NULL;
    }
    
    [super dealloc];
}

@end
