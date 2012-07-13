//
//  FEAppDelegate.m
//  FeedingEdgar
//
//  Created by Stuart Watkins on 11/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "FEAppDelegate.h"
#import <Parse/Parse.h>

@implementation FEAppDelegate

@synthesize window = _window;
@synthesize videos;
@synthesize girlRun = _girlRun;
@synthesize boyRun = _boyRun;
@synthesize girlJump = _girlJump;
@synthesize boyJump = _boyJump;
@synthesize isWifi;
//@synthesize track;
@synthesize backgroundMusicPlayer = _backgroundMusicPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadDataFromDisk];
    
    [Parse setApplicationId:@"d3uSZzF4FeUrQcMiwPVjw8aycbhvCwdO9RdYQP2J"
                  clientKey:@"A1MmNCXcyPUNVMl4yOUYmfJiSljfY5BOwXT0aX5b"];
    
    [PFFacebookUtils initializeWithApplicationId:@"464218030257493"];
    
    //NSError *setCategoryError = nil;
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    
    
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil]; 
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    // Create audio player with background music
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"01 Answers" ofType:@"mp3"];
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    NSError *error;
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    [_backgroundMusicPlayer setDelegate:self];  // We need this so we can restart after interruptions
    [_backgroundMusicPlayer setNumberOfLoops:-1];   // Negative number means loop
    
    [_backgroundMusicPlayer setVolume:0.3f];
    
    [self performSelector:@selector(playSound) withObject:nil afterDelay:1.0f];
    
/*
        [track setVolume:1];
    NSString *trackString = [[NSBundle mainBundle] pathForResource:@"01 Answers" ofType:@"mp3"];
    NSURL *trackURL = [NSURL fileURLWithPath:trackString];
        
    NSError *error;
        
        track = [[AVAudioPlayer alloc] initWithContentsOfURL:trackURL error:&error];
        track.numberOfLoops = 0;
        
        if (track == nil)
            NSLog([error description]);
        else
            [track setVolume:0.1];
        
        [track play];   
    
    
    */
    
    //[self performSelector:@selector(playSound) withObject:nil afterDelay:1.0f];
    
    //[track play];
    //[track stop];
    
    
    /*
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *myID = [defaults valueForKey:@"myID"];
    if (!myID) {
        NSString *uid = [self uuid];
        [defaults setValue:uid forKey:@"myID"];
        PFObject *me = [[PFObject alloc] initWithClassName:@"Device"];
        [me setValue:uid forKey:@"uid"];
        [me saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // ??
        }];
        [defaults synchronize];
    }
    */
    
    // Override point for customization after application launch.
    return YES;
}

/*
- (void)playSound {
    
    NSLog(@"track is playing? %@", self.track);
    
    if ([self.track prepareToPlay] && !self.track.isPlaying) {
        NSLog(@"playing track");
        [self.track play];
    } else {
        [self performSelector:@selector(playSound) withObject:nil afterDelay:1.0f];
        NSLog(@"trying to play again in one second");
    }
}
*/

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"handle open URL");
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"application open URL with %@, %@, %@", url, sourceApplication, annotation);
    return [PFFacebookUtils handleOpenURL:url]; 
}

- (NSMutableArray*)boyRun {
    if (_boyRun) {
        return _boyRun;
    }
    
    _boyRun = [NSMutableArray array];
    for (int i = 0; i <= 24; i++) {
        NSString *fileName = [NSString stringWithFormat:@"Man Run Cycle_%05i.png", i];
        [_boyRun addObject:(id)[[UIImage imageNamed:fileName] CGImage]];
    }
    return _boyRun;
}

- (NSMutableArray*)boyJump {
    if (_boyJump) {
        return _boyJump;
    }
    
    _boyJump = [NSMutableArray array];
    for (int i = 0; i <= 33; i++) {
        NSString *fileName = [NSString stringWithFormat:@"Man Jump_%05i.png", i];
        [_boyJump addObject:(id)[[UIImage imageNamed:fileName] CGImage]];
    }
    return _boyJump;
}

- (NSMutableArray*)girlRun {
    if (_girlRun) {
        return _girlRun;
    }
    
    _girlRun = [NSMutableArray array];
    for (int i = 0; i <= 24; i++) {
        NSString *fileName = [NSString stringWithFormat:@"Girl Run Cycle_%05i.png", i];
        
        [_girlRun addObject:(id)[[UIImage imageNamed:fileName] CGImage]];
    }
    return _girlRun;
}

- (NSMutableArray*)girlJump {
    if (_girlJump) {
        return _girlJump;
    }
    
    _girlJump = [NSMutableArray array];
    for (int i = 0; i <= 32; i++) {
        NSString *fileName = [NSString stringWithFormat:@"Girl Jump_%05i.png", i];
        [_girlJump addObject:(id)[[UIImage imageNamed:fileName] CGImage]];
    }
    return _girlJump;
}


// Path to the data file in the app's Documents directory
- (NSString *) pathForDataFile {
    NSArray*	documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*	path = nil;
 	
    if (documentDir) {
        path = [documentDir objectAtIndex:0];    
    }
 	
    return [NSString stringWithFormat:@"%@/%@", path, @"data.bin"];
}

- (void) saveDataToDisk {
    NSString * path = [self pathForDataFile];
    NSLog(@"Writing accounts to '%@' %@", path, self.videos);
 	
    NSMutableDictionary * rootObject;
    rootObject = [NSMutableDictionary dictionary];
    
    [rootObject setValue: [self videos] forKey:@"videos"];
    [NSKeyedArchiver archiveRootObject: rootObject toFile: path];
}

- (void) loadDataFromDisk {
    NSString     * path         = [self pathForDataFile];
    NSLog(@"Loading accounts from file '%@'", path);
 	
    NSDictionary * rootObject;
    
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    self.videos = [rootObject valueForKey:@"videos"];
    NSLog(@"Loaded accounts %@", videos);
    if (self.videos == nil) {
        self.videos = [[NSMutableArray alloc] init];  
    }
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark AVAudioPlayer delegate methods

- (void)playSound {
    [self performSelectorOnMainThread:@selector(tryPlayMusic) withObject:nil waitUntilDone:NO];
}

- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {
    _backgroundMusicInterrupted = YES;
    _backgroundMusicPlaying = NO;
}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player {
    if (_backgroundMusicInterrupted) {
        [self tryPlayMusic];
        _backgroundMusicInterrupted = NO;
    }
}

- (void)tryPlayMusic {
    
    // Check to see if iPod music is already playing
    UInt32 propertySize = sizeof(_otherMusicIsPlaying);
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &_otherMusicIsPlaying);
    
    // Play the music if no other music is playing and we aren't playing already
    if (_otherMusicIsPlaying != 1 && !_backgroundMusicPlaying) {
        [_backgroundMusicPlayer prepareToPlay];
        //if (soundsEnabled==YES) {
            [_backgroundMusicPlayer play];
            _backgroundMusicPlaying = YES;
            
            
        //}
    }   
}

@end
