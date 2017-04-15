//
//  EventDetailEditingTVC.m
//  Fredit
//
//  Created by Codetector on 2017/4/14.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "EventDetailEditingTVC.h"
#import "UIColor+ColorFromRGB.h"
#import <MBAutoGrowingTextView.h>
#import "NSDate+Rounding.h"
#import "AppDelegate.h"
#import "FreditAPI.h"
#import "FreditDataAccessObject.h"
#import <SVProgressHUD.h>

@interface EventDetailEditingTVC ()
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;

@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventDatetimePicker;
@property (strong, nonatomic) NSDate *eventDate;
@property (weak, nonatomic) IBOutlet MBAutoGrowingTextView *eventDetailText;
@property (strong, nonatomic) NSDateFormatter *labelFormatter;
@end

UIColor* highLightTextColor;
bool isDatetimeEditing = false;

@implementation EventDetailEditingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initializing Variables
    
    highLightTextColor = [UIColor colorWithRGB:0xFF2D55]; // Apple recomended pink color for selected date and stuff
    
    self.labelFormatter = [[NSDateFormatter alloc]init];
    self.labelFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.labelFormatter.timeStyle = NSDateFormatterShortStyle;
    
    self.eventDate = [NSDate date];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEdit)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAndClose)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) cancelAndClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = [[delegate persistentContainer]viewContext];
    return context;
}

- (void)viewDidLayoutSubviews {
    if (self.targetEvent) {
        self.eventDate = self.targetEvent.eventTime;
        self.eventNameTextField.text = self.targetEvent.eventName;
        self.eventDetailText.text = self.targetEvent.eventDescription;
    }
}

- (void) finishEdit {
    if ([self.eventNameTextField.text isEqualToString:@""]) {
        return;
    }
    [SVProgressHUD showWithStatus:@"Saving..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString* eventID = self.targetEvent ? self.targetEvent.eventId : @"";
        
        [[FreditAPI sharedInstance]creditEventWithId:eventID andEventName:self.eventNameTextField.text andTime:self.eventDate andDescription:self.eventDetailText.text];
        [FreditDataAccessObject updateAllEventsFromServerInContext:[self managedObjectContext]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:true completion:nil];
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setEventDate:(NSDate *)eventDate {
    _eventDate = eventDate;
    self.eventTimeLabel.text = [self.labelFormatter stringFromDate:_eventDate];
}

- (void)showStatusPickerCell {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.eventDatetimePicker.date = self.eventDate;
    self.eventDatetimePicker.hidden = NO;
    self.eventDatetimePicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.eventDatetimePicker.alpha = 1.0f;
    }];
}

- (void)hideStatusPickerCell {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.eventDatetimePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.eventDatetimePicker.hidden = YES;
                     }];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = self.tableView.rowHeight;
    
    if (indexPath.row == 2) {
        rowHeight = isDatetimeEditing ? 216 : 0;
    } else if (indexPath.row == 3) {
        rowHeight = 150;
    }
    return rowHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        //Make editing status the target status
        isDatetimeEditing ^= YES; // isdatetimeEditing = !isDatetimeEditing
        
        if (isDatetimeEditing) {
            self.eventTimeLabel.textColor = highLightTextColor;
            [self showStatusPickerCell];
        } else {
            self.eventTimeLabel.textColor = [UIColor blackColor];
            [self hideStatusPickerCell];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (IBAction)onEventDateTimePickerChange:(UIDatePicker *)sender {
    self.eventDate = sender.date;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
