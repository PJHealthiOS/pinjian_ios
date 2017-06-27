//
//  CreateOrderSubmitCell.h
//  GuaHao
//
//  Created by PJYL on 2016/11/9.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitActionBlock)(BOOL isSubmit);
@interface CreateOrderSubmitCell : UITableViewCell
@property (copy, nonatomic)SubmitActionBlock myBlock;
-(void)submitAction:(SubmitActionBlock)block;
@end
