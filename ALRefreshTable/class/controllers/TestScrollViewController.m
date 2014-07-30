//
//  TestScrollViewController.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-4-2.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "TestScrollViewController.h"
#import "ALTableCycleScrollView.h"

#define kBaseTag 1024

@interface TestScrollViewController ()

@property (nonatomic, strong)UIScrollView *scrollView;

//@property (nonatomic, strong)ALTableCycleScrollView *scrollView;
@property (nonatomic, strong)NSMutableDictionary *map;
@property (nonatomic, strong)NSArray *totalArray;

@end

@implementation TestScrollViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
//    self.map = [[NSMutableDictionary alloc] initWithCapacity:3];
//    self.totalArray = @[@[@"tableView1 cell1", @"tableView1 cell2", @"tableView1 cell3", @"tableView1 cell4", @"tableView1 cell5", @"tableView1 cell6"],
//                        @[@"tableView2 cell1", @"tableView2 cell2", @"tableView2 cell3", @"tableView2 cell4", @"tableView2 cell5", @"tableView2 cell6"],
//                        @[@"tableView3 cell1", @"tableView3 cell2", @"tableView3 cell3", @"tableView3 cell4", @"tableView3 cell5", @"tableView3 cell6"],
//                        @[@"tableView4 cell1", @"tableView4 cell2", @"tableView4 cell3", @"tableView4 cell4", @"tableView4 cell5", @"tableView4 cell6"],
//                        @[@"tableView5 cell1", @"tableView5 cell2", @"tableView5 cell3", @"tableView5 cell4", @"tableView5 cell5", @"tableView5 cell6"]];
//    
//    self.scrollView = [[ALTableCycleScrollView alloc] initWithFrame:self.view.bounds];
//    self.scrollView.cycleScrollEnabled = NO;
//    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:self.scrollView];
    

    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
//    self.scrollView.tableViewInstance = ^UITableView*(void){
//        return tableView;
//    };
    
//    [self.scrollView configTableViewsWithDelegate:self andCellId:@"cell"];
//    
//    self.scrollView.upDateTableViewForIndex = ^(NSInteger pageIndex, UITableView *tableView){
//        tableView.tag = kBaseTag + pageIndex;
//        [tableView reloadData];
//    };
//    
//    self.scrollView.totalPagesCount = ^NSInteger(void){
//        return 5;
//    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark - delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger pageIndex = tableView.tag - kBaseTag;
    NSArray *tmp = [self.totalArray objectAtIndex:pageIndex];
    if (verifiedNSArray(tmp)) {
        return tmp.count;
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSInteger pageIndex = tableView.tag - kBaseTag;
    NSArray *tmp = [self.totalArray objectAtIndex:pageIndex];
    cell.textLabel.text = [tmp objectAtIndex:indexPath.row];
    
    return cell;
}



@end
