//
//  EventTableViewCell.m
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "EventTableViewCell.h"

@interface EventTableViewCell()
@property (strong, nonatomic) Event* baseEvent;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDetaiLlabel;

@end

@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)updateViewWithEvent:(Event *)event {
    self.baseEvent = event;
    self.eventNameLabel.text = event.eventName;
    self.eventDateLabel.text = [NSDateFormatter localizedStringFromDate:event.eventTime dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    self.eventDetaiLlabel.text = event.eventDescription;
    if ([[event.eventName stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        self.eventNameLabel.attributedText = [[NSAttributedString alloc]
         initWithString: @"Untitled Event"
         attributes: @{
                       NSFontAttributeName: [UIFont italicSystemFontOfSize:
                                             self.eventNameLabel.font.pointSize]}];
    }
}

@end
