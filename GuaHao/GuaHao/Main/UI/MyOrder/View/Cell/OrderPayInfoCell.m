//
//  OrderPayInfoCell.m
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "OrderPayInfoCell.h"
#import "OrderDetailPriceView.h"

@interface OrderPayInfoCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *waitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *realPayLabel;

@property (strong, nonatomic) OrderDetailPriceView *orderPriceView;


@end
@implementation OrderPayInfoCell
+ (instancetype)renderCell:(OrderPayInfoCell *)cell order:(OrderVO *)order{

    
    NSString *serviceFee = [NSString stringWithFormat:@"%@",[[order.orderFeeFrom objectAtIndex:0] objectForKey:@"value"]];
    NSString *orderFee = [NSString stringWithFormat:@"%@",[[order.orderFeeFrom objectAtIndex:1] objectForKey:@"value"]];
    NSString *couponsePay = [NSString stringWithFormat:@"%@",[[order.orderFeeTo objectAtIndex:0] objectForKey:@"value"]];
    NSString *discountPay = [NSString stringWithFormat:@"%@",[[order.orderFeeTo objectAtIndex:1] objectForKey:@"value"]];
    NSString *actualPay = [NSString stringWithFormat:@"%@",order.actualPay];

    NSArray *reportSourceArr = @[@{@"type":[[order.orderFeeFrom objectAtIndex:0] objectForKey:@"name"],@"value":serviceFee,@"hidden":@"0"},@{@"type":[[order.orderFeeFrom objectAtIndex:1] objectForKey:@"name"],@"value":orderFee,@"hidden":@"1"},@{@"type":[[order.orderFeeTo objectAtIndex:0] objectForKey:@"name"],@"value":couponsePay,@"hidden":@"0"},@{@"type":[[order.orderFeeTo objectAtIndex:1] objectForKey:@"name"],@"value":discountPay,@"hidden":@"1"},@{@"type":@"实际支付",@"value":actualPay,@"hidden":@"0"}];
    cell.orderPriceView= [[OrderDetailPriceView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5 * 44)];
    [cell.orderPriceView reloadTableViewWithSourceArr:reportSourceArr];
    [cell.contentView addSubview:cell.orderPriceView];
    
    return cell;
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
