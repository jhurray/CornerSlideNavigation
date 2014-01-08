//
//  MainViewController.h
//  CornerSlideNavigationSampleProject
//
//  Created by Gregoire on 1/6/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//
#import "CornerSlideNavigationView.h"
#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<CornerSlideNavigationDelegate>

@property (nonatomic, strong) CornerSlideNavigationView *navView;
@property (nonatomic, strong) UILabel *label;

@end
