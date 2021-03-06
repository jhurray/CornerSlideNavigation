//
//  MainViewController.m
//  CornerSlideNavigationSampleProject
//
//  Created by Gregoire on 1/6/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize navView, label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:YES];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, DEVICEWIDTH, DEVICEHEIGHT/5)];
    [label setText:@"Swipe Down and left from the top right corner."];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    
    BOOL navBarHidden = self.navigationController.navigationBarHidden;
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    navView = [[CornerSlideNavigationView alloc] initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, DEVICEHEIGHT) withStatusBar:!statusBarHidden withNavBar:!navBarHidden];
    navView.delegate = self;
    [self.view addSubview:navView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SHOW" style:UIBarButtonSystemItemAction target:self action:@selector(showOrHideCorners)];
    
}

-(void)triangleButtonTouched:(TriangleView *)triangleView{
    
    [label setText:[NSString stringWithFormat:@"Triangle button #%lu touched!!", triangleView.tag]];
}

-(void)cornersHidden:(CornerSlideNavigationView *)cornerSlideNavView{
    
    if(!navView.visible){
        [label setText:@"Corner Slide Nav hidden."];
    }
    else{
        [label setText:@"Corner Slide Nav visible."];
    }
}

-(void)showOrHideCorners{
    [navView moveTriangles];
    if(navView.visible){
        [label setText:@"Corner Slide Nav hidden."];
    }
    else{
        [label setText:@"Corner Slide Nav visible."];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
