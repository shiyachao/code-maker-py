# -*- coding: UTF-8 -*-

import MySQLdb
import MySQLdb.cursors
from util import columnFormat, fieldTypeToJavaType, strQ2B, bracketsToArr, pureTypeToJdbcType, fieldTypeToTsType


# 获取数据库表结构
def tc(**arg):
    try:
        db = MySQLdb.connect(arg['url'], arg['user'], arg['pwd'], arg['dbName'], port=int(arg['port']), charset='utf8',
                             cursorclass=MySQLdb.cursors.DictCursor)
    except Exception as err:
        print(err)
        raise Exception("error")
    cursor = db.cursor()
    # 获取表结构
    sql = '''SELECT
    t.COLUMN_NAME AS fieldName,
    (
    CASE
    WHEN t.IS_NULLABLE = 'YES' THEN
    True
    ELSE
    False
    END
    ) AS blank,
    t.COLUMN_COMMENT AS fieldComment,
    t.COLUMN_TYPE AS fieldType,
    (
    CASE
    WHEN t.COLUMN_KEY = 'PRI' THEN
    True
    ELSE
    False
    END
    ) AS isPri
    FROM
    information_schema.`COLUMNS` t
    WHERE
    t.TABLE_SCHEMA = (SELECT DATABASE())
    AND t.TABLE_NAME = '%s'
    ''' % arg['tableName']
    cursor.execute(sql)
    result = cursor.fetchall()
    for item in result:
        # 数据库字段名，带下划线
        item['dbFieldName'] = item['fieldName']
        # 根据数据库字段生成首字母小写字段名
        item['fieldName'] = columnFormat(item['dbFieldName'])
        # 根据数据库字段生成首字母大写字段名（方便模板使用）
        item['capFieldName'] = columnFormat(item['dbFieldName'], True)
        # 添加javaType
        item['javaType'] = fieldTypeToJavaType(item['fieldType'])
        # 添加tsType
        item['tsType'] = fieldTypeToTsType(item['fieldType'])
        # 枚举字段处理
        comment = strQ2B(item['fieldComment'])
        commentArr = comment.split(":")
        item['commentName'] = commentArr[0]
        if len(commentArr) > 1:
            commentJsonArr = []
            for word in commentArr[1].split(";"):
                if word:
                    wordArr = word.split(",")
                    if len(wordArr) > 1:
                        commentJsonArr.append({
                            "value": wordArr[0],
                            "label": wordArr[1]
                        })
            item['commentEnum'] = commentJsonArr
        else:
            item['commentEnum'] = []
        # 字段长度处理
        item['pureFieldType'] = item['fieldType'].split('(')[0]  # 纯净字段类型，去掉括号，mybatis xml使用
        fieldTypeBracketsArr = bracketsToArr(item['fieldType'])
        if len(fieldTypeBracketsArr) > 0:
            item['max'] = fieldTypeBracketsArr[0]
            if len(fieldTypeBracketsArr) > 1:
                item['pointMax'] = fieldTypeBracketsArr[1]
        # jdbcType
        item['jdbcType'] = pureTypeToJdbcType(item['pureFieldType'])
    db.close()
    return result


def tl(tableName="", **arg):
    try:
        db = MySQLdb.connect(arg['url'], arg['user'], arg['pwd'], arg['dbName'], port=int(arg['port']), charset='utf8',
                             cursorclass=MySQLdb.cursors.DictCursor)
    except Exception as err:
        print(err)
        raise Exception("error")
    cursor = db.cursor()
    # 获取数据库表列表
    sql = f'''
        SELECT
        table_name AS tableName,
        table_comment AS tableComment
        FROM
        INFORMATION_SCHEMA. TABLES
        WHERE
        table_schema = "%s"
        ''' % arg['dbName']
    if tableName:
        sql += 'AND table_name = "{tName}";'.format(tName=tableName)
    # else:
    #     sql += "AND table_name LIKE 't_%';"
    cursor.execute(sql)
    result = cursor.fetchall()
    db.close()
    return result
