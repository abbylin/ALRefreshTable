//
//  CoreTextTestCell.m
//  ALRefreshTable
//
//  Created by linzhu on 14-8-28.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "CoreTextTestCell.h"

@interface CoreTextTestCell (){
    UILabel *_titleLabel;
    UILabel *_textLabel;
    UILabel *_timeLabel;
}

@end

@implementation CoreTextTestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_textLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    _titleLabel.frame = CGRectMake(10, 10, rect.size.width - 20.0, 20.0);
}

- (void)setInfo:(NSDictionary *)dict{
    NSString *nickName = @"CIGALYAMEI";
    NSString *wholeText = [NSString stringWithFormat:@"欢迎%@进入直播间", nickName];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:wholeText];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[wholeText rangeOfString:nickName]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
