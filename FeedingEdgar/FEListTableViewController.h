//
//  FEListTableViewController.h
//  FeedingEdgar
//
//  Created by Stuart Watkins on 3/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEAppDelegate.h"
#import "Reachability.h"

@interface FEListTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *theTableView;
    IBOutlet UIActivityIndicatorView *ind;
    NSArray *videos;
    FEAppDelegate *app;
}


- (IBAction)backToMenu:(id)sender;

@end
