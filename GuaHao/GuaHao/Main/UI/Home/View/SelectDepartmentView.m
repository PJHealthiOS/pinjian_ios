//
//  GuaHao
//
//  Created by qiye on 16/2/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SelectDepartmentView.h"
#import "UIViewController+Toast.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"

@interface SelectDepartmentView ()
@end

@implementation SelectDepartmentView{
    
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UITableView *tableView2;
    NSMutableArray * firsts;
    NSMutableArray * seconds;
    NSInteger selectRow ;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"SelectDepartmentView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        [self initView];
    }
    return self;
}

-(void) initView{
    firsts = [NSMutableArray new];
    seconds = [NSMutableArray new];
    tableView.width = 150;
    tableView2.width = self.width - 150;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xtxxcell"];
    [tableView2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xtxxcell1"];
    
}

-(void)updateView
{
    [self getFirstDepartment];
}

-(void)getFirstDepartment
{
    [firsts removeAllObjects];
    [self makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getFirstExpDepartment:_hospitalID andCallback:^(id data) {
        [self hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
//            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    for (int i = 0; i<arr.count; i++) {
                        DepartmentVO *vo = [DepartmentVO mj_objectWithKeyValues:arr[i]];
                        [firsts addObject:vo];
                    }
                    [tableView reloadData];
                    if(firsts.count>0){
                        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                        [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
                    }
                }
                
            }else{
//                [self inputToast:msg];
            }
        }
    }];
}

-(void)getSecondDepartment:(int) index
{
    DepartmentVO *vo = firsts[index];
    [self makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getSecondExpDepartment:_hospitalID departmentId:vo.id andCallback:^(id data) {
        [self hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
//            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    [seconds removeAllObjects];
                    for (int i = 0; i<arr.count; i++) {
                        DepartmentVO *vo = [DepartmentVO mj_objectWithKeyValues:arr[i]];
                        [seconds addObject:vo];
                    }
                    [tableView2 reloadData];
                }
                
            }else{
                //            [self inputToast:msg];
            }
        }
    }];
}

-(void) callbackSencond:(id) data
{

}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==_tableView){
        return firsts.count;
    }else{
        return seconds.count ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView ==_tableView) {
        UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"xtxxcell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:240.0f /255.0f blue:238.0f/255.0f alpha:1.0f];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        
        DepartmentVO * vo = firsts[indexPath.row];
        cell.textLabel.text = vo.name ;
        cell.textLabel.font =  [UIFont fontWithName:@"Arial" size:13.0f];
        return cell;
    }
    else{
        UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"xtxxcell1" forIndexPath:indexPath];
        if (indexPath.row%2==1) {
            cell.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:240.0f /255.0f blue:238.0f/255.0f alpha:1.0f];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        DepartmentVO * vo = seconds[indexPath.row];
        cell.textLabel.text = vo.name ;
        cell.textLabel.font =  [UIFont fontWithName:@"Arial" size:13.0f];
        return cell;
    }
}

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_tableView){
        selectRow = indexPath.row ;
        [self getSecondDepartment:(int)selectRow];
    }
    else{
        if (_delegate) {
            [_delegate selectDepartmentViewDelegate:seconds[indexPath.row]];
        }
        [self removeFromSuperview];
    }
}

@end
