//
//  SortSelectTableView.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/24.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SortSelectTableView.h"
#import "SortTableViewCell.h"
@interface SortSelectTableView ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@end
@implementation SortSelectTableView
-(instancetype)initWithFrame:(CGRect)frame sourceArray:(NSArray *)sourceArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.sourceArr = [NSMutableArray arrayWithArray:sourceArr];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, sourceArr.count *44 > frame.size.height ? frame.size.height:sourceArr.count *44)];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.tableView registerNib:[UINib nibWithNibName:@"SortTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SortTableViewCell"];
        [self.tableView reloadData];
    }
    return self;
}

-(void)reloadTableView:(NSArray *)sourceArr{
    self.sourceArr = [NSMutableArray arrayWithArray:sourceArr];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, sourceArr.count *44 > SCREEN_HEIGHT - 108 ? SCREEN_HEIGHT - 108:sourceArr.count *44);
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SortTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SortTableViewCell"];
    [cell setTypeNmae:[self.sourceArr objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myBlock) {
        self.myBlock(indexPath.row,YES);
    }
    
}

-(void)cellClickAction:(CellClickActionBlock)block{
    self.myBlock = block;
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidden = YES;
    self.myBlock(1,NO);
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
