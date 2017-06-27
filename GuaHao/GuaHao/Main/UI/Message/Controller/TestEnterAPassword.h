//
//  TestEnterAPassword.h
//  GuaHao
//
//  Created by 123456 on 16/2/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ApplyForWithdrawCash.h"

@protocol TestEnterAPasswordDelegate <NSObject>

-(void)testEnterAPasswordDelegate;

@end

@interface TestEnterAPassword : UIViewController

@property(nonatomic) ApplyForWithdrawCash * ApplyForW;
@property(assign) id<TestEnterAPasswordDelegate> delegate;

@end
