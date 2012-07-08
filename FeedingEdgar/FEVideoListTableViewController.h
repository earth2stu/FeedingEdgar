//
//  FEVideoListTableViewController.h
//  FeedingEdgar
//
//  Created by Stuart Watkins on 25/06/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FEVideoListTableViewController : PFQueryTableViewController {
    PFQuery *query;
    IBOutlet UITableView *customTableView;
}

@end
