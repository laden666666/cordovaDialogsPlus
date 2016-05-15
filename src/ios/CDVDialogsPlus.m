//
//  CDVDialogsPlus.m
//  test3
//
//  Created by js on 16/5/7.
//  Copyright © 2016 ningjz. All rights reserved.
//

#import "CDVDialogsPlus.h"

@implementation CDVDialogsPlus{
    //loading
    UIAlertView *showLoading;
    UIActivityIndicatorView *aiView;
    
    //progress
    UIAlertView *showProgress;
    UIProgressView *progressView;
    UILabel *progressLabel;
    NSString *progressCommandId;
}

const int CDV_DIAPLUS_LOAD = 10001;
const int CDV_DIAPLUS_PROGRESSVIEW = 10002;

//loading
-(void)showLoading:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* title = [command.arguments objectAtIndex:0];
    NSString* message = [command.arguments objectAtIndex:1];
    
    @try {
        [self showLoadingHandle:title message:message];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception name]];
    }
    @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}

-(void)showLoadingHandle:(NSString *)title message:(NSString *)message{
    
    if(showLoading == nil){
        showLoading =  [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        showLoading.tag = CDV_DIAPLUS_LOAD;
        
        
        aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75, 20, 30.0, 30.0)];
        aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        aiView.color = [UIColor blackColor];
        aiView.center = CGPointMake(135, 20);
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 85, 55)];
        [view addSubview:aiView];
        
        //check if os version is 7 or above.
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
            [showLoading setValue:view forKey:@"accessoryView"];
        }else{
            [showLoading addSubview:view];
        }
        [showLoading show];
        [aiView startAnimating];
    } else {
        showLoading.title = title;
        showLoading.message = message;
        [showLoading show];
        [aiView startAnimating];
    }
}

-(void)hideLoading:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    @try {
        [self hideLoadingHandle];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception name]];
    }
    @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}

- (void)hideLoadingHandle {
    if(showLoading != nil){
        [showLoading dismissWithClickedButtonIndex:0 animated:YES];
        [aiView stopAnimating];
        showLoading = nil;
    }
}

// 
-(void)showProgress:(CDVInvokedUrlCommand*)command
{
    
    NSString* title = [command.arguments objectAtIndex:0];
    NSString* message = [command.arguments objectAtIndex:1];
    bool cancelable = [[command.arguments objectAtIndex:2] boolValue];
    NSString *cancelableText = [command.arguments objectAtIndex:3];
    progressCommandId = command.callbackId;
    
    @try {
        [self progressStartHandle:title msessage:message cancelable:cancelable cancelableText:cancelableText];
    }
    @catch (NSException *exception) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception name]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}
-(void)progressStartHandle:(NSString *) title msessage:(NSString *)message cancelable:(BOOL) cancelable cancelableText: (NSString *)cancelableText{
    
    if(showProgress != nil){
        [showProgress dismissWithClickedButtonIndex:1 animated:NO];
        showProgress = nil;
        progressView = nil;
    }
    
    showProgress =  [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:(cancelable ? cancelableText : nil) otherButtonTitles:nil];
    showProgress.tag = CDV_DIAPLUS_PROGRESSVIEW;
    
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(0, 0, 225, 30);
    progressView.center = CGPointMake(135, 3);
    
    
    progressLabel = [[UILabel alloc] init];
    progressLabel.frame = CGRectMake(0, 0, 55, 30);
    progressLabel.center = CGPointMake(135, 18);
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.text = @"0%";
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 225, 35)];
    [view addSubview:progressView];
    [view addSubview:progressLabel];
    
    //check if os version is 7 or above.
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        [showProgress setValue:view forKey:@"accessoryView"];
    }else{
        [showProgress addSubview:view];
    }
    [showProgress show];
}


-(void)setProgressValue:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSNumber* value = [command.arguments objectAtIndex:0];
    
    @try {
        [self progressValueHandle:[value intValue]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception name]];
    }
    @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}
- (void)progressValueHandle:(NSInteger) value{
    if(value > 100){
        value = 100;
    } else if(value < 0){
        value = 0;
    }
    
    if(progressView != nil){
        progressLabel.text = [@"" stringByAppendingFormat:@"%ld%%" , (long)value];
        [progressView setProgress:value * 1.0 / 100.0 animated:YES];
    }
}

-(void)setProgressMessage:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* title = [command.arguments objectAtIndex:0];
    
    @try {
        [self progressMessageHandle:title];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception name]];
    }
    @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}
- (void)progressMessageHandle:(NSString*) message{
    if(showProgress != nil){
        showProgress.message = message;
    }
}

- (void)hideProgress:(CDVInvokedUrlCommand*)command{
    CDVPluginResult* pluginResult = nil;
    
    @try {
        [self progressStopHandle];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception name]];
    }
    @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}
- (void)progressStopHandle{
    if(progressView != nil){
        [showProgress dismissWithClickedButtonIndex:1 animated:YES];
        showProgress = nil;
        progressView = nil;
    }
    if(progressCommandId != nil){
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:progressCommandId];
        progressCommandId = nil;
    }
}

-(void)showNotice:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString *message = [command.arguments objectAtIndex:0];
    float time = [[command.arguments objectAtIndex:1] floatValue] / 1000;
    
    @try {
        [self showNoticeHandle:message itme:time];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception name]];
    }
    @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}
- (void)showNoticeHandle:(NSString *)message itme:(float) time{
    [[CDVDialogsPlusToast alloc]initWithText:message duration:time];
    
}

// callback of UIAlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //progress callback
    if(CDV_DIAPLUS_PROGRESSVIEW == alertView.tag){
        if (buttonIndex == 0 && progressCommandId != nil) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"cancel error"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:progressCommandId];
        }
    }
}
@end
