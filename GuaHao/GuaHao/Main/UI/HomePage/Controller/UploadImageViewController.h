//
//  UploadImageViewController.h
//  GuaHao
//
//  Created by PJYL on 2016/10/20.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef void(^RemarkDescriptionBlock)(NSArray *images,NSString *remark);
@interface UploadImageViewController : UIViewController


@property(copy, nonatomic)RemarkDescriptionBlock myBlock;
-(void)returnDataBlock:(RemarkDescriptionBlock)block;

@end
