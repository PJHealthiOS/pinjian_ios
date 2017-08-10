//
//  AddPersonSelectCell.h
//  GuaHao
//
//  Created by 123456 on 16/8/1.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPersonSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImage;
+ (instancetype)renderCell:(AddPersonSelectCell *)cell typeStr:(NSString *)typeStr valueStr:(NSString *)valueStr indexPath:(NSIndexPath *)indexPath;
@end
