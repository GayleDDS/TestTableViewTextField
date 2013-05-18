//
//  BetterTableViewController.m
//  TestTableViewTextField
//
//  Created by Gayle Dunham on 5/18/13.
//  Copyright (c) 2013 Gayle Dunham. All rights reserved.
//

#import "BetterTableViewController.h"

@interface BetterTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;

@property (weak, nonatomic) UITextField *activeTextField;

@property (strong, nonatomic) NSArray *allTextFields;

@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolbar;


- (IBAction)nextTextField:(UIBarButtonItem *)sender;
- (IBAction)doneKeyboard:(UIBarButtonItem *)sender;

@end

@implementation BetterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allTextFields = @[self.nameTextField, self.addressTextField, self.emailTextField, self.phoneTextField, self.dateOfBirthTextField];

    for (UITextField *textField in self.allTextFields) {
        textField.inputAccessoryView = self.keyboardToolbar;
        textField.delegate           = self;
    }
    self.phoneTextField.keyboardType         = UIKeyboardTypePhonePad;
    self.dateOfBirthTextField.keyboardType   = UIKeyboardTypeNumbersAndPunctuation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Toolbar Actions

- (IBAction)nextTextField:(UIBarButtonItem *)sender
{
    for (NSInteger i = 0; i < self.allTextFields.count; i++) {

        if ([self.allTextFields[i] isFirstResponder]) {
            [self.allTextFields[i] resignFirstResponder];
            
            NSInteger n = i + 1 < self.allTextFields.count ? i + 1 : 0;
            [self.allTextFields[n] becomeFirstResponder];
            break;
        }
    }
}

- (IBAction)doneKeyboard:(UIBarButtonItem *)sender
{
    UITextField *currentTextFiled = self.activeTextField;
    
    // If activeTextField is nil then we dont auto jump to the next text field in textFieldDidEndEditing:
    self.activeTextField = nil;
    
    [currentTextFiled resignFirstResponder];
}


#pragma mark - Text Field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    // if it's the phone number textfield format it.
    if(textField == self.phoneTextField ) {
        if (range.length == 1) {
            // Delete button was hit.. so tell the method to delete the last char.
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
        } else {
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:NO ];
        }
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        self.name = self.nameTextField.text;
    }
    else if (textField == self.addressTextField) {
        self.address = self.addressTextField.text;
    }
    else if (textField == self.emailTextField) {
        self.email = self.emailTextField.text;
    }
    else if (textField == self.phoneTextField) {
        self.phone = self.phoneTextField.text;
    }
    else if (textField == self.dateOfBirthTextField) {
        self.dateOfBirth = self.dateOfBirthTextField.text;
    }

    // If activeTextField is not nil then auto jump to the next text field
    if (self.activeTextField) {
        
        NSInteger indexActiveTextField = [self.allTextFields indexOfObject:self.activeTextField];
        NSInteger indexNextTextField   = indexActiveTextField + 1;
        
        if (indexNextTextField < self.allTextFields.count) {
            // Make the next text field next responder
            [self.allTextFields[indexNextTextField] becomeFirstResponder];
        } else {
            // We're at the last one so were done
            self.activeTextField = nil;
        }
    }
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
