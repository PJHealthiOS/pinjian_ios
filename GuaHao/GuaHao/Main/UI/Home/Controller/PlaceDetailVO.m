//
//  PlaceDetail.m
//  LXF_MapGuideDemo
//
//  Created by developer on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceDetailVO.h"

@implementation PlaceDetailVO

- (NSString *)pCountry
{
    if (_pCountry) {
        return _pCountry;
    }
    return @"";
}
- (NSString *)pProvince
{
    if (_pProvince) {
        return _pProvince;
    }
    return @"";
}
- (NSString *)pCity
{
    if (_pCity) {
        return _pCity;
    }
    return @"";
}
- (NSString *)pBusiness
{
    if (_pBusiness) {
        return _pBusiness;
    }
    return @"";
}
- (NSString *)pStreet
{
    if (_pStreet) {
        return _pStreet;
    }
    return @"";
}
- (NSString *)pStreet_number
{
    if (_pStreet_number) {
        return _pStreet_number;
    }
    return @"";
}
- (NSString *)pAddress
{
    if (_pAddress) {
        return _pAddress;
    }
    return @"";
}

- (NSString *)addr
{
    return [NSString stringWithFormat:@"%@%@%@%@%@%@", self.pCountry, self.pProvince, self.pCity, self.pBusiness, self.pStreet, self.pStreet_number];
}

@end
