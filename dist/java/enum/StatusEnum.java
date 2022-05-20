package com.ec.oas.enum;

/**
 * 测试枚举
 */
public enum StatusEnum {
    STATUS_00("00","正常"),
    STATUS_99("99","停用");

    private String code;
    private String desc;

    private StatusEnum(String code, String desc) {
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
        for (StatusEnum bn : values()) {
            if (bn.getCode().equals(code)) {
                desc = bn.desc;
                break;
            }
        }
        return desc;
    }


}
