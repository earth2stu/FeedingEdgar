//
//  FEChooseCharacterViewController.m
//  FeedingEdgar
//
//  Created by Stuart Watkins on 23/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "FEChooseCharacterViewController.h"
#import "FEViewController.h"
#import "FEAppDelegate.h"

@implementation FEChooseCharacterViewController

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    FEAppDelegate *app = (FEAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[app.track play];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseGirl:(id)sender {
    FEViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordVideo"];
    UINavigationController *navController = self.navigationController;
    vc.isGuy = NO;
    [navController popViewControllerAnimated:NO];
    [navController pushViewController:vc animated:YES];
}

- (IBAction)chooseGuy:(id)sender {
    FEViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordVideo"];
    UINavigationController *navController = self.navigationController;
    vc.isGuy = YES;
    [navController popViewControllerAnimated:NO];
    [navController pushViewController:vc animated:YES];
}
@end
