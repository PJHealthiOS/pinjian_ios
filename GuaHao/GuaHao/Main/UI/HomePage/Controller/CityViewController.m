//
//  CityViewController.m
//  GuaHao
//
//  Created by qiye on 16/9/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CityViewController.h"
#import "ServerManger.h"
#import "CityVO.h"

@interface CityViewController ()
@property (weak, nonatomic) IBOutlet UITableView *oneTable;
@property (weak, nonatomic) IBOutlet UITableView *twoTable;
@end

@implementation CityViewController{
    NSMutableArray * firsts;
    NSMutableArray * seconds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        //没有开启定位
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您尚未开启品简挂号定位服务，请在系统设置中开启"] preferredStyle:UIAlertControllerStyleAlert];
//        __weak typeof(self) weakSelf = self;
        [alertController addAction:[UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //定位服务设置界面
//            NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }

        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"不变");
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
       
    }else{
        
    }
    
    
    [_oneTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xtxxcell"];
    [_twoTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xtxxcell1"];
    self.title = @"选择城市";
    firsts = [NSMutableArray new];
    seconds = [NSMutableArray new];
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getCity:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    for (int i = 0; i<arr.count; i++) {
                        CityVO *city = [CityVO mj_objectWithKeyValues:arr[i]];
                        [firsts addObject:city];
                    }
                    CityVO *city = firsts[0];
                    seconds = [NSMutableArray arrayWithArray:city.children];
                    [_oneTable reloadData];
                    [_oneTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                    [_twoTable reloadData];
                }
                
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _oneTable){
        return firsts.count;
    }
    else{
        return seconds.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==_oneTable) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xtxxcell" forIndexPath:indexPath];
        
        CityVO * vo = firsts[indexPath.row];
        cell.textLabel.text = vo.name ;
        cell.textLabel.font =  [UIFont fontWithName:@"Arial" size:13.0f];
        return cell;
    }
    else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xtxxcell1" forIndexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        CityVO * vo = seconds[indexPath.row];
        cell.textLabel.text = vo.name ;
        cell.textLabel.font =  [UIFont fontWithName:@"Arial" size:13.0f];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_oneTable){
        CityVO *city = firsts[indexPath.row];
        if(city){
            seconds = [NSMutableArray arrayWithArray:city.children];
            [_twoTable reloadData];
        }
    }else{
        if(_myBlock){
             CityVO *city = seconds[indexPath.row];
            _myBlock(city);
            self.currentCityLabel.text = [NSString stringWithFormat:@"当前地址：%@", city.name];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
