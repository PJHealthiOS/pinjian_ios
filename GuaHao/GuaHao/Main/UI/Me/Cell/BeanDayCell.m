//
//  DayCell.m
//  GuaHao
//
//  Created by qiye on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "BeanDayCell.h"
#import "Utils.h"

@interface BeanDayCell ()
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UIImageView *imageUp;
@property (weak, nonatomic) IBOutlet UILabel *labUp;

@end

@implementation BeanDayCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"BeanDayCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}

-(void)setCell
{
    [_imageUp setImage:[UIImage imageNamed:@"point_circle_gray.png"]];
    _labDate.attributedText = [Utils attributeString:@[[Utils formateStrToMMDD:_dateVO.date]] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:[UIColor lightGrayColor]}]];
    _labUp.attributedText = [Utils attributeString:@[[NSString stringWithFormat:@"+%@",_dateVO.presentedPointNum]] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:18], NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    NSDate * date = [NSDate new];
    if([[Utils formateDay3:date] isEqualToString:_dateVO.date]){
        [_imageUp setImage:[UIImage imageNamed:_dateVO.sign?@"point_circle_white.png":@"point_circle_green.png"]];
        _labDate.attributedText = [Utils attributeString:@[@"今日"] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:RGBAlpha(60,179,113,1)}]];
        _labUp.attributedText = [Utils attributeString:@[[NSString stringWithFormat:@"+%@",_dateVO.presentedPointNum]] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:18], NSForegroundColorAttributeName:RGBAlpha(60,179,113,1)}]];
        if(!_dateVO.sign)_labUp.attributedText = [Utils attributeString:@[[NSString stringWithFormat:@"+%@",_dateVO.presentedPointNum]] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:18], NSForegroundColorAttributeName:RGBAlpha(60,179,113,1)}]];
    }
}



@end
