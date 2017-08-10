//
//  MemberAlterView.m
//  GuaHao
//
//  Created by PJYL on 2017/7/24.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "MemberAlterView.h"

@interface MemberAlterView (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;

@end


@implementation MemberAlterView

-(instancetype)initWithFrame:(CGRect)frame memberLevel:(int)memberLevel discountRate:(float)discountRate curAvailableTimes:(int)curAvailableTimes{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"MemberAlterView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        NSArray *levelArr = @[@"普通会员",@"白金会员",@"黄金会员",@"钻石会员",@"至尊会员",];
        self.levelLabel.text = [levelArr objectAtIndex:memberLevel - 1];
        self.discountLabel.text = [NSString stringWithFormat:@"%.1f折",discountRate *10];
        self.timesLabel.text = [NSString stringWithFormat:@"%d次",curAvailableTimes];
        
    }return self;
}

























-(void)clickShopAction:(SureAction)action{
    self.myAction = action;
}

- (IBAction)sureAction:(id)sender {
    [self removeFromSuperview];
    self.myAction(YES);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
