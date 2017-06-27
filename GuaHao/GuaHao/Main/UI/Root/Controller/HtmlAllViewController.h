//
//  HtmlAllViewController.h
//  Pinjian
//
//  Created by qiye on 15/11/24.
//  Copyright © 2015年 fangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickToSomePageAction)(NSString *funStr);
@interface HtmlAllViewController : UIViewController
@property (nonatomic, copy)ClickToSomePageAction myAction;

@property (copy) NSString *  mUrl;
@property (copy) NSString *  mTitle;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isTest;
@property(nonatomic,assign)BOOL withoutToken;

-(void)setURL:(NSString*)_url title:(NSString*)_title;
-(void)clickToPage:(ClickToSomePageAction)action;
@end

