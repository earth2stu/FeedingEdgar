//
//  FEViewController.m
//  FeedingEdgar
//
//  Created by Stuart Watkins on 11/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "FEViewController.h"
#import "FEVideoProcessingViewController.h"

#import "FEAppDelegate.h"

#define TIME_SCALE 600

@interface FEViewController() {
@private
    
}
- (void)backToMenu;
- (void)setupImageArrays;
- (void)done;
- (void) processVideo:(NSURL*)inputURL toFile:(NSURL*)outputURL;
- (void)addWaitingView;
- (void)setupAssetWriterInput;

@end

@implementation FEViewController
@synthesize recordLight;

@synthesize isGuy;

@synthesize assetWriter2, assetWriterVideoInput2, reader2, readerVideoTrackOutput2;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Find a camera with the specificed AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

// Find a front facing camera, returning nil if one is not found
- (AVCaptureDevice *) frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

// Find a back facing camera, returning nil if one is not found
- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    //AVURLAsset *preFile = [[AVURLAsset alloc] initWithURL:nil options:nil];
    
    [self setupImageArrays];
    
    
    // SETUP CAPTURESESSION
    
    
    captureSession = [[AVCaptureSession alloc] init];
    //captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    
     
    
    
    
    
    // SET UP CAMERA AS CAPTUREDEVICE
    
    AVCaptureDevice *captureDevice = [self backFacingCamera];
    
    is1280OK = [captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset1280x720];
    
    if (is1280OK) {
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    } else {
        captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    NSError *error = nil;
//    BOOL didLock = [captureDevice lockForConfiguration:&error];
    
//    if (didLock) {
//        [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
//    }
    
    
    // SETUP CAPTUREDEVICEINPUT WITH CAPTUREDEVICE AS THE INPUT DEVICE
    
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:nil];
    [captureSession addInput:deviceInput];
    
    
    
    
    
    // SETUP VIDEODATA AS THE OUTPUT
    // AND SET IT'S CALLBACK ROUTINE ON A DISPATCH QUEUE (BACKGROUND THREAD)
    // THE CALLBACK ROUTINE WILL WRITE TO THE ASSET WRITER BELOW
    
    // try frame by frame processing ..
    videoData = [[AVCaptureVideoDataOutput alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    [videoData setSampleBufferDelegate:self queue:queue];
    
    NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
    
    //[outputSettings setObject: [NSNumber numberWithInt:kCMVideoCodecType_JPEG] forKey:(NSString*)
    // kCVPixelBufferPixelFormatTypeKey];
    [outputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(NSString*)
     kCVPixelBufferPixelFormatTypeKey];

    videoData.alwaysDiscardsLateVideoFrames = NO;
    //videoData.
    //videoData.minFrameDuration = CMTimeMake(1, 15);
    
    [videoData setVideoSettings:outputSettings];
    
    
    // SET THE CAPTURESESSION TO OUTPUT TO THE VIDEODATA
    
    
//    [captureSession addOutput:videoData];
    
//    for (AVCaptureConnection *connection in videoData.connections) {
//        connection.videoMinFrameDuration = CMTimeMake(1, 15);
//    }
    
    dispatch_release(queue);
    
    
    // SETUP THE PREVIEWLAYER TO DISPLAY THE CAPTURESESSION
    
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession]; 
    //previewLayer.frame = self.view.layer.bounds; 
    
    
    previewLayer.frame = CGRectMake(40, 50, 400, 225);
    
    
    //previewLayer.frame = CGRectMake(0, 25, 480, 270);
    previewLayer.orientation = AVCaptureVideoOrientationLandscapeLeft;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspect; 
    //previewLayer.opacity = 0.8f;
    //[self.view.layer addSublayer:previewLayer];
    [self.view.layer insertSublayer:previewLayer below:startButton.layer];
    
    // ADD THE RUNNING CHARACTER IMAGEVIEW AFTER THE PREVIEW LAYER SO ITS ON TOP
    
    //imageView.frame = CGRectMake(60, 140, 200, 200);
   // imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    //[self.view addSubview:imageView];
    
    
    // ADD THE START-STOP BUTTON
    
    /*
    startStopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    [startStopButton addTarget:self action:@selector(startStopVideo:) forControlEvents:UIControlEventTouchUpInside];
    [startStopButton setFrame:CGRectMake(0, 0, 80, 44)];
    [self.view addSubview:startStopButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(350, 100, 80, 44)];
    [self.view addSubview:backButton];
    
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testButton setTitle:@"test push" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testPush) forControlEvents:UIControlEventTouchUpInside];
    [testButton setFrame:CGRectMake(350, 200, 80, 44)];
    [self.view addSubview:testButton];
    
    */
    
    [captureSession startRunning];
    
    
    // SET ALL THE SETTINGS TO WRITE THE VIDEO
    
    /*
    NSDictionary *codecSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   //[NSNumber numberWithInt:1600000], AVVideoAverageBitRateKey,
                                   //[NSNumber numberWithInt:12],AVVideoMaxKeyFrameIntervalKey,
                                   //videoCleanApertureSettings, AVVideoCleanApertureKey,
                                   //videoAspectRatioSettings, AVVideoPixelAspectRatioKey,
                                   //AVVideoProfileLevelH264Main30, AVVideoProfileLevelKey,
                                   nil];
    
    

    
    
    //NSString *targetDevice = [[UIDevice currentDevice] model];
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   codecSettings,AVVideoCompressionPropertiesKey,
                                   [NSNumber numberWithInt:1280], AVVideoWidthKey,
                                   [NSNumber numberWithInt:720], AVVideoHeightKey,
                                   nil];
    
    
    
    
    
    /* to prepare for output; I'll output 640x480 in H.264, via an asset writer *
    NSDictionary *assettSettings =
    [NSDictionary dictionaryWithObjectsAndKeys:
     
     [NSNumber numberWithInt:1280], AVVideoWidthKey,
     [NSNumber numberWithInt:720], AVVideoHeightKey,
     AVVideoCodecH264, AVVideoCodecKey,
     
     nil];
    
    // CREATE THE ASSETWRITER WITH THE DEFINED SETTINGS
    
    assetWriterInput = [AVAssetWriterInput 
                        assetWriterInputWithMediaType:AVMediaTypeVideo
                        outputSettings:videoSettings];
    
    
    
    assetWriterInput.expectsMediaDataInRealTime = YES;
    //assetWriterInput.transform = CGAffineTransformMakeRotation(M_PI);
    

    
    // TIE IT ALL TOGETHER - SET THE ASSETWRITERINPUT TO TALK TO THE PIXELBUFFERADAPTOR
    // WHICH IS WRITTEN TO IN THE CALLBACK ROUTINE
    
    /*
    pixelBufferAdaptor =
    [[AVAssetWriterInputPixelBufferAdaptor alloc] 
     initWithAssetWriterInput:assetWriterInput 
     sourcePixelBufferAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], 
      kCVPixelBufferPixelFormatTypeKey,
      nil]];
    *
    
    
    [captureSession startRunning];
    //[captureSession startRunning];
    
    
    */
    
    //NSLog(@"assign input to assetwriter1");
    
    
    
    //myCustomQueue = dispatch_queue_create("com.example.MyCustomQueue", NULL);
    
    //dispatch_retain(myCustomQueue);
    
    //[self startSendingVideo];
    
}

- (IBAction)jump:(id)sender {
    
}

- (IBAction)backToMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setupImageArrays {
    
    
    FEAppDelegate *app = (FEAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (isGuy) {
        runImages = app.boyRun;
        jumpImages = app.boyJump;
    } else {
        runImages = app.girlRun;
        jumpImages = app.girlJump;
    }
    
    /*
    imageView = [[UIImageView alloc] init];
    
    girlImages = [[NSMutableArray alloc] init];
    girlImagesUIImage = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i <= 25; i++) {
        NSString *fileName = [NSString stringWithFormat:@"Girl Run Cycle_%05i.png", i];
        //UIImage *girlrun1 = [UIImage imageNamed:fileName];
        
        //[girlImagesUIImage addObject:[UIImage imageNamed:fileName]];
        
        //CGImageRef girlrun1 = [UIImage imageNamed:fileName].CGImage;
        //NSValue *cgImageValue = [NSValue valueWithBytes:&girlrun1 objCType:@encode(CGImageRef)];
        //[girlImages addObject:cgImageValue];
        
        [girlImages addObject:(id)[[UIImage imageNamed:fileName] CGImage]];
    }
    
    */
    
    /*
    
    UIImage *man1 = [UIImage imageNamed:@"Girl Run Cycle_00000.png"];
    UIImage *man2 = [UIImage imageNamed:@"man2.png"];
    UIImage *man3 = [UIImage imageNamed:@"man3.png"];
    UIImage *man4 = [UIImage imageNamed:@"man4.png"];
    UIImage *man5 = [UIImage imageNamed:@"man5.png"];
    UIImage *man6 = [UIImage imageNamed:@"man6.png"];
    UIImage *man7 = [UIImage imageNamed:@"man7.png"];
    UIImage *man8 = [UIImage imageNamed:@"man8.png"];
    UIImage *man9 = [UIImage imageNamed:@"man9.png"];
    UIImage *man10 = [UIImage imageNamed:@"man10.png"];
    UIImage *man11 = [UIImage imageNamed:@"man11.png"];
    UIImage *man12 = [UIImage imageNamed:@"man12.png"];
    
    manAnimatedImages = [[NSArray alloc] initWithObjects:man1, man2, man3, man4, man5, man6, man7, man8, man9, man10, man11, man12, nil];
    
     */
    
    //imageView.animationImages = girlImagesUIImage;
    //imageView.animationRepeatCount = 0;
    //imageView.animationDuration = 1;
    //[imageView startAnimating];
    
    /*
     * 16 x 9 at 480 wide = 270 high
     * 25 from the top + 270 + 25 at the bottom = 320
     * 420 out of 720 = 58.333%
     * 58.333% of 270 = 158 (height) (148 width)
     * half of which is 79
     * 160 - 79 = 81 (y val)
     * 240 - 74 (half of 148) = 166
     */
    
    /*
     * 16 x 9 at 400 wide = 225 high
     * 50 from the top + 225 + 45 at the bottom = 320
     * 420 out of 720 = 58.333%
     * 58.333% of 225 = 131 (height) (122 width)
     * half of which is 65
     * middle of vid is 162 - 65 = 97 (y val)
     * 240 - 61 (half of 122) = 179
     */
    
    
    
    
    animLayer = [CALayer layer];
    // animLayer.frame = CGRectMake(173, 93, 135 , 135); // for 360
    //animLayer.frame = CGRectMake(166, 81, 148, 158);
    animLayer.frame = CGRectMake(179, 97, 122, 131);
    
    [self.view.layer addSublayer:animLayer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath: @"contents"];
    animation.calculationMode = kCAAnimationDiscrete;
    animation.duration = 1.0;
    animation.repeatCount = INFINITY;
    //animation.values = girlImages; // NSArray of CGImageRefs
    animation.values = runImages;
    animation.delegate = self;
    [animLayer addAnimation:animation forKey:@"contents"];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //CAKeyframeAnimation *kf = (CAKeyframeAnimation*)anim;
    //kf.repeatCount = 1;
    //animLayer.speed = 0.0;
    NSLog(@"ANIM STOPPED");
}

- (void)deleteAllFiles {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDirectoryEnumerator* en = [fm enumeratorAtPath:path];    
    NSError* err = nil;
    BOOL res;
    
    NSString* file;
    while (file = [en nextObject]) {
        res = [fm removeItemAtPath:[path stringByAppendingPathComponent:file] error:&err];
        if (!res && err) {
            NSLog(@"oops: %@", err);
        }
    }
}

- (IBAction)startStopVideo:(id)sender {
    
    if (!assetWriter) {
        [self startSendingVideo:nil];
    } else {
        [self stopVideo:nil];
    }
    
    
}

- (void)setupAssetWriterInput {
    NSDictionary *codecSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   //[NSNumber numberWithInt:1600000], AVVideoAverageBitRateKey,
                                   //[NSNumber numberWithInt:12],AVVideoMaxKeyFrameIntervalKey,
                                   //videoCleanApertureSettings, AVVideoCleanApertureKey,
                                   //videoAspectRatioSettings, AVVideoPixelAspectRatioKey,
                                   //AVVideoProfileLevelH264Main30, AVVideoProfileLevelKey,
                                   nil];
    
    
    
    
    
    //NSString *targetDevice = [[UIDevice currentDevice] model];
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   codecSettings,AVVideoCompressionPropertiesKey,
                                   [NSNumber numberWithInt:1280], AVVideoWidthKey,
                                   [NSNumber numberWithInt:720], AVVideoHeightKey,
                                   nil];
    
    
    
    
    
    /* to prepare for output; I'll output 640x480 in H.264, via an asset writer */
     NSDictionary *assettSettings =
     [NSDictionary dictionaryWithObjectsAndKeys:
     
     [NSNumber numberWithInt:1280], AVVideoWidthKey,
     [NSNumber numberWithInt:720], AVVideoHeightKey,
     AVVideoCodecH264, AVVideoCodecKey,
     
     nil];
     
     // CREATE THE ASSETWRITER WITH THE DEFINED SETTINGS
     
     assetWriterInput = [AVAssetWriterInput 
     assetWriterInputWithMediaType:AVMediaTypeVideo
     outputSettings:videoSettings];
     
     
     
     assetWriterInput.expectsMediaDataInRealTime = YES;
}

-(IBAction)startSendingVideo:(id)sender {
    
    frameNumber = 0;
    
//    [jumpButton setHidden:NO];
    [menuButton setHidden:YES];
    [startButton setHidden:YES];
    [stopButton setHidden:NO];
    [recordLight setHidden:NO];
    
    [captureSession addOutput:videoData];
    
    [self setupAssetWriterInput];
    
    pixelBufferAdaptor =
    [[AVAssetWriterInputPixelBufferAdaptor alloc] 
     initWithAssetWriterInput:assetWriterInput 
     sourcePixelBufferAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], 
      kCVPixelBufferPixelFormatTypeKey,
      nil]];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* foofile = [documentsPath stringByAppendingPathComponent:@"part1_0.mov"];
    
    currentVideo = [[Video alloc] init];
    
    NSURL *fileOut = [NSURL fileURLWithPath:foofile];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:foofile error:&error];
    
    
    assetWriter = [[AVAssetWriter alloc]
                   initWithURL:fileOut
                   fileType:AVFileTypeQuickTimeMovie
                   error:nil];
    [assetWriter addInput:assetWriterInput];
    
    //[self deleteAllFiles];
    
    [assetWriter startWriting];
    //[assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    firstFrameWallClockTime = CACurrentMediaTime();
    [assetWriter startSessionAtSourceTime: CMTimeMake(0, TIME_SCALE)];
    
    //[captureSession startRunning];
    
}

- (void)testPush {
    FEVideoProcessingViewController *pvc = (FEVideoProcessingViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Processing"];
    
    
    UINavigationController *navController = self.navigationController;
    
    //[navController popViewControllerAnimated:NO];
    [navController pushViewController:pvc animated:YES];
}


- (void)addWaitingView{
    
    [jumpButton setHidden:YES];
    [menuButton setHidden:YES];
    [stopButton setHidden:YES];
    [startButton setHidden:YES];
    [recordLight setHidden:YES];
    
    [animLayer removeFromSuperlayer];
    
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    [coverView setBackgroundColor:[UIColor clearColor]];
    
    //UIView *spiralView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    UIImageView *spiralImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spiral.png"]];
    
    [spiralImage setFrame:CGRectMake(184, 104, 113, 113)];
    
    //[spiralView setBackgroundColor:[UIColor whiteColor]];
    
    
    CABasicAnimation* spinAnimation = [CABasicAnimation
                                       animationWithKeyPath:@"transform.rotation"];
    spinAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    spinAnimation.toValue = [NSNumber numberWithFloat:5*2*M_PI];
    spinAnimation.duration = 20.0;
    [spiralImage.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
    
    [coverView addSubview:spiralImage];
    
    
    [self.view addSubview:coverView];
    
}

- (void)removeWaitingView{
    [menuButton setHidden:NO];
    [startButton setHidden:NO];
    
    [coverView removeFromSuperview];
    [self.view.layer addSublayer:animLayer];
}

- (IBAction)stopVideo:(id)sender {
    
    
    
    
    [self performSelectorOnMainThread:@selector(addWaitingView) withObject:nil waitUntilDone:NO];
    
    
    NSLog(@"doing stop video");
    //[captureSession stopRunning];
    
    //[captureSession addOutput:videoData];
    
    [captureSession removeOutput:videoData];
    
    [assetWriter finishWriting];
    
    assetWriterInput = nil;
    
    assetWriter = nil;
    
    
    pixelBufferAdaptor = nil;
    
    
    
    // PROCESS FILE
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* inFile = [documentsPath stringByAppendingPathComponent:@"part1_0.mov"];
    NSURL *fileIn = [NSURL fileURLWithPath:inFile];
    
    //uid = [self uuid];
    
    NSString *uniqueOut = [NSString stringWithFormat:@"%@.mov", currentVideo.guid];
    NSString* outFile = [documentsPath stringByAppendingPathComponent:uniqueOut];
    NSURL *fileOut = [NSURL fileURLWithPath:outFile];
    
    /*
    pfVideo = [PFObject objectWithClassName:@"Video"];
    [pfVideo setObject:[PFUser currentUser] forKey:@"user"];
    [pfVideo setValue:currentVideo.guid forKey:@"guid"];
    //[vid setValue:currentVideo.title forKey:@"title"];
    //[vid setValue:currentVideo.timestamp forKey:@"timestamp"];
    [pfVideo saveEventually];
    */
    
    FEAppDelegate *app = (FEAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.videos addObject:currentVideo];
    [app saveDataToDisk];
    
    
    
    
    [self processVideo:fileIn toFile:fileOut];
    
    
    
    /*
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    
    NSString* foofile = [documentsPath stringByAppendingPathComponent:@"part1_0.mov"];
    
    [self downloadVideo:foofile];
    
    FEVideoProcessingViewController *pvc = (FEVideoProcessingViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Processing"];
    
    
    UINavigationController *navController = self.navigationController;
    
    
    //[navController popViewControllerAnimated:NO];
    [navController pushViewController:pvc animated:NO];
    
    
//    [self.navigationController pushViewController:pvc animated:NO];
    //[self presentModalViewController:pvc animated:NO];
    
    //NSURL *fileOut = [NSURL fileURLWithPath:foofile];
    */
    
}

-(void)downloadVideo:(NSString *)sampleMoviePath{
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(sampleMoviePath)){
        UISaveVideoAtPathToSavedPhotosAlbum(sampleMoviePath, self, @selector(video:didFinishSavingWithError: contextInfo:), nil);
    }
}

-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"Finished with error: %@", error);
}

- (void)        captureOutput:(AVCaptureOutput *)captureOutput 
        didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
               fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    //CMTime presentationTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    // a very dense way to keep track of the time at which this frame
    // occurs relative to the output stream, but it's just an example!
    //CMTime presentationTime = CMTimeMake(frameNumber, 15);
    
    
    
    
    
    // calculate the time
    CFAbsoluteTime thisFrameWallClockTime = CACurrentMediaTime();
    CFTimeInterval elapsedTime = thisFrameWallClockTime - firstFrameWallClockTime;
    CMTime presentationTime =  CMTimeMake (elapsedTime * TIME_SCALE, TIME_SCALE);
    
    
    
    
//    UIImage *img = [UIImage imageWithCGImage:[self imageFromSampleBuffer:sampleBuffer]];
    /*
    frameNumber++;
    
    int animFrame = (frameNumber % 25);


    CGImageRef imageRef = [self imageFromSampleBuffer:sampleBuffer];
    
    CGImageRef newImageRef = [self addText:imageRef frameNum:animFrame];
    
    CVPixelBufferRef videoRef = (CVPixelBufferRef)[self pixelBufferFromCGImage:newImageRef size:CGSizeMake(640, 480)];

    
*/
    
    //CVImageBufferRef imageBuffer2 = CMSampleBufferGetImageBuffer(videoRef);
    
    
        
    
    
    //NSLog(@"writer 1 status=%i, writier 2 status=%i", [assetWriter1 status], [assetWriter2 status]);
    //NSLog(@"writer 1 inputs=%i, writier 2 inputs=%i", [[assetWriter1 inputs] count], [[assetWriter2 inputs] count] );
    //NSLog(@"inputWriter=%@", assetWriterInput);
    
    
        if(assetWriterInput.readyForMoreMediaData) {
            //NSLog(@"PIXELBUFFER1 at frame:%lld the presentation time is%f", frameNumber, elapsedTime);
            
            
            
            [pixelBufferAdaptor appendPixelBuffer:imageBuffer
                              withPresentationTime:presentationTime];
            //withPresentationTime:CMTimeMake(frameNumber, 15)];
            
        } else {
            NSLog(@"losing frames");
        }
    /*
    CGImageRelease(imageRef);
    CGImageRelease(newImageRef);
    CVBufferRelease(videoRef);
    
    */
    
    if (elapsedTime >= 10.0f) {
        //[self stopVideo];
        [self stopVideo:nil];
        //[self performSelectorOnMainThread:@selector(stopVideo) withObject:nil waitUntilDone:NO];
        
    }
    
}


- (CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer // Create a CGImageRef from sample buffer data
{
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
    CVPixelBufferLockBaseAddress(imageBuffer,0);        // Lock the image buffer 
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image 
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    size_t width = CVPixelBufferGetWidth(imageBuffer); 
    size_t height = CVPixelBufferGetHeight(imageBuffer); 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst); 
    CGImageRef newImage = CGBitmapContextCreateImage(newContext); 
    CGContextRelease(newContext); 
    
    CGColorSpaceRelease(colorSpace); 
    CVPixelBufferUnlockBaseAddress(imageBuffer,0); 
    /* CVBufferRelease(imageBuffer); */  // do not call this!
    
    return newImage;
}


- (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey, 
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    // CVReturn status = CVPixelBufferPoolCreatePixelBuffer(NULL, adaptor.pixelBufferPool, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL); 
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}





-(CGImageRef)addText:(CGImageRef)img frameNum:(int)frameNum{
    
    int w = 640;
    
    int h = 480; 
    
    //lon = h - lon;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img);
    
    //UIImage *overlay = [girlImages objectAtIndex:frameNum];
    
    CGImageRef overlayRef;
    [[girlImages objectAtIndex:frameNum] getValue:&overlayRef ];

    
    //UIImage *overlay = [UIImage imageNamed:@"C-W.png"];
//    CGImageRef overlayRef = overlay.CGImage;
    
//    CGContextDrawImage(context, CGRectMake(220, 140, 150, 150), overlayRef);
    
    /*
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
    
    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
    
    CGContextSelectFont(context, "Arial", 18, kCGEncodingMacRoman);
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
    
    
    
    //rotate text
    
    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
    
    CGContextShowTextAtPoint(context, 4, 52, text, strlen(text));
    
     
     */
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    return imageMasked;
    
    //return [UIImage imageWithCGImage:imageMasked];
    
}



- (void)viewDidUnload
{
    [self setRecordLight:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //FEAppDelegate *app = (FEAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[app.track play];
    //app.track.volume = 1.0f;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}






#pragma mark Video Processing

- (void) processVideo:(NSURL*)inputURL toFile:(NSURL*)outputURL {
    
    
    NSError __autoreleasing *error = nil;
    
    // AVURLAsset to read input movie (i.e. mov recorded to local storage)
    NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *inputAsset = [[AVURLAsset alloc] initWithURL:inputURL options:inputOptions];
    
    // Load the input asset tracks information
    [inputAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler: ^{
        
        // Check status of "tracks", make sure they were loaded    
        AVKeyValueStatus tracksStatus = [inputAsset statusOfValueForKey:@"tracks" error:&error];
        if (!tracksStatus == AVKeyValueStatusLoaded)
            // failed to load
            return;
        
        // Fetch length of input video; might be handy
        NSTimeInterval videoDuration = CMTimeGetSeconds([inputAsset duration]);
        // Fetch dimensions of input video
        CGSize videoSize = [inputAsset naturalSize];
        
        
        /* Prepare output asset writer */
        self.assetWriter2 = [[AVAssetWriter alloc] initWithURL:outputURL fileType:AVFileTypeQuickTimeMovie error:&error];
        NSParameterAssert(assetWriter2);
        assetWriter2.shouldOptimizeForNetworkUse = NO;
        
        
        // Video output
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                       AVVideoCodecH264, AVVideoCodecKey,
                                       [NSNumber numberWithInt:videoSize.width], AVVideoWidthKey,
                                       [NSNumber numberWithInt:videoSize.height], AVVideoHeightKey,
                                       nil];
        self.assetWriterVideoInput2 = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                        outputSettings:videoSettings];
        
        self.assetWriterVideoInput2.transform = CGAffineTransformMakeRotation(M_PI);
        
        
        NSParameterAssert(assetWriterVideoInput2);
        NSParameterAssert([assetWriter2 canAddInput:assetWriterVideoInput2]);
        [assetWriter2 addInput:assetWriterVideoInput2];
        
        
        // Start writing
        CMTime presentationTime = kCMTimeZero;
        
        [assetWriter2 startWriting];
        [assetWriter2 startSessionAtSourceTime:presentationTime];
        
        
        /* Read video samples from input asset video track */
        self.reader2 = [AVAssetReader assetReaderWithAsset:inputAsset error:&error];
        
        NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
        [outputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
        self.readerVideoTrackOutput2 = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:[[inputAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                                                 outputSettings:outputSettings];
        
        
        // Assign the tracks to the reader and start to read
        [reader2 addOutput:readerVideoTrackOutput2];
        if ([reader2 startReading] == NO) {
            // Handle error
        }
        
        
        
        dispatch_queue_t dispatch_queue = dispatch_get_main_queue();
        
        [assetWriterVideoInput2 requestMediaDataWhenReadyOnQueue:dispatch_queue usingBlock:^{
            CMTime presentationTime = kCMTimeZero;
            
            while ([assetWriterVideoInput2 isReadyForMoreMediaData]) {
                CMSampleBufferRef sample = [readerVideoTrackOutput2 copyNextSampleBuffer];
                
                if (sample) {
                    presentationTime = CMSampleBufferGetPresentationTimeStamp(sample);
                    
                    //NSLog(@"%@", presentationTime.value);
                    
                    
                    /* Composite over video frame */
                    
                    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sample); 
                    
                    // Lock the image buffer
                    CVPixelBufferLockBaseAddress(imageBuffer,0); 
                    
                    // Get information about the image
                    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer); 
                    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
                    size_t width = CVPixelBufferGetWidth(imageBuffer); 
                    size_t height = CVPixelBufferGetHeight(imageBuffer); 
                    
                    // Create a CGImageRef from the CVImageBufferRef
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
                    //CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
                    
                    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, 4 * width, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
                    
                    
                    //CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
                    
                    
                    /*** Draw into context ref to draw over video frame ***/
                    
                    frameNumber++;
                    
                    int animFrame = (frameNumber % 25);
                    
                    NSLog(@"frame num = %i", animFrame);
                    
                    int framePart = ((presentationTime.value % presentationTime.timescale) / (presentationTime.timescale / 25));
                    
                    NSLog(@"framepart = %i", framePart);
                    
                    
                    
                    //NSObject *o = [runImages objectAtIndex:animFrame];
                    
                    
                    
                    CGImageRef overlayRef = (__bridge CGImageRef)[runImages objectAtIndex:framePart];
                    
                                        
                    //[[runImages objectAtIndex:animFrame] getValue:&overlayRef ];
                    
                    
                    //UIImage *overlay = [UIImage imageNamed:@"C-W.png"];
                    //    CGImageRef overlayRef = overlay.CGImage;
                    
                    //CGContextScaleCTM(newContext, 1.0, -1.0);
                    //CGContextTranslateCTM(newContext, 0, 720);
                    
                    CGContextRotateCTM(newContext, M_PI);
                    
                    /*
                     * height is 720 - 420 = 300 .. 150 from the top
                     * width is 1280 - 392 = 888 ... 444 from the left
                     */
                    
                    CGContextDrawImage(newContext, CGRectMake(-392 -444,-420 -150, 392, 420), overlayRef);
                    //CGContextDrawImage(newContext, CGRectMake(-360 -460,-360 -180, 360, 360), overlayRef);
                    //CGContextDrawImage(newContext, CGRectMake(460, -180, 360, 360), overlayRef);
                    //CGContextDrawImage(newContext, CGRectMake(-460, 180, 360, 360), overlayRef);
                    //CGContextDrawImage(newContext, CGRectMake(460, 180, 360, 360), overlayRef);
                    
                    //CGImageAlphaInfo info = CGImageGetAlphaInfo(overlayRef);
                    
                    //CGContextRotateCTM(newContext, M_PI);
                    
                    if (frameNumber == 50.0) {
                        NSLog(@"writing the image !!!!!!!!!!!!!!!!!");
                        //currentVideo.thumbnail = [UIImage imageWithCGImage:overlayRef];
                        CGImageRef imgRef = CGBitmapContextCreateImage(newContext);
                        UIImage *fullSize = [UIImage imageWithCGImage:imgRef];
                        UIGraphicsBeginImageContextWithOptions(CGSizeMake(128, 72), NO, 0.0);
                        [fullSize drawInRect:CGRectMake(0, 0, 128, 72)];
                        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();  
                        UIImage *rotatedImage = [newImage imageRotatedByDegrees:180];
                        UIGraphicsEndImageContext();
                        
                        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                        NSString *uniqueOut = [NSString stringWithFormat:@"%@.png", currentVideo.guid];
                        NSString* outFile = [documentsPath stringByAppendingPathComponent:uniqueOut];
                        
                        NSData *imageData = UIImagePNGRepresentation(rotatedImage);
                        [imageData writeToFile:outFile atomically:YES];
                        
                        
                        currentVideo.thumbnail = rotatedImage;
                    }

                    
                    // We unlock the  image buffer
                    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
                    
                    // We release some components
                    CGContextRelease(newContext); 
                    CGColorSpaceRelease(colorSpace);
                    
                    /* End composite */
                    
                    [assetWriterVideoInput2 appendSampleBuffer:sample];
                    CFRelease(sample);
                    
                }
                else {
                    [assetWriterVideoInput2 markAsFinished];
                    
                    /* Close output */
                    
                    [assetWriter2 endSessionAtSourceTime:presentationTime];
                    if (![assetWriter2 finishWriting]) {
                        NSLog(@"[assetWriter finishWriting] failed, status=%@ error=%@", assetWriter2.status, assetWriter2.error);
                    }
                    [self done];
                    //[self performSelectorOnMainThread:@selector(done) withObject:nil waitUntilDone:NO];
                    
                }
                
            }
        }];
        
    }];
    
    
    
}

- (void)done {
    
    //[pfVideo setObject:UIImagePNGRepresentation(currentVideo.thumbnail)  forKey:@"thumbnail"];
    //[pfVideo saveEventually];
    
    [self performSelectorOnMainThread:@selector(removeWaitingView) withObject:nil waitUntilDone:YES];
}


@end
