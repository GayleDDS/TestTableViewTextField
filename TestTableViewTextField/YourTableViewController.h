//
//  YourTableViewController.h
//  TestTableViewTextField
//
//  Created by Gayle Dunham on 5/18/13.
//  Copyright (c) 2013 Gayle Dunham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourTableViewController : UITableViewController {

    NSString* phone_;
    UITextField* phoneFieldTextField;
}

@property (nonatomic,copy) NSString* phone;

@end

