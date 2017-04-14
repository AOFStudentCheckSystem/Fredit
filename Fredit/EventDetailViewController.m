//
//  EventDetailViewController.m
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()
@property (strong, nonatomic) Event* baseEvent;

@property (weak, nonatomic) IBOutlet UIView *hoverView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventIdLabel;
@property (weak, nonatomic) IBOutlet UITableView *signUpTableView;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (self.baseEvent) {
        self.hoverView.hidden = true;
        self.eventNameLabel.text = self.baseEvent.eventName;
        self.eventTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.baseEvent.eventTime dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];;
        self.eventStatusLabel.text = [NSString stringWithFormat:@"%i", self.baseEvent.eventStatus];
        self.eventIdLabel.text = self.baseEvent.eventId;

    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkInButton:(UIButton *)sender {
}

- (void)populateViewWithEvent:(Event *)event {
    self.baseEvent = event;
}

// UITableview Datasource

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
