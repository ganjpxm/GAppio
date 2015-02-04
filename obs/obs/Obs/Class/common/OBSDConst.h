//
//  DBSConst.h
//  DbsMobileApp4
//
//  Created by Johnny on 6/3/14.
//  Copyright (c) 2014 dbs. All rights reserved.
//

#define THEME_COLOR [UIColor colorWithRed:0.0/255.0 green:97.0/255.0 blue:196.0/255.0 alpha:1.0]
#define LIGHT_GRAY_COLOR  [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:245.0/255.0 alpha:1.0]
#define DARK_GRAY_COLOR  [UIColor colorWithRed:153.0/255.0 green:152.0/255.0 blue:157.0/255.0 alpha:1.0]


//static NSString * const URL_HOST                   = @"http://119.9.74.121/";
static NSString * const URL_HOST                   = @"http://192.168.0.109:8080/obs/";
static NSString * const LOGIN_ORG_CD               = @"01";

// Time
static long const FILE_EXPIREDDATE                 = (1 * 24 * 60 * 60);
static long const FORM_LOAD_TIMEOUT                = 15;
static long const FORM_SUBMIT_TIMEOUT              = (1.5 * 60);
static long const FORM_UPLOAD_TIMEOUT              = (7 * 60);

static NSInteger const MAP_DIRECTION = 1;
static NSInteger const MAP_ROUTE = 2;
static NSInteger const CALL_LEAD_PASSENGER = 3;
static NSInteger const CALL_BOOK_BY_USER = 4;
static NSInteger const CALL_ASSIGNER = 5;

//GOOGLE ANALYTICS
static NSString * const GOOGLE_ANALYTICS_TRACKING_ID = @"UA-49817046-1";
static BOOL const GOOGLE_ANALYTICS_OPT_OUT = NO;
static NSString * const SCREEN_LOGIN = @"Login";
static NSString * const SCREEN_BOOKING_UPCONMING = @"Upcoming booking";
static NSString * const SCREEN_BOOKING_DETAIL = @"Booking detail";
static NSString * const SCREEN_BOOKING_PAST = @"Pasting Booking";
static NSString * const SCREEN_PROFILE = @"Profile";
static NSString * const SCREEN_MORE = @"More";
static NSString * const SCREEN_CHECK_LIST = @"Check List";
static NSString * const SCREEN_PRODUCT_INFO = @"Product Info";

static NSString * const KEY_OBSD                   = @"OBSD";
static NSString * const KEY_NETWORK_STATUS_OBSD    = @"ObsNetworkState";
static NSString * const KEY_DB_VERSION_OBSD        = @"OBSCDbVersion";
static NSString * const KEY_USER_CD_OBSD           = @"ObsdUserCd";
static NSString * const KEY_PASSWORD_OBSD          = @"ObsdPassword";
static NSString * const KEY_USER_ID_OBSD           = @"ObsdUserId";
static NSString * const KEY_USER_NAME_OBSD         = @"ObsdUserName";
static NSString * const KEY_USER_MOBILE_PHONE_OBSD = @"ObsdUserMobilePhone";
static NSString * const KEY_USER_EMAIL_OBSD        = @"ObsdUserEmail";
static NSString * const KEY_USER_PHOTO_URL_OBSD    = @"ObsdUserPhotoUrl";
static NSString * const KEY_USER_EXTEND_ITEMS_OBSD = @"ObsdUserExtendItems";
static NSString * const KEY_ORG_ID_OBSD            = @"ObsdOrgId";
static NSString * const KEY_ORG_NAME_OBSD          = @"ObsdOrgName";
static NSString * const KEY_ORG_MOBILE_NUMBER_OBSD = @"ObsdOrgMobileNumber";
static NSString * const KEY_ORG_EMAIL_OBSD         = @"ObsdOrgEmail";
static NSString * const KEY_ORG_PHONE_NUMBER_OBSD  = @"ObsdOrgPhoneNumber";
static NSString * const KEY_ORG_ADDRESS_OBSD       = @"ObsdOrgAddress";
static NSString * const KEY_BOOKING_VEHICLE_ITEM_ID_OBSD = @"ObsdBookingVehicleItemId";

static NSString * const KEY_UDID_OBSD              = @"ObsdUDID";
static NSString * const KEY_DEVICE_TOKEN_OBSD      = @"ObsdDeviceToken";
static NSString * const KEY_PUSH_NOTIFICATION_OBSD = @"ObsdPushNotification";

static NSString * const KEY_RESULT                 = @"result";
static NSString * const KEY_DATA                   = @"data";
static NSString * const KEY_START_DATE             = @"startDate";

static NSString * const VALUE_SCCESS               = @"success";
static NSString * const VALUE_FAIL                 = @"fail";
static NSString * const VALUE_NEW_ITEMS            = @"New Items";
static NSString * const VALUE_YES                  = @"YES";
static NSString * const VALUE_NO                   = @"NO";
static NSString * const VALUE_ACCEPTED             = @"accepted";

static NSString * const VALUE_BOOKING_SERVICE_CD_ARRIVAL   = @"0101";
static NSString * const VALUE_BOOKING_SERVICE_CD_DEPARTURE = @"0102";

static NSString * const DB_VERSION                 = @"1.0";
static NSString * const DB_NAME                    = @"obsc.sqlite";
static NSString * const TABLE_BM_CONFIG            = @"bm_config";
static NSString * const COLUMN_CONFIG_ID           = @"configId";
static NSString * const COLUMN_CONFIG_CD           = @"configCd";
static NSString * const COLUMN_CONFIG_NAME         = @"configName";
static NSString * const COLUMN_CONFIG_VALUE        = @"configValue";

static NSString * const TABLE_OBM_BOOKING_VEHICLE_ITEM      = @"ObmBookingVehicleItem";
static NSString * const COLUMN_BOOKING_VEHICLE_ITEM_ID      = @"bookingVehicleItemId";
static NSString * const COLUMN_BOOKING_VEHICLE_ID           = @"bookingVehicleId";
static NSString * const COLUMN_BOOKING_NUMBER               = @"bookingNumber";
static NSString * const COLUMN_BOOKING_SERVICE              = @"bookingService";
static NSString * const COLUMN_BOOKING_SERVICE_CD           = @"bookingServiceCd";
static NSString * const COLUMN_PICKUP_DATE                  = @"pickupDate";
static NSString * const COLUMN_PICKUP_TIME                  = @"pickupTime";
static NSString * const COLUMN_PICKUP_DATE_TIME             = @"pickupDateTime";
static NSString * const COLUMN_BOOKING_GHOURS               = @"bookingHours";
static NSString * const COLUMN_FLIGHT_NUMBER                = @"flightNumber";
static NSString * const COLUMN_PICKUP_CITY                  = @"pickupCity";
static NSString * const COLUMN_PICKUP_CITY_CD               = @"pickupCityCd";
static NSString * const COLUMN_PICKUP_ADDRESS               = @"pickupAddress";
static NSString * const COLUMN_PICKUP_POINT                 = @"pickupPoint";
static NSString * const COLUMN_DESTINATION                  = @"destination";
static NSString * const COLUMN_VEHICLE                      = @"vehicle";
static NSString * const COLUMN_VEHICLE_CD                   = @"vehicleCd";
static NSString * const COLUMN_PRICE                        = @"price";
static NSString * const COLUMN_DRIVER_USER_ID               = @"driverUserId";
static NSString * const COLUMN_LEAD_PASSENGER_FIRST_NAME    = @"leadPassengerFirstName";
static NSString * const COLUMN_LEAD_PASSENGER_LAST_NAME     = @"leadPassengerLastName";
static NSString * const COLUMN_LEAD_PASSENGER_MOBILE_NUMBER = @"leadPassengerMobileNumber";
static NSString * const COLUMN_BOOKING_STATUS               = @"bookingStatus";
static NSString * const COLUMN_BOOKING_STATUS_CD            = @"bookingStatusCd";
static NSString * const COLUMN_PAYMENT_STATUS               = @"paymentStatus";
static NSString * const COLUMN_PAYMENT_STATUS_CD            = @"paymentStatusCd";
static NSString * const COLUMN_DRIVER_USER_NAME            = @"driverUserName";
static NSString * const COLUMN_DRIVER_MOBILE_NUMBER        = @"driverMobileNumber";
static NSString * const COLUMN_DRIVER_VEHICLE              = @"driverVehicle";
static NSString * const COLUMN_LEAD_PASSENGER_GENDER       = @"leadPassengerGender";
static NSString * const COLUMN_LEAD_PASSENGER_GENDER_CD    = @"leadPassengerGenderCd";
static NSString * const COLUMN_NUMBER_OF_PASSENGER         = @"numberOfPassenger";
static NSString * const COLUMN_PAYMENT_MODE                = @"paymentMode";
static NSString * const COLUMN_PAYMENT_MODE_CD             = @"paymentModeCd";
static NSString * const COLUMN_BOOKING_USER_NAME           = @"bookingUserName";
static NSString * const COLUMN_BOOKING_USER_MOBILE_NUMBER  = @"bookingUserMobileNumber";
static NSString * const COLUMN_BOOKING_USER_EMAIL          = @"bookingUserEmail";
static NSString * const COLUMN_BOOKING_USER_SURNAME        = @"bookingUserSurname";

static NSString * const COLUMN_ORG_EMAIL                   = @"orgEmail";
static NSString * const COLUMN_ASSIGN_ORG_ID               = @"assignOrgId";
static NSString * const COLUMN_ASSIGN_ORG_NAME             = @"assignOrgName";
static NSString * const COLUMN_ASSIGN_ORG_EMAIL            = @"assignOrgEmail";
static NSString * const COLUMN_ASSIGN_DRIVER_USER_ID       = @"assignDriverUserId";
static NSString * const COLUMN_ASSIGN_DRIVER_USER_NAME     = @"assignDriverUserName";
static NSString * const COLUMN_ASSIGN_DRIVER_MOBILE_PHONE  = @"assignDriverMobilePhone";
static NSString * const COLUMN_ASSIGN_DRIVER_EMAIL         = @"assignDriverEmail";

static NSString * const COLUMN_BOOKING_USER_GENDER         = @"bookingUserGender";
static NSString * const COLUMN_BOOKING_USER_GENDER_CD      = @"bookingUserGenderCd";
static NSString * const COLUMN_AGENT_USER_ID               = @"agentUserId";
static NSString * const COLUMN_AGENT_USER_NAME             = @"agentUserName";
static NSString * const COLUMN_AGENT_MOBILE_NUMBER         = @"agentMobileNumber";
static NSString * const COLUMN_AGENT_EMAIL                 = @"agentEmail";
static NSString * const COLUMN_OPERATOR_MOBILE_NUMBER      = @"operatorMobileNumber";
static NSString * const COLUMN_OPERATOR_EMAIL              = @"operatorEmail";

static NSString * const COLUMN_ORIGIN_URL          = @"originUrl";
static NSString * const COLUMN_TITLE               = @"title";
static NSString * const COLUMN_REMARK              = @"remark";
static NSString * const COLUMN_DESCRIPTION         = @"description";
static NSString * const COLUMN_TAG                 = @"tag";
static NSString * const COLUMN_DISPLAY_NO          = @"displayNo";
static NSString * const COLUMN_ROLE_IDS            = @"roleIds";
static NSString * const COLUMN_ORG_ID              = @"orgId";
static NSString * const COLUMN_ORG_NAME            = @"orgName";
static NSString * const COLUMN_OPERATOR_ID         = @"operatorId";
static NSString * const COLUMN_OPERATOR_NAME       = @"operatorName";
static NSString * const COLUMN_LANG                = @"lang";
static NSString * const COLUMN_CREATE_DATE_TIME    = @"createDateTime";
static NSString * const COLUMN_MODIFY_TIMESTAMP    = @"modifyTimestamp";
static NSString * const COLUMN_DATA_STATE          = @"dataState";
static NSString * const COLUMN_SEND_STATE          = @"sendState";
static NSString * const COLUMN_SEND_DATE_TIME      = @"sendDateTime";
static NSString * const COLUMN_RECIEVE_DATE_TIME   = @"recieveDateTime";
static NSString * const COLUMN_QUERY_FILTERS       = @"queryFilters";

typedef enum 
{
    ALL,
    UPCOMING,
    PAST
} BookingItemDate;

typedef NS_ENUM(NSInteger, Search)
{
    SearchALL = 0,
    SearchUPCOMING = 1,
    SearchPAST = 2
};


