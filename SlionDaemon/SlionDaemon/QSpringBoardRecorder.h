//
//  QScreenRecorder.h
//  CaptureRecord
//
//  Created by Jolin He on 14-1-2.
//  Copyright (c) 2014年 Jolin He. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "QRecordable.h"

/*!
 Recorder for the screen.
 
 @warning This uses a private API (UIGetScreenImage), and is not available in the simulator.
 */
@interface QSpringBoardRecorder : NSObject
@property(nonatomic,assign)CGSize size;
- (void)SpringBoardRecorder;
@end
