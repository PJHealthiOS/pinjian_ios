//
//  SpecialSelectTableView.h
//  GuaHao
//
//  Created by PJYL on 2016/11/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellClickActionBlock)(NSInteger index, int type);
@interface SpecialSelectTableView : UIView
@property (nonatomic, copy)CellClickActionBlock myBlock;
@property (nonatomic, strong)UITableView *tableView;
-(void)changTableView:(int)type;
-(void)cellClickAction:(CellClickActionBlock)block;
@end
