//
//  TicketVO.h
//  GuaHao
//
//  Created by qiye on 16/2/23.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface TicketVO : NSObject

@property(strong) NSNumber   * id;
@property(strong) NSString   * imgUrl;
@property(strong) NSNumber   * status;// 0 未操作  1待审核 2 审核通过 3审核失败

@end
