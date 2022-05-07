from file import outfile, jsonFileRead
from jdbc import tc
from util import tableNameFormat, tableNameFormatByCon


def makeFile(**arg):
    try:
        config = jsonFileRead("config/config.json")
        path = config['outPut']
        dbName = config['projectName'] or arg['dbName']
        tableName = arg['tableName']
        tableComment = arg['tableComment']
        # 获取表字段信息
        tableCol = tc(**arg)
        # 转化表名为驼峰格式
        tableNameReset = tableNameFormat(tableName)
        capTableNameReset = tableNameFormat(tableName, True)
        # 转化表名为符号连接格式，默认-
        tableNameByCon = tableNameFormatByCon(tableName)
        # 获取主键
        primary = {}
        for item in tableCol:
            if item['isPri'] == 1:
                primary = item
                break
        # 获取枚举
        enums = []
        for item in tableCol:
            if item['commentEnum']:
                enums.append(item)
        result = {
            # 数据库名，也是项目名，为了填充包名 例如 package com.ccicln.${dbName}.model
            'dbName': dbName,
            # 驼峰表名
            'tableName': tableNameReset,
            'capTableName': capTableNameReset,
            # -号连接表名
            'tableNameByCon': tableNameByCon,
            # 数据库表名
            'dbTableName': tableName,
            # 请求路径(默认驼峰表名)
            'apiUrl': arg['apiUrl'] if arg['apiUrl'] else tableNameByCon,
            # 公司名，也是包名 例如com.ccicln中的ccicln
            'comName': config['comName'],
            # 主键信息
            'primary': primary,
            # 表描述
            'tableComment': tableComment,
            # 是否有枚举字段
            'enums': enums,
            # 表字段数据
            'columns': tableCol,
            # 作者
            'author': config['author'],
            # 联系电话
            'phone': config['phone']
        }
        print(result)
        outfile("/index.vue.tm", "{path}/vue".format(path=path),
                "/{tableNameReset}.vue".format(tableNameReset=tableNameReset), result)
        outfile("/modal.vue.tm", "{path}/vue/module".format(path=path),
                "/add{capTableNameReset}.vue".format(capTableNameReset=capTableNameReset), result)
        outfile("/api.js.tm", "{path}/vue/api".format(path=path),
                "/{tableNameReset}.js".format(tableNameReset=tableNameReset), result)
        outfile("/Model.java.tm", "{path}/java/model".format(path=path),
                "/{capTableNameReset}Model.java".format(capTableNameReset=capTableNameReset), result)
        outfile("/Controller.java.tm", "{path}/java/controller".format(path=path),
                "/{capTableNameReset}Controller.java".format(capTableNameReset=capTableNameReset), result)
        outfile("/Service.java.tm", "{path}/java/service".format(path=path),
                "/{capTableNameReset}Service.java".format(capTableNameReset=capTableNameReset), result)
        outfile("/Mapper.java.tm", "{path}/java/mapper".format(path=path),
                "/{capTableNameReset}Mapper.java".format(capTableNameReset=capTableNameReset), result)
        outfile("/Mapper.xml.tm", "{path}/java/sqlmap".format(path=path),
                "/{capTableNameReset}Mapper.xml".format(capTableNameReset=capTableNameReset), result)
        outfile("/module.ts.tm", "{path}/nest".format(path=path),
                "/{tableNameByCon}.module.ts".format(tableNameByCon=tableNameByCon), result)
        outfile("/model.ts.tm", "{path}/nest".format(path=path),
                "/{tableNameByCon}.model.ts".format(tableNameByCon=tableNameByCon), result)
        outfile("/controller.ts.tm", "{path}/nest".format(path=path),
                "/{tableNameByCon}.controller.ts".format(tableNameByCon=tableNameByCon), result)
        outfile("/service.ts.tm", "{path}/nest".format(path=path),
                "/{tableNameByCon}.service.ts".format(tableNameByCon=tableNameByCon), result)
        for item in enums:
            enumObj = {
                **result,
                "columns": item
            }
            outfile("/Enum.java.tm", "{path}/java/enum".format(path=path),
                    "/{capFieldName}Enum.java".format(capFieldName=item['capFieldName']), enumObj)
    except Exception as err:
        print(err)
        raise Exception("error")
