//
//  EvaluateAlterView.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/22.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "EvaluateAlterView.h"

@interface EvaluateAlterView (){
    
}
@property (weak, nonatomic) IBOutlet UIButton *shopButton;

@end
@implementation EvaluateAlterView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"EvaluateAlterView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }return self;
}
- (IBAction)shopAction:(id)sender {
    self.myAction(YES);
}
-(void)clickShopAction:(ShopAction)action{
    self.myAction = action;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
