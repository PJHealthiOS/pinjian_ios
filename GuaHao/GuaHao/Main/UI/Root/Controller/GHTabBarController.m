

#import "GHTabBarController.h"
#import "GHNavigationController.h"
#import "UIImage+Image.h"
#import "HomePageVC.h"
#import "MessageViewController.h"

#import "GHOrderController.h"
#import "GHMySelfViewController.h"
#import "MessageController.h"
#import "InformationController.h"
#import "GHTabBar.h"
@interface GHTabBarController ()

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong)HomePageVC *homeVC;
@property (nonatomic, strong)GHOrderController *ghOrder;

@property (nonatomic, weak) GHMySelfViewController *my;
@property (nonatomic, weak) MessageController *message;

@end

@implementation GHTabBarController

- (NSMutableArray *)items
{
    if (_items == nil) {
        
        _items = [NSMutableArray array];
        
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加所有子控制器
    [self setUpAllChildViewController];
    self.tabBar.backgroundColor = [UIColor whiteColor];
//    GHTabBar *tabbar = [[GHTabBar alloc]init];
//    [tabbar plusBtnClickAction:^(BOOL result) {
//        SpecialListViewController *vc = [GHViewControllerLoader SpecialListViewController];
//        vc.isPresent = YES;
//        GHNavigationController *nav = [[GHNavigationController alloc]initWithRootViewController:vc];
//        [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
//    }];
//    [self setValue:tabbar forKey:@"tabBar"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMSGBack:) name:@"UserMSGUpdate" object:nil];
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"消息"]) {
        if ([DataManager getInstance].user == nil) {
            LoginViewController * vc = [GHViewControllerLoader LoginViewController];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
        }
    
    }
    

    
}
-(void)updateMSGBack:(NSNotification *)notification{
    if(notification.userInfo == nil){
        return;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark - 添加所有的子控制器
- (void)setUpAllChildViewController
{
    // 首页

    HomePageVC *homeVC = (HomePageVC *)[[GHViewControllerLoader HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"HomePageVC"];
    [self setUpOneChildViewController:homeVC image:[UIImage imageNamed:@"tabbar_home0.png"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_home_selected0.png"] title:@"首页"];
    self.homeVC = homeVC;
    
    
    //消息
    
    MessageController * message = [[MessageController alloc] init];
    [self setUpOneChildViewController:message image:[UIImage imageNamed:@"tabbar_acceptOrder0.png"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_acceptOrder_selected0.png"] title:@"消息"];
    _message = message;
    [DataManager getInstance].messageVC = message;
   
    ///特色科室
    SpecialListViewController *specialOrder = [GHViewControllerLoader SpecialListViewController];
    [self setUpOneChildViewController:specialOrder image:[UIImage imageNamed:@"tabbar_special.png"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_special_selected.png"] title:@"特色科室"];
    
    ///咨询
    InformationController * information = [[InformationController alloc] init];
    [self setUpOneChildViewController:information image:[UIImage imageNamed:@"tabbar_search0.png"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_search_selected0.png"] title:@"资讯"];
    
    // 我
//    PersonViewController *me = [[PersonViewController alloc] init];
    GHMySelfViewController *my = (GHMySelfViewController *)[GHViewControllerLoader GHMySelfViewController];
    [self setUpOneChildViewController:my image:[UIImage imageNamed:@"tabbar_profile0.png"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_profile_selected0.png"] title:@"我的"];
//    _my = my;
}
// navigationItem决定导航条上的内容
// 导航条上的内容由栈顶控制器的navigationItem决定

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    vc.tabBarItem.title = title;
    UIColor *titleHighlightedColor = [UIColor colorWithRed:53.0f/255.0f green:206.0f /255.0f blue:128.0f/255.0f alpha:1.0f];
    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];

    // 保存tabBarItem模型到数组
    [self.items addObject:vc.tabBarItem];

        GHNavigationController *nav = [[GHNavigationController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];

    
    
}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
