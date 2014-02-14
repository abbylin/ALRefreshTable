//
//  ALRootTableViewController.h
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-13.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALRefreshTableDelegate.h"

@class ALRefreshTableHeaderView;

@interface ALRootTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ALRefreshTableDelegate>

@property (nonatomic, strong) ALRefreshTableHeaderView *refreshHeaderView;

@property (nonatomic, strong) UITableView *tableView;


// public methods
- (void)addRefreshHeader;
- (void)removeRefreshHeader;

// overide methods
-(void)beginToReloadData:(ALRefreshPos)aRefreshPos;
-(void)finishReloadingDataComplete:(void(^)(void))completeBlock;

@end
