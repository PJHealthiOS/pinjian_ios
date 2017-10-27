//
//  ShareNoteCell.m
//  GuaHao
//
//  Created by qiye on 16/7/7.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ShareNoteCell.h"
#import "ShareLogVO.h"
#import "Utils.h"
#import "UIViewBorders.h"
@implementation ShareNoteCell{
    
    __weak IBOutlet UILabel *labDate;
    __weak IBOutlet UILabel *labTip;
    __weak IBOutlet UILabel *labName;
    __weak IBOutlet UIImageView *imgRectBg;
    __weak IBOutlet UILabel *labStatus;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addBottomBorderWithHeight:1.0 andColor:RGBAlpha(241,241,241,1.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(ShareLogVO*)vo
{
    if([vo isKindOfClass:[ShareLogVO class]]){
        if(vo.withdrawal){
            labName.attributedText = [Utils attributeString:@[vo.name] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:[UIColor orangeColor]}]];
        }else{
            labName.attributedText = [Utils attributeString:@[vo.name] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11], NSForegroundColorAttributeName:[UIColor blackColor]}]];
        }
        labDate.text = vo.createDate;
        labStatus.text = vo.statusCn;
        labTip.attributedText = [Utils attributeString:@[vo.desc,@",奖励",vo.money.stringValue,@"元"] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:9]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:9]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:9], NSForegroundColorAttributeName:[UIColor orangeColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:9]}]];
        imgRectBg.image = [UIImage imageNamed:vo.status.intValue==3?@"share_btn_gray.png":@"share_btn_green.png"];
    }

}

@end
