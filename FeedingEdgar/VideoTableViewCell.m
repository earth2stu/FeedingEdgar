//
//  VideoTableViewCell.m
//  FeedingEdgar
//
//  Created by Stuart Watkins on 6/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "VideoTableViewCell.h"



@implementation VideoTableViewCell

@synthesize thumbView, video, moviePlayer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)playVideo:(id)sender {
    
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *uniqueOut = [NSString stringWithFormat:@"%@.mov", [video valueForKey:@"guid"]];
    NSString* outFile = [documentsPath stringByAppendingPathComponent:uniqueOut];
    //NSURL *fileOut = [NSURL fileURLWithPath:outFile];

    //NSString *path = [[NSBundle mainBundle] pathForResource:outFile ofType:@"mov"];
    NSURL *url = [NSURL fileURLWithPath:outFile];
    
    
    moviePlayer =  [[MPMoviePlayerController alloc]
                    initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay = YES;
    [self.superview.superview addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
    
    
    
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        //[player.view removeFromSuperview];
    }
}

@end
