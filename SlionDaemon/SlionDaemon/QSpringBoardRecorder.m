//
//  QScreenRecorder.m
//  QScreenRecorder
//
//  Created by Jolin He on 14-1-2.
//  Copyright (c) 2014年 Jolin He. All rights reserved.
//

#import "QSpringBoardRecorder.h"
#import <UIKit/UIKit.h>
#import "QDefines.h"
#include <dlfcn.h>
#include <stdio.h>
#import "IOMobileFrameBuffer.h"
#import "IOSurface.h"

#pragma mark - Private Declarations

@implementation QSpringBoardRecorder{
    IOSurfaceRef _screenSurface;
    IOSurfaceRef _copySurface;
    IOSurfaceAcceleratorRef _outAcc;
    
    uint32_t aseed;
    CFMutableDictionaryRef _surfaceOptions;
    
    NSTimeInterval _startTime;
    NSTimeInterval _recordTime;
}

-(void)dealloc{
    [self releaseSurface];
}

- (id)init {
    if ((self = [super init])) {
        
    }
    
    if (![self getScreenSurface]) {
        return nil;
    }
    
    return self;
}


- (void)renderInContext:(CGContextRef)context videoSize:(CGSize)videoSize {
    if (!_copySurface) [self createCopySurface];
    if (!_copySurface) return;
    
    IOSurfaceLock(_screenSurface, kIOSurfaceLockReadOnly, &aseed);
    IOSurfaceAcceleratorTransferSurface(_outAcc, _screenSurface, _copySurface, _surfaceOptions, NULL);
    IOSurfaceUnlock(_screenSurface, kIOSurfaceLockReadOnly, &aseed);
    
    size_t width = _size.width;
    size_t height = _size.height;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, IOSurfaceGetBaseAddress(_copySurface), (width*height*4), NULL);
    CGImageRef cgImage=CGImageCreate(width, height, 8, 8*4, IOSurfaceGetBytesPerRow(_copySurface), CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little, provider, NULL, YES, kCGRenderingIntentDefault);
    if (!cgImage) {
        NSLog(@"failed to create pixel buffer");
    }else{
       //CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    }
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
}

- (void)SpringBoardRecorder{
    if (!_copySurface) [self createCopySurface];
    if (!_copySurface) return;
    
    IOSurfaceLock(_screenSurface, kIOSurfaceLockReadOnly, &aseed);
    IOSurfaceAcceleratorTransferSurface(_outAcc, _screenSurface, _copySurface, _surfaceOptions, NULL);
    IOSurfaceUnlock(_screenSurface, kIOSurfaceLockReadOnly, &aseed);
    
    size_t width = _size.width;
    size_t height = _size.height;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, IOSurfaceGetBaseAddress(_copySurface), (width*height*4), NULL);
    CGImageRef cgImage=CGImageCreate(width, height, 8, 8*4, IOSurfaceGetBytesPerRow(_copySurface), CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little, provider, NULL, YES, kCGRenderingIntentDefault);
    if (!cgImage) {
        NSLog(@"failed to create pixel buffer");
    }else{
        
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        NSData *imageViewData = UIImagePNGRepresentation(image);
        NSString *savedImagePath = [@"/private/var/mobile/Media/Slion" stringByAppendingPathComponent:@"root1.png"];
        [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
        
    }
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    
}

#pragma mark 释放资源
- (void)releaseSurface {
    CFRelease(_copySurface);
    _copySurface = NULL;
    CFRelease(_outAcc);
    _outAcc=NULL;
}


#pragma mark 创建资源

- (BOOL)getScreenSurface {
    char const * const __unused ServiceNames[] = {
        "AppleMobileCLCD",
        "AppleCLCD",
        "AppleH1CLCD",
        "AppleM2CLCD"
    };
    
    IOMobileFramebufferService framebufferService = 0;
#if !TARGET_IPHONE_SIMULATOR
    for (unsigned long i = 0; i < sizeof(ServiceNames) / sizeof(ServiceNames[0]); i++) {
        
        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                         IOServiceMatching(ServiceNames[i]));
        if (framebufferService) {
            break;
        }
    }
#endif
    if (!framebufferService) {
        NSLog(@"failed to create framebuffer service");
        return NO;
    }
    
    IOMobileFramebufferConnection __unused framebufferConnection = NULL;
#if TARGET_IPHONE_SIMULATOR
    kern_return_t result = KERN_FAILURE;
#else
    kern_return_t result = IOMobileFramebufferOpen(framebufferService,
                                                   mach_task_self(),
                                                   0,
                                                   &framebufferConnection);
#endif
    if (result != KERN_SUCCESS) {
        NSLog(@"failed to open framebuffer");
        return NO;
    }
    CoreSurfaceBufferRef screenSurface = NULL;
    
#if TARGET_IPHONE_SIMULATOR
    kern_return_t getLayerResult = KERN_FAILURE;
#else
    kern_return_t getLayerResult = IOMobileFramebufferGetLayerDefaultSurface(framebufferConnection,
                                                                             0,
                                                                             &screenSurface);
#endif
    if (getLayerResult != KERN_SUCCESS) {
        NSLog(@"failed to get screen surface");
        return NO;
    }
    
    // CoreSurfaceRef and IOSurfaceRef are toll-free bridged
    _screenSurface = (IOSurfaceRef)screenSurface;
    
    // TODO: Close framebuffer connection?
    // IOMobileFramebufferConnection appears to be a pointer type
    // (it's being dereferenced in IOMobileFramebufferGetLayerDefaultSurface())
    // so it's a different type than io_connect_t,
    // hence we cannot IOServiceClose() it.
    
    IOSurfaceLock(_screenSurface, kIOSurfaceLockReadOnly, &aseed);
    size_t width = IOSurfaceGetWidth(_screenSurface);
    size_t height = IOSurfaceGetHeight(_screenSurface);
    IOSurfaceUnlock(_screenSurface, kIOSurfaceLockReadOnly, &aseed);
    
    _size=CGSizeMake(width, height);
    IOSurfaceAcceleratorCreate(NULL, 0, &_outAcc);
    
    return YES;
}



- (BOOL)createCopySurface {
#if !TARGET_IPHONE_SIMULATOR
    
    uint32_t width = _size.width;
    uint32_t height = _size.height;
    int bPE=4;
    int pitch = width*bPE, size = width*height*bPE;
    char pixelFormat[4] = {'A','R','G','B'};
    _surfaceOptions = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(_surfaceOptions, kIOSurfaceIsGlobal, kCFBooleanTrue);
    CFDictionarySetValue(_surfaceOptions, kIOSurfaceBytesPerRow, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &pitch));
    CFDictionarySetValue(_surfaceOptions, kIOSurfaceBytesPerElement, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bPE));
    CFDictionarySetValue(_surfaceOptions, kIOSurfaceWidth, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &width));
    CFDictionarySetValue(_surfaceOptions, kIOSurfaceHeight, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &height));
    CFDictionarySetValue(_surfaceOptions, kIOSurfacePixelFormat, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, pixelFormat));
    CFDictionarySetValue(_surfaceOptions, kIOSurfaceAllocSize, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &size));
    _copySurface = IOSurfaceCreate(_surfaceOptions);
    
#endif
    
    if (_copySurface == NULL) {
        NSLog(@"failed to get surface from pixel buffer");
        return NO;
    }
    return YES;
}

@end
