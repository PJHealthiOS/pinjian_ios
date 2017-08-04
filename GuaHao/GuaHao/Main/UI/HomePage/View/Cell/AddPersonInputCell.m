//
//  AddPersonInputCell.m
//  GuaHao
//
//  Created by 123456 on 16/8/1.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AddPersonInputCell.h"

@interface AddPersonInputCell (){
    NSInteger row;
}

@end
@implementation AddPersonInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)endEditingAction:(id)sender {
    if (self.myblock != nil ) {
        self.myblock(_textField.text,self.indexPath);
    }

}
- (IBAction)change:(UITextField *)sender {
    if (sender.text.length == 0) {
        if (self.myblock != nil ) {
            self.myblock(_textField.text,self.indexPath);
        }
        NSLog(@"删除完了");
    }
}




-(void)returnValue:(ReturnValueBlock)block{
    self.myblock = block;
}

+ (instancetype)renderCell:(AddPersonInputCell *)cell  typeStr:(NSString *)typeStr valueStr:(NSString *)valueStr indexPath:(NSIndexPath *)indexPath{
    cell.nameLable.text = typeStr;
    cell.textField.text = valueStr;
    if (valueStr.length == 0) {
        cell.textField.placeholder = [NSString stringWithFormat: @"请输入%@",typeStr];
    }
    
    if (indexPath.row > 5) {
        cell.mustImage.hidden = YES;
    }
    cell.indexPath = indexPath;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
