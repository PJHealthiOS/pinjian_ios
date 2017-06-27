//
//  EvaluateSelectView.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/20.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "EvaluateSelectView.h"

@interface EvaluateSelectView (){
    
}
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;
@property (strong, nonatomic) NSMutableArray *btnArr;
@property (assign, nonatomic) BOOL isSmile;
@end
@implementation EvaluateSelectView

-(instancetype)initWithFrame:(CGRect)frame isSmile:(BOOL)isSmile{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"EvaluateSelectView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.btnArr = [NSMutableArray arrayWithObjects:self.firstButton,self.secondButton,self.thirdButton,self.fourButton,self.fiveButton, nil];
        self.isSmile = isSmile;
        [self initCell];
    }
    return self;
}
-(void)initCell{
    for (int i = 0; i < self.btnArr.count; i++) {
        UIButton *btn = (UIButton *)[self.btnArr objectAtIndex:i];
        btn.selected = NO;
        [self setButtonImage:btn];
    }
}
-(void)setButtonImage:(UIButton *)button{
    [button setImage:[UIImage imageNamed:self.isSmile ? @"smile_normal":@"star_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:self.isSmile ? @"smile_select":@"star_select"] forState:UIControlStateSelected];
}

- (IBAction)buttonSelectAction:(UIButton *)sender {
    if (!self.canClick) {
        return;
    }
    if (sender.selected) {//
        [self initCell];
    }
    [self updateCell:((short)sender.tag - 12000) canClick:YES];
    self.myAction(sender.tag - 12000);
}


-(void)updateCell:(int)index canClick:(BOOL)canClick{
    for (int i = 0; i < self.btnArr.count; i++) {
        UIButton *button = (UIButton *)[self.btnArr objectAtIndex:i];
        if (i < index) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        
    }
    
}
-(void)butonClickAction:(ClickButtonAction)action{
    self.myAction = action;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
