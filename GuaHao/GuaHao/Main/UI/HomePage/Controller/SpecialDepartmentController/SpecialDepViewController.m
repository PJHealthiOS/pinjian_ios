//
//  SpecialDepViewController.m
//  GuaHao
//
//  Created by PJYL on 2016/11/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SpecialDepViewController.h"
#import "BannerVO.h"
#import "DoctorVO.h"
#import "GHAdvertView.h"
#import "SpecialDepInfoCell.h"
#import "DoctorSelectTableViewCell.h"
#import "HtmlAllViewController.h"
#import "SpecialDoctorInfoViewController.h"
#import "SpecialDoctorSelectViewController.h"
#import "SpecialDepartmentInfoCell.h"
@interface SpecialDepViewController ()<UITableViewDelegate,UITableViewDataSource>{
    GHAdvertView *adView;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *doctorArr;
@property (nonatomic, strong)NSMutableArray *bannerArr;
@property (nonatomic, strong)NSMutableArray *imageArr;
@property (nonatomic, strong)NSMutableArray *illnessArr;
@property (nonatomic, copy)NSString *depInfoStr;
@property (nonatomic, assign)CGFloat infoCellHeight;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation SpecialDepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoCellHeight = 155;
    [self.tableView registerNib:[UINib nibWithNibName:@"DoctorSelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DoctorSelectTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SpecialDepartmentInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SpecialDepartmentInfoCell"];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    __weak typeof(self) weakSelf = self;
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] specialDepInfo:self._id andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if(code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    
                    weakSelf.depInfoStr = data[@"object"][@"resume"];
                    ///banner
                    NSArray * banners = data[@"object"][@"banners"];
                    weakSelf.bannerArr = [NSMutableArray array];
                    weakSelf.imageArr = [NSMutableArray array];
                    weakSelf.illnessArr  = [NSMutableArray arrayWithArray:data[@"object"][@"illnesses"]];
                    
                    for (NSDictionary *dic in banners) {
                        BannerVO *vo = [BannerVO mj_objectWithKeyValues:dic];
                        [weakSelf.imageArr addObject:vo.picUrl];
                        [weakSelf.bannerArr addObject:vo];
                        [adView setAdvertImagesOrUrls:weakSelf.imageArr];
                    }
                    ///医生
                    NSArray * doctors = data[@"object"][@"doctors"];
                    weakSelf.doctorArr = [NSMutableArray array];
                    for (NSDictionary *dic in doctors) {
                        DoctorVO *vo = [DoctorVO mj_objectWithKeyValues:dic];
                        [weakSelf.doctorArr addObject:vo];
                        
                    }
                    
                    
                    [weakSelf.tableView reloadData];
                    
                }else{
                    
                }
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
    
}




#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
       return self.doctorArr.count;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 100;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            height = SCREEN_WIDTH/(750.0/288.0);
        }else{
            return [self getInfoHeight:self.illnessArr];
        }
    }else{
        height = 150;
    }
    
    return height;
}
-(int)getInfoHeight:(NSArray *)sourceArr{
    float originX = 10;
    int row = 0;
    for (NSString *str in sourceArr) {
        float originX_ = 10;
        originX_ = originX + str.length * 12 + 10 + 20;
        if (originX_ > SCREEN_WIDTH) {
            originX = 10;
            row = row + 1;
        }
        originX = originX + str.length * 12 + 10 + 20;
        
    }
    return row * (30 + 10) + 110;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 60;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {

        
        return self.headerView;
    }
    return nil;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {///轮播图
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (nil == cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.bannerArr.count > 0) {
                if ([cell.contentView viewWithTag:1011]) {
                    adView = [cell.contentView viewWithTag:1011];
                }else{
                    adView = [[GHAdvertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(750.0/288.0))];
                    [cell.contentView addSubview:adView];
                    [adView setAdvertImagesOrUrls:self.imageArr];
                    __weak typeof(self) weakSelf = self;
                    [adView setAdvertAction:^(NSInteger idx) {
                        [weakSelf clickIndex:idx];
                    }];
                    if (self.imageArr.count >1) {
                        [adView setAdvertInterval:3];
                    }
                    
                    [adView setCurrentPageColor:[UIColor greenColor]];
                    [adView setPageIndicatorTintColor:[UIColor grayColor]];
                    //            cell.contentView.backgroundColor = [UIColor greenColor];
                    
                }
                
            }
            return cell;
        }else{///简介
            
            SpecialDepartmentInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SpecialDepartmentInfoCell"];
              [cell layoutWithSourceArr:self.illnessArr];
            return cell;
            
//            SpecialDepInfoCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"SpecialDepInfoCell"];
//            [cell layoutSubviewsInfo:self.depInfoStr imageStr:@""];
//            __weak typeof (self) weakSelf = self;
//            [cell openDepInfoAction:^(BOOL open) {
//                if (!open) {
//                    weakSelf.infoCellHeight = 155;
//                }else{
//                     weakSelf.infoCellHeight = 125 + [weakSelf boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 0) str:weakSelf.depInfoStr fount:13].height;;
//                }
//                [weakSelf.tableView reloadData];
//                NSLog(@"weakSelf.infoCellHeight-----------%f",weakSelf.infoCellHeight);
//            }];
//            return cell;
        }
    }else{///医生
        DoctorVO *vo = [self.doctorArr objectAtIndex:indexPath.row];
         DoctorSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorSelectTableViewCell"];
        [cell setCell:vo];
        return cell;
    }
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        SpecialDoctorInfoViewController *view = [GHViewControllerLoader SpecialDoctorInfoViewController ];
        DoctorVO * vo = self.doctorArr[indexPath.row];
        view.doctorId = vo.id;
        [self.navigationController pushViewController:view animated:YES];
    }
}
///轮播图点击事件
-(void)clickIndex:(NSInteger)index{

    BannerVO *vo = [self.bannerArr objectAtIndex:index];
    if (vo.linkUrl.length < 6) {
        return;
    }
    HtmlAllViewController *controller = [[HtmlAllViewController alloc] init];
    controller.mUrl = vo.linkUrl;
    controller.mTitle = vo.name;
    [self.navigationController pushViewController:controller animated:YES];
}
//更多医生
- (IBAction)moreDoctor:(id)sender {
    SpecialDoctorSelectViewController *vc = [GHViewControllerLoader SpecialDoctorSelectViewController];
    vc._id = self._id;
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGSize)boundingRectWithSize:(CGSize)size str:(NSString *)str fount:(CGFloat)fount
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fount]};
    
    CGSize retSize = [str boundingRectWithSize:size
                                       options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize;
    
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
