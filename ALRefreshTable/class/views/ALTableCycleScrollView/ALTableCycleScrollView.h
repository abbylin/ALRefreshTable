//
//  ALTableCycleScrollView.h
//  ALRefreshTable
//
//  Created by Abby lin on 14-4-2.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALTableCycleScrollView : UIView

@property (nonatomic, readonly)UIScrollView *mainScrollView;
@property (nonatomic, assign)BOOL cycleScrollEnabled;


/**
 dataSource: get total pages count
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);

/**
 dataSource: update content of tableView for index
 **/
@property (nonatomic , copy) void(^upDateTableViewForIndex)(NSInteger pageIndex, UITableView *tableView);

/**
 dataSource: load tableView instance
 **/
@property (nonatomic, copy) void(^configTableView)(UITableView *tableView);

/**
 delegate: scroll to the tableView with index
 **/
@property (nonatomic, copy) void(^scrollToTableViewWithIndex)(NSInteger pageIndex);

- (void)configTableViewsWithDelegate:(id<UITableViewDataSource, UITableViewDelegate>)aDelegate andCellId:(NSString*)cellId;


@end
