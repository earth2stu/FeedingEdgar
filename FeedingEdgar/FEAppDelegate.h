//
//  FEAppDelegate.h
//  FeedingEdgar
//
//  Created by Stuart Watkins on 11/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEAppDelegate : UIResponder <UIApplicationDelegate> {
    NSMutableArray *videos;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *videos;

@property (strong, nonatomic) NSMutableArray *girlRun;
@property (strong, nonatomic) NSMutableArray *girlJump;
@property (strong, nonatomic) NSMutableArray *boyRun;
@property (strong, nonatomic) NSMutableArray *boyJump;


- (NSString*)uuid;
- (void) saveDataToDisk;
- (void) loadDataFromDisk;


@end
