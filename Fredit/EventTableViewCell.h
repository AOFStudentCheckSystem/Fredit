//
//  EventTableViewCell.h
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "Event+CoreDataClass.h"

@interface EventTableViewCell : MGSwipeTableCell
@property (strong, nonatomic, readonly) Event* baseEvent;

- (void) updateViewWithEvent: (Event*) event;

@end
