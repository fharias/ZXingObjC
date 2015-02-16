//
//  LeftMenuViewController.m
//  MarketingScanner
//
//  Created by FABIO ARIAS on 12/02/15.
//  Copyright (c) 2015 Draconis Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeftMenuViewController.h"

@implementation LeftMenuViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
-(void) viewDidLoad{
    self.dataSourceMenu = [@[@"Inicio", @"Favoritos"] mutableCopy];
}

#pragma TableViewController Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSourceMenu count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Item"];
    if(!cell){
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Item"];
    }
    cell.textLabel.text = self.dataSourceMenu[indexPath.row];
    return cell;
}

@end