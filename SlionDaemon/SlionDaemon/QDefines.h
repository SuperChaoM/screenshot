//
//  QDefines.h
//  CaptureRecord
//
//  Created by Jolin He on 14-1-2.
//  Copyright (c) 2014年 Jolin He. All rights reserved.
//
#import <Foundation/Foundation.h>

#define QSetError(__ERROR__, __ERROR_CODE__, __DESC__, ...) do { \
NSString *message = [NSString stringWithFormat:__DESC__, ##__VA_ARGS__]; \
NSLog(@"%@", message); \
if (__ERROR__) *__ERROR__ = [NSError errorWithDomain:QErrorDomain code:__ERROR_CODE__ \
userInfo:[NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,  \
nil]]; \
} while (0)

#if DEBUG
#define QDebug(...) NSLog(__VA_ARGS__)
#define QWarn(...) NSLog(__VA_ARGS__)
#else
#define QDebug(...) do { } while(0)
#define QWarn(...) do { } while(0)
#endif

/*!
 Error domain.
 */
extern NSString *const QErrorDomain;

/*!
 Exception.
 */
extern NSString *const QException;

/*!
 Recording did start notification.
 Notification object is the QRecorder instance that started.
 */
extern NSString *const QRecorderDidStartNotification;

/*!
 Recording did stop notification.
 Notification object is the QRecorder instance that stopped.
 */
extern NSString *const QRecorderDidStopNotification;

/*!
 Video did change notification.
 Notification object is the QVideo instance that changed.
 */
extern NSString *const QVideoDidChangeNotification;

/*!
 UIEvent notification.
 Notification object is the UIEvent instance.
 */
extern NSString *const QUIEventNotification;


typedef enum : NSInteger {
  QErrorCodeInvalidVideo = -100,
  QErrorCodeInvalidState = -101,
} QErrorCode;

/*!
 QRecorder options.
 */
typedef enum : NSUInteger {
  QRecorderOptionUserCameraRecording = 1 << 0, // Record the user using the front facing camera
  QRecorderOptionUserAudioRecording = 1 << 1, // Record the user audio
  QRecorderOptionTouchRecording = 1 << 2, // Record touches
} QRecorderOptions;

/*!
 Save result block.
 @param URL Asset URL. To load the ALAsset, use ALAssetsLibrary assetForURL:resultBlock:failureBlock.
 */
typedef void (^QRecorderSaveResultBlock)(NSURL *URL);

/*!
 Save failure block.
 @param error Error
 */
typedef void (^QRecorderSaveFailureBlock)(NSError *error);
