//
//  Video.m
//  FeedingEdgar
//
//  Created by Stuart Watkins on 3/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "Video.h"

@implementation Video


@synthesize title, timestamp, guid, thumbnail, isUploaded, url;

- (id)init {
    if (self = [super init]) {
        self.guid = [self uuid];
        isUploaded = NO;
    }
    return self;
}

// Called when unserialized
- (id) initWithCoder: (NSCoder *)coder {
    if (self = [super init]) {
        self.title = [coder decodeObjectForKey:@"title"];
        self.timestamp = [coder decodeObjectForKey:@"timestamp"];
        self.guid = [coder decodeObjectForKey:@"guid"];
        self.isUploaded = [coder decodeBoolForKey:@"isUploaded"];
    }
    return self;
}

// Called when serialized
- (void) encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.timestamp forKey:@"timestamp"];
    [coder encodeObject:self.guid forKey:@"guid"];
    [coder encodeBool:self.isUploaded forKey:@"isUploaded"];
}

-(NSString *)description {
 	return [NSString stringWithFormat:@"Video { title: '%@' }", self.title];
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

@end
