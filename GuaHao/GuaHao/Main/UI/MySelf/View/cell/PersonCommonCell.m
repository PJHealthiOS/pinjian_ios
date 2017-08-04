//
//  PersonCommonCell.m
//  GuaHao
//
//  Created by qiye on 16/7/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PersonCommonCell.h"
#import "UIViewBorders.h"
#import "Utils.h"
@implementation PersonCommonCell{
    

    __weak IBOutlet UIImageView *imgIcon;
    __weak IBOutlet UILabel *labTitle;
    __weak IBOutlet UILabel *labContent;
    __weak IBOutlet UIImageView *imgRedDot;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addBottomBorderWithHeight:1.0 andColor:[Utils lineGray]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCell:(NSDictionary*)dic indexPth:(NSIndexPath *)indexPath
{
    [imgIcon setImage:[UIImage imageNamed:dic[@"icon"]]];
    labTitle.text = dic[@"title"];
    imgRedDot.hidden = YES;
    labContent.hidden = YES;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            labContent.hidden = NO;
            labContent.text = dic[@"content"];
            labContent.textAlignment = NSTextAlignmentRight;
        }else if (indexPath.row == 2) {
            imgRedDot.hidden = NO;
        }
    }
    if (self.isMyOrder) {
        imgRedDot.hidden = YES;
    }

}
@end
