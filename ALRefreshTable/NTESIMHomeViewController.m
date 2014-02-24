//
//  NTESIMHomeViewController.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-20.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "NTESIMHomeViewController.h"

@interface NTESIMHomeViewController ()

@property (nonatomic, strong)NTESIMTabBarView *mainTabBar;

@end

@implementation NTESIMHomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"自选股";
	// Do any additional setup after loading the view.
    
    self.mainTabBar = [[NTESIMTabBarView alloc] initWithFrame:CGRectMake(0.0, self.view.bounds.size.height - 50.0, self.view.bounds.size.width, 50.0)];
    [self.mainTabBar setTabTitlesArray:@[@"自选", @"咨询", @"交易", @"设置"]];
    self.mainTabBar.delegate = self;
    [self.view addSubview:self.mainTabBar];
    
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
    
}

@end
