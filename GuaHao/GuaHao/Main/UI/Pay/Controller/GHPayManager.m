//
//  GHPayManager.m
//  GuaHao
//
//  Created by PJYL on 2018/1/23.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import "GHPayManager.h"
#import "payRequsestHandler.h"
#import <AlipaySDK/AlipaySDK.h>


@implementation GHPayManager
+(GHPayManager *)sharePayManager{
    static dispatch_once_t onceToken;
    static GHPayManager *payManager;
    dispatch_once(&onceToken, ^{
        payManager = [[GHPayManager alloc]init];

    });
    return payManager;
}

-(void)getPayWithPayType:(GHPayType)payType parameters:(NSDictionary *)parameters action:(GHWXPayAction)action{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxPayBack" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payBack:) name:@"wxPayBack" object:nil];
    switch (payType) {
        case GHPayTypeWX:
        {
            if (![WXApi isWXAppInstalled]) {
                //        [RSProgressHUD showErrorWithStatus:@"您未安装微信客户端"];
                return;
            };
           

            self.wxPayAction = action;
//            payRequsestHandler *req = [[payRequsestHandler alloc] init];
            //初始化支付签名对象
//            [req init:APP_ID mch_id:MCH_ID];
            //设置密钥
//            [req setKey:PARTNER_ID];
            if (parameters.count > 0) {
                NSMutableString *stamp  = [parameters objectForKey:@"timestamp"];
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [parameters objectForKey:@"appid"];
                req.partnerId           = [parameters objectForKey:@"partnerid"];
                req.prepayId            = [parameters objectForKey:@"prepayid"];
                req.nonceStr            = [parameters objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [parameters objectForKey:@"package"];
                req.sign                = [parameters objectForKey:@"sign"];
                [WXApi sendReq:req];
            }
        }
            break;
        case GHPayTypeAlipay:
        {
            self.wxPayAction = action;
            
           
            [[AlipaySDK defaultService] payOrder:[parameters objectForKey:@"orderString"] fromScheme:@"pinjianguahao" callback:^(NSDictionary *resultDic) {
                NSLog(@"支付宝支付回调----%@",resultDic);
                NSString *codeStr = [resultDic objectForKey:@"resultStatus"];
                switch (codeStr.integerValue) {
                    case 9000:{///成功
                        self.wxPayAction(@"", 0);
                    }
                        break;
                    case 6001:{///取消
                        self.wxPayAction(@"", 1);
                    }
                        break;
                        
                    default:{///失败
                        self.wxPayAction(@"", 2);
                    }
                        break;
                }
                
                
                
            }];
            
        }
            break;
        default:{
//            self.wxPayAction(@"", 2);
            NSLog(@"支付类型错误");
        }
            break;
    }
            
}







/**
 *  微信支付，生成新的订单号
 */
-(void)getWXPayNewOrderWith:(NSDictionary *)parameters action:(GHWXPayAction)action{
    if (![WXApi isWXAppInstalled]) {
        //        [RSProgressHUD showErrorWithStatus:@"您未安装微信客户端"];
        return;
    };
    self.wxPayAction = action;
//    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
//    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
//    [req setKey:PARTNER_ID];
    if (parameters.count > 0) {
        NSMutableString *stamp  = [parameters objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [parameters objectForKey:@"appid"];
        req.partnerId           = [parameters objectForKey:@"partnerid"];
        req.prepayId            = [parameters objectForKey:@"prepayid"];
        req.nonceStr            = [parameters objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [parameters objectForKey:@"package"];
        req.sign                = [parameters objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
    
    
}


/**
 *  支付宝支付，生成新的订单号
 */
-(void)getAliPayNewOrderWith:(NSDictionary *)parameters action:(GHWXPayAction)action{
    self.wxPayAction = action;
    [[AlipaySDK defaultService]payOrder:@"1234567876543" fromScheme:@"pinjianguahao" callback:^(NSDictionary *resultDic) {
        NSLog(@"支付宝支付回调----%@",resultDic);
        NSString *codeStr = [resultDic objectForKey:@"resultStatus"];
        switch (codeStr.integerValue) {
            case 9000:{///成功
                self.wxPayAction(@"", 0);
            }
                break;
            case 6001:{///取消
                self.wxPayAction(@"", 1);
            }
                break;
            
            default:{///失败
                self.wxPayAction(@"", 2);
            }
                break;
        }
        
        
        
    }];
    
    
    
}



-(void)payBack:(NSNotification *)notification{
    ///收到支付宝、微信支付回调
    NSDictionary *infoDic = [notification object];
    NSString *errCode = [infoDic objectForKey:@"errCode"];
    switch (errCode.integerValue) {
        case 0:{///成功
            self.wxPayAction(@"", 0);
        }
            break;
        case -2:{///取消
            self.wxPayAction(@"", 1);
        }
            break;
            
        default:{///失败
            self.wxPayAction(@"", 2);
        }
            break;
    }
    
    
}










@end
