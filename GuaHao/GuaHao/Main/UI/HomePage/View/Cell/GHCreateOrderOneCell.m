//
//  GHCreateOrderOneCell.m
//  GuaHao
//
//  Created by PJYL on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHCreateOrderOneCell.h"

@interface GHCreateOrderOneCell (){
    
}

@property (weak, nonatomic) IBOutlet UIImageView *msgRedIcon;

@end
@implementation GHCreateOrderOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code[button setAdjustsImageWhenHighlighted:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hxMessage:) name:@"HXMessageEvent" object:nil];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    if (self.myBlock) {
        self.myBlock(sender.tag);
    }
}

#pragma mark - Internal
-(void)hxMessage:(NSNotification *)notification
{
    NSString * msg = notification.object;
    if (msg&&[msg isEqualToString:@"1"] ) {
        _msgRedIcon.hidden = NO;
    }else{
        _msgRedIcon.hidden = YES;
    }
}
-(void)clickButtonReturn:(ClickReturnBlock)block{
    self.myBlock = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
