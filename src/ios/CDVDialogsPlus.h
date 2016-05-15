//
//  CDVDialogsPlus.h
//  test3
//
//  Created by js on 16/5/7.
//  Copyright © 2016年 zrsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CDVDialogsPlusToast.h"
#import <Cordova/CDV.h>

@interface CDVDialogsPlus : CDVPlugin

/**
 * @brief show the loading dialog
 *
 * @param title             the title of the loading dialog
 * @param message           the message of the loading dialog
 *
 */
- (void)showLoadingHandle:(NSString *)title message:(NSString *)message;

/**
 * @brief hide the loading dialog
 *
 */
- (void)hideLoadingHandle ;

/**
 * @brief show the progress dialog
 *
 * @param title             the title of the progress dialog
 * @param message           the message of the progress dialog
 * @param cancelable        whether to show cancel button
 * @param cancelableText    the content of the cancel button
 *
 */
- (void)progressStartHandle:(NSString *) title msessage:(NSString *)message cancelable:(BOOL) cancelable cancelableText: (NSString *)cancelableText;

/**
 * @brief set value of the progress dialog
 *
 * @param value
 *
 */
- (void)progressValueHandle:(NSInteger) value;

/**
 * @brief set value of the progress dialog
 *
 * @param value
 *
 */
- (void)progressMessageHandle:(NSString *) Title;

/**
 * @brief hide the progress dialog
 *
 */
- (void)progressStopHandle;

/**
 * Show notice
 *
 * @param message   The message of the notice
 * @param time
 */
- (void)showNoticeHandle:(NSString *)message itme:(float) time;
@end
