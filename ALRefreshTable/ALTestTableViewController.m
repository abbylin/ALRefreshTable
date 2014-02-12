//
//  ALTestTableViewController.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-11.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "ALTestTableViewController.h"
#import "ASIHttpRequest.h"

@interface ALTestTableViewController ()

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation ALTestTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //[self createHeaderView];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCell"];
    
    self.dataArray = @[@"label1", @"label2", @"label3"];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollView.contentOffset.y= %f", scrollView.contentOffset.y);
}
@end
