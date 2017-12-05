//
//  HomePageVC.m
//  GuaHao
//
//  Created by PJYL on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "HomePageVC.h"
#import "GHSearchBar.h"
#import "SweepVIewController.h"
#import "GHCreateOrderOneCell.h"
#import "GHCreateOrderTwoCell.h"
#import "GHScrollViewCell.h"
#import "GHInformationCell.h"
#import "NewsView.h"
#import "GHAdvertView.h"
#import "HomeVO.h"
#import "BannerVO.h"
#import "CityViewController.h"
#import "CityVO.h"
#import "PointVO.h"
#import "HtmlAllViewController.h"
#import "EMClient.h"
#import "EaseUI.h"
#import "ExpertSelectViewController.h"
#import "CreateOrderNormalViewController.h"
#import "HealthTestListViewController.h"
#import "HealthTestVO.h"
#import "ArticleListVO.h"
#import "UITableView+MJ.h"
#import "InformationDetailViewController.h"
#import "ChildBannerController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SpecialDepartmentVO.h"
#import "SpecialDepViewController.h"
#import "SpecialListViewController.h"
#import "PonitViewController.h"

@interface HomePageVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,LoginViewDelegate,EMChatManagerDelegate>{
    GHAdvertView *adView;
    NSMutableArray * bannerImages;
    HomeVO * homeVO;
    NSMutableArray * assessments;
    NSMutableArray * specialDepArr;;
    NSMutableArray * articles;
    NSTimer  * time;
    BOOL     isOpen;
    BOOL alreadySuccess;
    NSString * longitude;
    NSString * latitude;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *sweepButton;
@property (strong, nonatomic)UIImageView *dragimage;

@end

@implementation HomePageVC

-(void)chooseCity:(NSString *)cityNmae cityCode:(NSString *)cityCode{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您当前定位的城市是%@,是否切换",cityNmae] preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[DataManager getInstance]setRegion:cityCode name:cityNmae ];
        [DataManager getInstance].cityName = cityNmae;
        [DataManager getInstance].cityId = cityCode;
        [weakSelf.locationButton setTitle:cityNmae forState:UIControlStateNormal];
        [weakSelf updateOrLoginFromChanged:YES];

    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"不变");
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    assessments = [NSMutableArray array];
    articles = [NSMutableArray array];
    specialDepArr = [NSMutableArray array];
   
//    //声明tableView的位置 添加下面代码
//    if (@available(iOS 11.0, *)) {
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
//    }
    
    if([DataManager getInstance].cityName.length < 1){
     [_locationButton setTitle:@"上海市" forState:UIControlStateNormal];
        [[DataManager getInstance]setRegion:@"021" name:@"上海市" ];
    }else{
        [_locationButton setTitle:[DataManager getInstance].cityName forState:UIControlStateNormal];
    }
    ///添加导航条
    [self addSearchBar];
    [self updateOrLoginFromChanged:NO];
    isOpen = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotify:) name:@"UserMSGUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushFamily:) name:@"PushFamily" object:nil];

    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    MJRefreshBackGifFooter * footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"没有辣(~.~)！" forState:MJRefreshStateIdle];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.mj_footer = footer;
    UserVO* vo = [DataManager getInstance].user;
    [[EMClient sharedClient] asyncLoginWithUsername:vo.hxUsername password:vo.hxPassword success:^{
        NSLog(@"环信登录成功");
        [[EMClient sharedClient] setApnsNickname:vo.nickName];
        EMConversation * im = [[EMClient sharedClient].chatManager getConversation:@"pinjian001" type:EMConversationTypeChat createIfNotExist:YES];
        NSLog(@"xxxxxxxx:%d",im.unreadMessagesCount);
        if(im.unreadMessagesCount>0){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HXMessageEvent" object:@"1"];
        }
    } failure:^(EMError *aError) {
        NSLog(@"环信登录fail");
    }];
    [self addDragImage];///添加浮动按钮
}

///开始定位
-(void)startLocation{
    __weak typeof(self) weakSelf = self;
    
    [[GeoLocationManager shareLocation]getLocationInfo:^(BOOL success, NSString *_cityNmae, NSString *_cityCode, NSString *_longitude, NSString *_latitude) {
        
        if (![DataManager getInstance].cityId && [homeVO.regionCodes containsObject:_cityCode]) {
            [DataManager getInstance].cityId = _cityCode;
            [DataManager getInstance].cityName = _cityNmae;
            [[DataManager getInstance]setRegion:_cityCode name:_cityNmae ];
            [weakSelf.locationButton setTitle:_cityNmae forState:UIControlStateNormal];
            [weakSelf updateOrLoginFromChanged:NO];
        }else{
            if (![[DataManager getInstance].cityId isEqualToString:_cityCode]) {
                [weakSelf chooseCity:_cityNmae cityCode:_cityCode];
                if (![DataManager getInstance].cityId) {
                    [DataManager getInstance].cityName = _cityNmae;
                    [[DataManager getInstance]setRegion:_cityCode name:_cityNmae ];
                    [[DataManager getInstance]setRegion:_cityCode name:_cityNmae ];
                    [[DataManager getInstance]setRegionLatitude:latitude longitude:longitude];
                    [weakSelf.locationButton setTitle:_cityNmae forState:UIControlStateNormal];

                }
            }
        }
        
    }];

}



-(void)loadNewData{
    if (!alreadySuccess) {
        [self updateOrLoginFromChanged:NO];
    }
    [_tableView.mj_header endRefreshing];
}
-(void)loadMoreData{
    [_tableView.mj_footer endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


-(void)addDragImage{
    self.dragimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homePage_draw.png"]];
    self.dragimage.frame = CGRectMake(SCREEN_WIDTH-80, 200, 60, 60);
    self.dragimage.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [self.dragimage addGestureRecognizer:panGesture];
    [self.dragimage addGestureRecognizer:tap];
    [self.view addSubview:self.dragimage];
}
-(void)move:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:self.dragimage];
    sender.view.center = CGPointMake(point.x + sender.view.center.x, sender.view.center.y + point.y);
    [sender  setTranslation:CGPointMake(0, 0) inView:self.view];
}
-(void)click{
    [self login];
    if ([DataManager getInstance].loginState != 1) {
        return;
    }
    [MobClick event:@"click43"];
    
//    PonitViewController * views = [[PonitViewController alloc] init];
//    [self.navigationController pushViewController:views animated:YES];

    HtmlAllViewController *controller = [[HtmlAllViewController alloc] init];
    controller.isTest = YES;
    controller.mUrl = @"https://www.pjhealth.com.cn/wx/LotteryTurntable/app/index.html";
    controller.mTitle = @"抽奖";
    controller.titleStr = @"【品简挂号】邀你来拼手气！";
    controller.descStr = @"我正在参加拼手气赢现金活动，邀你一起来围观，就在【品简挂号】>>";
    [self.navigationController pushViewController:controller animated:YES];


}


- (void)didReceiveMessages:(NSArray *)aMessages
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HXMessageEvent" object:@"1"];
    [self startPlaySystemSound];
}

-(void)startPlaySystemSound
{
    if (isOpen) {
        isOpen = NO;
        time = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    }
}

-(void)scrollTimer
{
    isOpen = YES;
    [time invalidate];
    AudioServicesPlaySystemSound (1007);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

-(void)updateOrLoginFromChanged:(BOOL)changged {
    NSLog(@"请求数据-----=-");
    [[ServerManger getInstance] getBannerList:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            if (code.intValue == 0) {
                alreadySuccess = YES;
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    homeVO = [HomeVO mj_objectWithKeyValues:data[@"object"]];
                    [ServerManger getInstance].appDownloadURL = homeVO.appDownLoadUrl;
                    articles = [NSMutableArray array];
                    for (NSDictionary *dic in homeVO.articles) {
                        ArticleListVO *vo = [ArticleListVO mj_objectWithKeyValues:dic];
                        [articles addObject:vo];
                    }
                    assessments = [NSMutableArray array];
                    for (NSDictionary *dic in homeVO.assessments) {
                        HealthTestVO *vo = [HealthTestVO mj_objectWithKeyValues:dic];
                        [assessments addObject:vo];
                    }
                    
                    specialDepArr = [NSMutableArray array];
                    for (NSDictionary *dic in homeVO.featuredDepts) {
                        SpecialDepartmentVO *vo = [SpecialDepartmentVO mj_objectWithKeyValues:dic];
                        [specialDepArr addObject:vo];
                    }
                    
                    if (homeVO.unreadMsgNum.intValue > 0) {
                        [DataManager getInstance].messageVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",homeVO.unreadMsgNum];
                    }else{
                        [DataManager getInstance].messageVC.tabBarItem.badgeValue = nil;
                        [DataManager getInstance].messageVC.tabBarController.selectedIndex = 0;
                    }
                    
                    [self getImages];
                    [_tableView reloadData];
                   ///在请求成功之后进行定位，如果一致就不作处理，不一致就提示更换，如果取消就不管了
                    if (!changged) {
                        [self startLocation];//开始定位
                    }
                    

                }
                
            }else{
            }
        }
    }];
}
-(void)getImages
{
    bannerImages =[NSMutableArray array];
    for (int i=0; i<homeVO.banners.count; i++) {
        BannerVO * ss=homeVO.banners[i];
        [bannerImages addObject:ss.picUrl];
    }
    [adView setAdvertImagesOrUrls:bannerImages];
}
#pragma mark - Internal
-(void)pushNotify:(NSNotification *)notification
{
    if (notification.userInfo != nil || notification.userInfo[@"extras"][@"type"] != nil ) {
        NSInteger  type = [notification.userInfo[@"extras"][@"type"] integerValue];
        if (type == 6) { //verifyStatus:3;
            NSString * obj = notification.userInfo[@"extras"][@"obj"];
            NSString * type = [obj substringWithRange:NSMakeRange(13,1)];
            [DataManager getInstance].user.verifyStatus = [NSNumber numberWithInt:type.intValue];
        }
        if (type == 9) { //realnameAuthStatus:3;
            NSString * obj = notification.userInfo[@"extras"][@"obj"];
            NSString * type = [obj substringWithRange:NSMakeRange(19,1)];
            [DataManager getInstance].user.verifyStatus = [NSNumber numberWithInt:type.intValue];
        }
    }
}

-(void)pushFamily:(NSNotification *)notification
{
    self.tabBarController.selectedIndex = 2;
    
}
-(void)readMessage:(NSNotification *)notification
{
    [self.tabBarItem setBadgeValue:nil];
}

#pragma mark - addSearchBar
-(void)addSearchBar{
    GHSearchBar *searchBar = [[GHSearchBar alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 120, 30) isHome:YES];
    searchBar.isHome = YES;
    [searchBar setCancelButtonTitle:@"搜索医生" setPlaceholder:@"搜索医院、科室、医生"];
    [self.topView addSubview:searchBar];
//    [self.navigationController.navigationBar addSubview:searchBar];

    searchBar.delegate = self;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"来到搜索界面");
    GHSearchViewController *searchVC = (GHSearchViewController *)[GHViewControllerLoader GHSearchViewController];
    [self.navigationController pushViewController:searchVC animated:NO];
    return NO;
}

- (IBAction)locationAction:(id)sender {
    CityViewController *view = [GHViewControllerLoader CityViewController];
    view.currentCityLabel.text = [NSString stringWithFormat:@"当前地址：%@", [DataManager getInstance].cityName];
    __weak typeof(self) weakSelf = self;
    view.myBlock = ^(CityVO* vo){
    [weakSelf.locationButton setTitle:vo.name forState:UIControlStateNormal];
        [[DataManager getInstance] setRegion:[NSString stringWithFormat:@"%@",vo.code] name:vo.name];
        [DataManager getInstance].cityId = vo.code;
        [weakSelf updateOrLoginFromChanged:YES];
        
//        if([DataManager getInstance].user.token){
//            [[ServerManger getInstance] bindCity:vo.id andCallback:^(id data) {
//                if (data!=[NSNull class]&&data!=nil) {
//                    NSNumber * code = data[@"code"];
//                    if (code.intValue == 0) {
//                        if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
//                            [[DataManager getInstance] setRegion:[NSString stringWithFormat:@"%@",vo.code] name:vo.name];
//                            [DataManager getInstance].cityId = vo.code;
//                            [weakSelf updateOrLoginFromChanged:YES];
//                        }
//                    }else{
//                    }
//                }
//            }];
//        }
    };
    [self.navigationController pushViewController:view animated:NO];

}

- (IBAction)onSweep:(id)sender {
    SweepViewController *sweepVC = [[SweepViewController alloc]init];
    [self.navigationController pushViewController:sweepVC animated:NO];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return homeVO.featuredDepts.count > 0 ?6:5;
    }else{
        return articles.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    }else{
        return 0;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 40;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                height = SCREEN_WIDTH/(750.0/376.0);
            }break;
            case 1:{
                height = 44;
            }break;
            case 2:{
                height = 150;
            }break;
            case 3:{
                height = 168;
            }break;
            case 4:{
                height = (SCREEN_WIDTH - 20.0)/2.0/(352.0/200.0) + 84;
            }break;
            case 5:{
                height = (SCREEN_WIDTH - 20.0)/2.0/(352.0/200.0) + 84 ;
            }break;
            default:
                break;
        }
    }else{
        height = 95;
    }
    return height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self layoutSubViewsIndexPath:indexPath];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 7.5, 100, 30)];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"健康资讯";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"更多 >" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.frame = CGRectMake(SCREEN_WIDTH - 70, 7.5, 60, 30);
        [button setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moreInformation:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xE7E7E7);
        [backView addSubview:lineView];
        [backView addSubview:label];
        [backView addSubview:button];
        return backView;
    }
    return nil;
}
-(UITableViewCell *)layoutSubViewsIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //添加轮播图
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (nil == cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (bannerImages.count > 0) {
                if ([cell.contentView viewWithTag:1011]) {
                    adView = [cell.contentView viewWithTag:1011];
                }else{
                    adView = [[GHAdvertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(750.0/376.0))];
                    [cell.contentView addSubview:adView];
                    [adView setAdvertImagesOrUrls:bannerImages];
                    __weak typeof(self) weakSelf = self;
                    [adView setAdvertAction:^(NSInteger idx) {
                        [weakSelf clickIndex:idx];
                    }];
                    [adView setAdvertInterval:5];
                    [adView setCurrentPageColor:[UIColor greenColor]];
                    [adView setPageIndicatorTintColor:[UIColor grayColor]];
                    
                }
                
            }
            return cell;
        }else if (indexPath.row == 1){
            //添加通知栏
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"noticeCellID"];
            if (nil == cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noticeCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NewsView *newsV;
            if ([cell.contentView viewWithTag:1001]) {
                newsV = [cell.contentView viewWithTag:1001];
            }else{
                newsV = [[NewsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
                newsV.tag = 1001;
                [newsV setHideMore];
            }

            [newsV setNewArray:homeVO.sysRollMsgs clickAction:^(NSInteger index) {
                NSLog(@"点击了第----%ld",(long)index);
            }];
            
            [newsV setNewsFont:[UIFont systemFontOfSize:14]];
            [newsV setNewsTextColor:RGB(102, 102, 102)];
            [cell.contentView addSubview:newsV];
            return cell;
        }else if (indexPath.row == 3){//陪诊、咨询、重疾
            GHCreateOrderOneCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHCreateOrderOneCell"];

            return cell;
        }else if (indexPath.row == 2){///普通、专家号
            GHCreateOrderTwoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHCreateOrderTwoCell"];
            return cell;
        }else {//特色科室
            GHScrollViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHScrollViewCell"];
//            __weak typeof(self) weakSelf = self;
            if (indexPath.row == 4 && homeVO.featuredDepts.count > 0){
                [cell layoutSubviews:specialDepArr title:@"特色科室"  type:1];
                [cell clickCellReturn:^(NSInteger index) {
                    SpecialDepViewController *vc = [GHViewControllerLoader SpecialDepViewController];
                    SpecialDepartmentVO *vo = [specialDepArr objectAtIndex:index];
                    vc.title = vo.name;
                    vc._id = vo.id;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [cell clickButtonReturn:^(NSInteger type) {
                    [self moreInformation:4];
                }];
            }else{
                [cell layoutSubviews:assessments title:@"健康评测" type:2];
//                __weak typeof(self) weakSelf = self;
                [cell clickCellReturn:^(NSInteger index) {
                    HealthTestVO *vo = [assessments objectAtIndex:index];
                    [self pushToHtmlAllViewControllerWithTitle:vo.name URL:vo.linkUrl];
                    NSLog(@"button.tag-------------%ld",(long)index);
                }];
                [cell clickButtonReturn:^(NSInteger type) {
                    [self moreInformation:5];
                }];
            }
            
            return cell;
        }
    }else{///咨询
        GHInformationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHInformationCell"];
        [cell layoutSubviews:[articles objectAtIndex:indexPath.row]];
        return cell;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    UIColor * color = GHDefaultColor;
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"offsetY--------%f",offsetY)
    if (offsetY > 0) {
        CGFloat alpha = MIN(1,  ((offsetY) / 64));
        [self.topView setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.topView setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        ArticleListVO *vo = [articles objectAtIndex:indexPath.row];
            InformationDetailViewController * view = [[InformationDetailViewController alloc] init];
            view.articleID = vo.id;
            [self.navigationController pushViewController:view animated:YES];
        
    }
}
//普通号
- (IBAction)normalOrderAction:(UITapGestureRecognizer *)sender {
    [self normalOrder];
    
}
//专家
- (IBAction)expertOrderAction:(UITapGestureRecognizer *)sender {
    [self expertOrder];
}
///重疾
- (IBAction)seriousAction:(id)sender {
    [self serious];
}

- (IBAction)askAction:(UITapGestureRecognizer *)sender {
    [self askTheDoctor];
}
///陪诊
- (IBAction)accompanyAction:(id)sender {
    [self accompany];
}
///团体健康
- (IBAction)groupAction:(id)sender {
    [self login];
    if ([DataManager getInstance].loginState != 1) {
        return;
    }
    NSLog(@"普通");
    [MobClick event:@"click4"];
    HealthManagerViewController *view = [GHViewControllerLoader HealthManagerViewController];
    [self.navigationController pushViewController:view animated:YES];
}
//普通挂号、
-(void)normalOrder{
    [self login];
    if ([DataManager getInstance].loginState != 1) {
        return;
    }
    NSLog(@"普通");
    [MobClick event:@"click4"];
    CreateOrderNormalViewController *view = [GHViewControllerLoader CreateOrderNormalViewController];
    [self.navigationController pushViewController:view animated:YES];
}
//专家号
-(void)expertOrder{
    [self login];
    if ([DataManager getInstance].loginState != 1) {
        return;
    }
    NSLog(@"专家");
    [MobClick event:@"click5"];
    ExpertSelectViewController *view = [GHViewControllerLoader ExpertSelectViewController];
//    TestViewController *view = [GHViewControllerLoader TestViewController];

    [self.navigationController pushViewController:view animated:YES];
    
}
///挂号咨询
-(void)askTheDoctor{
    NSLog(@"///挂号咨询");
    UserVO* vo = [DataManager getInstance].user;
    [self.view setUserInteractionEnabled:NO];
    [[EMClient sharedClient] asyncLoginWithUsername:vo.hxUsername password:vo.hxPassword success:^{
        NSLog(@"环信登录成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HXMessageEvent" object:@"0"];
        EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"pinjian001" conversationType:EMConversationTypeChat];
        [[EMClient sharedClient] setApnsNickname:vo.nickName];
        NSMutableDictionary * dic = [NSMutableDictionary new];
        chatController.title = @"挂号咨询";
        dic[@"senderName"] = @"我";
        dic[@"senderAvatar"] = [DataManager getInstance].user.avatar;
        dic[@"receiverName"] = @"品简客服";
        dic[@"receiverAvatar"] = @"doctor_defalt_icon.png";
        chatController.pinjian = dic;
        [self.navigationController pushViewController:chatController animated:YES];
        self.view.userInteractionEnabled = YES;
    } failure:^(EMError *aError) {
        NSLog(@"环信登录fail");
        self.view.userInteractionEnabled = YES;
    }];
}
//暖心陪诊
-(void)accompany{
    [self login];
    if ([DataManager getInstance].loginState != 1) {
        return;
    }
    [self.navigationController pushViewController:[GHViewControllerLoader AccompanyMenuViewController] animated:YES];
}
//重疾直通车
-(void)serious{
    [self login];
    if ([DataManager getInstance].loginState != 1) {
        return;
    }
    [self.navigationController pushViewController:[GHViewControllerLoader SeriousFlowViewController] animated:YES];
}
///挂号、咨询、关注、陪诊点击
-(void)buttonClickAction:(NSInteger)tag{
//    switch (tag) {
//        case 11001:{
//            [self normalOrder];
//        }break;
//        case 11002:{
//            [self expertOrder];
//        }break;
//        case 11003:{
//            [self askTheDoctor];
//        }break;
//        case 11004:{
//            [self myAttention];
//        }break;
//        case 11005:{
//            [self accompany];
//        }break;
//        default:
//            break;
//    }
}
//更多
-(void)moreInformation:(NSInteger)type{
    if (type == 5) {//健康评测更多
        NSLog(@"健康评测更多");
        HealthTestListViewController *vc = [GHViewControllerLoader HealthTestListViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 4){///特色科室
        NSLog(@"特色科室");
         self.tabBarController.selectedIndex = 2;
//        SpecialListViewController *vc = [GHViewControllerLoader SpecialListViewController];
//        [self.navigationController pushViewController:vc animated:YES];
    }else{//健康资讯更多
        self.tabBarController.selectedIndex = 3;
    }
}

///轮播图点击
-(void)clickIndex:(NSInteger)index{//1接单视频 2 充值  3儿童急诊 4特色科室 5特需号页面  6就医陪诊 7社保卡预约挂号页面
    if (homeVO.banners&&homeVO.banners.count>index) {
        BannerVO * vo = homeVO.banners[index];
        if (vo.type) {
            if (vo.type.intValue == 1) {
//                [self playMP4];
            }else if (vo.type.intValue == 2) {///充值
                
                [self recharge];
            }else if (vo.type.intValue == 3) {
                
                [self login];
                if ([DataManager getInstance].loginState != 1) {
                    return;
                }
                ChildBannerController *view = (ChildBannerController *)[GHViewControllerLoader ChildBannerController];
                [self.navigationController pushViewController:view animated:YES];
                return;
            }else if (vo.type.intValue == 4) {///调到特色科室更多
                SpecialListViewController *vc = [GHViewControllerLoader SpecialListViewController];
                [self.navigationController pushViewController:vc animated:YES];
            }else if (vo.type.intValue == 5) {///特需号
                [self expertOrder];
            }else if (vo.type.intValue == 6) {///就医陪诊
                [self accompany];
            }else if (vo.type.intValue == 7) {///社保卡预约
                [self login];
                if ([DataManager getInstance].loginState != 1) {
                    return;
                }
                NSLog(@"普通");
                [MobClick event:@"click4"];
                CreateOrderNormalViewController *view = [GHViewControllerLoader CreateOrderNormalViewController];
                view.isHomeCome = YES;
                [self.navigationController pushViewController:view animated:YES];

            }else if (vo.type.intValue == 8){///红包介绍页
                PacketInfoViewController *PacketView = [GHViewControllerLoader PacketInfoViewController];
                [self.navigationController pushViewController:PacketView animated:YES];
            }
            
            
        }
        if(vo.linkUrl&&vo.linkUrl.length>6){
            [self login];
            if ([DataManager getInstance].loginState != 1) {
                return;
            }
            HtmlAllViewController *controller = [[HtmlAllViewController alloc] init];
            controller.mUrl = vo.linkUrl ; ;
            controller.mTitle = vo.name;
            __weak typeof(self) weakSelf = self;
            [controller clickToPage:^(NSString *funStr) {
                if ([funStr hasSuffix:@"expertOrder"]) {///专家号

                }else if ([funStr hasSuffix:@"normalOrder"]) {///普通号
                    [weakSelf normalOrder];
                }else if ([funStr hasSuffix:@"seriousOrder"]) {///重疾
                    [weakSelf serious];
                }else if ([funStr hasSuffix:@"accompanyOrder"]) {///陪诊
                    [weakSelf accompany];
                }else if ([funStr hasSuffix:@"healthOrder"]) {///健康管理
                    [weakSelf.navigationController pushViewController:[GHViewControllerLoader HealthManagerViewController] animated:YES];
                }else if ([funStr containsString:@"specialOrder"]) {///特色科室
                    if ([funStr containsString:@"specialOrder&id="]) {///指定科室
                        ///先获取id，在跳转
                        NSString *idStr = [[funStr componentsSeparatedByString:@"specialOrder&id="]lastObject];
                        SpecialDepViewController *depVC = [GHViewControllerLoader SpecialDepViewController];
                        depVC._id = [NSNumber numberWithInt:idStr.intValue];
                        [weakSelf.navigationController pushViewController:depVC animated:YES];
                    }else{
                        [weakSelf.navigationController pushViewController:[GHViewControllerLoader SpecialListViewController] animated:YES];

                    }
                    
                }
            }];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
}
-(void)pushToHtmlAllViewControllerWithTitle:(NSString *)title URL:(NSString *)url {
    HtmlAllViewController *controller = [[HtmlAllViewController alloc] init];
    controller.isTest = YES;
    controller.mUrl = [DataManager getInstance].user.token;
    controller.mTitle = title;
    [self.navigationController pushViewController:controller animated:YES];
}
///充值
-(void)recharge{
    [self login];
    if ([DataManager getInstance].loginState != 1) {
        return;
    }
    GHRechargeViewController *view = [GHViewControllerLoader GHRechargeViewController];
    [self.navigationController pushViewController:view animated:YES];
    
}

///登录】
-(void) login{
    if ([DataManager getInstance].loginState == 1) {
        
    }else{
        LoginViewController * view = [GHViewControllerLoader LoginViewController];
        view.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

-(void)loginComplete{
    
}

- (UIImage *)createAImageWithColor:(UIColor *)color alpha:(CGFloat)alpha{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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
