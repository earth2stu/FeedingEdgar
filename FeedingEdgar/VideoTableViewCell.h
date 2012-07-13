//
//  VideoTableViewCell.h
//  FeedingEdgar
//
//  Created by Stuart Watkins on 6/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Video.h"
#import "Reachability.h"

@interface VideoTableViewCell : UITableViewCell <PF_FBRequestDelegate, PF_FBDialogDelegate, UIAlertViewDelegate> {

    MPMoviePlayerController *moviePlayer;
    UIAlertView *alert;
    UIAlertView *deleteAlert;
}
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
-(IBAction) playMovie;

@property (nonatomic, retain) IBOutlet UIButton *thumbView;
@property (nonatomic, retain) Video *video;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UIButton *sendHQButton;

- (IBAction)playVideo:(id)sender;
- (IBAction)sendHQ:(id)sender;
- (IBAction)deleteVideo:(id)sender;
- (void)doDelete;
- (void)setControls;

@end
