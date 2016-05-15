//
//  CDVDialogsPlusToast.h
//  test3
//
//  Created by js on 16/5/8.
//  Copyright © 2016年 zrsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CDVDialogsPlusToast : NSObject

/**
 * @brief show the progress dialog
 *
 * @param text              the contect of the toast
 * @param time              the time of displaying. the unit is second
 *
 */
- (id)initWithText:(NSString *)text duration:(int) duration;

@end
