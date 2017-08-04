//
//  PacketInfoShareView.m
//  GuaHao
//
//  Created by PJYL on 2017/5/5.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "PacketInfoShareView.h"

@interface PacketInfoShareView (){
    
}
@property (weak, nonatomic) IBOutlet UIView *wxView;
@property (weak, nonatomic) IBOutlet UIView *friendView;

@end
@implementation PacketInfoShareView
- (IBAction)wxAction:(id)sender {
    self.myAction(YES);

}
- (IBAction)friendAction:(id)sender {
    self.myAction(NO);
}
-(void)clickAction:(ClickShareAction)action{
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
