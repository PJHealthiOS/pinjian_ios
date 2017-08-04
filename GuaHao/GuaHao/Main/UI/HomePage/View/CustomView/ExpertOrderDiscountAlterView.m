//
//  ExpertOrderDiscountAlterView.m
//  GuaHao
//
//  Created by PJYL on 2017/7/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "ExpertOrderDiscountAlterView.h"

@interface ExpertOrderDiscountAlterView (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *desc_label;

@end
@implementation ExpertOrderDiscountAlterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"ExpertOrderDiscountAlterView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self changeLabel:self.desc_label withTextColor:UIColorFromRGB(0x45c768)];
    }return self;
}

-(void)clickAction:(AlterSureAction)action{
    self.myAction = action;
}

- (void)changeLabel:(UILabel *)label withTextColor:(UIColor *)color {
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@".",@"~",@"周"];
    NSString *content = label.text;
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    for (int i = 0; i < content.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(i, 1)];
        }
        
    }
    //完成查找数字，最后将带有字体下划线的字符串显示在UILabel上
    label.attributedText = attributeString;
    
    
}

- (IBAction)cancelAction:(id)sender {
    self.myAction(NO);
    [self removeFromSuperview];
}
- (IBAction)sureAction:(id)sender {
    self.myAction(YES);
    [self removeFromSuperview];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
