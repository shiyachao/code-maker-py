package com.ec.oas.model;

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

import com.ec.commons.mode.BaseObject;
import com.ec.commons.constant.oas.CodeTypeEnum;
import com.ec.commons.constant.oas.StatusEnum;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotBlank;

/**
 * @author #{syc 12345678912}
 */
@ApiModel("基础数据")
public class CodeMapModel extends BaseObject {
	

	//private static final long serialVersionUID = -7263368279485574826L;
	@ApiModelProperty(value = "基础数据主键")
	@Length(max = 36, message = "基础数据主键长度不能超过36")
	private String codeMapId;
	@ApiModelProperty(value = "基础数据名称")
	@NotBlank(message="基础数据名称不能为空")
	@Length(max = 20, message = "基础数据名称长度不能超过20")
	private String codeMapName;
	@ApiModelProperty(value = "基础数据类型：00，人员类别；")
	@NotBlank(message="基础数据类型：00，人员类别；不能为空")
	@Length(max = 2, message = "基础数据类型长度不能超过2")
	private String codeType;
	private String codeTypeCn;
	@ApiModelProperty(value = "状态：00，正常；99，停用；")
	@NotBlank(message="状态：00，正常；99，停用；不能为空")
	@Length(max = 2, message = "状态长度不能超过2")
	private String status;
	private String statusCn;
	@ApiModelProperty(value = "创建时间")
	@NotBlank(message="创建时间不能为空")
	@Length(max = 6, message = "创建时间长度不能超过6")
	private Date regTime;
	@ApiModelProperty(value = "更新时间")
	@NotBlank(message="更新时间不能为空")
	@Length(max = 6, message = "更新时间长度不能超过6")
	private Date updTime;
	

	public String getCodeMapId() {
		return codeMapId;
	}

	public void setCodeMapId(String codeMapId) {
		this.codeMapId = codeMapId;
	}


	public String getCodeMapName() {
		return codeMapName;
	}

	public void setCodeMapName(String codeMapName) {
		this.codeMapName = codeMapName;
	}


	public String getCodeType() {
		return codeType;
	}

	public void setCodeType(String codeType) {
		this.codeType = codeType;
	}

	public String getCodeTypeCn() {
		return CodeTypeEnum.getDesc(codeType);
	}

	public void setCodeTypeCn(String codeTypeCn) {
		this.codeTypeCn = codeTypeCn;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStatusCn() {
		return StatusEnum.getDesc(status);
	}

	public void setStatusCn(String statusCn) {
		this.statusCn = statusCn;
	}

	public Date getRegTime() {
		return regTime;
	}

	public void setRegTime(Date regTime) {
		this.regTime = regTime;
	}


	public Date getUpdTime() {
		return updTime;
	}

	public void setUpdTime(Date updTime) {
		this.updTime = updTime;
	}

}
