//
//  ALTestTableViewController.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-11.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "ALTestTableViewController.h"
#import "ASIHttpRequest.h"
#import "ALRefreshTableHeaderView.h"

@interface ALTestTableViewController ()

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation ALTestTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.tableView.rowHeight = 60.0f;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCell"];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:3];
    [self.dataArray addObjectsFromArray:@[@"label1", @"label2", @"label3"]];
    
    [self addRefreshHeader];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self setRefreshFooter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray ? self.dataArray.count : 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"testCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark - testcode
- (void)beginToReloadData:(ALRefreshPos)aRefreshPos{
    [super beginToReloadData:aRefreshPos];
    
    if (aRefreshPos == ALRefreshHeader) {
        // reload data
        [self performSelector:@selector(testFinish) withObject:nil afterDelay:0.5];
    }else{
        // load more data
        [self performSelector:@selector(testLoadMore) withObject:nil afterDelay:0.5];
    }
}

- (void)testLoadMore{
    int i = self.dataArray ? self.dataArray.count : 0;
    for (int k = 0; k < 3; k++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"label%d", i+1]];
        i ++;
    }
    
    [self.tableView reloadData];
    [self finishReloadingDataComplete:^{
        if (self.refreshFooterView) {
            [self setRefreshFooter];
        }
    }];
}

- (void)testFinish{
    [self finishReloadingDataComplete:^{
        
    }];
}

@end
