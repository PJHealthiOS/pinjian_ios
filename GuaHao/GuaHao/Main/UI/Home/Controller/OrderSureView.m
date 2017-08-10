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

@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labContent;

@end

@implementation OrderSureView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"OrderSureView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        containerView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        

    }
    return self;
}

-(void)setName:(NSString*) _name content:(NSString*) _content fromNormal:(BOOL)isNormal
{
    if (isNormal) {
        _labName.text = [NSString stringWithFormat:@"%@, 您好！",_name];
        
        _labContent.attributedText = [Utils attributeString:@[@"您挂号时间为",_content,@"的普通订单提交成功,品简专员将第一时间为您接单请耐心等待",@"。"] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:RGBAlpha(80, 206, 123, 1)},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:[UIColor blackColor]}]];
        _labContent.lineBreakMode = NSLineBreakByWordWrapping;
    }else{
        _labContent.text = _content;
    }
    
}


- (IBAction)sureAction:(id)sender {
    self.myAction(YES);
}


-(void)clickSureAction:(CustomerAlterAction)action{
    self.myAction = action;
}

@end
