//
//  SelfTableView.h
//  类网易效果
//
//  Created by jimmy on 14-9-16.
//  Copyright (c) 2014年 ceosoftcenters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@class SelfTableView;
@protocol SelfTableViewDelegate <NSObject>
@required;
-(float)heightForRowAtIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SelfTableView *)aView;
-(void)didSelectRowAtIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SelfTableView *)aView;
-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(SelfTableView *)aView;
-(void)refreshData:(void(^)())complete FromView:(SelfTableView *)aView;
@optional
//- (void)tableViewWillBeginDragging:(UIScrollView *)scrollView;
//- (void)tableViewDidScroll:(UIScrollView *)scrollView;
////- (void)tableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(CustomTableView *)aView;
@end

@protocol SelfTableViewDataSource <NSObject>
@required;
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(SelfTableView *)aView;
-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SelfTableView *)aView;

@end


@interface SelfTableView : UIView<UITableViewDelegate,UITableViewDataSource,SGFocusImageFrameDelegate,EGORefreshTableHeaderDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    NSInteger     mRowCount;
}

@property (nonatomic,assign) BOOL reloading;

@property (nonatomic,retain) UITableView *homeTableView;
@property (nonatomic,retain) NSMutableArray *tableInfoArray;
@property (nonatomic,assign) id<SelfTableViewDataSource> dataSource;
@property (nonatomic,assign) id<SelfTableViewDelegate>  delegate;

#pragma mark 强制列表刷新
-(void)forceToFreshData;

@end
