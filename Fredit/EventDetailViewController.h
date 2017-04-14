//
//  EventDetailViewController.h
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event+CoreDataClass.h"

@interface EventDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (void) populateViewWithEvent: (Event*) event;

@end
