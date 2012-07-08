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


@interface VideoTableViewCell : UITableViewCell {

    MPMoviePlayerController *moviePlayer;
}
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
-(IBAction) playMovie;

@property (nonatomic, retain) IBOutlet UIButton *thumbView;
@property (nonatomic, retain) PFObject *video;

- (IBAction)playVideo:(id)sender;

@end
