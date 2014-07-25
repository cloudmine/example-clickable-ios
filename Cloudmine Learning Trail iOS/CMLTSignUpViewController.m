//
//  CMLTSignUpViewController.m
//  Cloudmine Learning Trail iOS
//
//  Created by Charles Burnett on 7/18/14.
//  Copyright (c) 2014 CloudMine. All rights reserved.
//

#import "CMLTSignUpViewController.h"
#import "Cloudmine.h"
@interface CMLTSignUpViewController ()

@end

@implementation CMLTSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    
    if (textField == _nameField) {
        [_emailField becomeFirstResponder];
    }
    
    else if (textField == _emailField) {
        [_passwordField becomeFirstResponder];
    }
    
    else if (textField == _passwordField) {
        [_confirmPasswordField becomeFirstResponder];
    }
    else
    {
        if (![_passwordField.text isEqualToString:_confirmPasswordField.text] ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords do not match" message:@"Your password fields do not match" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            [alert show];
        }
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)note
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 120, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)keyboardWillHide:(NSNotification *)note
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 120, self.view.frame.size.width, self.view.frame.size.height);
}

- (IBAction)didPressSignUp:(id)sender {
    CMUser *user = [[CMUser alloc] initWithEmail:_emailField.text andPassword:_passwordField.text];
    [user createAccountWithCallback:^(CMUserAccountResult resultCode, NSArray *messages) {
        switch(resultCode) {
            case CMUserAccountCreateSucceeded:
                // did it!
                NSLog(@"Account Created");
                [self performSegueWithIdentifier:@"signupSegue" sender:self];
                break;
            case CMUserAccountCreateFailedInvalidRequest:
                NSLog(@"Invalid Request");
                // forgot the email/username or password
                break;
            case CMUserAccountCreateFailedDuplicateAccount:
            {
                // account with this email already exists
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Account Exists" message:@"An account with this email already exists" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alert show];
                break;
            }
        }
    }];
}
@end
