import re


# 数据库字段转化驼峰写法 cap：是否首字母大写
def columnFormat(column, cap=False):
    arr = []
    columnArr = column.split('_')
    for index in range(len(columnArr)):
        if index == 0 and not cap:
            arr.append(columnArr[index])
        else:
            arr.append(columnArr[index].capitalize())
    return ''.join(arr)


# 数据库表名转化驼峰写法，并去掉前缀
def tableNameFormat(name, cap=False):
    arr = []
    nameArr = name.split('_')
    nameArr = nameArr[1:]
    for index in range(len(nameArr)):
        if index == 0 and not cap:
            arr.append(nameArr[index])
        else:
            arr.append(nameArr[index].capitalize())
    return ''.join(arr)

def tableNameFormatByCon(name, con='-'):
    arr = []
    nameArr = name.split('_')
    nameArr = nameArr[1:]
    for index in range(len(nameArr)):
        arr.append(nameArr[index])
    return con.join(arr)

# 数据库类型转化java类型
def fieldTypeToJavaType(colType):
    singleType = colType.split("(")[0]
    # 数据库类型与java类型对照字典
    typeObj = {
        "decimal": 'BigDecimal',
        "timestamp": 'Date',
        "datetime": 'Date',
        "date": 'Date',
        "time": 'Date',
        "int": 'Integer',
    }
    return typeObj.get(singleType, "String")


# 数据库类型转化java类型
def fieldTypeToTsType(colType):
    singleType = colType.split("(")[0]
    # 数据库类型与java类型对照字典
    typeObj = {
        "decimal": 'number',
        "timestamp": 'Date',
        "datetime": 'Date',
        "date": 'Date',
        "time": 'Date',
        "int": 'number',
    }
    return typeObj.get(singleType, "string")


# 数据库纯净类型转化jdbc类型
def pureTypeToJdbcType(pureType):
    typeObj = {
        "int": 'INTEGER',
        "longtext": 'VARCHAR',
    }
    if pureType in typeObj:
        return typeObj[pureType]
    else:
        return pureType.upper()


def strQ2B(ustring):
    """全角转半角"""
    restring = ""
    for uchar in ustring:
        inside_code = ord(uchar)
        if inside_code == 12288:  # 全角空格直接转换            
            inside_code = 32
        elif 65281 <= inside_code <= 65374:  # 全角字符（除空格）根据关系转化
            inside_code -= 65248

        restring += chr(inside_code)
    return restring


def strB2Q(ustring):
    """半角转全角"""
    restring = ""
    for uchar in ustring:
        inside_code = ord(uchar)
        if inside_code == 32:  # 半角空格直接转化                  
            inside_code = 12288
        elif 32 <= inside_code <= 126:  # 半角字符（除空格）根据关系转化
            inside_code += 65248

        restring += chr(inside_code)
    return restring


# 提取括号中内容
def bracketsToArr(fieldType):
    brackets = re.findall(r'[(](.*?)[)]', fieldType)
    return brackets[0].split(",") if len(brackets) > 0 else []


