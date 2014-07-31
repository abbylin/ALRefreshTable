//
//  TestController1.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-3-5.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "TestController1.h"

@interface TestController1 (){
    UIImageView *icon;
    UIView *testView1;
}

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation TestController1

- (void)viewDidLoad{
    [super viewDidLoad];
    self.dataArray = @[@"test1", @"test2", @"test3"];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    [self.tableView removeFromSuperview];
//    self.tableView.hidden = YES;
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"segment1", @"segment2"]];
    segment.frame = CGRectMake(10, 80, 300, 50);
    [self.view addSubview:segment];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.frame = CGRectMake(100.0, 150, 50.0, 50.0);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(testAnimation) forControlEvents:UIControlEventTouchUpInside];
    
//    icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_support_highlighted.png"]];
//    icon.frame = CGRectMake(100.0, 300.0, icon.image.size.width, icon.image.size.height);
//    [self.view addSubview:icon];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 248, self.view.bounds.size.width, 2)];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    
    testView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 250, 30, 30)];
    testView1.layer.borderColor = [UIColor redColor].CGColor;
    testView1.layer.borderWidth = 1.0;
    testView1.frame = CGRectMake(0, 250, 30, 30);
    [self.view addSubview:testView1];
    
    [self performSelector:@selector(testAnimation) withObject:nil afterDelay:1.0];
}

- (void)testAnimation{
    testView1.layer.anchorPoint = CGPointMake(1.0, 1.0);
    testView1.layer.position = CGPointMake(testView1.layer.position.x+testView1.layer.bounds.size.width/2, testView1.layer.position.y + testView1.layer.bounds.size.height/2);
    NSLog(@"position is %@ first", NSStringFromCGPoint(testView1.layer.position));
    testView1.layer.position = CGPointMake(testView1.layer.position.x, testView1.layer.position.y + testView1.layer.bounds.size.height);
    CAKeyframeAnimation *rotate = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.delegate = self;
    rotate.values = @[@(DegreesToRadians(0)), @(DegreesToRadians(90))];
    rotate.duration = 2.0;
    [testView1.layer addAnimation:rotate forKey:@"rotationAnim"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [testView1.layer removeAllAnimations];
        testView1.layer.anchorPoint = CGPointMake(0.5, 0.5);
        testView1.frame = CGRectMake(0, 250, 30, 30);
        NSLog(@"position is %@ after animation", NSStringFromCGPoint(testView1.layer.position));
    }
}

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"position is %@", NSStringFromCGPoint(testView1.layer.position));
}

- (void)showAnimation:(id)sender{
    // pop up animation
    //    CATransform3D t = CATransform3DMakeTranslation(10.0, 20.0, 0.0);
    //    CGSize tSize = CGSizeMake(10.0, 20.0);
    //    CAKeyframeAnimation *upAnim = [CAKeyframeAnimation animationWithKeyPath:@"translation"];
    //    upAnim.values = @[[NSValue valueWithCGSize:tSize]];
    //    upAnim.duration = 0.4;
    //    [voteButton.layer addAnimation:upAnim forKey:@"translationAnimation"];
    
//    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//    animationGroup.removedOnCompletion = YES;
//    animationGroup.duration = 2.0;
//    
//    icon.layer.position = CGPointMake(icon.layer.position.x+icon.layer.bounds.size.width/2, icon.layer.position.y-20.0);
//    //voteButton.layer.transform = CATransform3DMakeRotation(0.40, 0.0, 0.0, 1.0);
//    
//    // rotate animation
//    icon.layer.anchorPoint = CGPointMake(1.0, 0.5);
//    CATransform3D b1 = CATransform3DMakeRotation(0.7, 0.0, 0.0, 1.0);
//    CATransform3D b2 = CATransform3DMakeRotation(-0.30, 0.0, 0.0, 1.0);
//    CABasicAnimation *beginAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    beginAnim.fromValue = [NSValue valueWithCATransform3D:b1];
//    beginAnim.toValue = [NSValue valueWithCATransform3D:b2];
//    //beginAnim.duration = 0.6;
//    
//    //Size Animation
//    //    CATransform3D t1 = CATransform3DMakeScale(1,    1,    1);
//    //    CATransform3D t2 = CATransform3DMakeScale(1.64, 1.64, 1.64);
//    //    CATransform3D t3 = CATransform3DMakeScale(0.79, 0.79, 0.79);
//    //    CATransform3D t4 = CATransform3DMakeScale(0.94, 0.94, 0.94);
//    //    CATransform3D t5 = CATransform3DMakeScale(1,    1,    1);
//    
//    CATransform3D t1 = CATransform3DMakeScale(1,    1,    1);
//    CATransform3D t2 = CATransform3DMakeScale(1.12, 1.12, 1.12);
//    CATransform3D t3 = CATransform3DMakeScale(1.64, 1.64, 1.64);
//    
//    CAKeyframeAnimation *sizeAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    sizeAnim.values = @[[NSValue valueWithCATransform3D:b1],
//                        [NSValue valueWithCATransform3D:t1],
//                        [NSValue valueWithCATransform3D:t2],
//                        [NSValue valueWithCATransform3D:t3],
//                        [NSValue valueWithCATransform3D:b2]];
//    sizeAnim.keyTimes = @[@(0), @(0.1), @(0.25), @(0.4), @(1)];
//    sizeAnim.removedOnCompletion = NO;
//    
//    animationGroup.animations = @[sizeAnim];
//    animationGroup.delegate = self;
    
    icon.layer.anchorPoint = CGPointMake(0.9, 1.0);
    icon.layer.position = CGPointMake(icon.layer.position.x+icon.layer.bounds.size.width/2, icon.layer.position.y-20.0);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.removedOnCompletion = NO;
    animationGroup.duration = 1.0;
    
    CAKeyframeAnimation *rotateAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnim.values = @[@(0.7), @(0.78), @(-0.3)];
    rotateAnim.keyTimes = @[@(0.0), @(0.7), @(1.0)];
    
    
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.values = @[@(1.0), @(1.12), @(1.98), @(1.98)];
    scaleAnim.keyTimes = @[@(0.0), @(0.5), @(0.6), @(1.0)];
    
    animationGroup.animations = @[rotateAnim, scaleAnim];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [icon.layer addAnimation:animationGroup forKey:@"animation"];
    
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    if (flag) {
//        [icon.layer removeAllAnimations];
//        icon.layer.anchorPoint = CGPointMake(0.5, 0.5);
//        icon.layer.transform = CATransform3DIdentity;
//        icon.layer.position = CGPointMake(icon.layer.position.x, icon.layer.position.y-20.0+icon.layer.bounds.size.height/2);
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray && self.dataArray.count > 0) {
        return self.dataArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

@end
