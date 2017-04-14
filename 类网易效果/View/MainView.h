//
//  MainView.h
//  类网易效果
//
//  Created by jimmy on 14-9-15.
//  Copyright (c) 2014年 ceosoftcenters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "ContentView.h"

@interface MainView : UIView <MenuDelegate,ScrollPageViewDelegate>{
    MenuView *menuView;
    ContentView *contentView;
}

@end
