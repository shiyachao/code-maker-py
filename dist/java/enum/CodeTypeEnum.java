package com.ec.oas.enum;

/**
 * 测试枚举
 */
public enum CodeTypeEnum {
    CODETYPE_00("00","人员类别");

    private String code;
    private String desc;

    private CodeTypeEnum(String code, String desc) {
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
        for (CodeTypeEnum bn : values()) {
            if (bn.getCode().equals(code)) {
                desc = bn.desc;
                break;
            }
        }
        return desc;
    }


}
