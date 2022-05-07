package com.${comName}.${dbName}.model;

<%!
	# 检测表中是否有某个数据类型
	def filter(str,columns):
		result = False
		for item in columns:
			if item['pureFieldType'] == str:
				result = True
		return result
%>\
	% if filter("decimal",columns):
import java.math.BigDecimal;
import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.Digits;
	% endif
	% if filter('timestamp',columns) or filter('datetime',columns) or filter('date',columns) or filter('time',columns):
import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;
	% endif
	% if filter('int',columns):
import java.lang.Integer;
	% endif

import com.${comName}.commons.mode.BaseObject;
% for item in columns:
    % if item['commentEnum']:
import com.${comName}.commons.constant.${dbName}.${item['capFieldName']}Enum;
    % endif
% endfor
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotBlank;

/**
 * @author #{${author} ${phone}}
 */
@ApiModel("${tableComment}")
public class ${capTableName}Model extends BaseObject {
	

	//private static final long serialVersionUID = -7263368279485574826L;
	% for item in columns:
<%
	name = item['fieldName']
	type = item['pureFieldType']
	javaType = item['javaType']
	blank = item['blank']
	comment = item['fieldComment']
%>\
	@ApiModelProperty(value = "${comment}")
		% if not blank and name != primary['fieldName']:
	@NotBlank(message="${comment.split(':')[0]}不能为空")
		% endif
		% if 'max' in item:
	@Length(max = ${item['max']}, message = "${item['commentName']}长度不能超过${item['max']}")
		% elif type == "decimal":
	@DecimalMin("0")
	@Digits(integer = ${item['max']},fraction = ${item['pointMax']},message = "整数位上限为${item['max']}位，小数位上限为${item['pointMax']}位")
		% elif type == "timestamp" or type == "datetime" or type == "date" or type == "time":
	@DateTimeFormat(iso=ISO.DATE)
		% endif
	private ${javaType} ${name};
	    % if item['commentEnum']:
	private String ${name}Cn;
	    % endif
	% endfor
	
	% for item in columns:
<%
	name = item['fieldName']
	capName = item['capFieldName']
	javaType = item['javaType']
%>\

	public ${javaType} get${capName}() {
		return ${name};
	}

	public void set${capName}(${javaType} ${name}) {
		this.${name} = ${name};
	}

	% if item['commentEnum']:
	public String get${capName}Cn() {
		return ${capName}Enum.getDesc(${name});
	}

	public void set${capName}Cn(String ${name}Cn) {
		this.${name}Cn = ${name}Cn;
	}
	% endif
	% endfor
}
