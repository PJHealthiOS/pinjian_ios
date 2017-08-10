//
//  GHEmptyView.m
//  GuaHao
//
//  Created by 123456 on 16/8/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHEmptyView.h"
#import "GHTabBarController.h"
@interface GHEmptyView (){
    
}


@end
@implementation GHEmptyView
+ (instancetype)emptyView {
    
    GHEmptyView *__emptyView = [[[NSBundle mainBundle] loadNibNamed:@"GHEmptyView" owner:nil options:nil] firstObject];

    
    return __emptyView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"GHEmptyView" owner:nil options:nil] firstObject];
    }
    return self;
}
- (void)setShowContent:(NSString *)content {
    self.label.text = content;
}
- (IBAction)buttonAction:(UIButton *)sender {
    GHTabBarController *tarbarVC = (GHTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *VC = [self currentViewController];
    tarbarVC.selectedIndex = 0;
    [VC.navigationController popToRootViewControllerAnimated:NO];
}

- (UIViewController *)findBestViewController:(UIViewController *)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else {
            return vc;
        }
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
}

-(UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.frame = CGRectMake(0, 0, newSuperview.bounds.size.width, 200);
        self.center = CGPointMake(newSuperview.center.x, newSuperview.bounds.size.height / 2);
    }
}
@end
