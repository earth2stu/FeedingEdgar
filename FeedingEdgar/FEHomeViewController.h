//
//  FEHomeViewController.h
//  FeedingEdgar
//
//  Created by Stuart Watkins on 24/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface FEHomeViewController : UIViewController <UIAlertViewDelegate> {
    UIAlertView *alert;
    AVAudioPlayer *track;
}

- (IBAction)showVideoList:(id)sender;
- (IBAction)recordGirl:(id)sender;
- (void)playSound;

@end
