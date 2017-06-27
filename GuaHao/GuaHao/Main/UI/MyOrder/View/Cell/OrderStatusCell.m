//
//  OrderStatusCell.m
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "OrderStatusCell.h"
@interface OrderStatusCell (){
    
}

@property (strong, nonatomic)  UIImageView *orderStatusImage;
@property (strong, nonatomic)  UILabel *orderStatusLabel;
@property (strong, nonatomic)  UILabel *orderStatusDescribeLabel;
@property (strong, nonatomic)  UIView *statusBackView;

@end
@implementation OrderStatusCell
+ (instancetype)renderCell:(OrderStatusCell *)cell order:(OrderVO *)order{
    
    
    if (!order) {
        return cell;
    }
    
    NSDictionary *dic = @{@"1":@"order_detail_status_pay.png",@"2":@"order_detail_status_accept.png",@"3":@"order_detail_status_accept.png",@"4":@"order_detail_status_accept.png",@"9":@"order_detail_status_end.png",@"10":@"order_detail_status_end.png"};
    
    cell.orderStatusImage.image = [UIImage imageNamed:[dic objectForKey:[NSString stringWithFormat:@"%@",order.status]]];
    cell.orderStatusLabel.text = order.statusCn;
    cell.orderStatusDescribeLabel.text = order.statusDesc;

    
    

    [cell layoutSubviewsWithLogs:order.statusLogs];
    return cell;
}
+ (instancetype)AccrenderCell:(OrderStatusCell *)cell order:(AccDetialVO *)order{
    
    
    if (!order) {
        return cell;
    }
    
    NSDictionary *dic = @{@"1":@"order_detail_status_pay.png",@"2":@"order_detail_status_accept.png",@"3":@"order_detail_status_accept.png",@"4":@"order_detail_status_accept.png",@"9":@"order_detail_status_end.png",@"10":@"order_detail_status_end.png"};
    
    cell.orderStatusImage.image = [UIImage imageNamed:[dic objectForKey:[NSString stringWithFormat:@"%@",order.status]]];
    cell.orderStatusLabel.text = order.statusCn;
    cell.orderStatusDescribeLabel.text = order.statusDesc;
    
    
    
    
    [cell layoutSubviewsWithLogs:order.statusLogs];
    return cell;
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
        
//        [self.statusBackView addSubview:label];
//        [self.statusBackView addSubview:imageView];
        
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type{//0挂号 1预约
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.statusBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 80)];
        self.statusBackView.backgroundColor = RGB(244, 249, 245);
        [self.contentView addSubview:self.statusBackView];
        
        self.orderStatusImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 44, 44)];
        self.orderStatusImage.tag = 10001;
        self.orderStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.orderStatusImage.frame) + 10, CGRectGetMinY(self.orderStatusImage.frame), SCREEN_WIDTH - CGRectGetMaxX(self.orderStatusImage.frame) -10, 21)];
        self.orderStatusLabel.font = [UIFont systemFontOfSize:15];
        self.orderStatusLabel.tag = 10002;
        self.orderStatusDescribeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.orderStatusImage.frame) + 10, CGRectGetMaxY(self.orderStatusLabel.frame), SCREEN_WIDTH - CGRectGetMaxX(self.orderStatusImage.frame) -20, 40)];
        self.orderStatusDescribeLabel.numberOfLines = 0;
        self.orderStatusDescribeLabel.font = [UIFont systemFontOfSize:12];
        self.orderStatusDescribeLabel.tag = 10003;
        [self.contentView addSubview:self.orderStatusImage];
        [self.contentView addSubview:self.orderStatusLabel];
        [self.contentView addSubview:self.orderStatusDescribeLabel];
        
        NSMutableArray *source =[NSMutableArray arrayWithArray: @[@"待支付",@"待接单",@"待挂号",@"待就诊"]];
        if (type == 3) {
            [source removeLastObject];
        }
        CGFloat centerX = SCREEN_WIDTH / (source.count *2.0);
        
        UIView *lineView = [[UIView alloc]initWithFrame: CGRectMake(centerX, 50, SCREEN_WIDTH - 2 * centerX, 1)];
        lineView.backgroundColor = RGB(230, 230, 230);
        [self.statusBackView addSubview:lineView];
        
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
            
            [self.statusBackView addSubview:label];
            [self.statusBackView addSubview:imageView];
            
            centerX = centerX + SCREEN_WIDTH / source.count;
        }
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
