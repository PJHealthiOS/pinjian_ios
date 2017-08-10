

//
//  ChooseDepartmentsVC.m
//  GuaHao
//
//  Created by 123456 on 16/1/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ChooseDepartmentsVC.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "DepartmentVO.h"

@interface ChooseDepartmentsVC (){
    
    NSArray * array ;
    NSArray * array1 ;
    NSInteger selectRow ;
    NSMutableArray * firsts;
    NSMutableArray * seconds;    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@end

@implementation ChooseDepartmentsVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _hospital.name;
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden =YES;
    if (_hospital) {
        _labTitle.text = _hospital.name;
    }
    
    firsts = [NSMutableArray new];
    seconds = [NSMutableArray new];
    
    _tableView.delegate = self ;
    _tableView.dataSource = self ;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xtxxcell"];
    
   
    _tableView1.delegate = self ;
    _tableView1.dataSource = self ;
    [_tableView1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xtxxcell1"];
    
    [self getFirstDepartment];

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableView){
        return firsts.count;
    }
    else{
        return seconds.count ;
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *selected = [_tableView indexPathForSelectedRow];
    if(selected) [_tableView selectRowAtIndexPath:selected animated:NO scrollPosition:UITableViewScrollPositionNone];
    NSIndexPath *selected2 = [_tableView1 indexPathForSelectedRow];
    if(selected) [_tableView1 selectRowAtIndexPath:selected2 animated:NO scrollPosition:UITableViewScrollPositionNone];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==_tableView) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xtxxcell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:240.0f /255.0f blue:238.0f/255.0f alpha:1.0f];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
 
        DepartmentVO * vo = firsts[indexPath.row];
        cell.textLabel.text = vo.name ;
        cell.textLabel.font =  [UIFont fontWithName:@"Arial" size:13.0f];
        return cell;
    }
    else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xtxxcell1" forIndexPath:indexPath];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_tableView){
        selectRow = indexPath.row ;
        [self getSecondDepartment:(int)selectRow];
    }
    else{
        if (_onBlockDepartment) {
            _onBlockDepartment(seconds[indexPath.row]);
            NSArray *viewControllers = self.navigationController.viewControllers;
            [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count - _popBackType] animated:YES];
        }
    }
}


-(void)getFirstDepartment
{
    [firsts removeAllObjects];
    [[ServerManger getInstance] getFirstDepartment:_hospital.id oppointment:self.isOppointment isChildEmergency:_isChildren andCallback:^(id data) {
        [self callbackFirst:data];
    }];
}

-(void) callbackFirst:(id) data
{
    [self.view hideToastActivity];
    if (data!=[NSNull class]&&data!=nil) {
        NSNumber * code = data[@"code"];
        NSString * msg = data[@"msg"];
        if (code.intValue == 0) {
            if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                NSArray * arr = data[@"object"];
                for (int i = 0; i<arr.count; i++) {
                    DepartmentVO *vo = [DepartmentVO mj_objectWithKeyValues:arr[i]];
                    [firsts addObject:vo];
                }
                [_tableView reloadData];
                if(firsts==nil||firsts.count==0){
                }else{
                    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
                }
                
            }
            
        }else{
            [self inputToast:msg];
        }
    }
}

-(void)getSecondDepartment:(int) index
{
    DepartmentVO *vo = firsts[index];
    [[ServerManger getInstance] getSecondDepartment:_hospital.id oppointment:self.isOppointment departmentId:vo.id isChildEmergency:_isChildren andCallback:^(id data) {
        [self callbackSencond:data];
    }];
}

-(void) callbackSencond:(id) data
{
    [self.view hideToastActivity];
    if (data!=[NSNull class]&&data!=nil) {
        NSNumber * code = data[@"code"];
        NSString * msg = data[@"msg"];
        if (code.intValue == 0) {
            if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                NSArray * arr = data[@"object"];
                [seconds removeAllObjects];
                for (int i = 0; i<arr.count; i++) {
                    DepartmentVO *vo = [DepartmentVO mj_objectWithKeyValues:arr[i]];
                    [seconds addObject:vo];
                }
                [_tableView1 reloadData];
            }
            
        }else{
            [self inputToast:msg];
        }
    }
}

-(void)setDepartmentVO:(HospitalVO*)vo
{
    if (vo.id.intValue != _hospital.id.intValue) {
        _hospital = vo;
        _labTitle.text = vo.name;
        [self getFirstDepartment];
    }
}

- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
