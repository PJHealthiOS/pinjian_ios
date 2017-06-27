//
//  DayCell.m
//  GuaHao
//
//  Created by qiye on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "DateDayCell.h"
#import "Utils.h"
#import "UIViewBorders.h"

@interface DateDayCell ()
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labWeek;
@property (weak, nonatomic) IBOutlet UIImageView *imageUp;
@property (weak, nonatomic) IBOutlet UIImageView *imageDown;
@property (weak, nonatomic) IBOutlet UILabel *labUp;
@property (weak, nonatomic) IBOutlet UILabel *labDown;

@end

@implementation DateDayCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"DateDayCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        _labUp.text = @"";
        _labDown.text = @"";

        UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
        [_imageUp setUserInteractionEnabled:YES];
        [_imageUp addGestureRecognizer:tapGuesture1];
        UITapGestureRecognizer * tapGuesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func2:)];
        [_imageDown setUserInteractionEnabled:YES];
        [_imageDown addGestureRecognizer:tapGuesture2];
        [self addRightBorderWithWidth:1.0 andColor:RGBAlpha(235,235,235,1.0)];
    }
    return self;
}

-(void)setCell
{
    [_imageUp setImage:[UIImage imageNamed:@"order_expert_desc_white_big.png"]];
    [_imageDown setImage:[UIImage imageNamed:@"order_expert_desc_white_big.png"]];
    _labDate.text = [Utils formateStrToMMDD:_dayVO.scheduleDate];
    _labWeek.text = [Utils formateStrToWeek:_dayVO.scheduleDate];
    _labUp.text = @"";
    _labDown.text = @"";
    if (_dayVO.upSDay) {
        [_imageUp setImage:[UIImage imageNamed:@"order_expert_dec_big2.png"]];
        _labUp.text = @"可约";
    }
    if (_dayVO.downSDay) {
        [_imageDown setImage:[UIImage imageNamed:@"order_expert_dec_big2.png"]];
        _labDown.text = @"可约";
    }
}

-(void) func1:(UITapGestureRecognizer *) tap{
    if(_delegate&&_dayVO.upSDay){
        [_delegate delegateDateDayCell:_dayVO.upSDay];
    }
}

-(void) func2:(UITapGestureRecognizer *) tap{
    if(_delegate&&_dayVO.downSDay){
        [_delegate delegateDateDayCell:_dayVO.downSDay];
    }
}

@end
