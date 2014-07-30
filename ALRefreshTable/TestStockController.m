//
//  TestStockController.m
//  ALRefreshTable
//
//  Created by lin zhu on 14-1-13.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "TestStockController.h"
#import "ASIHttpRequest.h"
#import "ALStockSeries.h"
#import "ALStockKLineView.h"

#define kTestStockUrl @"http://ichart.yahoo.com/table.csv?s=600000.SS&g=d"

@interface TestStockController ()

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)ALStockKLineView *candleLineView;
@property (nonatomic, assign)NSInteger drawCandleBeginIndex;
@property (nonatomic, assign)NSInteger drawCandleEndIndex;
@property (nonatomic, assign)CGPoint touchedPoint;

@end

@implementation TestStockController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self getDataForStockID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createCandleLineView{
    self.candleLineView = [[ALStockKLineView alloc] initWithFrame:CGRectMake(10.0, 30.0, self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 40.0)];
    self.drawCandleBeginIndex = 0;
    self.drawCandleEndIndex = 99;
    [self.candleLineView setDrawStockSeriesData:self.dataArray withBegin:self.drawCandleBeginIndex andEnd:self.drawCandleEndIndex];
    [self.view addSubview:self.candleLineView];
    
//    self.candleLineView.userInteractionEnabled = YES;
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
//    [self.candleLineView addGestureRecognizer:pan];
}

- (void)panGestureRecognizer:(UIGestureRecognizer*)recognizer{
    CGPoint touchPoint = CGPointZero;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        touchPoint = [recognizer locationInView:self.candleLineView];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [(UIPanGestureRecognizer*)recognizer translationInView:self.candleLineView];
        if (translation.x > 0) {
            NSInteger candleOffsetNum = translation.x/[self.candleLineView getCandleWidth];
            self.drawCandleBeginIndex += candleOffsetNum;
            self.drawCandleEndIndex += candleOffsetNum;
            [self.candleLineView setDrawStockSeriesData:self.dataArray withBegin:self.drawCandleBeginIndex andEnd:self.drawCandleEndIndex];
            [self.candleLineView setNeedsDisplay];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        self.touchedPoint = [touch locationInView:self.candleLineView];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        //NSLog(@"CGPoint(%.2f, %.2f)", [touch locationInView:self.candleLineView].x, [touch locationInView:self.candleLineView].y);
        
        CGPoint newPoint = [touch locationInView:self.candleLineView];
        NSInteger candleOffsetNum = (newPoint.x - self.touchedPoint.x)/[self.candleLineView getCandleWidth];
        self.drawCandleBeginIndex += candleOffsetNum;
        self.drawCandleEndIndex += candleOffsetNum;
        NSLog(@"begin from %d, end at %d", self.drawCandleBeginIndex, self.drawCandleEndIndex);
        [self.candleLineView setDrawStockSeriesData:self.dataArray withBegin:self.drawCandleBeginIndex andEnd:self.drawCandleEndIndex];
        [self.candleLineView setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


#pragma mark -
#pragma mark - get data
- (void)getDataForStockID{
    
    NSURL *url = [NSURL URLWithString:[kTestStockUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setTimeOutSeconds:5];
    __weak id weakP = request;
	[weakP setCompletionBlock:^{
        NSMutableArray *data =[[NSMutableArray alloc] init];
        NSMutableArray *category =[[NSMutableArray alloc] init];
        
        NSString *content = [request responseString];
        NSArray *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSInteger idx;
        for (idx = lines.count-1; idx > 0; idx--) {
            NSString *line = [lines objectAtIndex:idx];
            if([line isEqualToString:@""]){
                continue;
            }
            NSArray   *arr = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            [category addObject:[arr objectAtIndex:0]];
            
            ALStockSeries *stockSeries = [[ALStockSeries alloc] init];
            stockSeries.date = [arr objectAtIndex:0];
            stockSeries.open = [arr objectAtIndex:1];
            stockSeries.close = [arr objectAtIndex:4];
            stockSeries.high = [arr objectAtIndex:2];
            stockSeries.low = [arr objectAtIndex:3];
            stockSeries.volume = [[arr objectAtIndex:5] floatValue]/1000000;
            
            if (stockSeries.open.floatValue == stockSeries.close.floatValue && stockSeries.volume == 0) {
                // 当天停盘
                stockSeries = nil;
            }else{
                [data insertObject:stockSeries atIndex:0];
            }
        }
        
        self.dataArray = data;
        
        [self createCandleLineView];
    }];
    
	[request startAsynchronous];
}

@end
