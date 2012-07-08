//
//  FEVideoProcessingViewController.m
//  FeedingEdgar
//
//  Created by Stuart Watkins on 24/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "FEVideoProcessingViewController.h"
#import <Parse/Parse.h>

@interface FEVideoProcessingViewController() {
@private
    
}

- (void) processVideo:(NSURL*)inputURL toFile:(NSURL*)outputURL;
- (void) setupImageArrays;
- (void) done;
- (NSString*) uuid;

@end

@implementation FEVideoProcessingViewController

@synthesize assetWriter;
@synthesize assetWriterVideoInput;
@synthesize reader;
@synthesize readerVideoTrackOutput;
@synthesize currentVideo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //return;
    [self setupImageArrays];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* inFile = [documentsPath stringByAppendingPathComponent:@"part1_0.mov"];
    NSURL *fileIn = [NSURL fileURLWithPath:inFile];
    
    uid = [self uuid];
    
    NSString *uniqueOut = [NSString stringWithFormat:@"%@.mov", currentVideo.guid];
    NSString* outFile = [documentsPath stringByAppendingPathComponent:uniqueOut];
    NSURL *fileOut = [NSURL fileURLWithPath:outFile];
    
    
    [self processVideo:fileIn toFile:fileOut];
    
}

- (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)
                      uuidStringRef];
    CFRelease(uuidStringRef);
    return uuid;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setupImageArrays {
    
    girlImages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= 25; i++) {
        NSString *fileName = [NSString stringWithFormat:@"Girl Run Cycle_%05i.png", i];
        //UIImage *girlrun1 = [UIImage imageNamed:fileName];
        
        //[girlImagesUIImage addObject:[UIImage imageNamed:fileName]];
        
        CGImageRef girlrun1 = [UIImage imageNamed:fileName].CGImage;
        NSValue *cgImageValue = [NSValue valueWithBytes:&girlrun1 objCType:@encode(CGImageRef)];
        [girlImages addObject:cgImageValue];
    }
    
    
    
}

- (void) done {
    /*
    PFObject *video = [[PFObject alloc] initWithClassName:@"Video"];
    [video setValue:uid forKey:@"uid"];
    [video setValue:@"girl" forKey:@"gender"];
    //[video setValue:[NSValue valueWithNonretainedObject:NO] forKey:@"isUploaded"];
    
    [video saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // not quite sure what to do ?!
    }];
    
    if (!self.navigationController) {
        NSLog(@"well that explains it!!");
    }
     */
    
    [self.navigationController popViewControllerAnimated:NO];
    
    //UINavigationController *nav = self.presentingViewController.navigationController;
    
    //[nav popToRootViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:NO];
    
    //[nav popViewControllerAnimated:NO];
    
    //[self.navigationController popViewControllerAnimated:NO];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
}


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
        self.assetWriter = [[AVAssetWriter alloc] initWithURL:outputURL fileType:AVFileTypeQuickTimeMovie error:&error];
        NSParameterAssert(assetWriter);
        assetWriter.shouldOptimizeForNetworkUse = NO;
    
        
        // Video output
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                       AVVideoCodecH264, AVVideoCodecKey,
                                       [NSNumber numberWithInt:videoSize.width], AVVideoWidthKey,
                                       [NSNumber numberWithInt:videoSize.height], AVVideoHeightKey,
                                       nil];
        self.assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                        outputSettings:videoSettings];
        
        self.assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI);
        
        
        NSParameterAssert(assetWriterVideoInput);
        NSParameterAssert([assetWriter canAddInput:assetWriterVideoInput]);
        [assetWriter addInput:assetWriterVideoInput];
        
        
        // Start writing
        CMTime presentationTime = kCMTimeZero;
        
        [assetWriter startWriting];
        [assetWriter startSessionAtSourceTime:presentationTime];
        
        
        /* Read video samples from input asset video track */
        self.reader = [AVAssetReader assetReaderWithAsset:inputAsset error:&error];
        
        NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
        [outputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
        self.readerVideoTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:[[inputAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                                                 outputSettings:outputSettings];
        
        
        // Assign the tracks to the reader and start to read
        [reader addOutput:readerVideoTrackOutput];
        if ([reader startReading] == NO) {
            // Handle error
        }
        
        
        dispatch_queue_t dispatch_queue = dispatch_get_main_queue();
        
        [assetWriterVideoInput requestMediaDataWhenReadyOnQueue:dispatch_queue usingBlock:^{
            CMTime presentationTime = kCMTimeZero;
            
            while ([assetWriterVideoInput isReadyForMoreMediaData]) {
                CMSampleBufferRef sample = [readerVideoTrackOutput copyNextSampleBuffer];
                
                if (sample) {
                    presentationTime = CMSampleBufferGetPresentationTimeStamp(sample);
                    
                    
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
                    
                    CGImageRef overlayRef;
                    [[girlImages objectAtIndex:animFrame] getValue:&overlayRef ];
                    
                    
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
                    
                    
                    
                    // We unlock the  image buffer
                    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
                    
                    // We release some components
                    CGContextRelease(newContext); 
                    CGColorSpaceRelease(colorSpace);
                    
                    /* End composite */
                    
                    [assetWriterVideoInput appendSampleBuffer:sample];
                    CFRelease(sample);
                    
                }
                else {
                    [assetWriterVideoInput markAsFinished];
                    
                    /* Close output */
                    
                    [assetWriter endSessionAtSourceTime:presentationTime];
                    if (![assetWriter finishWriting]) {
                        NSLog(@"[assetWriter finishWriting] failed, status=%@ error=%@", assetWriter.status, assetWriter.error);
                    }
                    [self done];
                    //[self performSelectorOnMainThread:@selector(done) withObject:nil waitUntilDone:NO];
                    
                }
                
            }
        }];
        
    }];
    
    
    
}


- (IBAction)testBack:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
