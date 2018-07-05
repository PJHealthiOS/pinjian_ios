//
//  PlasticHospitalView.m
//  GuaHao
//
//  Created by PJYL on 2018/6/12.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import "PlasticHospitalView.h"
#import "PlasticHospitalModel.h"
#import "PlasticHospitalCell.h"
@interface PlasticHospitalView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *hospitalArray;
@property (strong, nonatomic) NSMutableArray *hospitalHeightArray;



@end


@implementation PlasticHospitalView
-(instancetype)initWithFrame:(CGRect)frame idStr:(NSInteger)idStr{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"PlasticHospitalView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(SCREEN_WIDTH*1, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 44 - 56);
        [_tableView registerNib:[UINib nibWithNibName:@"PlasticHospitalCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PlasticHospitalCell"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self loadWithID:idStr];
    }return self;
    
}
-(void)loadWithID:(NSInteger)idStr{
    
    __weak typeof(self) weakSelf = self;
    self.hospitalArray = [NSMutableArray array];
    self.hospitalHeightArray = [NSMutableArray array];
    [[ServerManger getInstance]getPlasticHospitalsWithId:idStr andCallback:^(id data) {
        if (data!=[NSNull class]&&data!=nil){
            NSNumber * code = data[@"code"];
//            NSString * msg = data[@"msg"];
            if(code.intValue == 0){
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    for (id dic in arr) {
                        PlasticHospitalModel * order = [PlasticHospitalModel mj_objectWithKeyValues:dic];
                        [weakSelf.hospitalArray addObject:order];
                        [self.hospitalHeightArray addObject:@"展开"];
                    }
                    [weakSelf.tableView reloadData];
                    
                }
                
            }else{
                //                [weakSelf inputToast:msg];
            }
        }
        
    }];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h = 220;
    CGFloat h1 = 20;///科室项目
    CGFloat h2 = 0; ///科室简介
    
    if ([[self.hospitalHeightArray objectAtIndex:indexPath.row] isEqualToString:@"收起"]) {
        ///变大
        PlasticHospitalModel * order = [self.hospitalArray objectAtIndex:indexPath.row];
        
        ///计算科室简介的高度高度
        h2 =  [self getRectWithSize:CGSizeMake(SCREEN_WIDTH - 102, MAXFLOAT) str:[NSString stringWithFormat:@"科室简介：%@", order.deptComments] fount:11].height + 30;
        
        ///计算科室的高度高度
        NSArray *sourceArr =[order.deptName componentsSeparatedByString:@","];
        float originX = 0;
        int row = 0;
        for (NSString *str in sourceArr) {
            float originX_ = 10;
            originX_ = originX + str.length * 12 + 10 + 20;
            if (originX_ > SCREEN_WIDTH - 102) {
                originX = 0;
                row = row + 1;
            }
            originX = originX + str.length * 12 + 10 + 20;
        }
        h1 = row * (20 + 10) + 20;
        
        h = 220 + (h1>=20?h1:0) + (h2>=30?h2:0);
    }
    return h;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hospitalArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlasticHospitalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PlasticHospitalCell"];
    if (self.hospitalArray.count>0) {
        [cell setCell:self.hospitalArray[indexPath.row] indexPath:indexPath operationStr:[self.hospitalHeightArray objectAtIndex:indexPath.row]];
        __weak typeof(self) weakSelf = self;
        
        [cell operationClick:^(NSIndexPath *indexPath) {
            [weakSelf detialInformation:indexPath];
        }];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)detialInformation:(NSIndexPath *)indexPath{
    if ([[self.hospitalHeightArray objectAtIndex:indexPath.row] isEqualToString:@"展开"]) {
        ///全部高度
        [self.hospitalHeightArray replaceObjectAtIndex:indexPath.row withObject:@"收起"];
    }else{///标准高度
        [self.hospitalHeightArray replaceObjectAtIndex:indexPath.row withObject:@"展开"];
    }
    
    //         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y <= 0) {
        self.tableView.scrollEnabled = NO;
        scrollView.contentOffset = CGPointZero;
    }
    
}

- (CGSize)getRectWithSize:(CGSize)size str:(NSString *)str fount:(CGFloat)fount
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
