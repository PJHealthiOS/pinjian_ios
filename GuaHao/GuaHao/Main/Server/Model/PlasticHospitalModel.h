//
//  PlasticHospitalModel.h
//  GuaHao
//
//  Created by PJYL on 2018/6/29.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface PlasticHospitalModel : NSObject
@property(copy) NSString * deptComments;
@property(copy) NSString * level;
@property(copy) NSString * longitude;
@property(copy) NSString * latitude;
@property(copy) NSString * image;
@property(copy) NSString * name;
@property(copy) NSString * deptName;
@property(copy) NSString * address;
@property(strong) NSNumber * id;

@end
