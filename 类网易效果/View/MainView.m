//
//  MainView.m
//  类网易效果
//
//  Created by jimmy on 14-9-15.
//  Copyright (c) 2014年 ceosoftcenters. All rights reserved.
//

#import "MainView.h"
#import "CommonDefines.h"

@implementation MainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    NSArray *menuItems = @[@{NormalImage: @"normal.png",
                             HighlightImage:@"helight.png",
                             Title:@"头条",
                             ItemWidth:[NSNumber numberWithFloat:60]
                             },
                           @{NormalImage: @"normal.png",
                             HighlightImage:@"helight.png",
                             Title:@"推荐",
                             ItemWidth:[NSNumber numberWithFloat:60]
                             },
                           @{NormalImage: @"normal.png",
                             HighlightImage:@"helight.png",
                             Title:@"娱乐",
                             ItemWidth:[NSNumber numberWithFloat:60]
                             },
                           @{NormalImage: @"normal.png",
                             HighlightImage:@"helight.png",
                             Title:@"体育",
                             ItemWidth:[NSNumber numberWithFloat:60]
                             },
                           @{NormalImage: @"normal.png",
                             HighlightImage:@"helight.png",
                             Title:@"科技",
                             ItemWidth:[NSNumber numberWithFloat:60]
                             },
                           @{NormalImage: @"normal.png",
                             HighlightImage:@"helight.png",
                             Title:@"新闻",
                             ItemWidth:[NSNumber numberWithFloat:60]
                             },
                           @{NormalImage: @"normal.png",
                             HighlightImage:@"helight.png",
                             Title:@"汽车",
                             ItemWidth:[NSNumber numberWithFloat:60]
                             },
                           @{NormalImage: @"normal.png",
                             HighlightImage:@"helight.png",
                             Title:@"NBA",
                             ItemWidth:[NSNumber numberWithFloat:60]
                             },
                           ];
    if (menuView == nil) {
        menuView = [[MenuView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, ItemHeight) items:menuItems];
        menuView.delegate = self;
    }
    
    if (contentView == nil) {
        contentView = [[ContentView alloc]initWithFrame:CGRectMake(0, ItemHeight, self.frame.size.width, self.frame.size.height-ItemHeight)];
        contentView.delegate = self;
        
    }
    // 设置tableView个数
    [contentView setContentOfTables:menuItems.count];
    [menuView clickButtonAtIndex:0];
    
    [self addSubview:menuView];
    [self addSubview:contentView];
    
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    [menuView changeButtonStateWithTag:(aPage+1)];
    //    if (aPage == 3) {
    //刷新当页数据
    [contentView freshContentTableAtIndex:aPage];
    //    }
}

#pragma mark Menu Delegate
- (void)didMenuClickedButtonAtIndex:(NSInteger)aIndex{
    [contentView moveScrollViewToIndex:aIndex];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
