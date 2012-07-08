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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadDataFromDisk];
    
    [Parse setApplicationId:@"d3uSZzF4FeUrQcMiwPVjw8aycbhvCwdO9RdYQP2J"
                  clientKey:@"A1MmNCXcyPUNVMl4yOUYmfJiSljfY5BOwXT0aX5b"];
    
    [PFFacebookUtils initializeWithApplicationId:@"464218030257493"];
    
    
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url]; 
}

- (NSMutableArray*)boyRun {
    if (_boyRun) {
        return _boyRun;
    }
    
    _boyRun = [NSMutableArray array];
    for (int i = 0; i <= 26; i++) {
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
    for (int i = 0; i <= 25; i++) {
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
    
    [rootObject setValue: [self videos] forKey:@"accounts"];
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

@end
