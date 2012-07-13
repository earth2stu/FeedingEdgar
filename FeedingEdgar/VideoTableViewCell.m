//
//  VideoTableViewCell.m
//  FeedingEdgar
//
//  Created by Stuart Watkins on 6/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "FEAppDelegate.h"


@implementation VideoTableViewCell

@synthesize thumbView, video, moviePlayer, progressView, sendHQButton;



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
    
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    
    //moviePlayer.shouldAutoplay = YES;

    [self.superview.superview addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
    //[moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [self performSelector:@selector(setControls) withObject:nil afterDelay:1.0f];
    
    
}

- (void)setControls {
    [moviePlayer setControlStyle:MPMovieControlStyleDefault];
}

- (IBAction)sendHQ:(id)sender {
    
    
    FEAppDelegate *app = (FEAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    if (!app.isWifi) {
        alert = [[UIAlertView alloc] initWithTitle:@"Feeding Edgar" message:@"You need to be connected via WIFI" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Feeding Edgar" message:@"By uploading this footage you are granting Feeding Edgar unlimited use of your recorded footage" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    }
    
    
    
    
    
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        return;
    }
    
    if ([alertView isEqual:deleteAlert]) {
        [self doDelete];
        return;
    }
    
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *uniqueOut = [NSString stringWithFormat:@"%@.mov", video.guid];
    NSString* outFile = [documentsPath stringByAppendingPathComponent:uniqueOut];
    //NSURL *fileOut = [NSURL fileURLWithPath:outFile];
    
     //NSString *path = [outputURL path];
     
    [progressView setHidden:NO];
    
    //PFFile *imgFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png", video.guid] contentsAtPath:outFile];
    //[imgFile save];
    
     PFFile *file = [PFFile fileWithName:[NSString stringWithFormat:@"%@.mov", video.guid] contentsAtPath:outFile];
     
     [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (succeeded) {
             NSLog(@"woot!");
         }
         
         FEAppDelegate *app = (FEAppDelegate*)[[UIApplication sharedApplication] delegate];
         
         
         [progressView setHidden:YES];
         video.isUploaded = YES;
         video.url = file.url;
         
         NSLog(@"saved at:%@", file.url);
         
         [app saveDataToDisk];
         
         PFObject *vid = [[PFObject alloc] initWithClassName:@"Video"];
         
         
          [vid setObject:[PFUser currentUser] forKey:@"user"];
          [vid setValue:video.guid forKey:@"guid"];
         [vid setValue:file.url forKey:@"videoURL"];
          //[vid setValue:currentVideo.title forKey:@"title"];
          //[vid setValue:currentVideo.timestamp forKey:@"timestamp"];
         
         
         NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         NSString *uniqueOut = [NSString stringWithFormat:@"%@.png", video.guid];
         NSString* outFile = [documentsPath stringByAppendingPathComponent:uniqueOut];
         UIImage *image = [UIImage imageWithContentsOfFile:outFile];
         if (image) {
             [vid setObject:UIImagePNGRepresentation(image)  forKey:@"thumbnail"];
         }
         
         //[pfVideo saveEventually];
         
         
          [vid saveEventually];
          

         
         
         

         
         // post to facebook
         
         /*
         NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"__MY_APP_ID__", @"app_id",
                                        @"http://google.com", @"link",
                                        @"http://www.youtube.com/v/hpP7wvMqGYU", @"source",
                                        @"http://img.youtube.com/vi/hpP7wvMqGYU/0.jpg", @"picture",
                                        @"myName", @"name",
                                        @"myCaption", @"caption",
                                        @"myDescription", @"description",
                                        nil];
         
         
         [p dialog:@"feed" andParams:params andDelegate:self];
         */
         
         PF_Facebook *p = [PFFacebookUtils facebook];
         
         
         [p dialog:@"feed" 
                   andParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                              file.url, @"link",
                              file.url, @"source",
                              @"http://img.youtube.com/vi/hpP7wvMqGYU/0.jpg", @"picture",
                              @"Feeding Edgar", @"name",
                              @"I made this!", @"caption",
                              @"I just created this video for the Feeding Edgar video clip", @"description",                                                              
                              nil] 
                 andDelegate:self];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
         
         /*
         NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        file.url, @"source",
                                        @"http://img.youtube.com/vi/hpP7wvMqGYU/0.jpg", @"picture",
                                        @"Feeding Edgar", @"name",
                                        @"I just made this vid for Feeding Edgar!!", @"description",
                                        nil];
         
         [p requestWithGraphPath:@"me/videos" andParams:params andHttpMethod:@"POST" andDelegate:self];
         */
         
     } progressBlock:^(int percentDone) {
         //asdf
         progressView.progress = percentDone / 100.0f;
     }];
     
}



- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
    
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        //[player.view removeFromSuperview];
    }
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    NSLog(@"woot posted!!");
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}

- (void)dialogDidComplete:(PF_FBDialog *)dialog {
    NSLog(@"woot!!");
}

- (void)dialog:(PF_FBDialog *)dialog didFailWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}

- (IBAction)deleteVideo:(id)sender {
    
    deleteAlert = [[UIAlertView alloc] initWithTitle:@"Feeding Edgar" message:@"Delete video?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [deleteAlert show];
}

- (void)doDelete {
    
    FEAppDelegate *app = (FEAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.videos removeObject:video];
    [app saveDataToDisk];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *uniqueOut = [NSString stringWithFormat:@"%@.mov", video.guid];
    NSString* outFile = [documentsPath stringByAppendingPathComponent:uniqueOut];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:outFile error:&error];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
}

@end
