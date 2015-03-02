//
//  DBManager.m
//  JOne
//
//  Created by Johnny on 31/10/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>
#import "JpDataUtil.h"

static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

//Database
+ (DBManager*)getSharedInstance
{
    static DBManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    });
    
    return sharedInstance;
}

- (BOOL)createDB
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = dirPaths[0];
    
    // Build the path to the database file
    dbPath = [[NSString alloc] initWithString: [docDirPath stringByAppendingPathComponent: DB_NAME]];
    BOOL isSuccess = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: dbPath] && ![DB_VERSION isEqualToString:[JpDataUtil getValueFromUDByKey:KEY_DB_VERSION_OBSD]]) {
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:dbPath]) {
            NSError *error;
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:dbPath error:&error];
            if (!success) {
                NSLog(@"Error removing database file at path: %@", error.localizedDescription);
            }
        }
    }
    
    if ([fileManager fileExistsAtPath: dbPath ] == NO)
    {
        const char *dbPathUTF8 = [dbPath UTF8String];
        if (sqlite3_open(dbPathUTF8, &database) == SQLITE_OK)
        {
            //id INTEGER primary key autoincrement, NULL, INTEGER, REAL, TEXT, BLOB.
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ text primary key, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ INTEGER, %@ TEXT)", TABLE_BM_CONFIG, COLUMN_CONFIG_ID, COLUMN_CONFIG_CD, COLUMN_CONFIG_NAME, COLUMN_CONFIG_VALUE, COLUMN_DESCRIPTION, COLUMN_LANG, COLUMN_CREATE_DATE_TIME, COLUMN_MODIFY_TIMESTAMP, COLUMN_DATA_STATE];
            char *errMsg;
            if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) isSuccess = NO;
            
            sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ text primary key, %@ TEXT, %@ INTEGER,%@ TEXT,%@ INTEGER,%@ TEXT,%@ TEXT,%@ REAL,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ REAL,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ REAL,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER,%@ TEXT)", TABLE_OBM_BOOKING_VEHICLE_ITEM,COLUMN_BOOKING_VEHICLE_ITEM_ID,COLUMN_BOOKING_NUMBER,COLUMN_PICKUP_DATE,COLUMN_PICKUP_TIME,COLUMN_PICKUP_DATE_TIME,COLUMN_BOOKING_SERVICE,COLUMN_BOOKING_SERVICE_CD,COLUMN_BOOKING_HOURS,COLUMN_FLIGHT_NUMBER,COLUMN_PICKUP_ADDRESS,COLUMN_DESTINATION,COLUMN_STOP1_ADDRESS,COLUMN_STOP2_ADDRESS,COLUMN_REMARK,COLUMN_VEHICLE,COLUMN_PRICE_UNIT,COLUMN_PRICE,COLUMN_PAYMENT_STATUS,COLUMN_PAYMENT_MODE,COLUMN_BOOKING_STATUS,COLUMN_BOOKING_STATUS_CD,COLUMN_BOOKING_USER_FIRST_NAME,COLUMN_BOOKING_USER_LAST_NAME,COLUMN_BOOKING_USER_GENDER,COLUMN_BOOKING_USER_MOBILE_NUMBER,COLUMN_BOOKING_USER_EMAIL,COLUMN_LEAD_PASSENGER_FIRST_NAME,COLUMN_LEAD_PASSENGER_LAST_NAME,COLUMN_LEAD_PASSENGER_GENDER,COLUMN_LEAD_PASSENGER_MOBILE_NUMBER,COLUMN_LEAD_PASSENGER_EMAIL,COLUMN_NUMBER_OF_PASSENGER,COLUMN_DRIVER_USER_NAME,COLUMN_DRIVER_LOGIN_USER_ID,COLUMN_DRIVER_MOBILE_NUMBER,COLUMN_DRIVER_VEHICLE,COLUMN_DRIVER_CLAIM_CURRENCY,COLUMN_DRIVER_CLAIM_PRICE,COLUMN_DRIVER_ACTION,COLUMN_ASSIGN_DRIVER_USER_ID,COLUMN_ASSIGN_DRIVER_USER_NAME,COLUMN_HISTORTY_DRIVER_USER_IDS,COLUMN_BROADCAST_TAG,COLUMN_CREATE_DATE_TIME,COLUMN_MODIFY_TIMESTAMP,COLUMN_DATA_STATE];
            
            
            if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) isSuccess = NO;
            
            if (!isSuccess) NSLog(@"Failed to create table : %s", errMsg);
            sqlite3_close(database);
            [JpDataUtil saveDataToUDForKey:KEY_DB_VERSION_OBSD value:DB_VERSION];
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL)insertOrUpdateOneRecord:(NSString*)aTableName pkColumnName:(NSString*)aPkColumnName columnValueDic:(NSMutableDictionary*)aColumnValueDic
{
    NSString *pk = [aColumnValueDic objectForKey:aPkColumnName];
    [self deleteOneRecord:aTableName pkColumnName:aPkColumnName pkValue:pk];
    return [self insertOneRecord:aTableName columnValueDic:aColumnValueDic];
}

- (BOOL)insertOneRecord:(NSString*)tableName columnValueDic:(NSMutableDictionary*)columnValueDic
{
    const char *dbPathUTF8 = [dbPath UTF8String];
    if (sqlite3_open(dbPathUTF8, &database) == SQLITE_OK)
    {
        NSArray *columns = [columnValueDic allKeys];
        NSMutableArray *values = [NSMutableArray array];
        [columns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *value = [NSString stringWithFormat:@"'%@'" ,[columnValueDic objectForKey:obj] ];
            [values addObject:value];
        }];
        
        NSString *sql = [NSString stringWithFormat: @"INSERT INTO '%@' (%@) VALUES (%@)", tableName, [columns componentsJoinedByString:@","], [values componentsJoinedByString:@","]];
        NSLog(@"Insert record into table sql : %@",sql);
        
        const char *sqlUTF8 = [sql UTF8String];
        if (sqlite3_prepare_v2(database, sqlUTF8, -1, &statement, nil) == SQLITE_OK)
        {
            int i=1;
            for ( NSString *column in columns) {
                NSString *value = [columnValueDic objectForKey:column];
                if ([column isEqual:COLUMN_PICKUP_DATE] || [column isEqual:COLUMN_PICKUP_DATE_TIME] || [column isEqual:COLUMN_BOOKING_HOURS] || [column isEqual:COLUMN_PRICE] || [column isEqual:COLUMN_DRIVER_CLAIM_PRICE] || [column isEqual:COLUMN_CREATE_DATE_TIME] || [column isEqual:COLUMN_MODIFY_TIMESTAMP]) {
                    if ([value isKindOfClass:[NSNull class]]) {
                        value = @"0";
                    }
                    sqlite3_bind_int64(statement, i, [value longLongValue]);
                } else {
                    if ([value isKindOfClass:[NSNull class]]) {
                        value = @"";
                    }
                    sqlite3_bind_text(statement, i, [value UTF8String], -1, NULL);
                }
                
                i++;
            }
        }
        if (sqlite3_step(statement) != SQLITE_DONE)
            NSLog(@"insertRecordIntoTable Error insert table with Error: %s", sqlite3_errmsg(database));
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return YES;
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"DB failed to create with Error: %s", sqlite3_errmsg(database));
    }
    return NO;
}

- (void)updateOneRecord:(NSString*)tableName pkColumnName:(NSString*)aPkColumnName pkValue:(NSString*)aPkValue updateColumnName:(NSString*)aUpdateColumnName updateValue:(NSString*)aUpdateValue
{
    const char *dbPathUTF8 = [dbPath UTF8String];
    if (sqlite3_open(dbPathUTF8, &database) != SQLITE_OK )
    {
        sqlite3_close(database);
        NSAssert1(0, @"DB failed to create with Error: %s", sqlite3_errmsg(database));
    }
    else
    {
        NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = '%@' where %@ = '%@'", tableName, aUpdateColumnName, aUpdateValue, aPkColumnName, aPkValue];
        NSLog(@"Update One Record SQL= %@", sql);
        const char *sqlUTF8 = [sql UTF8String];
        
        sqlite3_prepare_v2(database, sqlUTF8, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Update one record successfully");
        } else {
            NSLog(@"Update one record failed");
        }

        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
}

- (void)deleteRecords:(NSString *)aTableName
{
    const char *dbPathUTF8 = [dbPath UTF8String];
    if (sqlite3_open(dbPathUTF8, &database) != SQLITE_OK )
    {
        sqlite3_close(database);
        NSAssert1(0, @"DB failed to create with Error: %s", sqlite3_errmsg(database));
    }
    else
    {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ ", aTableName];
        const char *sqlUTF8 = [sql UTF8String];
        
        char *errMsg=nil;
        if(sqlite3_exec(database, sqlUTF8, NULL, NULL, &errMsg)==SQLITE_OK)
        {
            NSLog(@"Delete table %@. %s", aTableName, errMsg);
        }
    
        sqlite3_close(database);
    }
}

- (void)deleteOneRecord:(NSString*)aTableName pkColumnName:(NSString*)aPkColumnName pkValue:(NSString*)aPkValue
{
    const char *dbPathUTF8 = [dbPath UTF8String];
    if (sqlite3_open(dbPathUTF8, &database) != SQLITE_OK )
    {
        sqlite3_close(database);
        NSAssert1(0, @"DB failed to create with Error: %s", sqlite3_errmsg(database));
    }
    else
    {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", aTableName, aPkColumnName, aPkValue];
        const char *sqlUTF8 = [sql UTF8String];
        NSLog(@"deleteOneRecord %@", sql);
        
        sqlite3_prepare_v2(database, sqlUTF8, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Delete one record successfully");
        } else {
            NSLog(@"Delete one record failed");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
}

- (void)exeSql:(NSString*)aSql
{
    const char *dbPathUTF8 = [dbPath UTF8String];
    if (sqlite3_open(dbPathUTF8, &database) != SQLITE_OK )
    {
        sqlite3_close(database);
        NSAssert1(0, @"DB failed to create with Error: %s", sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"SQL= %@", aSql);
        const char *sqlUTF8 = [aSql UTF8String];
        
        sqlite3_prepare_v2(database, sqlUTF8, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Successfully");
        } else {
            NSLog(@"Failed");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
}

- (NSMutableArray*)getCmConfigs
{
    const char *dbPathUTF8 = [dbPath UTF8String];
    if (sqlite3_open(dbPathUTF8, &database) != SQLITE_OK )
    {
        sqlite3_close(database);
        NSAssert1(0, @"DB failed to create with Error: %s", sqlite3_errmsg(database));
        return Nil;
    }
    else
    {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ ", TABLE_BM_CONFIG];
        const char *sqlUTF8 = [sql UTF8String];
        
        NSMutableArray *cmConfigs = [[NSMutableArray alloc] init];
        if (sqlite3_prepare_v2(database, sqlUTF8, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] forKey:COLUMN_CONFIG_ID];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)] forKey:COLUMN_CONFIG_CD];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)] forKey:COLUMN_CONFIG_NAME];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)] forKey:COLUMN_CONFIG_VALUE];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)] forKey:COLUMN_DESCRIPTION];
                 [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)] forKey:COLUMN_LANG];
                 [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)] forKey:COLUMN_CREATE_DATE_TIME];
                 [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)] forKey:COLUMN_MODIFY_TIMESTAMP];
                 [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)] forKey:COLUMN_DATA_STATE];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
        if ([cmConfigs count] > 0) {
            return cmConfigs;
        } else {
            return Nil;
        }
    }
}

- (NSMutableDictionary*)getCmConfigByConfigCd:configCd withLang:aLang
{
    const char *dbPathUTF8 = [dbPath UTF8String];
    if (sqlite3_open(dbPathUTF8, &database) != SQLITE_OK )
    {
        sqlite3_close(database);
        NSAssert1(0, @"DB failed to create with Error: %s", sqlite3_errmsg(database));
        return Nil;
    }
    else
    {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ = '%@'", TABLE_BM_CONFIG, COLUMN_CONFIG_CD, configCd,COLUMN_LANG, aLang];
        const char *sqlUTF8 = [sql UTF8String];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (sqlite3_prepare_v2(database, sqlUTF8, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)] forKey:COLUMN_CONFIG_CD];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)] forKey:COLUMN_CONFIG_NAME];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)] forKey:COLUMN_CONFIG_VALUE];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)] forKey:COLUMN_DESCRIPTION];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
        return dic;
    }
}

- (NSMutableArray*)getObmBookingVehicleItemWithDriverUserId:(NSString *)aDriverUserId search:(Search)search
{
    const char *dbPathUTF8 = [dbPath UTF8String];
    if (sqlite3_open(dbPathUTF8, &database) != SQLITE_OK )
    {
        sqlite3_close(database);
        NSAssert1(0, @"DB failed to create with Error: %s", sqlite3_errmsg(database));
        return Nil;
    }
    else
    {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ ", TABLE_OBM_BOOKING_VEHICLE_ITEM];
        if ([aDriverUserId length] > 0) {
            sql = [sql stringByAppendingString:[NSString stringWithFormat:@" where (%@ = '%@' or %@ = '%@') ", COLUMN_DRIVER_LOGIN_USER_ID, aDriverUserId, COLUMN_ASSIGN_DRIVER_USER_ID, aDriverUserId]];
        }
        
        unsigned long long curDateTimeMillisecond = ([[NSDate date] timeIntervalSince1970] * 1000);
        switch(search) {
            case UPCOMING:
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and %@ >= %llu order by %@ asc,%@ asc ", COLUMN_PICKUP_DATE_TIME, curDateTimeMillisecond, COLUMN_PICKUP_DATE, COLUMN_PICKUP_TIME]];
                break;
            case PAST:
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and %@ < %llu order by %@ desc,%@ asc ", COLUMN_PICKUP_DATE_TIME, curDateTimeMillisecond, COLUMN_PICKUP_DATE, COLUMN_PICKUP_TIME]];
                break;
            case BROADCAST:
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and %@ = '%@' order by %@ asc,%@ asc ", COLUMN_BROADCAST_TAG, @"yes", COLUMN_PICKUP_DATE, COLUMN_PICKUP_TIME]];
                break;
            default:
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@" order by %@ desc,%@ asc ", COLUMN_PICKUP_DATE, COLUMN_PICKUP_TIME]];
        }
        const char *sqlUTF8 = [sql UTF8String];
        
        NSMutableArray *obmBookingVehicleItems = [[NSMutableArray alloc] init];
        if (sqlite3_prepare_v2(database, sqlUTF8, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] forKey:COLUMN_BOOKING_VEHICLE_ITEM_ID];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)] forKey:COLUMN_BOOKING_NUMBER];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)] forKey:COLUMN_PICKUP_DATE];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)] forKey:COLUMN_PICKUP_TIME];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)] forKey:COLUMN_PICKUP_DATE_TIME];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)] forKey:COLUMN_BOOKING_SERVICE];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)] forKey:COLUMN_BOOKING_SERVICE_CD];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)] forKey:COLUMN_BOOKING_HOURS];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)] forKey:COLUMN_FLIGHT_NUMBER];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)] forKey:COLUMN_PICKUP_ADDRESS];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)] forKey:COLUMN_DESTINATION];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)] forKey:COLUMN_STOP1_ADDRESS];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)] forKey:COLUMN_STOP2_ADDRESS];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)] forKey:COLUMN_REMARK];
                
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)] forKey:COLUMN_VEHICLE];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)] forKey:COLUMN_PRICE_UNIT];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)] forKey:COLUMN_PRICE];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)] forKey:COLUMN_PAYMENT_STATUS];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)] forKey:COLUMN_PAYMENT_MODE];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)] forKey:COLUMN_BOOKING_STATUS];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 20)] forKey:COLUMN_BOOKING_STATUS_CD];
                
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 21)] forKey:COLUMN_BOOKING_USER_FIRST_NAME];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 22)] forKey:COLUMN_BOOKING_USER_LAST_NAME];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 23)] forKey:COLUMN_BOOKING_USER_GENDER];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 24)] forKey:COLUMN_BOOKING_USER_MOBILE_NUMBER];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 25)] forKey:COLUMN_BOOKING_USER_EMAIL];
                
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 26)] forKey:COLUMN_LEAD_PASSENGER_FIRST_NAME];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 27)] forKey:COLUMN_LEAD_PASSENGER_LAST_NAME];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 28)] forKey:COLUMN_LEAD_PASSENGER_GENDER];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 29)] forKey:COLUMN_LEAD_PASSENGER_MOBILE_NUMBER];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 30)] forKey:COLUMN_LEAD_PASSENGER_EMAIL];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 31)] forKey:COLUMN_NUMBER_OF_PASSENGER];
                
                
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 32)] forKey:COLUMN_DRIVER_USER_NAME];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 33)] forKey:COLUMN_DRIVER_LOGIN_USER_ID];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 34)] forKey:COLUMN_DRIVER_MOBILE_NUMBER];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 35)] forKey:COLUMN_DRIVER_VEHICLE];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 36)] forKey:COLUMN_DRIVER_CLAIM_CURRENCY];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 37)] forKey:COLUMN_DRIVER_CLAIM_PRICE];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 38)] forKey:COLUMN_DRIVER_ACTION];
                
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 39)] forKey:COLUMN_ASSIGN_DRIVER_USER_ID];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 40)] forKey:COLUMN_ASSIGN_DRIVER_USER_NAME];
                
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 41)] forKey:COLUMN_HISTORTY_DRIVER_USER_IDS];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 42)] forKey:COLUMN_BROADCAST_TAG];
                
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 43)] forKey:COLUMN_CREATE_DATE_TIME];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 44)] forKey:COLUMN_MODIFY_TIMESTAMP];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 45)] forKey:COLUMN_DATA_STATE];
            
                [obmBookingVehicleItems addObject:dic];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
        if ([obmBookingVehicleItems count] > 0) {
            return obmBookingVehicleItems;
        } else {
            return Nil;
        }
    }
}


@end
