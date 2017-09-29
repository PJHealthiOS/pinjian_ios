//
//  InformationController.m
//  GuaHao
//
//  Created by qiye on 16/10/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "InformationController.h"
#import "InformationDetailViewController.h"

#import "NavigationTabView.h"
#import "Utils.h"
#import "UITableView+MJ.h"
#import "ServerManger.h"
#import "Masonry.h"
#import "HtmlAllViewController.h"
#import "InformationCell.h"
#import "ArticeHomeVO.h"
#import "CategoryVO.h"
#import "ArticleListVO.h"
#import "GHAdvertView.h"
@interface InformationController ()<NavigationTabViewDelegate,UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NavigationTabView *tabView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ArticeHomeVO *dataSource;
@property (nonatomic, strong) NSMutableArray *bananaSource;
@end

@implementation InformationController{
    int page ;
    NSNumber * selectID;
    GHAdvertView *adView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabView = [[NavigationTabView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), SCREEN_WIDTH, 42)];
    [self.view addSubview:self.tabView];
    [self ad];
    _tabView.delegate = self;
    _tabView.itemTitles = @[@""];
    [_tabView reloadData];
    [_tabView setSelectedIndex:0];
    page = 1;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 108 - 49)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[InformationCell class] forCellReuseIdentifier:@"InformationCell"];
    [self.view addSubview:self.tableView];
//    __weak typeof (self) weakSelf = self;
    self.tableView.backgroundColor = [Utils lineGray];

    [self.tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
    [self getServer];
}
-(void)ad{
    adView = [[GHAdvertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(750.0/376.0))];
    __weak typeof(self) weakSelf = self;
    [adView setAdvertAction:^(NSInteger idx) {
        [weakSelf clickIndex:idx];
    }];
    [adView setAdvertInterval:3];
    [adView setCurrentPageColor:[UIColor greenColor]];
    [adView setPageIndicatorTintColor:[UIColor grayColor]];
}
- (void)didSelectTabAtIndex:(NSInteger)index
{
    if(_dataSource&&_dataSource.categories){
        CategoryVO * vo = _dataSource.categories[index];
        selectID = vo.id;
        _dataSource.articles = nil;
        [self.bananaSource removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void) loadNewData
{
    [self getOrders:NO];
}

-(void) loadMoreData
{
    [self getOrders:YES];
}

-(void) getOrders:(BOOL) isMore
{
    if (!isMore) {
        _dataSource.articles = nil;
        page = 1;
    }else{
        page ++;
    }
    
    [[ServerManger getInstance] getHomeList:selectID size:6 page: page andCallback:^(id data) {
        
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    NSMutableArray * messages = [NSMutableArray arrayWithArray:_dataSource.articles];
                    for (int i = 0; i<arr.count; i++) {
                        ArticleListVO *vo = [ArticleListVO mj_objectWithKeyValues:arr[i]];
                        [messages addObject:vo];
                    }
                    if(_dataSource.articles){
                        _dataSource.articles = nil;
                    }
                    self.bananaSource = [NSMutableArray array];
                    for (int i = 0; i < messages.count; i++) {
                        if (i < 3) {
                            ArticleListVO *vo = [messages objectAtIndex:i];
                            [self.bananaSource addObject:vo.coverUrl];;
                        }
                        
                        
                    }
                    _dataSource.articles = messages;
                    [_tableView reloadData];
                    
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(void) getServer
{
    [[ServerManger getInstance] getHomeArticle:6 page:page andCallback:^(id data) {
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    _dataSource = [ArticeHomeVO mj_objectWithKeyValues:data[@"object"]];
                    _tabView.itemTitles = _dataSource.getCategories;
                    CategoryVO * vo = _dataSource.categories[0];
                    selectID = vo.id;
                    self.bananaSource = [NSMutableArray array];
                    for (int i = 0; i < _dataSource.articles.count; i++) {
                        if (i < 3) {
                            ArticleListVO *vo = [_dataSource.articles objectAtIndex:i];
                            [self.bananaSource addObject:vo.coverUrl];;
                        }
                        
                        
                    }
                    [_tabView reloadData];
                    [_tabView setSelectedIndex:0];
                    [_tableView reloadData];
                    
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        if(self.dataSource&&self.dataSource.articles){
            return self.dataSource.articles.count;
        }
        return 0;
    }
   
}
//轮播图点击
-(void)clickIndex:(NSInteger)index{
    if (index < _dataSource.articles.count) {
        ArticleListVO * vo = [_dataSource.articles objectAtIndex:index];
        InformationDetailViewController * view = [[InformationDetailViewController alloc] init];
        view.articleID = vo.id;
        [self.navigationController pushViewController:view animated:YES];
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.bananaSource.count > 0) {
            if ([cell.contentView viewWithTag:1011]) {
                adView = [cell.contentView viewWithTag:1011];
            }else{
                [cell.contentView addSubview:adView];
               
                
            }
            
        }
         [adView setAdvertImagesOrUrls:self.bananaSource];
        return cell;
    }else{
        InformationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InformationCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.dataSource&&self.dataSource.articles){
            [cell setCell:self.dataSource.articles[indexPath.row]];
        }
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCREEN_WIDTH/(750.0/376.0);
    }
    return 106;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArticleListVO * vo;
    if (self.dataSource&&self.dataSource.articles) {
        vo = self.dataSource.articles[indexPath.row];
        InformationDetailViewController * view = [[InformationDetailViewController alloc] init];
        view.articleID = vo.id;
        [self.navigationController pushViewController:view animated:YES];
    }
}
@end
