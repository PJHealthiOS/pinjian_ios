//
//  LocationTableViewCell.m
//  GuaHao
//
//  Created by qiye on 16/2/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell{
    
    __weak IBOutlet UILabel *nameLab;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(SiteVO*) vo{
    
    nameLab.text = vo.name;
}
@end
