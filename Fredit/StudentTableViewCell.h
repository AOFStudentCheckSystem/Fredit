//
//  StudentTableViewCell.h
//  Fredit
//
//  Created by Codetector on 2017/4/21.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student+CoreDataClass.h"

@interface StudentTableViewCell : UITableViewCell

- (void) refreshContentWithStudent: (Student* )student;

@end
