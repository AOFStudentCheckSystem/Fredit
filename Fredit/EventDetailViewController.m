//
//  EventDetailViewController.m
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventDetailEditingTVC.h"
#import "UserInterfaceStrings.h"
#import "FreditAPI.h"

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
        //Initialize button
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showEditView)];
        
        self.navigationItem.rightBarButtonItem = editButton;
        
        self.hoverView.hidden = true;
        [self updateviewAccordingToBaseEvent];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEventChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.baseEvent.managedObjectContext];
    [[self signUpTableView]setDataSource:self];
    [[self signUpTableView]setDelegate:self];
}

- (void) onEventChange: (NSNotification*) n {
    NSArray* updatedObjects = [n.userInfo objectForKey:NSUpdatedObjectsKey];
//    NSLog(@"%@ ",updatedObjects.description);
    if (self.baseEvent) {
        for (NSManagedObject* obj in updatedObjects) {
            if ([obj.objectID isEqual:self.baseEvent.objectID]) {
                self.hoverView.hidden = ((Event*)obj).changed >= 0;
                self.baseEvent = (Event*)obj;
                [self updateviewAccordingToBaseEvent];
                return;
            }
        }
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"eventRecordCell"];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self signUpTableView]deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) updateviewAccordingToBaseEvent {
    self.eventNameLabel.text = self.baseEvent.eventName;
    self.eventTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.baseEvent.eventTime dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];;
    self.eventStatusLabel.attributedText = [UserInterfaceStrings localizedStringForEventStatus:self.baseEvent.eventStatus];
    self.eventIdLabel.text = self.baseEvent.eventId;
//    
//    if ([FreditAPI isDeviceOnline]) {
//        NSLog(@"%@",[[FreditAPI sharedInstance]fetchRecordsForEvent:self.baseEvent]);
//    }
    
}

- (void) showEditView{
    EventDetailEditingTVC* editing = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetailEditVC"];
    editing.targetEvent = self.baseEvent;
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:editing];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLayoutSubviews {
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
