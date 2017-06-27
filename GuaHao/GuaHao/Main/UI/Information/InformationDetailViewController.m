//
//  InformationDetailViewController.m
//  GuaHao
//
//  Created by qiye on 16/9/29.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "InformationDetailViewController.h"
#import "Masonry.h"
#import "InformationContentCell.h"
#import "InformationVO.h"
#import "InformationCommentCell.h"
#import "ServerManger.h"
#import "InformationVO.h"
#import "UITableView+MJ.h"
#import "CommentVO.h"
#import "CommentFloorVO.h"
#import "Utils.h"
#import "UIViewBorders.h"
#import "ServerManger.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CommentView.h"
@interface InformationDetailViewController () <UITableViewDataSource, UITableViewDelegate ,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) InformationVO *dataSource;
@property (nonatomic, strong) UIView * bottowView;
@property (nonatomic, strong) UIButton * btnSend;
@property (nonatomic, strong) UIButton * btnShare;
@property (nonatomic, strong) UIButton * btnPraise;
@property (nonatomic, copy) NSString *inputTF;
@end

@implementation InformationDetailViewController{
    int page;
    NSMutableDictionary * commentDic;
    CommentVO *  commentVO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康资讯";

    _dataSource = [InformationVO new];
    page = 1;
    [self initView];
    [self.tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
    [self loadNewData];
}

-(void)initView{
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[InformationContentCell class] forCellReuseIdentifier:@"InformationContentCell"];
    [self.tableView registerClass:[InformationCommentCell class] forCellReuseIdentifier:@"InformationCommentCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(-50);
    }];
    
    self.bottowView = [[UIView alloc] init];
    self.bottowView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.bottowView];
    [self.bottowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(50);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    [self.bottowView addTopBorderWithHeight:1.0 andColor:[Utils lineGray]];
    
    
    
    //输入按钮
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setTitle:@"发表评论..." forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(requestForCommon) forControlEvents:UIControlEventTouchUpInside];
    [commentButton setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    commentButton.backgroundColor = [UIColor whiteColor];
    commentButton.layer.cornerRadius  = 5;
    commentButton.layer.masksToBounds = YES;
    [self.bottowView addSubview:commentButton];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(30);
        make.left.mas_offset(10);
        make.right.mas_offset(-90);
        make.bottom.mas_offset(-10);
    }];
    
    ///底部分享按钮
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"information_share.png"] forState:UIControlStateNormal];
    [self.bottowView addSubview:shareButton];
    [shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(41, 32));
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-8);
    }];

    
    ///底部点赞按钮
    self.btnPraise = [[UIButton alloc] init];
    [self.btnPraise setImage:[UIImage imageNamed:@"information_good_normal.png"] forState:UIControlStateNormal];
    [self.btnPraise setImage:[UIImage imageNamed:@"information_good_select"] forState:UIControlStateSelected];
    [self.bottowView addSubview:self.btnPraise];
    [self.btnPraise addTarget:self action:@selector(sendPraise:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPraise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(30);
        make.right.mas_offset(-54);
        make.bottom.mas_offset(-10);
    }];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, 32)];
    [btn setImage:[UIImage imageNamed:@"information_share.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //监听键盘，键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardwill:)
                                                name:UIKeyboardWillShowNotification object:nil];
    
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keybaordhide:)
                                                name:UIKeyboardWillHideNotification object:nil];
    
    //设置点击手势，当点击空白处，结束编辑，收回键盘
    UITapGestureRecognizer *tapp=[[UITapGestureRecognizer alloc]
                                  initWithTarget:self action:@selector(tapAction:)];
    tapp.delegate = self;
    //开启交互
    self.view.userInteractionEnabled=YES;
    //添加手势到视图
    [self.view addGestureRecognizer:tapp];
}
///点击进行评论
-(void)requestForCommon{
    CommentView *commentView = [[CommentView alloc]initWithFrame:self.view.frame];
    __weak typeof(self) weakSelf = self;
    [commentView sendCommentMessage:^(NSString *result) {
        weakSelf.inputTF = result;
        [weakSelf sendClick:nil];
    }];
    [self.view addSubview:commentView];
}
//点击手势方法
-(void)tapAction:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

//当键盘出现时，调用此方法
-(void)keyboardwill:(NSNotification *)sender
{
    //获取键盘高度
    NSDictionary *dict=[sender userInfo];
    NSValue *value=[dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardrect = [value CGRectValue];
    int height=keyboardrect.size.height;
    
    //如果输入框的高度低于键盘出现后的高度，视图就上升；
    self.view.frame = CGRectMake(0, -height, self.view.frame.size.width, self.view.frame.size.height);
}

//当键盘隐藏时候，视图回到原定
-(void)keybaordhide:(NSNotification *)sender
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendClick:nil];
    return YES;
}

-(void)sendClick:(id)sender{
    NSLog(@"send click");
    [self.view endEditing:YES];
    if(self.inputTF&&self.inputTF.length==0){
        return;
    }
    [commentDic setObject:self.inputTF forKey:@"content"];
    [[ServerManger getInstance] commentArticle:commentDic ariticleID:_dataSource.id andCallback:^(id data) {
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    [self inputToast:@"评论成功！"];
                    [self comment];
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(void)sendPraise:(id)sender{
    
    [[ServerManger getInstance] praiseArticle:_dataSource.id andCallback:^(id data) {
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    [self inputToast:@"点赞成功！"];
                    self.btnPraise.selected = YES;
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(void)comment{
    if(commentVO == nil||commentVO.id == nil){
        commentVO = [CommentVO new];
        commentVO.creatorName = [DataManager getInstance].user.nickName;
        commentVO.avatar = [DataManager getInstance].user.avatar;
        commentVO.content = self.inputTF;
        commentVO.replyTime = [Utils getCurrentDay];
        commentVO.replyCount = [NSNumber numberWithInt:0];
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        if(_dataSource.comments==nil){
            _dataSource.comments = [NSArray arrayWithObject:commentVO];
        }else{
            NSMutableArray * arr = [NSMutableArray arrayWithArray:_dataSource.comments];
            [arr addObject:commentVO];
            _dataSource.comments = [NSArray arrayWithArray:arr];
        }
        
        [_dataSource caculateHeight];
        commentVO = nil;
        self.inputTF = @"";
        [_tableView reloadData];
        return;
    }
    CommentFloorVO * vo = commentVO.childComments[commentVO.childComments.count-1];
    vo.content = self.inputTF;
    self.inputTF = @"";
    if(_dataSource.comments){

        for (int i = 0; i< _dataSource.comments.count; i++) {
            CommentVO * cc = _dataSource.comments[i];
            if (cc.id.intValue == commentVO.id.intValue) {
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                cc = commentVO;
                [_dataSource caculateHeight];
                commentVO = nil;
                NSIndexPath  *indexPath_1=[NSIndexPath indexPathForRow:i+1 inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray  arrayWithObject:indexPath_1] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }

}

-(void)shareClick:(id)sender{
    NSLog(@"share click");
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"commo_applyShare_2Bar.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://list.image.baidu.com/t/yingshi.jpg"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"想了解更多信息，请下载品简挂号！"
                                         images:imageArray
                                            url:[NSURL URLWithString:_dataSource.linkUrl]
                                          title:_dataSource.title
                                           type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"详情点击：%@",_dataSource.linkUrl] title:_dataSource.title image:imageArray url:[NSURL URLWithString:_dataSource.linkUrl] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
        
//        [shareParams SSDKSetupQQParamsByText:@"想了解更多信息，请下载品简挂号！" title:_dataSource.title url:[NSURL URLWithString:_dataSource.linkUrl] thumbImage:imageArray image:imageArray type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
//        
//        [shareParams SSDKSetupQQParamsByText:@"想了解更多信息，请下载品简挂号！" title:_dataSource.title url:[NSURL URLWithString:_dataSource.linkUrl] thumbImage:imageArray image:imageArray type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               [self inputToast:@"分享成功"];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               [self inputToast:@"分享失败"];
                               break;
                           }
                           default:
                               break;
                       }
                   }];
    }
}

-(void) loadNewData
{
    _dataSource = nil;
    page = 1;
    [[ServerManger getInstance] getArticle:_articleID size:6 page: page andCallback:^(id data) {
        [_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    _dataSource = [InformationVO mj_objectWithKeyValues:data[@"object"]];
                   // self.title = _dataSource.title;
                    [_dataSource caculateHeight];
                    commentDic = [NSMutableDictionary new];
                    if(_dataSource.praised){
                        self.btnPraise.selected = YES;
                    }
                    [_tableView reloadData];
                    
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(void) loadMoreData
{
    page ++;
    [[ServerManger getInstance] getCommendList:_articleID size:6 page: page andCallback:^(id data) {
        
        [_tableView.mj_footer endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    NSMutableArray * messages = [NSMutableArray arrayWithArray:_dataSource.comments];
                    for (int i = 0; i<arr.count; i++) {
                        CommentVO *vo = [CommentVO mj_objectWithKeyValues:arr[i]];
                        [messages addObject:vo];
                    }
                    _dataSource.comments = [NSArray arrayWithArray:messages];
                    [_dataSource caculateHeight];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataSource&&(self.dataSource.comments==nil||self.dataSource.comments.count==0)){
        return 1;
    }
    return self.dataSource.comments.count+1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof (self) weakSelf = self;

    if(indexPath.row == 0){
        InformationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationContentCell"];
        cell.myBlock =^(float height){
            InformationVO * vo = weakSelf.dataSource;
            if(vo.cellHeight < 2){
                weakSelf.dataSource.cellHeight = height;
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray  arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCell:_dataSource];
        return cell;
    }
    InformationCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InformationCommentCell"];
    if(_dataSource.comments){
        cell.myblock = ^(NSMutableDictionary * dic,CommentVO * vo)
        {
            [weakSelf dealBlock:dic vo:vo];
        };
        [cell setCell:_dataSource.comments[indexPath.row-1]];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)dealBlock:(NSMutableDictionary *) dic vo:(CommentVO*) vo
{
    if(dic){
        commentVO = vo;
        commentDic = dic;
        [self requestForCommon];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0){
        if(self.dataSource){
            InformationVO * vo = self.dataSource;
            if(vo.cellHeight >0){
                if (vo.cellHeight < 1000) {
                    return 1000;
                }
                return vo.cellHeight;
            }
        }
        return 600;
    }else{
        CommentVO * vo = _dataSource.comments[indexPath.row-1];
        return vo.cellHeight;
    }
    return 50;
}
@end
