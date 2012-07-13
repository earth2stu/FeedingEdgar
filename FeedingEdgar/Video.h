//
//  Video.h
//  FeedingEdgar
//
//  Created by Stuart Watkins on 3/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject <NSCoding> {
    NSString *title;
    NSDate *timestamp;
    NSString *guid;
    BOOL isUploaded;
    NSString *url;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *timestamp;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) UIImage *thumbnail;
@property (assign) BOOL isUploaded;
@property (nonatomic, retain) NSString *url;
- (NSString *)uuid;

@end
