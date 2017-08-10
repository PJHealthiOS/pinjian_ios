//
//  GHBankStatementController.m
//  GuaHao
//
//  Created by qiye on 16/9/7.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHBankStatementController.h"
#import "BankVO.h"
#import "BankStatusVO.h"

@interface GHBankStatementController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *labCurrentStatus;
@property (weak, nonatomic) IBOutlet UILabel *labBankname;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labID;
@property (weak, nonatomic) IBOutlet UILabel *labBank;
@property (weak, nonatomic) IBOutlet UIButton *btnState1;
@property (weak, nonatomic) IBOutlet UIButton *btnState2;
@property (weak, nonatomic) IBOutlet UILabel *labState1;
@property (weak, nonatomic) IBOutlet UILabel *labDate1;
@property (weak, nonatomic) IBOutlet UILabel *labState2;
@property (weak, nonatomic) IBOutlet UILabel *labDate2;

@end

@implementation GHBankStatementController{
    BankVO * bankVO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单详情";
    [self getBankInfo];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bottomView.frame)+47);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getBankInfo
{
    [[ServerManger getInstance] getBankInfo:_bankID andCallback:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    bankVO = [BankVO mj_objectWithKeyValues:data[@"object"]];
                    [self initView];
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(void)initView{
    _labBankname.text = bankVO.bankName;
    _labMoney.text = bankVO.amount.stringValue;
    _labDate.text = bankVO.createDate;
    _labID.text = bankVO.serialNo;
    _labBank.text = bankVO.getBankNameAndCard;
    _labCurrentStatus.text = bankVO.statusCn;
    
    if(bankVO.statusLogs&&bankVO.statusLogs.count>1){
        BankStatusVO * vo1 = bankVO.statusLogs[0];
        BankStatusVO * vo2 = bankVO.statusLogs[1];
        _btnState1.selected = vo1.isChecked;
        _btnState2.selected = vo2.isChecked;
        _labState1.text = vo1.desc;
        _labState2.text = vo2.desc;
        _labDate1.text = vo1.operateDate;
        _labDate2.text = vo2.operateDate;
    }
}
@end
