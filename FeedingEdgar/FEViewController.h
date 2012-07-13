//
//  FEViewController.h
//  FeedingEdgar
//
//  Created by Stuart Watkins on 11/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Video.h"
#import <Parse/Parse.h>
#import "UIImage-Extensions.h"

@interface FEViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate> {

    AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor;
    
    AVAssetWriter *assetWriter;
    AVAssetWriterInput *assetWriterInput;
    AVCaptureSession *captureSession;
    AVCaptureVideoDataOutput *videoData;
    AVQueuePlayer *player;
    int streamPart;
    int64_t frameNumber;
    CFAbsoluteTime firstFrameWallClockTime;
    
    dispatch_queue_t myCustomQueue;
    
    UIImageView *runningMan;

    UIImageView *imageView;
    NSArray *manAnimatedImages;
    
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *stopButton;
    IBOutlet UIButton *menuButton;
    IBOutlet UIButton *jumpButton;
    
    
    UIButton *startStopButton;
    
    NSMutableArray *girlImages;
    NSMutableArray *girlImagesUIImage;
    
    Video *currentVideo;
    
    CALayer *animLayer;
    
    NSArray *runImages;
    NSArray *jumpImages;
    
    UIView *coverView;
    PFObject *pfVideo;
    
    BOOL is1280OK;
    
    
}

@property (assign) BOOL isGuy;


- (CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
- (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size;
-(CGImageRef)addText:(CGImageRef)img frameNum:(int)frameNum;
- (void)deleteAllFiles;
- (IBAction)startStopVideo:(id)sender;
-(void)downloadVideo:(NSString *)sampleMoviePath;
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;


-(IBAction)startSendingVideo:(id)sender;

- (IBAction)stopVideo:(id)sender;

- (IBAction)jump:(id)sender;

- (IBAction)backToMenu:(id)sender;


// Processing stuff
@property (strong, nonatomic) IBOutlet UIImageView *recordLight;

@property (nonatomic, retain) AVAssetWriter *assetWriter2;
@property (nonatomic, retain) AVAssetWriterInput *assetWriterVideoInput2;
@property (nonatomic, retain) AVAssetReader *reader2;
@property (nonatomic, retain) AVAssetReaderTrackOutput *readerVideoTrackOutput2;
@property (nonatomic, retain) Video *currentVideo;


@end
