//
//  FEVideoProcessingViewController.h
//  FeedingEdgar
//
//  Created by Stuart Watkins on 24/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Video.h"

@interface FEVideoProcessingViewController : UIViewController {
    NSMutableArray *girlImages;
    int64_t frameNumber;
    NSString *uid;
}

- (IBAction)testBack:(id)sender;
@property (nonatomic, retain) AVAssetWriter *assetWriter;
@property (nonatomic, retain) AVAssetWriterInput *assetWriterVideoInput;
@property (nonatomic, retain) AVAssetReader *reader;
@property (nonatomic, retain) AVAssetReaderTrackOutput *readerVideoTrackOutput;
@property (nonatomic, retain) Video *currentVideo;

@end
