//
//  CDVDialogsPlusToast.m
//  test3
//
//  Created by js on 16/5/8.
//  Copyright © 2016年 zrsoft. All rights reserved.
//

#import "CDVDialogsPlusToast.h"

@implementation CDVDialogsPlusToast{
    UIButton *contentView;
}

- (id)initWithText:(NSString *)text duration:(int) duration{
    
    //Default display two seconds
    if(duration <=0 ){
        duration = 1;
    }
    
    if (self = [super init]) {
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 12, textSize.height + 12)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.borderWidth = 1.0f;
        contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        contentView.backgroundColor = [UIColor colorWithRed:0.2f
                                                      green:0.2f
                                                       blue:0.2f
                                                      alpha:0.75f];
        [contentView addSubview:textLabel];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        contentView.alpha = 0.0f;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        contentView.center = CGPointMake(window.center.x, window.center.y * 3 / 2);;
        [window addSubview:contentView];
        
        [UIView beginAnimations:@"show" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3];
        contentView.alpha = 1.0f;
        [UIView commitAnimations];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 * duration target:self selector:@selector(hideToast:) userInfo:nil  repeats: YES];
    }
    return self;
    
}

- (void)hideToast:(NSTimer *)timer{
    [timer invalidate];
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)dismissToast{
    [contentView removeFromSuperview];
}

    


@end
