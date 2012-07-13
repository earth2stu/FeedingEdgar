//
//  FEAppDelegate.h
//  FeedingEdgar
//
//  Created by Stuart Watkins on 11/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface FEAppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate> {
    NSMutableArray *videos;
    //AVAudioPlayer *track;
    
    
    AVAudioPlayer *_backgroundMusicPlayer;
    BOOL _backgroundMusicPlaying;
    BOOL _backgroundMusicInterrupted;
    UInt32 _otherMusicIsPlaying;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *videos;

@property (strong, nonatomic) NSMutableArray *girlRun;
@property (strong, nonatomic) NSMutableArray *girlJump;
@property (strong, nonatomic) NSMutableArray *boyRun;
@property (strong, nonatomic) NSMutableArray *boyJump;
@property (assign) BOOL isWifi;

@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;

//@property (strong, nonatomic) AVAudioPlayer *track;

- (NSString*)uuid;
- (void) saveDataToDisk;
- (void) loadDataFromDisk;
- (void)playSound;
- (void)tryPlayMusic;


@end
