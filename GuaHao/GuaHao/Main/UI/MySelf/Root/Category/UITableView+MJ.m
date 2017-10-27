//
//  UITableView+MJ.m
//  GuaHao
//
//  Created by qiye on 16/8/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "UITableView+MJ.h"
#import "MJRefresh.h"
#import "MJGHHeader.h"

@implementation UITableView (MJ)

-(void)initMJ:(id)target type:(MJType) type newAction:(SEL) newSel moreAction:(SEL) moreSel
{
    switch (type) {
        case MJTypeNone:
        {
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:newSel];
            MJRefreshBackGifFooter * footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:moreSel];
            self.mj_header = header;
            self.mj_footer = footer;
            break;
        }
        case MJTypePJGifELME:
        case MJTypePJGifTaoBao:
        case MJTypePJGifJD:
        {
            MJGHHeader *header = [MJGHHeader headerWithRefreshingTarget:target refreshingAction:newSel];
            MJRefreshBackGifFooter * footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:moreSel];
            header.mjType = type;
            self.mj_header = header;
            self.mj_footer = footer;
            break;
        }
        default:
            break;
    }
}
@end
