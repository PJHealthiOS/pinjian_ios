//
//  CreateOrderExpertCell.h
//  GuaHao
//
//  Created by PJYL on 16/9/1.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrderExpertCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabelLeftSpeace;
+ (instancetype)renderCell:(CreateOrderExpertCell *)cell typeStr:(NSString *)typeStr valueStr:(NSString *)valueStr indexPath:(NSIndexPath *)indexPath;
@end
