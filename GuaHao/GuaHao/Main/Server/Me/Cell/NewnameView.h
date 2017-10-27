//
//  NewnameView.h
//  GuaHao
//
//  Created by 123456 on 16/5/28.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVO.h"

@protocol NewnameDelegate <NSObject>
-(void)informationDelegate:(UserVO*) vo;
@end

@interface NewnameView : UIView

@property(assign) id<NewnameDelegate> delegate;
-(void)setUser:(UserVO*) _UserV;

@end
