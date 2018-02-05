//
//  GHPayManager.h
//  GuaHao
//
//  Created by PJYL on 2018/1/23.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,GHPayType) {
    GHPayTypeAlipay = 1,            //支付宝
    GHPayTypeWX = 2         ///微信
};



typedef void  (^GHWXPayAction)(NSString *orderID, NSInteger errorCode);




@interface GHPayManager : NSObject

@property (nonatomic, copy)GHWXPayAction wxPayAction;





+(GHPayManager *)sharePayManager;

-(void)getPayWithPayType:(GHPayType)payType parameters:(NSDictionary *)parameters action:(GHWXPayAction)action;
/**
 *  微信支付，生成新的订单号
 */
-(void)getWXPayNewOrderWith:(NSDictionary *)parameters action:(GHWXPayAction)action;


/**
 *  支付宝支付，生成新的订单号
 */
-(void)getAliPayNewOrderWith:(NSDictionary *)parameters action:(GHWXPayAction)action;



@end
