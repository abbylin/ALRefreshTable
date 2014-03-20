//
//  TestController1.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-3-5.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "TestController1.h"

@interface TestController1 ()

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation TestController1

- (void)viewDidLoad{
    [super viewDidLoad];
    self.dataArray = @[@"test1", @"test2", @"test3"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray && self.dataArray.count > 0) {
        return self.dataArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        return 50;
    }else{
        return 80;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

@end
