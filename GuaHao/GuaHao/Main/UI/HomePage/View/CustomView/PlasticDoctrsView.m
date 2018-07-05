//
//  PlasticDoctrsView.m
//  GuaHao
//
//  Created by PJYL on 2018/6/12.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import "PlasticDoctrsView.h"
#import "DoctorSelectTableViewCell.h"



@interface PlasticDoctrsView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    int page ;
    NSMutableArray * datas;
}
@property (nonatomic, assign) NSInteger idStr;


@end

@implementation PlasticDoctrsView
-(instancetype)initWithFrame:(CGRect)frame idStr:(NSInteger)idStr{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"PlasticDoctrsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(SCREEN_WIDTH *2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 44 - 56);
        self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [_tableView registerNib:[UINib nibWithNibName:@"DoctorSelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DoctorSelectTableViewCell"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        [self loadWithID:idStr];
    }return self;
    
}

-(void)loadWithID:(NSInteger)idStr{

    datas = [NSMutableArray array];
    self.idStr = idStr;
    [self getDoctors:NO];
}
-(void)loadMore{
     [self getDoctors:YES];
}
-(void) getDoctors:(BOOL) isMore
{
    if (!isMore) {
        [datas removeAllObjects];
        page = 1;
    }else{
        page ++;
    }
    [[ServerManger getInstance]getPlasticDoctorsWithId:self.idStr page:page andCallback:^(id data) {
        
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (arr&&arr.count>0) {
                        for (int i = 0; i<arr.count; i++) {
                            DoctorVO *vo = [DoctorVO mj_objectWithKeyValues:arr[i]];
                            [datas addObject:vo];
                    
                        }
                    }
                    
                    if (datas.count ==0) {
//                        [self inputToast:@"没有搜索到相关医生！"];
                    }
                }
                [_tableView reloadData];
                
            }else{
//                [self inputToast:msg];
            }
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 144;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoctorSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorSelectTableViewCell"];
    if (datas.count>0) {
        [cell setCell:datas[indexPath.row]];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (datas.count > 0) {
        DoctorVO * vo = datas[indexPath.row];
        self.action(vo.id);
    }
}

-(void)selectDoctor:(SelectDoctorAction)action{
    self.action = action;
}





-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"医生列表开始滑动,----->>>%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 0 ) {
        self.tableView.scrollEnabled = NO;
        scrollView.contentOffset = CGPointZero;
    }
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
