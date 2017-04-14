//
//  ContentView.h
//  类网易效果
//
//  Created by jimmy on 14-9-15.
//  Copyright (c) 2014年 ceosoftcenters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelfTableView.h"

// 下面一个ScrollView(左右滑动) 上面一个TableView
@protocol ScrollPageViewDelegate <NSObject>
-(void)didScrollPageViewChangedPage:(NSInteger)aPage;
@end

@interface ContentView : UIView <UIScrollViewDelegate,SelfTableViewDataSource,SelfTableViewDelegate>{
    NSInteger mCurrentPage;
    BOOL mNeedUseDelegate;
}

@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) NSMutableArray *contentItems;

@property (nonatomic,assign) id<ScrollPageViewDelegate> delegate;

#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSInteger)aNumerOfTables;

#pragma mark 刷新某个页面
-(void)freshContentTableAtIndex:(NSInteger)aIndex;

#pragma mark 移动ScrollView到某个页面
-(void)moveScrollViewToIndex:(NSInteger)aIndex;

@end
