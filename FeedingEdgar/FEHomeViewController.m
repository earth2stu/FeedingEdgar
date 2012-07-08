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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
    
        [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
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
    }
    
    
    
    //FEViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordVideo"];
    //[self.navigationController pushViewController:vc animated:YES];
}
@end
