//
//  GHAcceptOrderStatusCell.m
//  GuaHao
//
//  Created by PJYL on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHAcceptOrderStatusCell.h"
#import "StatusLogVO.h"
@interface GHAcceptOrderStatusCell (){
    
}
@property (weak, nonatomic)  UILabel *statusLabel1;
@property (weak, nonatomic)  UILabel *statusLabel2;
@property (weak, nonatomic)  UILabel *statusLabel3;
@property (weak, nonatomic)  UILabel *statusLabel4;
@property (weak, nonatomic)  UIImageView *statusImage1;
@property (weak, nonatomic)  UIImageView *statusImage2;
@property (weak, nonatomic)  UIImageView *statusImage3;
@property (weak, nonatomic)  UIImageView *statusImage4;
@property (weak, nonatomic)  UIView *statusLine1;
@property (weak, nonatomic)  UIView *statusLIne2;
@property (weak, nonatomic)  UIView *statusLine3;

@end

@implementation GHAcceptOrderStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviewsWithLogs:(NSArray *)source{
    
    UIImage *imageselect = [UIImage imageNamed:@"order_detail_status_select.png"];
    UIImage *imagenormal = [UIImage imageNamed:@"order_detail_status_normal.png"];
    
    for (int i = 0; i < source.count; i++) {
        StatusLogVO *model = [source objectAtIndex:i];
    
        UILabel *label = (UILabel *)[self.contentView viewWithTag:20000 + i];
        label.text = model.name;
        
        UIImageView * imageView = (UIImageView *)[self.contentView viewWithTag:30000 + i];

        imageView.image = model.isChecked == 1 ? imageselect : imagenormal;
        
        [self.contentView addSubview:label];
        [self.contentView addSubview:imageView];
        
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(int)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSMutableArray *source =[NSMutableArray arrayWithArray: @[@"待支付",@"待接单",@"待挂号",@"待就诊"]];
        if (type != 1) {
            [source removeLastObject];
        }
        CGFloat centerX = SCREEN_WIDTH / (source.count *2.0);
        
        UIView *lineView = [[UIView alloc]initWithFrame: CGRectMake(centerX, 50, SCREEN_WIDTH - 2 * centerX, 1)];
        lineView.backgroundColor = RGB(230, 230, 230);
        [self.contentView addSubview:lineView];
        
        UIImage *imagenormal = [UIImage imageNamed:@"order_detail_status_normal.png"];
        
        
        for (int i = 0; i < source.count; i++) {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/source.count, 15)];
            label.center = CGPointMake(centerX, 25);
            label.text = [source objectAtIndex:i];;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 20000 + i;
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
            imageView.center = CGPointMake(centerX, 50);
            imageView.image = imagenormal;
            imageView.tag = 30000 + i;
            
            [self.contentView addSubview:label];
            [self.contentView addSubview:imageView];
            
            centerX = centerX + SCREEN_WIDTH / source.count;
        }

    
    
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
