//
//  LeftMenuViewController.h
//  MarketingScanner
//
//  Created by FABIO ARIAS on 12/02/15.
//  Copyright (c) 2015 Draconis Software. All rights reserved.
//

#import "AMSlideMenuLeftTableViewController.h"


@interface LeftMenuViewController : AMSlideMenuLeftTableViewController

@property (retain, nonatomic) IBOutlet UITableView * menuLeft;
@property (strong, nonatomic) NSMutableArray * dataSourceMenu;
@end