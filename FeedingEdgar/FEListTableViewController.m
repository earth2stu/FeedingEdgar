//
//  FEListTableViewController.m
//  FeedingEdgar
//
//  Created by Stuart Watkins on 3/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "FEListTableViewController.h"
#import "Video.h"
#import <Parse/Parse.h>
#import "VideoTableViewCell.h"
#import "FEAppDelegate.h"

@implementation FEListTableViewController

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    self = [super ini
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadTable" object:nil];
    
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    //[query findObjects];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        videos = objects;
        [theTableView reloadData];
        [ind stopAnimating];
    }];
    */
    
    app = (FEAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app loadDataFromDisk];
    videos = app.videos;
    
    
    
        
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // set the blocks 
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
        
        if (reach.isReachableViaWiFi) {
            app.isWifi = YES;
            NSLog(@"WIFI");
        } else {
            app.isWifi = NO;
            NSLog(@"No WIFI");
        }
        
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        app.isWifi = NO;
        NSLog(@"UNREACHABLE!");
    };
    
    // start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    //[app.track play];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (videos) {
        //return [videos count];
        return [app.videos count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListItem";
    
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Video *video = [videos objectAtIndex:indexPath.row];
    
    cell.video = video;
    //cell.textLabel.text = [video valueForKey:@"guid"];
    
    //NSData *imageData = video.thumbnail;
    //[video objectForKey:@"thumbnail"];
    //UIImage *image = [UIImage imageWithData:imageData];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *uniqueOut = [NSString stringWithFormat:@"%@.png", video.guid];
    NSString* outFile = [documentsPath stringByAppendingPathComponent:uniqueOut];
    
    UIImage *image = [UIImage imageWithContentsOfFile:outFile];
    
    //[cell.thumbView setImage:image forState:UIControlStateNormal];
    
    [cell.thumbView setBackgroundImage:image forState:UIControlStateNormal];
    
    [cell.sendHQButton setEnabled:!video.isUploaded];
    
    
    
    //NSData *imageData = UIImagePNGRepresentation(rotatedImage);
    //[imageData writeToFile:outFile atomically:YES];

    
    
    
    //[cell.thumbView setImage:video.thumbnail forState:UIControlStateNormal];
    cell.tag = indexPath.row;
    
    //cell.thumbView setImage:image];
    // Configure the cell...
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)saveToParse:(Video*)video {
    
    /*
    NSString *path = [outputURL path];
    
    PFFile *file = [PFFile fileWithName:[NSString stringWithFormat:@"%@.mov", currentVideo.guid] contentsAtPath:path];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        <#code#>
    } progressBlock:^(int percentDone) {
        <#code#>
    }
     */
}

- (IBAction)backToMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadTable:(NSNotification*)notification {
    [theTableView reloadData];
}

@end
