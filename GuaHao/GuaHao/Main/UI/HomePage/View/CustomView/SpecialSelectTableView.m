//
//  SpecialSelectTableView.m
//  GuaHao
//
//  Created by PJYL on 2016/11/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SpecialSelectTableView.h"

@interface SpecialSelectTableView ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong)NSMutableArray *sourceArr;
@property (nonatomic, assign)int type;
@end

@implementation SpecialSelectTableView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.sourceArr = [NSMutableArray array];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/3.0, self.frame.size.height)];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        self.backgroundColor = [UIColor whiteColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }return self;
}

-(void)changTableView:(int)type{
    self.type = type;
    if (type == 1) {
        self.sourceArr = [NSMutableArray arrayWithObjects:@"全部",@"主任医师",@"副主任医师", nil];
    }else if (type == 2){
        self.sourceArr = [NSMutableArray arrayWithObjects:@"全部",@"由高到低",@"由低到高", nil];
    }else{
        self.sourceArr = [NSMutableArray arrayWithObjects:@"全部",@"可约",@"不可约", nil];
    }
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}
static NSString *cellID1 = @"cellID1";
static NSString *cellID2 = @"cellID2";
static NSString *cellID3 = @"cellID3";
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"";
    if (self.type == 1)cellID = cellID1;
    if (self.type == 2)cellID = cellID2;
    if (self.type == 3)cellID = cellID3;
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        label.text = [self.sourceArr objectAtIndex:indexPath.row];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x888888);
//        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        
    }return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--SpecialSelectTableView-----%@",[self.sourceArr objectAtIndex:indexPath.row]);
    if (self.myBlock) {
         self.myBlock(indexPath.row,self.type);
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)cellClickAction:(CellClickActionBlock)block{
    self.myBlock = block;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
