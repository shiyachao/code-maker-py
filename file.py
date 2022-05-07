from json import JSONDecodeError

from mako.lookup import TemplateLookup
import os
import mako.runtime
import json

mako.runtime.UNDEFINED = ''


def outfile(template, path, file, values):
    html_path = './'
    lookup = TemplateLookup(
        directories=[html_path],
        output_encoding='utf-8',
        input_encoding='utf-8',
        default_filters=['decode.utf8'],
        encoding_errors='replace',
        preprocessor=[lambda x: x.replace("\r\n", "\n")]
    )
    some_template = lookup.get_template("tm" + template)
    # bytes转化str
    info = str(some_template.render(**values), encoding="utf-8")
    # 替换换行符，避免换两行
    info = info.replace('\r\n', '\n')
    # 没有目录，先创建目录，再创建文件
    if not os.path.isdir(path):
        os.makedirs(path)
    file = open(path + file, "w", encoding="utf-8")
    file.write(info)
    file.close()
    return


def jsonFileWrite(path, obj):
    with open(path, 'w') as file_obj:
        json.dump(obj, file_obj)


def jsonFileRead(path):
    try:
        with open(path) as file_obj:
            obj = json.load(file_obj)
    except IOError:
        obj = {}
    except JSONDecodeError:
        obj = {}
    return obj
