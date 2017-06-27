//
//  SeriousExpertCell.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SeriousExpertCell.h"
@interface SeriousExpertCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) DoctorVO *expert;
@property (strong, nonatomic) NSMutableArray *selectedArr;
@end
@implementation SeriousExpertCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void) setCell:(DoctorVO*) vo selectedArr:(NSArray*)selectedArr indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selectedArr.count---%ld",selectedArr.count);
    self.selectedArr = [NSMutableArray arrayWithArray: selectedArr];
    BOOL contain = NO;
    for (DoctorVO *doctor in selectedArr) {
        if (doctor.id.intValue == vo.id.intValue) {
            NSLog(@"%d======orderid=======%d",doctor.id.intValue,vo.id.intValue);
            contain = YES;
        }
    }
    if (contain) {
         self.selectButton.selected = YES;
    }else{
        self.selectButton.selected = NO;
    }

    self.expert = vo;
    self.nameLabel.attributedText = [Utils attributeString:@[vo.name,[NSString stringWithFormat:@"   %@",vo.grade]] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:[UIColor lightGrayColor]}]];
    if(vo.desc){
        self.descriptionLabel.attributedText = [Utils attributeString:@[@"擅长 ",vo.desc] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12], NSForegroundColorAttributeName:[UIColor lightGrayColor]}]];
    }
    self.hospitalLabel.text = vo.hospitalName;
    self.amountLabel.text = [NSString stringWithFormat:@"接诊量 %@",vo.outpatientCount];
    self.departmentLabel.text = vo.departmentName;
    [ self.iconImageView sd_setImageWithURL: [NSURL URLWithString:vo.img]];
    
}
-(void)selectExpertAction:(SelectExpertBlock)block{
    self.myBlock = block;
}
- (IBAction)expertSelectAction:(UIButton *)sender {
    if (!sender.selected && (self.selectedArr.count >= 5)) {
        self.myBlock(self.selectedArr,YES);
        return;
    }
    BOOL contain = NO;
    DoctorVO *selectedDoctor ;
    for (DoctorVO *doctor in self.selectedArr) {
        if (doctor.id.intValue == self.expert.id.intValue) {
            contain = YES;
            selectedDoctor = doctor;
        }
    }
    if (contain) {
        [self.selectedArr removeObject:selectedDoctor];
    }else{
        [self.selectedArr addObject:self.expert];
    }
    self.myBlock(self.selectedArr,NO);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
