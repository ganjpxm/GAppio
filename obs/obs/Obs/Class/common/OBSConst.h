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


static NSString * const URL_HOST                   = @"http://119.9.74.121/";
static NSString * const URL_REACHABILITY           = @"http://1.lt.sg";
//static NSString * const URL_HOST                   = @"http://192.168.1.4:8080/obs/";
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
static NSInteger const MAP_ROUTE_STOP1 = 6;
static NSInteger const MAP_ROUTE_STOP2 = 7;

//GOOGLE ANALYTICS
static NSString * const GOOGLE_ANALYTICS_TRACKING_ID = @"UA-49817046-1";
static BOOL const GOOGLE_ANALYTICS_OPT_OUT = NO;
static NSString * const SCREEN_LOGIN = @"Login";
static NSString * const SCREEN_BOOKING_UPCONMING = @"Upcoming booking";
static NSString * const SCREEN_BOOKING_BROADCAST = @"Broadcast";
static NSString * const SCREEN_BOOKING_DETAIL = @"Booking detail";
static NSString * const SCREEN_BOOKING_PAST = @"Pasting Booking";
static NSString * const SCREEN_PROFILE = @"Profile";
static NSString * const SCREEN_MORE = @"More";
static NSString * const SCREEN_CHECK_LIST = @"Check List";
static NSString * const SCREEN_PRODUCT_INFO = @"Product Info";

static NSString * const KEY_OBS                   = @"OBS";
static NSString * const KEY_NETWORK_STATUS    = @"ObsNetworkState";
static NSString * const KEY_DB_VERSION_OBSD        = @"OBSCDbVersion";
static NSString * const KEY_USER_CD                = @"ObsUserCd";
static NSString * const KEY_PASSWORD_OBSD          = @"ObsPassword";
static NSString * const KEY_OBS_USER_ID            = @"ObsUserId";
static NSString * const KEY_USER_NAME              = @"ObsUserName";
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
static NSString * const KEY_LOGIN_USER_CD_OR_EMAIL_OR_MOBILE_NUMBER = @"userCdOrEmailOrMobileNumber";
static NSString * const KEY_LOGIN_USER_PASSWORD    = @"userPassword";
static NSString * const KEY_USER_ID                = @"userId";
static NSString * const KEY_BOOKING_VEHICLE_ITEM_ID = @"bookingVehicleItemId";
static NSString * const KEY_ACTION                  = @"action";

static NSString * const KEY_UDID_OBS              = @"ObsUDID";
static NSString * const KEY_DEVICE_TOKEN_OBS      = @"ObsDeviceToken";
static NSString * const KEY_IS_REGIST_DEVICE_OBS = @"ObsIsRegistDevice";

static NSString * const KEY_RESULT                 = @"result";
static NSString * const KEY_DATA                   = @"data";
static NSString * const KEY_START_DATE             = @"startDate";
static NSString * const KEY_BROADCAST_BOOKING_VEHICLE_ITEM_IDS = @"broadcastBookingVehicleItemIds";
static NSString * const KEY_IS_SHOW_BROADCAST      = @"isShowBroadcast";

static NSString * const VALUE_SUCCESS               = @"success";
static NSString * const VALUE_FAIL                 = @"fail";
static NSString * const VALUE_NEW_ITEMS            = @"New Items";
static NSString * const VALUE_YES                  = @"YES";
static NSString * const VALUE_NO                   = @"NO";
static NSString * const VALUE_ACCEPTED             = @"accepted";

static NSString * const VALUE_BOOKING_SERVICE_CD_ARRIVAL    = @"0101";
static NSString * const VALUE_BOOKING_SERVICE_CD_DEPARTURE  = @"0102";
static NSString * const VALUE_BOOKING_SERVICE_CD_POINT_TO_POINT = @"0103";
static NSString * const VALUE_BOOKING_SERVICE_CD_HOURLY     = @"0104";
static NSString * const VALUE_BOOKING_STATUS_CD_PENDING     = @"0800";
static NSString * const VALUE_BOOKING_STATUS_CD_PROCESSING  = @"0801";
static NSString * const VALUE_BOOKING_STATUS_CD_CONFIRMED   = @"0802";
static NSString * const VALUE_BOOKING_STATUS_CD_ASSIGNED    = @"0803";
static NSString * const VALUE_BOOKING_STATUS_CD_DRIVER_INFO_SNET = @"0804";
static NSString * const VALUE_BOOKING_STATUS_CD_UPDATE      = @"0805";
static NSString * const VALUE_BOOKING_STATUS_CD_REFUND      = @"0807";
static NSString * const VALUE_BOOKING_STATUS_CD_UNSUCCESSFUL= @"0808";
static NSString * const VALUE_BOOKING_STATUS_CD_CANCELLED   = @"0809";
static NSString * const VALUE_BOOKING_STATUS_CD_MISSED      = @"0810";
static NSString * const VALUE_BOOKING_STATUS_CD_COMPLETED   = @"0811";
static NSString * const VALUE_BOOKING_STATUS_CD_ENQUIREY    = @"0821";

static NSString * const DB_VERSION                 = @"1.0";
static NSString * const DB_NAME                    = @"obsc.sqlite";
static NSString * const TABLE_BM_CONFIG            = @"bm_config";
static NSString * const COLUMN_CONFIG_ID           = @"configId";
static NSString * const COLUMN_CONFIG_CD           = @"configCd";
static NSString * const COLUMN_CONFIG_NAME         = @"configName";
static NSString * const COLUMN_CONFIG_VALUE        = @"configValue";

static NSString * const TABLE_OBM_BOOKING_VEHICLE_ITEM      = @"ObmBookingVehicleItem";
static NSString * const COLUMN_BOOKING_VEHICLE_ITEM_ID      = @"bookingVehicleItemId";
static NSString * const COLUMN_BOOKING_NUMBER               = @"bookingNumber";
static NSString * const COLUMN_PICKUP_DATE                  = @"pickupDate";
static NSString * const COLUMN_PICKUP_TIME                  = @"pickupTime";
static NSString * const COLUMN_PICKUP_DATE_TIME             = @"pickupDateTime";
static NSString * const COLUMN_BOOKING_SERVICE              = @"bookingService";
static NSString * const COLUMN_BOOKING_SERVICE_CD           = @"bookingServiceCd";
static NSString * const COLUMN_BOOKING_HOURS                = @"bookingHours";
static NSString * const COLUMN_FLIGHT_NUMBER                = @"flightNumber";
static NSString * const COLUMN_PICKUP_ADDRESS               = @"pickupAddress";
static NSString * const COLUMN_DESTINATION                  = @"destination";
static NSString * const COLUMN_STOP1_ADDRESS                = @"stop1Address";
static NSString * const COLUMN_STOP2_ADDRESS                = @"stop2Address";
static NSString * const COLUMN_REMARK                       = @"remark";

static NSString * const COLUMN_VEHICLE                      = @"vehicle";
static NSString * const COLUMN_PRICE_UNIT                   = @"priceUnit";
static NSString * const COLUMN_PRICE                        = @"price";
static NSString * const COLUMN_PAYMENT_STATUS               = @"paymentStatus";
static NSString * const COLUMN_PAYMENT_MODE                 = @"paymentMode";
static NSString * const COLUMN_BOOKING_STATUS               = @"bookingStatus";
static NSString * const COLUMN_BOOKING_STATUS_CD            = @"bookingStatusCd";

static NSString * const COLUMN_BOOKING_USER_FIRST_NAME     = @"bookingUserFirstName";
static NSString * const COLUMN_BOOKING_USER_LAST_NAME      = @"bookingUserLastName";
static NSString * const COLUMN_BOOKING_USER_GENDER         = @"bookingUserGender";
static NSString * const COLUMN_BOOKING_USER_MOBILE_NUMBER  = @"bookingUserMobileNumber";
static NSString * const COLUMN_BOOKING_USER_EMAIL          = @"bookingUserEmail";

static NSString * const COLUMN_LEAD_PASSENGER_FIRST_NAME    = @"leadPassengerFirstName";
static NSString * const COLUMN_LEAD_PASSENGER_LAST_NAME     = @"leadPassengerLastName";
static NSString * const COLUMN_LEAD_PASSENGER_GENDER        = @"leadPassengerGender";
static NSString * const COLUMN_LEAD_PASSENGER_MOBILE_NUMBER = @"leadPassengerMobileNumber";
static NSString * const COLUMN_LEAD_PASSENGER_EMAIL         = @"leadPassengerEmail";
static NSString * const COLUMN_NUMBER_OF_PASSENGER          = @"numberOfPassenger";

static NSString * const COLUMN_DRIVER_USER_NAME            = @"driverUserName";
static NSString * const COLUMN_DRIVER_LOGIN_USER_ID        = @"driverLoginUserId";
static NSString * const COLUMN_DRIVER_MOBILE_NUMBER        = @"driverMobileNumber";
static NSString * const COLUMN_DRIVER_VEHICLE              = @"driverVehicle";
static NSString * const COLUMN_DRIVER_CLAIM_CURRENCY       = @"driverClaimCurrency";
static NSString * const COLUMN_DRIVER_CLAIM_PRICE          = @"driverClaimPrice";
static NSString * const COLUMN_DRIVER_ACTION               = @"driverAction";

static NSString * const COLUMN_ASSIGN_DRIVER_USER_ID       = @"assignDriverUserId";
static NSString * const COLUMN_ASSIGN_DRIVER_USER_NAME     = @"assignDriverUserName";

static NSString * const COLUMN_HISTORTY_DRIVER_USER_IDS    = @"historyDriverUserIds";
static NSString * const COLUMN_BROADCAST_TAG               = @"broadcastTag";

static NSString * const COLUMN_CREATE_DATE_TIME            = @"createDateTime";
static NSString * const COLUMN_MODIFY_TIMESTAMP            = @"modifyTimestamp";
static NSString * const COLUMN_DATA_STATE                  = @"dataState";

static NSString * const COLUMN_ORIGIN_URL          = @"originUrl";
static NSString * const COLUMN_TITLE               = @"title";
static NSString * const COLUMN_DESCRIPTION         = @"description";
static NSString * const COLUMN_TAG                 = @"tag";
static NSString * const COLUMN_DISPLAY_NO          = @"displayNo";
static NSString * const COLUMN_ROLE_IDS            = @"roleIds";
static NSString * const COLUMN_ORG_ID              = @"orgId";
static NSString * const COLUMN_ORG_NAME            = @"orgName";
static NSString * const COLUMN_OPERATOR_ID         = @"operatorId";
static NSString * const COLUMN_OPERATOR_NAME       = @"operatorName";
static NSString * const COLUMN_LANG                = @"lang";
static NSString * const COLUMN_SEND_STATE          = @"sendState";
static NSString * const COLUMN_SEND_DATE_TIME      = @"sendDateTime";
static NSString * const COLUMN_RECIEVE_DATE_TIME   = @"recieveDateTime";
static NSString * const COLUMN_QUERY_FILTERS       = @"queryFilters";

static NSString * const ACTION_ACCEPT_ENQUIRY_BOOKING = @"AcceptEnquiryBooking";
static NSString * const ACTION_REJECT_ENQUIRY_BOOKING = @"RejectEnquiryBooking";
static NSString * const ACTION_ACCEPT_NEW_BOOKING = @"AcceptNewBooking";
static NSString * const ACTION_REJECT_NEW_BOOKING = @"RejectNewBooking";
static NSString * const ACTION_ACCEPT_UPDATE_BOOKING = @"AcceptUpdateBooking";
static NSString * const ACTION_REJECT_UPDATE_BOOKING = @"RejectUpdateBooking";
static NSString * const ACTION_ACCEPT_CANCEL_BOOKING = @"AcceptCancelBooking";
static NSString * const ACTION_REJECT_CANCEL_BOOKING = @"RejectCancelBooking";

typedef enum
{
    ALL,
    UPCOMING,
    PAST,
    BROADCAST
} BookingItemDate;

typedef NS_ENUM(NSInteger, Search)
{
    SearchALL = 0,
    SearchUPCOMING = 1,
    SearchPAST = 2,
    SearchBROADCAST = 3,
};


