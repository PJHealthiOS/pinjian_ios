//
//  
//  GuaHao
//
//  Created by qiye on 16/2/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteVO.h"

@protocol WriteIDcardViewDelegate <NSObject>
-(void) writeIDcardDelegate:(NSString*) content;
@end

@interface WriteIDcardView : UIView
@property(assign) id<WriteIDcardViewDelegate> delegate;
@end
