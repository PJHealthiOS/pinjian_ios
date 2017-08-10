//
//  PlaceDetail.h
//  LXF_MapGuideDemo
//
//  Created by developer on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
@interface PlaceDetailVO : NSObject{
    
}

@property(nonatomic, assign)    double                    pLatStr;
@property(nonatomic, assign)    double                      pLngStr;
@property(nonatomic, copy)    NSString                     *pAddress;
@property(nonatomic, copy)    NSString                     *pBusiness;
@property(nonatomic, copy)    NSString                     *pCity;
@property(nonatomic, copy)    NSString                     *pCountry;
@property(nonatomic, copy)    NSString                     *pDistrict;
@property(nonatomic, copy)    NSString                     *pProvince;
@property(nonatomic, copy)    NSString                     *pStreet;
@property(nonatomic, copy)    NSString                     *pStreet_number;

- (NSString *)addr;

@end
