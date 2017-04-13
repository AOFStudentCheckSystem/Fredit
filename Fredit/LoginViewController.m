//
//  ViewController.m
//  Fredit
//
//  Created by Codetector on 2017/4/10.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+RoundCornerUIView.h"
#import <SVProgressHUD.h>
#import "FreditAPI.h"
@interface LoginViewController ()
    @property (weak, nonatomic) IBOutlet UIButton *signUpButton;
    @property (weak, nonatomic) IBOutlet UITextField *emailInput;
    @property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidLayoutSubviews {
    [[self signUpButton]createRoundCorner:7 shadowRadius:0 borderWidth: 0.4 shadowOpacity:0];
    [super viewDidLayoutSubviews];
}

- (IBAction)onTextClickDone:(UITextField *)sender {
    [sender resignFirstResponder];
    if ([sender isEqual:self.emailInput]) {
        [self.passwordInput becomeFirstResponder];
    }
    
    if ([sender isEqual:self.passwordInput]) {
        //Submit Login Request
        [self signInButtonTouch:self.signUpButton];
    }
}

- (IBAction)resignFirstResponder: (UITextField *)sender {
    [sender resignFirstResponder];
}
- (IBAction)signInButtonTouch:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"Signing In..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL result = [[FreditAPI sharedInstance] loginWithUsername:self.emailInput.text andPassword:self.passwordInput.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [SVProgressHUD setMaximumDismissTimeInterval:3];
            if (result) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [SVProgressHUD showSuccessWithStatus:@"Logged In"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Failed to Login"];
            }
        });
    });
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
