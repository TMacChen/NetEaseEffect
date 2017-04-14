//
//  ContentView.m
//  类网易效果
//
//  Created by jimmy on 14-9-15.
//  Copyright (c) 2014年 ceosoftcenters. All rights reserved.
//

#import "ContentView.h"
#import "SelfTableView.h"
#import "NewsItemCell.h"

@implementation ContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mNeedUseDelegate = YES;
        if (_contentItems == nil) {
            _contentItems = [[NSMutableArray alloc] init];
        }
        
        if (_scrollView == nil) {
            _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
            _scrollView.pagingEnabled = YES;
            _scrollView.delegate = self;
        }
        [self addSubview:_scrollView];
    }
    return self;
}


-(void)setContentOfTables:(NSInteger)aNumerOfTables{
    for (int i = 0; i < aNumerOfTables; i++) {
        SelfTableView *tableView = [[SelfTableView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        //为table添加嵌套HeadderView
        [self addLoopScrollowView:tableView];
        [_scrollView addSubview:tableView];
        [_contentItems addObject:tableView];
    }
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width * aNumerOfTables, self.frame.size.height)];
}

#pragma mark 添加HeaderView
-(void)addLoopScrollowView:(SelfTableView *)aTableView {
    //添加一张默认图片
    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:@{@"image": [NSString stringWithFormat:@"girl%d",2]} tag:-1];
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, -105, 320, 105) delegate:aTableView imageItems:@[item] isAuto:YES];
    aTableView.homeTableView.tableHeaderView = bannerView;
}

#pragma mark 改变TableView上面滚动栏的内容
-(void)changeHeaderContentWithCustomTable:(SelfTableView *)aTableContent{
    int length = 4;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < length; i++)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"title%d",i],@"title" ,
                              [NSString stringWithFormat:@"girl%d",(i + 1)],@"image",
                              nil];
        [tempArray addObject:dict];
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    //添加最后一张图 用于循环
    if (length > 1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
        [itemArray addObject:item];
    }
    
    SGFocusImageFrame *vFocusFrame = (SGFocusImageFrame *)aTableContent.homeTableView.tableHeaderView;
    [vFocusFrame changeImageViewsContent:itemArray];
}


#pragma SelfTableView Delegate
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(SelfTableView *)aView{
    return aView.tableInfoArray.count;
}

-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SelfTableView *)aView{
    static NSString *vCellIdentify = @"newsItemCell";
    NewsItemCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"NewsItemCell" owner:self options:nil] lastObject];
    }
    
    // 循环图片
    NSInteger vNewIndex = aIndexPath.row % 4 + 1;
    vCell.photoView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new%d",vNewIndex]];
    return vCell;
}

#pragma mark CustomTableViewDelegate
-(float)heightForRowAtIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SelfTableView *)aView{
    NewsItemCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"NewsItemCell" owner:self options:nil] lastObject];
    return vCell.frame.size.height;
}

-(void)didSelectRowAtIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SelfTableView *)aView{
    
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(SelfTableView *)aView{
    for (int i = 0; i < 4; i++) {
        [aView.tableInfoArray  addObject:@"0"];
    }
    if (complete) {
        complete(4);
    }
}

-(void)refreshData:(void(^)())complete FromView:(SelfTableView *)aView{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [aView.tableInfoArray removeAllObjects];
        for (int i = 0; i < 4; i++) {
            [aView.tableInfoArray addObject:@"0"];
        }
        //改变header显示图片
        [self changeHeaderContentWithCustomTable:aView];
        if (complete) {
            complete();
        }
    });
}


#pragma UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    mNeedUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        int page = (_scrollView.contentOffset.x + self.frame.size.width/2.0)/self.frame.size.width;
        if (mCurrentPage == page) {
            return;
        }
        mCurrentPage = page;
        if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate) {
            [_delegate didScrollPageViewChangedPage:mCurrentPage];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = (_scrollView.contentOffset.x + self.frame.size.width/2.0)/self.frame.size.width;
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage = page;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

-(void)freshContentTableAtIndex:(NSInteger)aIndex{
    if (_contentItems.count < aIndex) {
        return;
    }
    SelfTableView *vTableContentView =(SelfTableView *)[_contentItems objectAtIndex:aIndex];
    [vTableContentView forceToFreshData];
}

-(void)moveScrollViewToIndex:(NSInteger)aIndex{
    mNeedUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.height);
    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
    mCurrentPage= aIndex;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
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
