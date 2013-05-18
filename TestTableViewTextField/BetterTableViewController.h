//
//  BetterTableViewController.h
//  TestTableViewTextField
//
//  Created by Gayle Dunham on 5/18/13.
//  Copyright (c) 2013 Gayle Dunham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BetterTableViewController : UITableViewController

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *dateOfBirth;

@end
