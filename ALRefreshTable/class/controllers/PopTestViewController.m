//
//  PopTestViewController.m
//  ALRefreshTable
//
//  Created by linzhu on 14-8-28.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "PopTestViewController.h"
#import "ALBaseAnimationTestViewController.h"
#import "CoreTextTestCell.h"

@interface PopTestViewController (){
    NSArray *_dataArray;
}

@end

@implementation PopTestViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _dataArray = @[@"text animation"];
    [self.tableView registerClass:[CoreTextTestCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark -
#pragma mark - UITableViewController delegate and data source methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray ? _dataArray.count : 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoreTextTestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ALBaseAnimationTestViewController *vc = [[ALBaseAnimationTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
