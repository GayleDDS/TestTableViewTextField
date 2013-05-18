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
    self.phoneTextField.keyboardType         = UIKeyboardTypeNumbersAndPunctuation;
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


@end
