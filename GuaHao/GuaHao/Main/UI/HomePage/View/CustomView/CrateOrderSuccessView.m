//
//  CrateOrderSuccessView.m
//  GuaHao
//
//  Created by PJYL on 2017/4/27.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "CrateOrderSuccessView.h"

@interface CrateOrderSuccessView (){
    
}

@end
@implementation CrateOrderSuccessView
- (IBAction)okAction:(UIButton *)sender {
    self.myAction(YES);
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"CrateOrderSuccessView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }return self;
}

-(void)clickShopAction:(OkAction)action{
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
