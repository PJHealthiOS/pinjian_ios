//
//  AddPersonInputCell.h
//  GuaHao
//
//  Created by 123456 on 16/8/1.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^ReturnValueBlock)(NSString * value,NSIndexPath *index);

@interface AddPersonInputCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *mustImage;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *speatView;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property(nonatomic,copy)ReturnValueBlock myblock;

-(void)returnValue:(ReturnValueBlock)block;

+ (instancetype)renderCell:(AddPersonInputCell *)cell typeStr:(NSString *)typeStr valueStr:(NSString *)valueStr indexPath:(NSIndexPath *)indexPath;
@end
