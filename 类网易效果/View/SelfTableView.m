//
//  SelfTableView.m
//  类网易效果
//
//  Created by jimmy on 14-9-16.
//  Copyright (c) 2014年 ceosoftcenters. All rights reserved.
//

#import "SelfTableView.h"
#import "LoadMoreCell.h"

@implementation SelfTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (_homeTableView == nil) {
            _homeTableView = [[UITableView alloc] initWithFrame:self.bounds];
            _homeTableView.delegate = self;
            _homeTableView.dataSource = self;
            [_homeTableView setBackgroundColor:[UIColor clearColor]];
        }
        if (_tableInfoArray == nil) {
            _tableInfoArray = [[NSMutableArray alloc] init];
        }
        [self addSubview:_homeTableView];
        [self createRefreshHeaderView];
    }
    return self;
}

- (void)createRefreshHeaderView{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:_homeTableView.frame];
		view.delegate = self;
		[self insertSubview:view belowSubview:_homeTableView];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark - EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    //	if ([_delegate respondsToSelector:@selector(tableViewEgoRefreshTableHeaderDataSourceIsLoading:FromView:)]) {
    //        BOOL vIsLoading = [_delegate tableViewEgoRefreshTableHeaderDataSourceIsLoading:view FromView:self];
    //        return vIsLoading;
    //    }
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    if ([_delegate respondsToSelector:@selector(refreshData: FromView:)]) {
        [_delegate refreshData:^{
            [self doneLoadingTableViewData];
        } FromView:self];
    }else{
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    }
	
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_homeTableView];
    [self.homeTableView reloadData];
	
}


#pragma TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_delegate respondsToSelector:@selector(numberOfRowsInTableView:InSection:FromView:)]) {
        NSInteger vRows = [_dataSource numberOfRowsInTableView:tableView InSection:section FromView:self];
        mRowCount = vRows;
        return vRows + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == mRowCount) {
        LoadMoreCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreCell" owner:self options:nil] lastObject];
        return vCell.frame.size.height;
    }
    
    if ([_delegate respondsToSelector:@selector(heightForRowAtIndexPath:IndexPath:FromView:)]) {
        float vRowHeight = [_delegate heightForRowAtIndexPath:tableView IndexPath:indexPath FromView:self];
        return vRowHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vMoreCellIdentify = @"loadMoreCell";
    if (indexPath.row == mRowCount) {
        LoadMoreCell *vCell = [tableView dequeueReusableCellWithIdentifier:vMoreCellIdentify];
        if (vCell == nil) {
            vCell = [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreCell" owner:self options:Nil] lastObject];
        }
        return vCell;
    }else{
        if ([_dataSource respondsToSelector:@selector(cellForRowInTableView:IndexPath:FromView:)]) {
            UITableViewCell *vCell = [_dataSource cellForRowInTableView:tableView IndexPath:indexPath FromView:self];
            return vCell;
        }
    }
    return Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == mRowCount) {
        if ([_delegate respondsToSelector:@selector(loadData:FromView:)]) {
            [_delegate loadData:^(int aAddedRowCount) {
                NSInteger vNewRowCount = aAddedRowCount;
                if (vNewRowCount > 0) {
                    NSMutableArray *indexPaths = [NSMutableArray array];
                    for (int lIndex = mRowCount; lIndex < mRowCount + vNewRowCount; lIndex++) {
                        [indexPaths addObject:[NSIndexPath indexPathForRow:lIndex inSection:0]];
                    }
                    [tableView beginUpdates];
                    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [tableView endUpdates];
                    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                }
            }FromView:self];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(didSelectRowAtIndexPath:IndexPath:FromView:)]) {
            [_delegate didSelectRowAtIndexPath:tableView IndexPath:indexPath FromView:self];
        }
    }
}

#pragma mark 强制列表刷新
-(void)forceToFreshData{
    [_homeTableView setContentOffset:CGPointMake(_homeTableView.contentOffset.x,  - 66) animated:YES];
    double delayInSeconds = .2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_refreshHeaderView forceToRefresh:_homeTableView];
    });
}


#pragma SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index{
    
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
