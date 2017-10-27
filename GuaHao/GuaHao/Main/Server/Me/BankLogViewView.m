//
//  GuaHao
//
//  Created by qiye on 16/2/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "BankLogViewView.h"
#import "UIViewController+Toast.h"
#import "MJRefresh.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "BankLogViewCell.h"
#import "BankLogVO.h"

@interface BankLogViewView ()
@end

@implementation BankLogViewView{
    
    __weak IBOutlet UITableView *tableView;
    NSMutableArray * datas;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"BankLogViewView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        [self initView];
    }
    return self;
}

-(void) initView{
    datas = [NSMutableArray new];
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerNib:[UINib nibWithNibName:@"BankLogViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BankLogViewCell"];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self getBankLog];
}

-(void) getBankLog
{
    [[ServerManger getInstance] cardLogList:^(id data) {
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (arr&&arr.count>0) {
                        for (int i = 0; i<arr.count; i++) {
                            BankLogVO *vo = [BankLogVO mj_objectWithKeyValues:arr[i]];
                            [datas addObject:vo];
                        }
                        [tableView reloadData];
                    }else{
                        if (_delegate) {
                            [_delegate bankLogViewDelegate:nil];
                        }
                        [self removeFromSuperview];
                    }
                }
                
                
            }else{
                //                [self inputToast:msg];
            }
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BankLogViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"BankLogViewCell"];
    
    if (datas.count>0) {
        [cell setCell:datas[indexPath.row]];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BankLogVO * vo = datas[indexPath.row];
    if (_delegate) {
        [_delegate bankLogViewDelegate:vo];
    }
    [self removeFromSuperview];
}

@end
