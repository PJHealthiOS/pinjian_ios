//
//  NormalNewsCell.m
//  GuaHao
//
//  Created by 123456 on 16/1/28.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "NormalNewsCell.h"
#import "Utils.h"

@interface NormalNewsCell(){
    
}
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rowImage;

@end

@implementation NormalNewsCell
    


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
 
-(void) setCell:(MessageVO*) vo
{
    self.descLabel.text = vo.content;
    self.dateLabel.text = vo.createDate;
    
    if (vo.type.intValue == 6 ||vo.type.intValue == 9 ||(vo.type.intValue>13&&vo.type.intValue<21)) {
        self.operationLabel.text = @"暂无详情";
        self.rowImage.hidden = YES;
    }else{
        self.rowImage.hidden = NO;
        self.operationLabel.text = @"查看详情";

    }
    self.typeLabel.text = vo.title;
//    titleLab.attributedText = [Utils attributeString:@[vo.title] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:vo.readed?[UIColor grayColor]:[UIColor blackColor]}]];
}

@end
