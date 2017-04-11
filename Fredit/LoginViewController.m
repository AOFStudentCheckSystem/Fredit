//
//  ViewController.m
//  Fredit
//
//  Created by Codetector on 2017/4/10.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+RoundCornerUIView.h"

@interface LoginViewController ()
    @property (weak, nonatomic) IBOutlet UIButton *signUpButton;

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
