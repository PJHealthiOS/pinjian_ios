//
//  VersionVO.h
//  GuaHao
//
//  Created by qiye on 16/2/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface VersionVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSString * versionName;
@property(strong) NSString * versionId;
@property(strong) NSString * downloadUrl;
@property(strong) NSString * serverUrl;
@property(assign) BOOL isAppstoreAudit;
@property BOOL  isForceUpdate;
@end
