//
//  MessageVO.h
//  GuaHao
//
//  Created by qiye on 16/2/18.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "UserVO.h"
#import "MsgTypeVO.h"

@interface MessageVO : NSObject

@property(strong) NSNumber * id;
@property(strong) NSNumber   * type;
@property(strong) NSString   * title;
@property(strong) NSString   * content;

@property(strong) NSString   * createDate;
@property(strong) NSString   * extraData;
@property  BOOL  readed;

@end
