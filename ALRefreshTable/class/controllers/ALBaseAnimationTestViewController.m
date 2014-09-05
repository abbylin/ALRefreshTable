//
//  ALBaseAnimationTestViewController.m
//  ALRefreshTable
//
//  Created by linzhu on 14-9-2.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "ALBaseAnimationTestViewController.h"
#import "POP.h"

const NSInteger kTestConstant = 1244354;

@interface ALBaseAnimationTestViewController (){
    UILabel *_animatedLabel;
}

@end

@implementation ALBaseAnimationTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self textAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textAnimation{
    _animatedLabel = [[UILabel alloc] init];
    _animatedLabel.frame = CGRectMake(20.0, 100.0, 100.0, 30.0);
    _animatedLabel.text = [@(kTestConstant) stringValue];
    [self.view addSubview:_animatedLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 6.0;
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.clipsToBounds = YES;
    [button setTitle:@"animation" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showTextAnimation:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(180, _animatedLabel.frame.origin.y, 100, 40);
    [self.view addSubview:button];
}

- (void)showTextAnimation:(id)sender{
    POPBasicAnimation *animation = [POPBasicAnimation animation];
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"num" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]){
            [obj setText:[NSString stringWithFormat:@"%d", (NSInteger)values[0]]];
        };
        
        prop.threshold = 1;
    }];
    animation.property = prop;
    animation.fromValue = @(kTestConstant);
    animation.toValue = @(kTestConstant+50000);
    animation.duration = 1.0;
    [_animatedLabel pop_addAnimation:animation forKey:nil];
}

@end
