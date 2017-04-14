//
//  NewsItemCell.m
//  类网易效果
//
//  Created by jimmy on 14-9-16.
//  Copyright (c) 2014年 ceosoftcenters. All rights reserved.
//

#import "NewsItemCell.h"

@implementation NewsItemCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.photoView.layer.cornerRadius = 5.0;
    self.photoView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
