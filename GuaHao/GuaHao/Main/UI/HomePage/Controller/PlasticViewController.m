//
//  PlasticViewController.m
//  GuaHao
//
//  Created by PJYL on 2018/6/11.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import "PlasticViewController.h"
#import "PlasticTypeVO.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "PlasticInfoView.h"
#import "PlasticHospitalView.h"
#import "PlasticDoctrsView.h"





@interface PlasticViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *itemListView;
@property (weak, nonatomic) IBOutlet UIScrollView *itemListScrollView;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet UIButton *itemInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
@property (weak, nonatomic) IBOutlet UIButton *doctorButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemListViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageHeight;



@property (strong, nonatomic) NSMutableArray *typeArray;
@property (strong, nonatomic) NSMutableArray *typeButtonArray;
@property (strong, nonatomic) NSMutableArray *hospitalArray;
@property (strong, nonatomic) NSMutableArray *doctorArray;
@property (assign, nonatomic) NSInteger selectTag;

@property (strong, nonatomic) PlasticDoctrsView *doctorView;
@property (strong, nonatomic) PlasticHospitalView *hospitalView;
@property (strong, nonatomic) PlasticInfoView *infoView;



@end

@implementation PlasticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全医美";
    self.itemInfoButton.selected = YES;
    self.topImageHeight.constant = SCREEN_WIDTH * 385.0 /749.0;
    self.typeArray = [NSMutableArray array];
    self.hospitalArray = [NSMutableArray array];
    self.doctorArray = [NSMutableArray array];
    
    
    
    [self loadPageData ];
    
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.topView.hidden = NO;
    self.topView.center = CGPointMake(self.topView.center.x, CGRectGetMidY(self.operationView.frame)-self.backScrollView.contentOffset.y +[UIApplication sharedApplication].statusBarFrame.size.height + 44) ;

}


-(void)loadPageData{
    __weak typeof(self) weakSelf = self;

    [[ServerManger getInstance]plasticHomeBack:^(id data) {
        
        if (data!=[NSNull class]&&data!=nil){
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if(code.intValue == 0){
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                     NSArray * arr = data[@"object"];
                    for (id dic in arr) {
                        PlasticTypeVO * order = [PlasticTypeVO mj_objectWithKeyValues:dic];
                        [weakSelf.typeArray addObject:order];
                    }
                    [weakSelf loadTypeViews];
                
                }
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
        
    }];
}











-(void)loadTypeViews{
    
    CGFloat w = SCREEN_WIDTH/3.5;
    CGFloat h = w*180/150.0;
    self.itemListViewHeight.constant = h +20;
    
    
    self.backViewHeight.constant = self.topImageHeight.constant + self.itemListViewHeight.constant + SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 44;
    
    self.typeButtonArray = [NSMutableArray array];
    
    for ( int i = 0; i<self.typeArray.count;i++ ) {
        PlasticTypeVO * order = [self.typeArray objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w*i, 0, w, h);
        [btn sd_setImageWithURL:[NSURL URLWithString:order.logo] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"type_border.png"] forState:UIControlStateSelected];
        
        if (0 == i) {
            btn.selected = YES;
            self.selectTag = 122;
        }
        btn.tag = i + 122;
        [btn addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeButtonArray addObject:btn];
        [self.itemListScrollView addSubview:btn];
        
    }
    self.itemListScrollView.contentSize = CGSizeMake(w *self.typeArray.count, h+20);
    
    
    self.contentScrollView.scrollEnabled = NO;

    
    PlasticTypeVO * order = [self.typeArray firstObject];
    self.infoView = [[PlasticInfoView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) order: order];
    self.infoView.scrollView.scrollEnabled = NO;
    [self.contentScrollView addSubview:self.infoView];
    
    
    self.doctorView = [[PlasticDoctrsView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) idStr:order.id.integerValue ];
    self.doctorView.tableView.scrollEnabled = NO;
    [self.doctorView selectDoctor:^(NSNumber *idStr) {
        ExpertInfomationViewController *view = [GHViewControllerLoader ExpertInfomationViewController ];
        view.doctorId = idStr;
        [self.navigationController pushViewController:view animated:YES];
    }];
    [self.contentScrollView addSubview:self.doctorView];
    
    
    self.hospitalView = [[PlasticHospitalView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT) idStr:order.id.integerValue ];
    self.hospitalView.tableView.scrollEnabled = NO;
    [self.contentScrollView addSubview:self.hospitalView];
    
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 44);
    
}


-(void)typeClick:(UIButton *)sender{
    if (self.selectTag == sender.tag) {
        NSLog(@"现在选中的就是这个不要点了");
        return;
    }else{
        self.selectTag = sender.tag;
    }
    
    
    for (UIButton *btn in self.typeButtonArray ) {
        btn.selected = NO;
    }
    sender.selected = YES;

   
    PlasticTypeVO *order = [self.typeArray objectAtIndex:sender.tag - 122];
    NSLog(@"order.name------%@",order.name);
    ///刷新医院推荐和直约名医
    [self.infoView changeInfo:order];
    [self.hospitalView loadWithID:order.id.integerValue];
    [self.doctorView loadWithID:order.id.integerValue];
    
    [self scrollViewDidScroll:self.backScrollView];
    
}




- (IBAction)itemInfoAction:(UIButton *)sender {
    [self selectAction:sender];
    [self animate:CGPointMake(0, 0)];

}


- (IBAction)recommendAction:(UIButton *)sender {
    [self selectAction:sender];
    [self animate: CGPointMake(SCREEN_WIDTH, 0)];

}


- (IBAction)doctorAction:(UIButton *)sender {
    [self selectAction:sender];
    [self animate:CGPointMake(SCREEN_WIDTH*2, 0)];

}

-(void)animate:(CGPoint)point{
    [UIView animateWithDuration:0.5 animations:^{
         self.contentScrollView.contentOffset = point;
    }];
}


-(void)selectAction:(UIButton *)sender{
    self.lineView.center =CGPointMake(sender.center.x, self.lineView.center.y);
    self.itemInfoButton.selected = [self.itemInfoButton isEqual:sender];
    self.recommendButton.selected = [self.recommendButton isEqual:sender];
    self.doctorButton.selected = [self.doctorButton isEqual:sender];
}







-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSString *str = @"";
    if (ceilf(scrollView.contentOffset.y ) >= ceilf(CGRectGetMinY(self.operationView.frame)) ) {
        self.topView.center = CGPointMake(self.topView.center.x, 28+[UIApplication sharedApplication].statusBarFrame.size.height + 44);
        self.doctorView.tableView.scrollEnabled = YES;
        self.hospitalView.tableView.scrollEnabled = YES;
        self.infoView.scrollView.scrollEnabled = YES;
        str = @"固定";
    }else{///如果没有达到顶部则下面tableView不能滑动
        self.doctorView.tableView.scrollEnabled = NO;
        self.hospitalView.tableView.scrollEnabled = NO;
        self.infoView.scrollView.scrollEnabled = NO;
        self.topView.center = CGPointMake(self.topView.center.x, CGRectGetMidY(self.operationView.frame)-scrollView.contentOffset.y +[UIApplication sharedApplication].statusBarFrame.size.height + 44);
        str = @"移动";
    }
//     NSLog(@"%@-------%f,",str,scrollView.contentOffset.y);
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
