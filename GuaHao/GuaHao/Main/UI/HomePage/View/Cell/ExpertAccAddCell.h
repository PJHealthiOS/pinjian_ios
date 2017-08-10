//
//  ExpertAccAddCell.h
//  GuaHao
//
//  Created by PJYL on 2016/10/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^ReturnValueBlock)(NSString * value);
@interface ExpertAccAddCell : UITableViewCell
@property (nonatomic,copy)ReturnValueBlock myBlock;
@property (weak, nonatomic) IBOutlet UITextField *textField;
-(void)returnValue:(ReturnValueBlock)block;
@end
