//
//  PacketInfoShareView.h
//  GuaHao
//
//  Created by PJYL on 2017/5/5.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickShareAction)(BOOL leftClick);
@interface PacketInfoShareView : UIView
@property (nonatomic, copy) ClickShareAction myAction;
-(void)clickAction:(ClickShareAction)action;
@end
