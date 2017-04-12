//
//  AboutTableTableViewController.m
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "AboutTableTableViewController.h"

#import "LoginViewController.h"
#import "FreditAPI.h"

@interface AboutTableTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *signInStatusLabel;

@end

@implementation AboutTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self signInStatusLabel]setEnabled:[[[FreditAPI sharedInstance]userAuthorizationToken] isEqualToString:@""]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) launchLoginView {
    LoginViewController* loginVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self presentViewController:loginVC animated:YES completion:nil];
    //    [[self navigationController]pushViewController:loginVC animated:YES];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0:
                    if ([[[FreditAPI sharedInstance]userAuthorizationToken] isEqualToString:@""]) {
                        [self launchLoginView];
                    }
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
