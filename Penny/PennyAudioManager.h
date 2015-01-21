//
//  PennyAudioManager.h
//  Penny
//
//  Created by Izzy Water on 1/19/15.
//  Copyright (c) 2015 Harmonic Processes. All rights reserved.
//

#ifndef Penny_PennyAudioManager_h
#define Penny_PennyAudioManager_h


#endif
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>

static const int kNumberBuffers = 3;
typedef struct {
    AudioStreamBasicDescription   mDataFormat;
    AudioQueueRef                 mQueue;
    AudioQueueBufferRef           mBuffers[kNumberBuffers];
    AudioBufferList               mBufferList[kNumberBuffers*2];
    CMBlockBufferRef              mBlockBuffer;
    UInt32                        bufferByteSize;
    //SInt64                        mCurrentPacket;
    //UInt32                        mNumPacketsToRead;
    //AudioStreamPacketDescription  *mPacketDescs;
    int                           listIdx;
    int                           qIdx;
    bool                          mIsRunning;
}AQPlayerState;


@interface PennyAudioManager : NSObject 
// define public properties
@property BOOL initialized;
@property AQPlayerState state;

// define public methods
- (void)setUp:(CMFormatDescriptionRef)desc cmBufferRef:(CMSampleBufferRef)buffer;
- (void)postAudio:(CMSampleBufferRef)buffer;
- (void)tearDown;

@end
