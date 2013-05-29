//
//  CONSTANTS.h
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#ifndef WeddingAlbum_CONSTANTS_h
#define WeddingAlbum_CONSTANTS_h

#define NEED_OUTPUT_LOG     1


#define KeyServer               @"server"
#define KeyOptionServer         @"option_image_server_domain"
#define KeyCouple               @"profile_couple"
#define KeyCoupleBoy            @"couple_name_boy"
#define KeyCoupleGirl           @"couple_name_girl"
#define KeyAppUrl               @"app_url"
#define KeyEmail                @"email"

#define CONFIG(key) [WADataEnvironment configForKey:key]

#define is_iPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define APP_SUPPORT                 [NSSearchPathForDirectoriesInDomains (NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0]

typedef void(^SLBlock)(void);
typedef void(^SLBlockBlock)(SLBlock block);
typedef void(^SLObjectBlock)(id obj);
typedef void(^SLArrayBlock)(NSArray *array);
typedef void(^SLMutableArrayBlock)(NSMutableArray *array);
typedef void(^SLDictionaryBlock)(NSDictionary *dic);
typedef void(^SLErrorBlock)(NSError *error);
typedef void(^SLIndexBlock)(NSInteger index);
typedef void(^SLFloatBlock)(CGFloat afloat);

typedef void(^SLCancelBlock)(id viewController);
typedef void(^SLFinishedBlock)(id viewController, id object);

#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#if NEED_OUTPUT_LOG
    #define SLog(xx, ...)   NSLog(xx, ##__VA_ARGS__)
    #define SLLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

    #define SLLogRect(rect) \
    SLLog(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y, \
    rect.size.width, rect.size.height)

    #define SLLogPoint(pt) \
    SLLog(@"%s x=%f, y=%f", #pt, pt.x, pt.y)

    #define SLLogSize(size) \
    SLLog(@"%s w=%f, h=%f", #size, size.width, size.height)

    #define SLLogColor(_COLOR) \
    SLLog(@"%s h=%f, s=%f, v=%f", #_COLOR, _COLOR.hue, _COLOR.saturation, _COLOR.value)

    #define SLLogSuperViews(_VIEW) \
    { for (UIView* view = _VIEW; view; view = view.superview) { SLLog(@"%@", view); } }

    #define SLLogSubViews(_VIEW) \
    { for (UIView* view in [_VIEW subviews]) { SLLog(@"%@", view); } }

#else
    #define SLog(xx, ...)  ((void)0)
    #define SLLog(xx, ...)  ((void)0)
    #define SLLogSize(size) ((void)0)
#endif

#endif
