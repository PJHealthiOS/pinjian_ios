//
//  SpecialListViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SpecialListViewController.h"
#import "SpecialDepartmentVO.h"
#import "SpecialCollectionCell.h"

@interface SpecialListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageHeight;
@property (weak, nonatomic) IBOutlet UIView *collocationBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (nonatomic, strong)NSMutableArray *sourceArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation SpecialListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"特色科室";
    self.headerImageHeight.constant = 351.0*SCREEN_WIDTH/750.0;
    self.sourceArr = [NSMutableArray array];
    [self getData];
    if (self.isPresent) {
        UIBarButtonItem *left = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"point_back.png"] highImage:[UIImage imageNamed:@"point_back.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        // 设置导航条的按钮
        self.navigationItem.leftBarButtonItem = left;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    // 定义大小
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 40)/3, 100);
    // 设置最小行间距
    layout.minimumLineSpacing = 0;
    // 设置垂直间距
    layout.minimumInteritemSpacing = 0;
    // 设置滚动方向（默认垂直滚动）
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40 , 300) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SpecialCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SpecialCollectionCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collocationBackView addSubview:self.collectionView];
    // Do any additional setup after loading the view.
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getData{
    __weak typeof(self) weakSelf = self;
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] specialDepListDataCallback:^(id data) {
        
        [weakSelf.view hideToastActivity];
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if(code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if(arr.count == 0){
                        weakSelf.cityLabel.hidden = NO;
                        weakSelf.cityImageView.hidden = NO;
                        
                        
                        weakSelf.backViewHeight.constant = self.headerImageHeight.constant + 128 + 300;
                    }else{
                        weakSelf.cityLabel.hidden = YES;
                        weakSelf.cityImageView.hidden = YES;
                        self.sourceArr = [NSMutableArray array];
                        for (NSDictionary *dic in arr) {
                            SpecialDepartmentVO *vo = [SpecialDepartmentVO mj_objectWithKeyValues:dic];
                            [weakSelf.sourceArr addObject:vo];
                            
                        }
                        weakSelf.backViewHeight.constant = self.headerImageHeight.constant + 150 + 100 *(int)ceilf(weakSelf.sourceArr.count/3.0);
                        
                        [self.collectionView reloadData];
                        
                    }

                    
                }else{
                    
                }
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SpecialDepartmentVO *vo = [self.sourceArr objectAtIndex:indexPath.row];
    SpecialCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialCollectionCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:vo.imageUrl] placeholderImage:nil];;
    cell.nameLabel.text = vo.name;

    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SpecialDepartmentVO *vo = [self.sourceArr objectAtIndex:indexPath.row];
    SpecialDepViewController *vc = [GHViewControllerLoader SpecialDepViewController];
    vc.title = vo.name;
    vc._id = vo.id;
    [self.navigationController pushViewController:vc animated:YES];
//    NSLog(@"--------------%@",vo.name);
    
    
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
