//
//  ImageLookViewController.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/2.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteImageAction)(BOOL result);
@interface ImageLookViewController : UIViewController
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy)DeleteImageAction myAction;
-(void)deleteImage:(DeleteImageAction)action;
@end
