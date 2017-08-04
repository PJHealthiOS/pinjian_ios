//
//  PersonCommonCell.h
//  GuaHao
//
//  Created by qiye on 16/7/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCommonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;
@property (assign, nonatomic) BOOL isMyOrder;
-(void)setCell:(NSDictionary*)dic indexPth:(NSIndexPath *)indexPath;
@end
