//
//  CommentView.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/13.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SendCommentBlock)(NSString *result);

@interface CommentView : UIView
@property (nonatomic, copy)SendCommentBlock myBlock;
-(void)sendCommentMessage:(SendCommentBlock)block;


@end
