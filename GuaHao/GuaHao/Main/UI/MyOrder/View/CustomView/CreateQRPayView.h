//
//  CreateQRPayView.h
//  GuaHao
//
//  Created by PJYL on 2016/11/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PaySuccessActionBlock)(BOOL payStatus);
@interface CreateQRPayView : UIView
@property(nonatomic, copy)PaySuccessActionBlock myBlock;
@property(nonatomic, strong)NSNumber *orderID;
@property(nonatomic, assign)BOOL isNormal;
-(void)returnPayStatus:(PaySuccessActionBlock)block;
-(void)getPayInfoWithType:(NSString *)typeStr;
-(void)createTimer;
@end
