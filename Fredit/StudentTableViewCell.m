//
//  StudentTableViewCell.m
//  Fredit
//
//  Created by Codetector on 2017/4/21.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "StudentTableViewCell.h"

@interface StudentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *preferredNameLabel;
@property (strong, nonatomic) Student* baseStudent;
@end

@implementation StudentTableViewCell

- (void)refreshContentWithStudent:(Student *)student {
    self.baseStudent = student;
    if (self.baseStudent) {
        self.lastNameLabel.text = self.baseStudent.lastName;
        self.firstNameLabel.text = self.baseStudent.firstName;
        self.preferredNameLabel.text = self.baseStudent.preferredName;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
