//
//  DayCell.m
//  GuaHao
//
//  Created by qiye on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "DayCell.h"
#import "Utils.h"
#import "UIViewBorders.h"

@interface DayCell ()
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labWeek;
@property (weak, nonatomic) IBOutlet UIImageView *imageUp;
@property (weak, nonatomic) IBOutlet UIImageView *imageDown;
@property (weak, nonatomic) IBOutlet UILabel *labUp;
@property (weak, nonatomic) IBOutlet UILabel *labDown;

@end

@implementation DayCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"DayCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
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
        [self addTopBorderWithHeight:1.0 andColor:[Utils lineGray]];
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
    if (_dayVO.upDay.apm&&[_dayVO.upDay.apm isEqualToString:@"上午"]) {
        if ([_dayVO.upDay.clinicType isEqualToString:@"约满"]){
            [_imageUp setImage:[UIImage imageNamed:@"order_expert_dec_no.png"]];
            NSString * str =[NSString stringWithFormat:@"%@",_dayVO.upDay.clinicType];
            _labUp.attributedText = [Utils attributeString:@[str] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14], NSForegroundColorAttributeName:[UIColor colorWithRed:255.0f/255.0f green:192.0f/255.0f blue:203.0f/255.0f alpha:1.0]}]];
        }else{
            [_imageUp setImage:[UIImage imageNamed:@"order_expert_dec_big2.png"]];
            NSString * str =[NSString stringWithFormat:@"%@",_dayVO.upDay.clinicType];
            _labUp.attributedText = [Utils attributeString:@[str] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14], NSForegroundColorAttributeName:[UIColor colorWithRed:144.0f/255.0f green:238.0f/255.0f blue:144.0f/255.0f alpha:1.0]}]];
        }
    }
    if (_dayVO.downDay.apm&&[_dayVO.downDay.apm isEqualToString:@"下午"]) {

        if ([_dayVO.upDay.clinicType isEqualToString:@"约满"]){
            [_imageDown setImage:[UIImage imageNamed:@"order_expert_dec_no.png"]];
            NSString * str =[NSString stringWithFormat:@"%@",_dayVO.upDay.clinicType];
            _labDown.attributedText = [Utils attributeString:@[str] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14], NSForegroundColorAttributeName:[UIColor colorWithRed:255.0f/255.0f green:192.0f/255.0f blue:203.0f/255.0f alpha:1.0]}]];
        }else{
            [_imageDown setImage:[UIImage imageNamed:@"order_expert_dec_big2.png"]];
            NSString * str =[NSString stringWithFormat:@"%@",_dayVO.downDay.clinicType];
            _labDown.attributedText = [Utils attributeString:@[str] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14], NSForegroundColorAttributeName:[UIColor colorWithRed:144.0f/255.0f green:238.0f/255.0f blue:144.0f/255.0f alpha:1.0]}]];
        }
    }
}

-(void) func1:(UITapGestureRecognizer *) tap{
    if(_delegate&&_dayVO.upDay.apm&&[_dayVO.upDay.apm isEqualToString:@"上午"]&&_dayVO.upDay.clickable){
        [_delegate delegateSelectDayCell:_dayVO.upDay];
    }
}

-(void) func2:(UITapGestureRecognizer *) tap{
    if(_delegate&&_dayVO.downDay.apm&&[_dayVO.downDay.apm isEqualToString:@"下午"]&&_dayVO.downDay.clickable){
        [_delegate delegateSelectDayCell:_dayVO.downDay];
    }
}

@end
