package com.${comName}.${dbName}.enum;

/**
 * 测试枚举
 */
public enum ${columns['capFieldName']}Enum {
    % for i in range(len(columns['commentEnum'])):
<%
    commentEnum = columns['commentEnum'][i]
%>\
    ${columns['fieldName'].upper()}_${commentEnum['value']}("${commentEnum['value']}","${commentEnum['label']}")${';' if i == len(columns['commentEnum']) - 1 else ','}
    % endfor

    private String code;
    private String desc;

    private ${columns['capFieldName']}Enum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    public static String getDesc(String code) {
        String desc = "";
        for (${columns['capFieldName']}Enum bn : values()) {
            if (bn.getCode().equals(code)) {
                desc = bn.desc;
                break;
            }
        }
        return desc;
    }


}
