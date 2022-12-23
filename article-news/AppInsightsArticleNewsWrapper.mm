//
//  AppInsightsArticleNewsWrapper.m
//  BlurScreenSdk
//
//  Created by Roby Setiawan on 23/12/22.
//

#import <Foundation/Foundation.h>
#import "AppInsightsArticleNewsWrapper.h"
#import "AppInsightsArticleNews.hpp"
@implementation AppInsightsArticleNewsWrapper
- (NSString *) generateAklInside {
    AppInsightsArticleNews appInsightsBlurScreenSdk;
    std::string buildBlurScreenSdkAkl = appInsightsBlurScreenSdk.generateAkl();
    return [NSString
            stringWithCString:buildBlurScreenSdkAkl.c_str()
            encoding:NSUTF8StringEncoding];
}
@end
