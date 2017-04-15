//
//  EventDetailEditingTVC.m
//  Fredit
//
//  Created by Codetector on 2017/4/14.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "EventDetailEditingTVC.h"
#import "UIColor+ColorFromRGB.h"

@interface EventDetailEditingTVC ()
@property (weak, nonatomic) IBOutlet UITableViewCell *eventNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventDatetimePicker;

@end

UIColor* highLightTextColor;
bool isDatetimeEditing = false;

@implementation EventDetailEditingTVC
- (IBAction)onEventDateTimePickerChange:(UIDatePicker *)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initializing Variables
    
    highLightTextColor = [UIColor colorWithRGB:0xFF2D55]; // Apple recomended pink color for selected date and stuff
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showStatusPickerCell {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
