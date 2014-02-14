//
//  ALRootTableViewController.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-13.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "ALRootTableViewController.h"
#import "ALRefreshTableHeaderView.h"

@interface ALRootTableViewController ()

@property (nonatomic, assign) BOOL isReloading;
@property (nonatomic, assign) ALRefreshPos refreshPos;

@end

@implementation ALRootTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // create the tableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    if (self.refreshHeaderView && [[self.refreshHeaderView superview] isEqual:self.tableView]) {
        self.refreshHeaderView.originalInset = self.tableView.contentInset;
    }
    
    NSLog(@"originalInset = %@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
    NSLog(@"originalOffset = %@", NSStringFromCGPoint(self.tableView.contentOffset));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - public methods
- (void)addRefreshHeader{
    if (self.refreshHeaderView && [self.refreshHeaderView superview]) {
        [self.refreshHeaderView removeFromSuperview];
        self.refreshHeaderView = nil;
    }
    
    self.refreshHeaderView = [[ALRefreshTableHeaderView alloc] initInScrollView:self.tableView];
    self.refreshHeaderView.delegate = self;
}

- (void)removeRefreshHeader{
    
    if (self.refreshHeaderView && [self.refreshHeaderView superview]) {
        [self.refreshHeaderView removeFromSuperview];
        self.refreshHeaderView = nil;
    }
}

#pragma mark -
#pragma mark overide UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
    
    return cell;
}

#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(ALRefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	self.isReloading = YES;
    self.refreshPos = aRefreshPos;
    
	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingDataComplete:(void (^)(void))completeBlock{
    //  model should call this when its done loading
	self.isReloading = NO;
    
    if (self.refreshPos == ALRefreshHeader) {
        [self.refreshHeaderView ALRefreshScrollViewDataSourceDidFinishedLoading:self.tableView
                                                                    andComplete:^{
                                                                        if (completeBlock) {
                                                                            completeBlock();
                                                                        }
                                                                    }];
    }
    
//    if (_refreshHeaderView) {
//        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView andComplete:completeBlock];
//    }
//    
//    if (_refreshFooterView) {
//        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView withComplete:completeBlock];
//        [self setFooterView];
//    }
    
    self.refreshPos = -1;
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
    
}

#pragma mark -
#pragma mark - ALRefreshTableDelegate method
- (void)ALRefreshTableDidTriggerRefresh:(ALRefreshPos)aRefreshPos{
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)ALRefreshTableDataSourceIsLoading:(UIView*)view{
    return self.isReloading;
}

- (NSDate*)ALRefreshTableDataSourceLastUpdated:(UIView*)view{
    return [NSDate date];;
}

@end
