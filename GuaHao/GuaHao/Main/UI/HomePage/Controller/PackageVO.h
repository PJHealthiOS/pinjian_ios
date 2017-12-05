//
//  PackageVO.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface PackageVO : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSNumber * id;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * img;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * subtitle;
@end
