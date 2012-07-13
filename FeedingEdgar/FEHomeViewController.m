//
//  FEHomeViewController.m
//  FeedingEdgar
//
//  Created by Stuart Watkins on 24/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "FEHomeViewController.h"
#import "FEVideoListTableViewController.h"
#import "FEViewController.h"
#import "FEChooseCharacterViewController.h"

#import "FEListTableViewController.h"
#import <Parse/Parse.h>

#import <AudioToolbox/AudioToolbox.h>

@implementation FEHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //NSString *trackString = [[NSBundle mainBundle] pathForResource:@"01 Answers" ofType:@"mp3"];
    //NSURL *trackURL = [NSURL fileURLWithPath:trackString];
    
    //NSError *error = nil;
    
    //SystemSoundID soundID;
    
    //Use audio sevices to create the sound
    
    //AudioServicesCreateSystemSoundID((__bridge CFURLRef)trackURL, &soundID);
    
    //Use audio services to play the sound
    
    //AudioServicesPlaySystemSound(soundID);
    
    //[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    
    /*
    track = [[AVAudioPlayer alloc] initWithContentsOfURL:trackURL error:&error];
    track.numberOfLoops = -1;
    //track.delegate = self;
    //[track play];
    //track.volume = 0.5f;
    [track prepareToPlay];
    [self performSelector:@selector(playSound) withObject:nil afterDelay:1.0f];
    */
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (IBAction)showVideoList:(id)sender {
    FEListTableViewController *vtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"List"];    
    [self.navigationController pushViewController:vtvc animated:YES];
}

- (IBAction)recordGirl:(id)sender {
    
    
    if ([PFUser currentUser])
    {
        FEChooseCharacterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseCharacter"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Feeding Edgar" message:@"So we can credit you for your fine work login via facebook" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];

        
    }
    
        
}

- (void)playSound {
    
    NSLog(@"track is playing? %@", track);
    
    if ([track prepareToPlay] && !track.isPlaying) {
        NSLog(@"playing track");
        [track play];
    } else {
        [self performSelector:@selector(playSound) withObject:nil afterDelay:1.0f];
        NSLog(@"trying to play again in one second");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[track play];
    FEAppDelegate *app = (FEAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[app.track pause];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"video_upload", 
                            
                            nil];
    
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            FEChooseCharacterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseCharacter"];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSLog(@"User logged in through Facebook!");
            FEChooseCharacterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseCharacter"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    
    
    //FEViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordVideo"];
    //[self.navigationController pushViewController:vc animated:YES];
}

- (void)facebookLogin {
    
}
@end
