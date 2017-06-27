//
//  SortSelectTableView.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/24.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CellClickActionBlock)(NSInteger index ,BOOL select);

@interface SortSelectTableView : UIView
@property (nonatomic, copy)CellClickActionBlock myBlock;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArr;

-(void)reloadTableView:(NSArray *)sourceArr;
-(void)cellClickAction:(CellClickActionBlock)block;
-(instancetype)initWithFrame:(CGRect)frame sourceArray:(NSArray *)sourceArr;
@end
