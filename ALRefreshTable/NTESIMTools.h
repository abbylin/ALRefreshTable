//
//  NTESIMTools.h
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-20.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#ifndef ALRefreshTable_NTESIMTools_h
#define ALRefreshTable_NTESIMTools_h


//====== 辅助工具 =====
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define isiPhone5 CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136))

// version related

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#pragma mark -
#pragma mark - object security check
//nsstring
static inline BOOL verifiedString(id strlike) {
    if (strlike && ![strlike isEqual:[NSNull null]] && [[strlike class] isSubclassOfClass:[NSString class]] && ((NSString*)strlike).length > 0) {
        return YES;
    }else{
        return NO;
    }
}

//nsnumber
static inline BOOL verifiedNSNumber(id numlike) {
    if (numlike && ![numlike isEqual:[NSNull null]] && [[numlike class] isSubclassOfClass:[NSNumber class]]) {
        return YES;
    }else{
        return NO;
    }
}

//nsarray
static inline BOOL verifiedNSArray(id arraylike) {
    if (arraylike && ![arraylike isEqual:[NSNull null]] && [[arraylike class] isSubclassOfClass:[NSArray class]] && [arraylike count] > 0) {
        return YES;
    }else{
        return NO;
    }
}

//nsdictionary
static inline BOOL verifiedNSDictionary(id dictlike) {
    if (dictlike && ![dictlike isEqual:[NSNull null]] && [[dictlike class] isSubclassOfClass:[NSDictionary class]]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -
#pragma mark - version related
static inline NSString* releaseVersion(void){
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
}

static inline NSString* developmentVersion(){
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}


#endif
