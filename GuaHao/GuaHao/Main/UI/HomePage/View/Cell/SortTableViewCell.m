//
//  SortTableViewCell.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/24.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SortTableViewCell.h"

@interface SortTableViewCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation SortTableViewCell
-(void)setTypeNmae:(NSString *)typeNmae{
    self.contentLabel.text = typeNmae;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
