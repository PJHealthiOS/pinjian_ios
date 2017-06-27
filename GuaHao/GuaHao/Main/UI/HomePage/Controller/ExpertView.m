//
//  ExpertView.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/1.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "ExpertView.h"

@interface ExpertView ()<UIAlertViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (strong, nonatomic) DoctorVO *doctor;
@end
@implementation ExpertView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //添加长摁手势
    }
    return self;
}
-(void)setCell:(DoctorVO *)doctor{
    self.doctor = doctor;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    //设置长按时间
    self.userInteractionEnabled = YES;
    longPressGesture.minimumPressDuration = 1;//(2秒)
    [self addGestureRecognizer:longPressGesture];

    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:doctor.img] placeholderImage:[UIImage imageNamed:@""]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithAttributedString:[self renderWithStr:doctor.departmentName color:UIColorFromRGB(0xacacac)]];
    [attStr appendAttributedString:[self renderWithStr:[NSString stringWithFormat:@"%@",doctor.grade] color:UIColorFromRGB(0x45c768)]];
    self.nameLabel.text = doctor.name;
    self.departmentLabel.attributedText = attStr;
    self.hospitalLabel.text = doctor.hospitalName;
}

-(void)longPressGesture:(UILongPressGestureRecognizer*)sender{
    if (self.close) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateBegan) {
        // do something
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"删除提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        
    }else if (sender.state == UIGestureRecognizerStateEnded){
        // do something
    }
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
       
    }else{
        self.myAction (self.doctor);
    }
}
-(void)deleteExpertAction:(LongPressAction)action{
    self.myAction =action;
}
-(NSMutableAttributedString *)renderWithStr:(NSString *)str color:(UIColor *)textColor{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attStr setAttributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, str.length)];
    return attStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
