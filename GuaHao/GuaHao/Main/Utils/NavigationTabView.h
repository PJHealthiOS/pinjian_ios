//
//  HeadTabView.h
//  Pinjian
//
//  Created by  patyang on 15/7/12.
//  Copyright (c) 2015年 fangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationTabViewDelegate <NSObject>

- (void)didSelectTabAtIndex:(NSInteger)index;

@end

@interface NavigationTabView : UIView

@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIColor *lineSelectedColor;
@property (nonatomic, strong) UIColor *viewColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, weak) NSObject<NavigationTabViewDelegate> *delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)reloadData;
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

@end
