//
//  CornerSlideNavigationView.m
//  CornerSlideNavigationSampleProject
//
//  Created by Gregoire on 1/6/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import "CornerSlideNavigationView.h"

#define T_SIZE DEVICEWIDTH/3
#define SHEETALPHA 0.5
#define NAVALPHA 0.7
#define SHEET_COLOR [UIColor darkGrayColor]
#define TOPRIGHTOFFSET 60
#define TOPRIGHTRATIOSHOWN 0.4

@implementation CornerSlideNavigationView

@synthesize triangles, visible, backgroundSheet, delegate;

static int heightOffset;



- (id)initWithFrame:(CGRect)frame withStatusBar:(BOOL)statusBar withNavBar:(BOOL)navBar
{
    self = [super initWithFrame:frame];
    if (self) {
        
        heightOffset = 0;
        if(statusBar){
            heightOffset+=STATUSBARHEIGHT;
        }
        if (navBar) {
            heightOffset+=NAVBARGEIGHT;
        }
        
        visible = FALSE;
        
        // Initialization code
        TriangleView *t1 = [[TriangleView alloc] initWithFrame:CGRectMake(DEVICEWIDTH, DEVICEHEIGHT, T_SIZE, T_SIZE)];
        [t1 setTag:1];
        TriangleView *t2 = [[TriangleView alloc] initWithFrame:CGRectMake(-T_SIZE, DEVICEHEIGHT, T_SIZE, T_SIZE)];
        [t2 setTag:2];
        TriangleView *t3 = [[TriangleView alloc] initWithFrame:CGRectMake(-T_SIZE, heightOffset-T_SIZE, T_SIZE, T_SIZE)];
        [t3 setTag:3];
        TriangleView *t4 = [[TriangleView alloc] initWithFrame:CGRectMake(DEVICEWIDTH+T_SIZE*(TOPRIGHTRATIOSHOWN-1), heightOffset-T_SIZE*TOPRIGHTRATIOSHOWN, T_SIZE, T_SIZE)];
        [t4 setTag:4];
        
       triangles = [[NSArray alloc] initWithObjects:t1, t2, t3, t4, nil];
        
        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        CGAffineTransform rotationTransformBtn = CGAffineTransformIdentity;
        double radians = 0;
        int num = 1;
        for(TriangleView *t in triangles){
            [t setBackgroundColor:[UIColor clearColor]];
            [t setAlpha:NAVALPHA];
            [t.btn setTitle:[NSString stringWithFormat:@"%i", num++] forState:UIControlStateNormal];
            [t.btn setTitleColor:TRIANGLE_COLOR forState:UIControlStateNormal];
            t.delegate = self;
            [self addSubview:t];
            t.transform = CGAffineTransformRotate(rotationTransform, radians);
            t.btn.transform = CGAffineTransformRotate(rotationTransformBtn, -radians);
            radians+=(PI/2);
        }
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [t4 addGestureRecognizer:recognizer];
        
        backgroundSheet = [[UIView alloc] initWithFrame:CGRectMake(0, heightOffset, DEVICEWIDTH, DEVICEHEIGHT)];
        [backgroundSheet setBackgroundColor:SHEET_COLOR];
        [backgroundSheet setAlpha:SHEETALPHA];
        
    }
    return self;
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint desiredOriginOut = CGPointMake(DEVICEWIDTH-recognizer.view.frame.size.width, heightOffset);
    CGPoint desiredOriginIn = CGPointMake(desiredOriginOut.x+TOPRIGHTRATIOSHOWN*T_SIZE, desiredOriginOut.y-TOPRIGHTRATIOSHOWN*T_SIZE);
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        
        
        NSLog(@"\n\nBEGAN\n");
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged){
        [((TriangleView *)[triangles objectAtIndex:3]).btn setBackgroundColor:BTN_COLOR];
        
        CGPoint translation = [recognizer translationInView:self];
        CGFloat translationValOut = MAX(-translation.x, translation.y);
        CGFloat translationValIn = MAX(translation.x, -translation.y);
        // add stuff for angle???
        
        CGFloat topRightDist = [self distanceBetween:desiredOriginIn and:desiredOriginOut];
        CGFloat outRatio = translationValOut/topRightDist;
        CGFloat inRatio = translationValIn/topRightDist;
        
        if(translation.x <= 0 && translation.y >= 0 && recognizer.view.frame.origin.x > desiredOriginOut.x){

            [recognizer.view setFrame:CGRectMake(MAX(desiredOriginOut.x, recognizer.view.frame.origin.x-translationValOut), MIN(desiredOriginOut.y, recognizer.view.frame.origin.y+translationValOut), recognizer.view.frame.size.width, recognizer.view.frame.size.height)];
            [self handlePanForOtherTrianglesWithRatio:outRatio movingOut:YES];

        }
        else if(translation.x >= 0 && translation.y <= 0 && recognizer.view.frame.origin.x < desiredOriginIn.x){
            
            [recognizer.view setFrame:CGRectMake(MIN(desiredOriginIn.x, recognizer.view.frame.origin.x+translationValIn), MAX(desiredOriginIn.y, recognizer.view.frame.origin.y-translationValIn), recognizer.view.frame.size.width, recognizer.view.frame.size.height)];
            [self handlePanForOtherTrianglesWithRatio:inRatio movingOut:NO];
        }
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        
        CGPoint velocity = [recognizer velocityInView:self];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        TriangleView *t1 = [triangles objectAtIndex:0];
        TriangleView *t2 = [triangles objectAtIndex:1];
        TriangleView *t3 = [triangles objectAtIndex:2];
        
        CGPoint t1OutOrigin = CGPointMake(DEVICEWIDTH-T_SIZE, DEVICEHEIGHT-T_SIZE);
        CGPoint t1InOrigin = CGPointMake(DEVICEWIDTH, DEVICEHEIGHT);
        CGPoint t2OutOrigin = CGPointMake(0, DEVICEHEIGHT-T_SIZE);
        CGPoint t2InOrigin = CGPointMake(-T_SIZE, DEVICEHEIGHT);
        CGPoint t3OutOrigin = CGPointMake(0, heightOffset);
        CGPoint t3InOrigin = CGPointMake(-T_SIZE, heightOffset-T_SIZE);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        
        if(velocity.x <=0 && velocity.y >=0 ){
            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if([self distanceBetween:recognizer.view.frame.origin and:desiredOriginOut] >= [self distanceBetween:recognizer.view.frame.origin and:desiredOriginIn]){
                    //going  IN
                    [t1 setFrame:CGRectMake(t1InOrigin.x, t1InOrigin.y, T_SIZE, T_SIZE)];
                    [t2 setFrame:CGRectMake(t2InOrigin.x, t2InOrigin.y, T_SIZE, T_SIZE)];
                    [t3 setFrame:CGRectMake(t3InOrigin.x, t3InOrigin.y, T_SIZE, T_SIZE)];
                    [recognizer.view setFrame:CGRectMake(desiredOriginIn.x, desiredOriginIn.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height)];
                    self.visible = FALSE;
                }
                else{ // going OUT
                    [t1 setFrame:CGRectMake(t1OutOrigin.x, t1OutOrigin.y, T_SIZE, T_SIZE)];
                    [t2 setFrame:CGRectMake(t2OutOrigin.x, t2OutOrigin.y, T_SIZE, T_SIZE)];
                    [t3 setFrame:CGRectMake(t3OutOrigin.x, t3OutOrigin.y, T_SIZE, T_SIZE)];
                    [recognizer.view setFrame:CGRectMake(desiredOriginOut.x, desiredOriginOut.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height)];
                    self.visible = TRUE;
                }
                
            } completion:^(BOOL finished) {
                [self.delegate cornersHidden:self];
            }];
        }
        //go in
        else if (velocity.x >=0 && velocity.y <=0){
            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [t1 setFrame:CGRectMake(t1InOrigin.x, t1InOrigin.y, T_SIZE, T_SIZE)];
                [t2 setFrame:CGRectMake(t2InOrigin.x, t2InOrigin.y, T_SIZE, T_SIZE)];
                [t3 setFrame:CGRectMake(t3InOrigin.x, t3InOrigin.y, T_SIZE, T_SIZE)];
                [recognizer.view setFrame:CGRectMake(desiredOriginIn.x, desiredOriginIn.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height)];
                
            } completion:^(BOOL finished){
                visible = FALSE;
                [delegate cornersHidden:self];
            }];
        }
        
        NSLog(@"\n\nENDED\n");
    }
}


-(void)handlePanForOtherTrianglesWithRatio:(CGFloat)ratio movingOut:(BOOL)showing{
    
    TriangleView *t1 = [triangles objectAtIndex:0];
    TriangleView *t2 = [triangles objectAtIndex:1];
    TriangleView *t3 = [triangles objectAtIndex:2];
    
    CGPoint t1OutOrigin = CGPointMake(DEVICEWIDTH-T_SIZE, DEVICEHEIGHT-T_SIZE);
    CGPoint t1InOrigin = CGPointMake(DEVICEWIDTH, DEVICEHEIGHT);
    CGPoint t2OutOrigin = CGPointMake(0, DEVICEHEIGHT-T_SIZE);
    CGPoint t2InOrigin = CGPointMake(-T_SIZE, DEVICEHEIGHT);
    CGPoint t3OutOrigin = CGPointMake(0, heightOffset);
    CGPoint t3InOrigin = CGPointMake(-T_SIZE, heightOffset-T_SIZE);
    
    CGFloat dist = sqrt(2)*T_SIZE*ratio;
    
    if(showing){
        [t1 setFrame:CGRectMake(MAX(t1OutOrigin.x, t1.frame.origin.x-dist), MAX(t1OutOrigin.y, t1.frame.origin.y-dist), T_SIZE, T_SIZE)];
        [t2 setFrame:CGRectMake(MIN(t2OutOrigin.x, t2.frame.origin.x+dist), MAX(t2OutOrigin.y, t2.frame.origin.y-dist), T_SIZE, T_SIZE)];
        [t3 setFrame:CGRectMake(MIN(t3OutOrigin.x, t3.frame.origin.x+dist), MIN(t3OutOrigin.y, t3.frame.origin.y+dist), T_SIZE, T_SIZE)];
        
    }
    else{
        [t1 setFrame:CGRectMake(MIN(t1InOrigin.x, t1.frame.origin.x+dist), MIN(t1InOrigin.y, t1.frame.origin.y+dist), T_SIZE, T_SIZE)];
        [t2 setFrame:CGRectMake(MAX(t2InOrigin.x, t2.frame.origin.x-dist), MIN(t2InOrigin.y, t2.frame.origin.y+dist), T_SIZE, T_SIZE)];
        [t3 setFrame:CGRectMake(MAX(t3InOrigin.x, t3.frame.origin.x-dist), MAX(t3InOrigin.y, t3.frame.origin.y-dist), T_SIZE, T_SIZE)];
    }
    
}


// FOR TRIANGLE VIEW DELEGATE
-(void)triangleButtonTouched:(TriangleView *)triangleView{
    [delegate triangleButtonTouched:triangleView];
}

-(void)moveTriangles{
    if(visible){
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [backgroundSheet setAlpha:0];
                             [[triangles objectAtIndex:0] setFrame:CGRectMake(DEVICEWIDTH, DEVICEHEIGHT, T_SIZE, T_SIZE) ];
                             [[triangles objectAtIndex:1] setFrame:CGRectMake(-T_SIZE, DEVICEHEIGHT, T_SIZE, T_SIZE) ];
                             [[triangles objectAtIndex:2] setFrame:CGRectMake(-T_SIZE, heightOffset-T_SIZE, T_SIZE, T_SIZE) ];
                             [[triangles objectAtIndex:3] setFrame:CGRectMake(DEVICEWIDTH+T_SIZE*(TOPRIGHTRATIOSHOWN-1), heightOffset-T_SIZE*TOPRIGHTRATIOSHOWN, T_SIZE, T_SIZE)];
                         }
                         completion:^(BOOL finished) {
                             visible = FALSE;
                             [backgroundSheet removeFromSuperview];
                         }];
        
    }
    else{
        [self addSubview:backgroundSheet];
        [self sendSubviewToBack:backgroundSheet];
        [UIView animateWithDuration:0.6f
                              delay:0.0f
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [backgroundSheet setAlpha:SHEETALPHA];
                             [[triangles objectAtIndex:0] setFrame:CGRectMake(DEVICEWIDTH-T_SIZE, DEVICEHEIGHT-T_SIZE, T_SIZE, T_SIZE) ];
                             [[triangles objectAtIndex:1] setFrame:CGRectMake(0, DEVICEHEIGHT-T_SIZE, T_SIZE, T_SIZE) ];
                             [[triangles objectAtIndex:2] setFrame:CGRectMake(0, heightOffset, T_SIZE, T_SIZE) ];
                             [[triangles objectAtIndex:3] setFrame:CGRectMake(DEVICEWIDTH-T_SIZE, heightOffset, T_SIZE, T_SIZE)];
                             
                         }
                         completion:^(BOOL finished) {
                             visible = TRUE;
                         }];
        
    }
    
}

- (float) distanceBetween : (CGPoint) p1 and: (CGPoint) p2
{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
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
