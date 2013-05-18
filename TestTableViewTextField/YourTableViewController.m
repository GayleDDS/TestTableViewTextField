//
//  YourTableViewController.m
//  TestTableViewTextField
//
//  Created by Gayle Dunham on 5/18/13.
//  Copyright (c) 2013 Gayle Dunham. All rights reserved.
//

#import "YourTableViewController.h"

@interface YourTableViewController () <UITextFieldDelegate>

@end

@implementation YourTableViewController

@synthesize phone = phone_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.phone = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Make cell unselectable and set font.
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:13];
    
    if (indexPath.section == 0) {
        
        UITextField* tf = nil;
        switch ( indexPath.row ) {
            case 3: {
                cell.textLabel.text = @"Phone" ;
                tf = phoneFieldTextField = [self makeTextField:self.phone placeholder:@"(xxx) xxx-xxxx"];
                phoneFieldTextField.keyboardType = UIKeyboardTypePhonePad;
                
                [self formatPhoneNumber:phoneFieldTextField.text deleteLastChar:YES];
                
                [cell addSubview:phoneFieldTextField];
                break ;
            }
                // Textfield dimensions
                tf.frame = CGRectMake(120, 12, 170, 30);
                
                // Workaround to dismiss keyboard when Done/Return is tapped
                [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
        }
    }
    return cell;
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //Section 1.
//    if ( textField == nameFieldTextField ) {
//        self.name = textField.text ;
//    } else if ( textField == addressFieldTextField ) {
//        self.address = textField.text ;
//    } else if ( textField == emailFieldTextField ) {
//        self.email = textField.text ;
//    } else
    
        if ( textField == phoneFieldTextField ) {
        self.phone = textField.text ;

//    }else if ( textField == dateOfBirthTextField ) {
//        self.dateOfBirth = textField.text ;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    // if it's the phone number textfield format it.
    if(textField == phoneFieldTextField) {
        if (range.length == 1) {
            // Delete button was hit.. so tell the method to delete the last char.
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
        } else {
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:NO ];
        }
        return false;
    }
    
    return YES;
    NSLog(@"Testing should change character in range");
}

- (UITextField *) makeTextField:(NSString *)text placeholder:(NSString *) placeholder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(117, 7, 183, 30)];
    
    if (text && text.length)
        textField.text = text;

    if (placeholder && placeholder.length)
        textField.placeholder = placeholder;

    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    UIBarButtonItem *flexableSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneKeyboard  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneKeyboard:)];
    keyboardToolbar.items = @[flexableSpace, doneKeyboard];
    
    textField.inputAccessoryView = keyboardToolbar;
    textField.delegate           = self;
    
    return textField;
}
     
- (void)doneKeyboard:(UIBarButtonItem *)sender
{
    if (phoneFieldTextField)
        [phoneFieldTextField resignFirstResponder];
}


- (NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar {
    
    if(simpleNumber.length == 0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    if (simpleNumber.length == 10 && deleteLastChar == NO) { [self resignFirstResponder];}
    
    return simpleNumber;
    NSLog(@"Testing format phone number");
}



@end
