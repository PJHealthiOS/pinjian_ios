//
//  ExpertAccTypeCell.h
//  GuaHao
//
//  Created by PJYL on 2016/10/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TypeIndexSelectBolck)(NSInteger index);

@interface ExpertAccTypeCell : UITableViewCell

@property (nonatomic, copy) TypeIndexSelectBolck myBlock;
-(void)typeSelect:(TypeIndexSelectBolck)block;
-(void)layoutSubviews:(NSInteger)index;
@end
