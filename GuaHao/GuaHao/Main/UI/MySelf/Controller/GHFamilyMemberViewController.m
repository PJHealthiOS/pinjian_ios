//
//  GHFamilyMemberViewController.m
//  GuaHao
//
//  Created by PJYL on 16/9/3.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHFamilyMemberViewController.h"
#import "GHFamilyAddCell.h"
#import "GHFamilyPersonCell.h"
#import "GHPersonInfoViewController.h"
#import "AddPersonViewController.h"
#import "PatientCellVO.h"

@interface GHFamilyMemberViewController ()<UITableViewDataSource,UITableViewDelegate,AddPatientDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sourceArr;

@end

@implementation GHFamilyMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家庭成员";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePatientInfo:) name:@"UpdatePatientInfo" object:nil];
    //获取数据
    [self getDateSource];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self getDateSource];
}
-(void)getDateSource{
    

    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getPatients:10 page:0 andCallback:^(id data) {
        [self.view hideToastActivity];
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    self.sourceArr = [NSMutableArray array];
                    for (int i = 0; i<arr.count; i++) {
                        PatientCellVO * patient = [PatientCellVO mj_objectWithKeyValues:arr[i]];
                        [ self.sourceArr addObject:patient];
                    }
                }
                [self.tableView reloadData];
                
            }else{
                [self inputToast:msg];
            }
        }
    }];

}

-(void)updatePatientInfo:(NSNotification *)notification{
    [self getDateSource];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        GHFamilyAddCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHFamilyAddCell"];
        if (self.sourceArr.count >= 5) {
            cell.label.text = [NSString stringWithFormat:@"* 不可添加家庭成员"];

        }
        cell.label.text = [NSString stringWithFormat:@"* 可添加%u位家庭成员",5 - self.sourceArr.count];
        return cell;
    }else{
        
        PatientCellVO * vo = self.sourceArr[indexPath.row-1];
        GHFamilyPersonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHFamilyPersonCell"];
        
        cell.nameLabel.text = vo.name;;
        ///加密
        NSString *IDCardNo = vo.cardNo;
        if (IDCardNo.length > 7) {
            IDCardNo = [IDCardNo stringByReplacingCharactersInRange:NSMakeRange(3, vo.cardNo.length - 6) withString:@" **** **** **** "];
        }
        
        
        cell.idCardLabel.text = IDCardNo;
        NSString *str = @"";
        UIColor *textColor = GHDefaultColor;;
        switch (vo.status.intValue) {
            case 0:
                str = @"未认证";
                textColor = [UIColor orangeColor];
                break;
            case 1:
                str = @"审核中";
                break;
            case 2:
                str = @"已认证";
                break;
            case 3:
                str = @"认证失败";
                break;
            case 4:
                str = @"";
                break;
            case 5:
                str = @"";
                break;
                
            default:
                break;
        }
        //下划线
        
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:textColor};
        
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:str attributes:attribtDic];
        
        cell.statusLabel.attributedText = attribtStr;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  == 0) {
        if(self.sourceArr&&self.sourceArr.count>=5){
            [self inputToast:@"最多添加五个就诊人！"];
            return;
        }
        AddPersonViewController *addVC = [[AddPersonViewController alloc]init];
        addVC.delegate = self;
        [self.navigationController pushViewController:addVC animated:YES];
    }else{
        GHPersonInfoViewController *infoVC = [GHViewControllerLoader GHPersonInfoViewController];
        PatientCellVO * patient = self.sourceArr[indexPath.row-1];
        infoVC.patientID =  patient.id;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}


-(void)addComplete:(PatientVO *)vo{
    [self getDateSource];
}

























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
