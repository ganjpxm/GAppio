//
//  DBManager.h
//  JOne
//
//  Created by Johnny on 31/10/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

@interface DBManager : NSObject
{
    NSString *dbPath;
}

+ (DBManager*)getSharedInstance;
- (BOOL)createDB;
- (BOOL)insertOneRecord:(NSString*)tableName columnValueDic:(NSMutableDictionary*)columnValueDic;
- (BOOL)insertOrUpdateOneRecord:(NSString*)aTableName pkColumnName:(NSString*)aPkColumnName columnValueDic:(NSMutableDictionary*)aColumnValueDic;
- (void)updateOneRecord:(NSString*)tableName pkColumnName:(NSString*)aPkColumnName pkValue:(NSString*)aPkValue updateColumnName:(NSString*)aUpdateColumnName updateValue:(NSString*)aUpdateValue;

- (void)deleteRecords:(NSString *)aTableName;
- (void)deleteOneRecord:(NSString*)aTableName pkColumnName:(NSString*)aPkColumnName pkValue:(NSString*)aPkValue;

- (void)exeSql:(NSString*)aSql;

- (NSMutableArray*)getCmConfigs;
- (NSMutableDictionary*)getCmConfigByConfigCd:configCd withLang:aLang;
- (NSMutableArray*)getObmBookingVehicleItemWithDriverUserId:(NSString *)aDriverUserId search:(Search)search;

@end
