//
//  InitViewController.h
//  MarketingScanner
//
//  Created by FABIO ARIAS on 11/02/15.
//  Copyright (c) 2015 Draconis Software. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "AMSlideMenuMainViewController.h"

@interface InitViewController : AMSlideMenuMainViewController
@property (weak, nonatomic) IBOutlet UIButton *btnToggleLoginState;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *lblFullname;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *btnScanTag;

@property (nonatomic, strong) AppDelegate *appDelegate;

- (IBAction)toggleLoginState:(id)sender;
- (IBAction)findNewTags:(id)sender;

@end