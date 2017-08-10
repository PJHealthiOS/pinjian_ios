//
//  PageScrollView.h
//  Pinjian
//
//  Created by Patrick Yang on 14-7-5.
//  Copyright (c) 2014年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PageScrollFinishNever = 0,
    PageScrollFinishScroll,
    PageScrollFinishFadOut,
    PageScrollFinishNoLimit,
} PageScrollFinishMode;

@class PageScrollView;

@protocol PageScrollViewDelegate <NSObject>

@optional

- (void)pageScrollView:(PageScrollView *)page didSelectedAtIndex:(NSInteger)index;
- (void)pageScrollViewDidFinished:(PageScrollView *)page;

@end

@interface PageScrollView : UIView
{
    
}

@property (nonatomic, weak) NSObject<PageScrollViewDelegate> *delegate;
@property (nonatomic, strong) NSArray *itemImages;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) PageScrollFinishMode finishMode;

- (void)reloadData;
- (void)show:(BOOL)animation;

-(void)showPageControl:(BOOL) show;
-(void)shouldAutoShow:(BOOL)shouldStart;

@end