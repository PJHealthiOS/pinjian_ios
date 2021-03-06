#import "GHNewFeatureController.h"
#import "GHNewFeatureCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface GHNewFeatureController ()

@property (nonatomic, weak) UIPageControl *control;

@end

@implementation GHNewFeatureController
static NSString *ID = @"cell";
- (instancetype)init
{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    
    // 清空行距
    layout.minimumLineSpacing = 0;
    
    // 设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [super initWithCollectionViewLayout:layout];
}
// self.collectionView != self.view
// 注意： self.collectionView 是 self.view的子控件

// 使用UICollectionViewController
// 1.初始化的时候设置布局参数
// 2.必须collectionView要注册cell
// 3.自定义cell
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 注册cell,默认就会创建这个类型的cell
    [self.collectionView registerClass:[GHNewFeatureCell class] forCellWithReuseIdentifier:ID];

    // 分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    

    // 添加pageController
    [self setUpPageControl];
}
// 添加pageController
- (void)setUpPageControl
{
    // 添加pageController,只需要设置位置，不需要管理尺寸
    UIPageControl *control = [[UIPageControl alloc] init];
    
    control.numberOfPages = 3;
    control.pageIndicatorTintColor = [UIColor lightGrayColor];
    control.currentPageIndicatorTintColor = UIColorFromRGB(0x45c768);
    
    // 设置center
    control.center = CGPointMake(self.view.width * 0.5, self.view.height-30);
    _control = control;
    [self.view addSubview:control];
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 80, 80, 30);
    [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    skipButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    skipButton.layer.cornerRadius = 15;
    skipButton.layer.masksToBounds = YES;
    [skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:skipButton];
    
}
-(void)skipAction{
    GHTabBarController *tabBarVc = [[GHTabBarController alloc] init];
    
    // 切换根控制器:可以直接把之前的根控制器清空
    GHKeyWindow.rootViewController = tabBarVc;
}
#pragma mark - UIScrollView代理
// 只要一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前的偏移量，计算当前第几页
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    // 设置页数
    _control.currentPage = page;
}
#pragma mark - UICollectionView代理和数据源
// 返回有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
// 返回第section组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}



// 返回cell长什么样子
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // dequeueReusableCellWithReuseIdentifier
    // 1.首先从缓存池里取cell
    // 2.看下当前是否有注册Cell,如果注册了cell，就会帮你创建cell
    // 3.没有注册，报错
    GHNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    
    // 拼接图片名称 3.5 320 480
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    NSString *imageName = [NSString stringWithFormat:@"new_feature_%d",indexPath.row + 1];
//    if (screenH > 480) { // 5 , 6 , 6 plus
//        imageName = [NSString stringWithFormat:@"new_feature_%d-568h",indexPath.row + 1];
//    }
    cell.image = [UIImage imageNamed:imageName];
    
    
    [cell setIndexPath:indexPath count:3];

    
    return cell;
    
}



@end
