//
//  ALTableCycleScrollView.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-4-2.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "ALTableCycleScrollView.h"

@interface ALTableCycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger pagesCount;
@property (nonatomic , strong) NSMutableArray *contentTableViews;
@property (nonatomic , strong) UIScrollView *mainScrollView;

@end

@implementation ALTableCycleScrollView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _pagesCount = totalPagesCount();
    if (_pagesCount > 0) {
        [self configContentTableViews];
    }
}

//- (void)setConfigTableView:(void (^)(UITableView *))configTableView{
//    UIView *tableView = tableViewInstance();
//    if (tableView) {
//        self.contentTableViews = nil;
//        self.contentTableViews = [[NSMutableArray alloc] init];
//        for (int i  = 0; i < 3; i++) {
//            UITableView *item = [tableView mutableCopy];
//            [self.contentTableViews addObject:item];
//            [self addSubview:item];
//        }
//    }
//    
//    if (_pagesCount > 0) {
//        [self configContentTableViews];
//    }
//}]

- (void)configTableViewsWithDelegate:(id<UITableViewDataSource,UITableViewDelegate>)aDelegate andCellId:(NSString *)cellId{
    if (verifiedNSArray(self.contentTableViews)) {
        for (UITableView *tableView in self.contentTableViews) {
            tableView.delegate = aDelegate;
            tableView.dataSource = aDelegate;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.cycleScrollEnabled = YES;
        
        self = [super initWithFrame:frame];
        if (self) {
            // Initialization code
            self.autoresizesSubviews = YES;
            self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
            self.mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            self.mainScrollView.contentMode = UIViewContentModeCenter;
            self.mainScrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.mainScrollView.frame), CGRectGetHeight(self.mainScrollView.frame));
            self.mainScrollView.delegate = self;
            self.mainScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.mainScrollView.frame), 0);
            self.mainScrollView.pagingEnabled = YES;
            [self addSubview:self.mainScrollView];
            self.currentPageIndex = 0;
            
            self.contentTableViews = nil;
            self.contentTableViews = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0; i < 3; i++) {
                UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
                tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                [self.mainScrollView addSubview:tableView];
                [self.contentTableViews addObject:tableView];
            }
            
            
        }
        return self;
    }
    return self;
}

- (void)configContentTableViews{
    if (self.contentTableViews && self.contentTableViews.count > 0) {
        
        [self updateTableViewDataSource];
        
        NSInteger counter = 0;
        for (UIView *contentView in self.contentTableViews) {
            CGRect rightRect = contentView.frame;
            rightRect.origin = CGPointMake(CGRectGetWidth(self.mainScrollView.frame) * (counter ++), 0);
            
            contentView.frame = rightRect;
        }
        
        if (self.currentPageIndex == 0 && !self.cycleScrollEnabled) {
            [self.mainScrollView setContentOffset:CGPointMake(0.0, 0.0)];
        }else if (self.currentPageIndex == self.pagesCount - 1 && !self.cycleScrollEnabled){
            [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width*2, 0)];
        }else{
            [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width, 0)];
        }
    }
}

- (void)updateTableViewDataSource{
    if (self.contentTableViews && self.contentTableViews.count == 3) {
        NSInteger previousPageIndex = [self getAvailableNextPageIndex];
        NSInteger nextPageIndex = [self getAvailablePreviousPageIndex];
        
        if (self.upDateTableViewForIndex) {
            self.upDateTableViewForIndex(previousPageIndex, [self.contentTableViews objectAtIndex:0]);
            self.upDateTableViewForIndex(_currentPageIndex, [self.contentTableViews objectAtIndex:1]);
            self.upDateTableViewForIndex(nextPageIndex, [self.contentTableViews objectAtIndex:2]);
        }
    }
}

- (NSInteger)getAvailableNextPageIndex{
    NSInteger nextPageIndex = -1;
    if (_currentPageIndex == self.pagesCount - 1){
        if (self.cycleScrollEnabled) {
            nextPageIndex = 0;
        }else{
            nextPageIndex = _currentPageIndex;
        }
    }else{
        nextPageIndex = _currentPageIndex + 1;
    }
    
    if (nextPageIndex >= self.pagesCount) {
        nextPageIndex = _currentPageIndex;
    }
    
    return nextPageIndex;
}

- (NSInteger)getAvailablePreviousPageIndex{
    NSInteger previousPageIndex = -1;
    if (_currentPageIndex == 0) {
        if (self.cycleScrollEnabled ) {
            previousPageIndex = self.pagesCount - 1;
        }else{
            previousPageIndex = _currentPageIndex;
        }
    }else{
        previousPageIndex = _currentPageIndex - 1;
    }
    
    return previousPageIndex;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //NSLog(@"content offset is %@", NSStringFromCGPoint(scrollView.contentOffset));
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        NSInteger nextPage = [self getAvailableNextPageIndex];
        if (nextPage != self.currentPageIndex) {
            self.currentPageIndex = nextPage;
        }
        [self configContentTableViews];
    }
    if(contentOffsetX <= 0) {
        NSInteger prePage = [self getAvailablePreviousPageIndex];
        if (prePage != self.currentPageIndex) {
            self.currentPageIndex = prePage;
        }
        [self configContentTableViews];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (self.cycleScrollEnabled) {
//        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
//    }
//    
//    if (self.scrollToTableViewWithIndex) {
//        self.scrollToTableViewWithIndex(self.currentPageIndex);
//    }
//}

@end
