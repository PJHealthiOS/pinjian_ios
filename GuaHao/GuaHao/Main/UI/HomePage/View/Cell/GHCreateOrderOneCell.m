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

@property (weak, nonatomic) IBOutlet UIImageView *oneIconImage;
@property (weak, nonatomic) IBOutlet UILabel *oneTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneDescLabel;

@property (weak, nonatomic) IBOutlet UIImageView *twoIconImage;
@property (weak, nonatomic) IBOutlet UILabel *twoTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoDescLabel;

@property (weak, nonatomic) IBOutlet UIImageView *threeIconImage;
@property (weak, nonatomic) IBOutlet UILabel *threeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeDescLabel;

@property (weak, nonatomic) IBOutlet UIImageView *fourIconImage;
@property (weak, nonatomic) IBOutlet UILabel *fourTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourDescLabel;




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
