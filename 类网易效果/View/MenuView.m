//
//  MenuView.m
//  类网易效果
//
//  Created by jimmy on 14-9-15.
//  Copyright (c) 2014年 ceosoftcenters. All rights reserved.
//

#import "MenuView.h"
#import "CommonDefines.h"

@implementation MenuView

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (scrollView == nil) {
            scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
            scrollView.showsVerticalScrollIndicator = NO;
        }
        
        if (itemInfoArray == nil) {
            itemInfoArray = [[NSMutableArray alloc]init];
        }
        [itemInfoArray removeAllObjects];
        
        
        [self createMenuItems:items];
        [self addSubview:scrollView];
        
    }
    return self;
}


- (void)createMenuItems:(NSArray *)items{
    int i = 0;
    float menuWidth = 0.0;
    for (NSDictionary *itemDic in items) {
//        NSString *normalImageName = [itemDic objectForKey:NormalImage];
//        NSString *highlightImageName = [itemDic objectForKey:HighlightImage];
        NSString *title = [itemDic objectForKey:Title];
        float itemWidth = [[itemDic objectForKey:ItemWidth] floatValue];
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [itemButton setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
//        [itemButton setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateSelected];
//        [itemButton setBackgroundColor:[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:0.6]];
        
        [itemButton setTitle:title forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
        [itemButton setTag:i+1];
        [itemButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [itemButton setFrame:CGRectMake(menuWidth, 0, itemWidth, self.frame.size.height)];
        [scrollView addSubview:itemButton];
//        [mButtonArray addObject:vButton];
        menuWidth += itemWidth;
        i++;
        
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *vNewDic = [itemDic mutableCopy];
        [vNewDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:ItemTotalWidth];
        [itemInfoArray addObject:vNewDic];
    }
    
    [scrollView setBackgroundColor:[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:0.6]];
    [scrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    // 保存menu总长度，如果小于320则不需要移动，方便点击button时移动位置的判断
    itemTotalWidth = menuWidth;
}


- (void)menuButtonClicked:(UIButton *)sender{
    if (!sender.selected) {
        [self changeButtonStateWithTag:sender.tag];
        
        // 刷新TableView
        if ([_delegate respondsToSelector:@selector(didMenuClickedButtonAtIndex:)]) {
            [_delegate didMenuClickedButtonAtIndex:(sender.tag-1)];
        }
    }
}

-(void)clickButtonAtIndex:(NSInteger)aIndex{
    for (id view in scrollView.subviews) {
        NSLog(@"v: %@",view);
    }
    
    UIButton *button = (UIButton *)[scrollView viewWithTag:(aIndex+1)];
    [self menuButtonClicked:button];
}

-(void)changeButtonStateWithTag:(NSInteger)buttonTag{
    for (id view in scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.tag == buttonTag) {
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }
    }

    [self moveScrollViewToSeeButtonWithTag:buttonTag];
}

- (void)moveScrollViewToSeeButtonWithTag:(NSInteger)buttonTag{
    if (itemInfoArray.count < buttonTag) {
        return;
    }
    
    if (itemTotalWidth <= self.bounds.size.width) {
        return;
    }
    
    UIButton *button = (UIButton *)[scrollView viewWithTag:buttonTag];
    // 左右边不动
    // 左边
    if ((CGRectGetMinX(button.frame) - scrollView.contentOffset.x) <= scrollView.frame.size.width/2 && scrollView.contentOffset.x == 0  ) {
        return;
    }
    // 右边
    if ((CGRectGetMinX(button.frame) - scrollView.contentOffset.x) >= scrollView.frame.size.width/2 && (scrollView.contentSize.width - scrollView.contentOffset.x) <= self.bounds.size.width) {
        return;
    }
    
    // 左右边移动到边界
    // 左边
    float offsetX = (CGRectGetMidX(button.frame) - scrollView.frame.size.width/2)<0? 0:(CGRectGetMidX(button.frame) - scrollView.frame.size.width/2);
    // 右边
    float finalOffsetX = (offsetX + scrollView.frame.size.width)>scrollView.contentSize.width?(scrollView.contentSize.width - scrollView.frame.size.width):offsetX;
    
    [scrollView setContentOffset:CGPointMake(finalOffsetX, scrollView.contentOffset.y) animated:YES];
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
