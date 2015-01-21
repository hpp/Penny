//
//  PennyAudioManager.m
//  Penny
//
//  Created by Izzy Water on 1/19/15.
//  Copyright (c) 2015 Harmonic Processes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PennyAudioManager.h"

#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>

@interface PennyAudioManager ()
// define private properties

// define private methods
@end






void audioQueueCB(void* currentState, AudioQueueRef queue, AudioQueueBufferRef buffer) {
    AQPlayerState cs = *(AQPlayerState *)currentState;
    //AudioQueueParameterValue *outValue;
    //AudioQueueGetParameter (queue, kAudioQueueParam_Volume, outValue);
    
    /*
    int i;
    SInt16 *data = (SInt16*)buffer->mAudioData;
    for (i = 0; i < cs.bufferByteSize/2; i++){
        srand(time(NULL));
        int randomInt = rand();
        short randomShort = (short)(randomInt % (2<<15));
        Byte randomNumber =(Byte) (randomShort & 0x00ff);
        data[2*i] = randomNumber;
        randomNumber =(Byte) ((randomShort & 0xff00) >> 8);
        data[2*i+1] = randomNumber;

    }
    */
    
    memcpy(buffer->mAudioData,cs.mBufferList[cs.qIdx].mBuffers[0].mData, cs.bufferByteSize);
    buffer->mAudioDataByteSize = cs.bufferByteSize;
    OSStatus status = AudioQueueEnqueueBuffer(queue, buffer, 0, NULL);
    if (status != 0){
        NSLog( @"Penny Audio Manager Queue CallBack Status %d", (int)status);
    }
    cs.mBufferList[cs.qIdx].mBuffers[0].mData = NULL;
    
    // reset read from buffer index
    if (++cs.qIdx>=2*kNumberBuffers) cs.qIdx = 0;
}


@implementation PennyAudioManager {
    // define private instance variables
    BOOL primed;
    dispatch_queue_t audioPlayQueue;
    
}

- (instancetype)init {
    self.initialized = false;
    self->primed = false;
    _state.mIsRunning = false;
    _state.qIdx = 0;
    _state.listIdx = 0;
    return self;
}

// implement methods
- (void)setUp:(CMFormatDescriptionRef)desc cmBufferRef:(CMSampleBufferRef)buffer {
    _state.mDataFormat = *CMAudioFormatDescriptionGetStreamBasicDescription(desc);
    
    
    //audioPlayQueue = dispatch_queue_create( "io.hpp.penny.audioManager.playCB", DISPATCH_QUEUE_SERIAL );
    
    
    OSStatus status;
    status = AudioQueueNewOutput(&_state.mDataFormat, audioQueueCB, &_state,
                                     NULL, NULL, 0, &_state.mQueue);
    checkStatus(status);
        
    _state.bufferByteSize = 2 * CMSampleBufferGetNumSamples(buffer); //two bytes per sample
    for (int i = 0; i < kNumberBuffers; ++i) {
        status = AudioQueueAllocateBuffer(_state.mQueue, _state.bufferByteSize, &_state.mBuffers[i]);
        checkStatus(status);
    }
        
    [self postAudio:buffer];
        
    self.initialized=true;
        

    
}

- (void)tearDown{
    checkStatus(AudioQueueStop(_state.mQueue, false)); //async, let flush finish
    AQPlayerState reset;
    _state = reset;
    [self init];
}

- (void)postAudio:(CMSampleBufferRef)buffer{
    
    checkStatus(CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(buffer , NULL,  &_state.mBufferList[_state.listIdx], sizeof(_state.mBufferList[_state.listIdx]), NULL, NULL, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment,
        &_state.mBlockBuffer ));

    
    if (!self->primed){
        if (_state.listIdx>=2){
            [self primeQueueNStart];
        }
    }
    
    // circular buffer...
    if (++_state.listIdx>=2*kNumberBuffers) _state.listIdx = 0;
}



- (void)primeQueueNStart{
        self->primed=true;
    
    for (int i = 0; i < kNumberBuffers; i++){
        audioQueueCB(&_state, _state.mQueue, _state.mBuffers[i]);
    }
    
    checkStatus(AudioQueuePrime(_state.mQueue, 0, NULL));
    
    checkStatus(AudioQueueStart(_state.mQueue, NULL));
    
    _state.mIsRunning = true;
}


#pragma mark Status Functions

void checkStatus(OSStatus status) {
    if (status != 0){
        NSLog( @"Penny Audio Manager Status %d", (int)status);
    }
}

@end
