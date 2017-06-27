//
//  OrderSureView.m
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "OrderSureView.h"
#import "Utils.h"

@interface OrderSureView ()

@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation OrderSureView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"OrderSureView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        
        UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
        [_bgView setUserInteractionEnabled:YES];
        [_bgView addGestureRecognizer:tapGuesture1];
    }
    return self;
}

-(void)setName:(NSString*) _name content:(NSString*) _content
{
    _labName.text = [NSString stringWithFormat:@"%@, 您好！",_name];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm-HH:mm"];
    NSDate * newdate =[format dateFromString:_content];
    NSDate * curDate = [NSDate date];
    newdate = [newdate dateByAddingTimeInterval:-3600];
    NSTimeInterval secondsBetweenDates= [newdate timeIntervalSinceDate:curDate];
//    if(secondsBetweenDates < 0){
//        newdate = [newdate dateByAddingTimeInterval:3600];
//        secondsBetweenDates= [newdate timeIntervalSinceDate:curDate];
//    }
    int seconds = (int)secondsBetweenDates;
    NSString * longStr = [Utils DDHHMMformatFromSeconds:seconds];
    _labContent.attributedText = [Utils attributeString:@[@"您的挂号时间是",[Utils formateDateNoSS:newdate],@"，具体就诊时间请联系医院专员",@"。"] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:RGBAlpha(80, 206, 123, 1)},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:[UIColor blackColor]}]];
    _labContent.lineBreakMode = NSLineBreakByWordWrapping;
}

- (IBAction)onSure:(id)sender {
    if (_delegate) {
        [_delegate orderSureDelegate:YES];
    }
}

- (IBAction)onClose:(id)sender {
    if (_delegate) {
        [_delegate orderSureDelegate:NO];
    }
}

-(void) func1:(UITapGestureRecognizer *) tap{
    if (_delegate) {
        [_delegate orderSureDelegate:NO];
    }
}

@end
