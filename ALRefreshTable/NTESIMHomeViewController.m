//
//  NTESIMHomeViewController.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-20.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "NTESIMHomeViewController.h"
#import "NTESIMCustomStocksViewController.h"

@interface NTESIMHomeViewController ()

@property (nonatomic, strong)NTESIMTabBarView *mainTabBar;

@property (nonatomic, strong)NTESIMCustomStocksViewController *stocksViewController;

@end

@implementation NTESIMHomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"自选股";
	// Do any additional setup after loading the view.
    [self loadTabControllers];
    
    self.mainTabBar = [[NTESIMTabBarView alloc] initWithFrame:CGRectMake(0.0, self.view.bounds.size.height - 50.0, self.view.bounds.size.width, 50.0)];
    [self.mainTabBar setTabTitlesArray:@[@"自选", @"咨询", @"交易", @"设置"]];
    self.mainTabBar.delegate = self;
    [self.view addSubview:self.mainTabBar];
    [self.mainTabBar setDefaultSelectedTab];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}

- (void)loadTabControllers{
    NTESIMCustomStocksViewController *vc = [[NTESIMCustomStocksViewController alloc] initWithCustomNaviBar:NO];
    self.stocksViewController = vc;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabSelectedWithIndex:(NSInteger)index{
    if (index == 0) {
        [self bringStocksControllerIn];
    }
}

- (void)bringStocksControllerIn{
    // bring the custom stocks viewController into the current screen
    if (self.stocksViewController  && [self.stocksViewController parentViewController] == nil) {
        [self addChildViewController:self.stocksViewController];
        self.stocksViewController.view.frame = CGRectMake(0.0, self.customNaviBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.customNaviBar.frame.size.height - self.mainTabBar.frame.size.height);
        [self.view addSubview:self.stocksViewController.view];
        [self.stocksViewController didMoveToParentViewController:self];
    }
}

@end
