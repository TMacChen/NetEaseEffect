//
//  MenuView.h
//  类网易效果
//
//  Created by jimmy on 14-9-15.
//  Copyright (c) 2014年 ceosoftcenters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuDelegate <NSObject>

@optional
-(void)didMenuClickedButtonAtIndex:(NSInteger)aIndex;
@end

@interface MenuView : UIView{
    UIScrollView *scrollView;
    NSMutableArray *itemInfoArray;
    float itemTotalWidth;
}

@property (nonatomic,assign) id <MenuDelegate> delegate;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

-(void)clickButtonAtIndex:(NSInteger)aIndex;

-(void)changeButtonStateWithTag:(NSInteger)buttonTag;

@end
