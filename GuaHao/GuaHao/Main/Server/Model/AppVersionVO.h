//
//  AppVersionVO.h
//  GuaHao
//
//  Created by qiye on 16/9/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "VersionVO.h"
#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface AppVersionVO : NSObject
@property(strong) NSString * advImgUrl;
@property(strong) NSString * advLinkUrl;
@property(strong) VersionVO * version;
@end
