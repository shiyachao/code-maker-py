package com.${comName}.${dbName}.controller;
<%
	primaryFieldName = primary['fieldName']
	primaryJavaType = primary['javaType']
%>\
import org.springframework.stereotype.Controller;
import com.${comName}.commons.command.ResultCommand;
import com.${comName}.commons.constant.base.HttpMethodTypeEnum;
import com.${comName}.commons.mode.BaseObject;
import com.${comName}.${dbName}.service.${capTableName}Service;
import com.${comName}.${dbName}.model.${capTableName}Model;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;
import com.github.pagehelper.Page;

import java.util.List;

@Api(value = "${tableComment}", tags = "${tableComment}")
@Controller
@RequestMapping("/${apiUrl}")
public class ${capTableName}Controller {
    Logger logger = LoggerFactory.getLogger(getClass());
    @Autowired
    private ${capTableName}Service ${tableName}Service;

    @ApiOperation(value = "删除${tableComment}", httpMethod = HttpMethodTypeEnum.DELETE)
    @DeleteMapping("/{${primaryFieldName}}")
    @ResponseBody
    public ResultCommand<BaseObject> deleteByPrimaryKey(@PathVariable ${primaryJavaType} ${primaryFieldName}) {
        logger.info("删除方法入参:{}", ${primaryFieldName});
        ResultCommand<BaseObject> resultCommand = new ResultCommand<>();
        int result = ${tableName}Service.deleteByPrimaryKey(${primaryFieldName});
        resultCommand.setMessage(result == 1 ? "删除成功" : "删除失败");
        resultCommand.setResult(result == 1 ? ResultCommand.SUCCESS : ResultCommand.FAILED);
        logger.info("删除方法出参:{}", result);
        return resultCommand;
    }

    @ApiOperation(value = "新增${tableComment}", httpMethod = HttpMethodTypeEnum.POST)
    @PostMapping
    @ResponseBody
    public ResultCommand<BaseObject> insertSelective(@Valid @RequestBody ${capTableName}Model record, BindingResult br) {
        logger.info("新增方法入参:{}", record);
        ResultCommand<BaseObject> resultCommand = new ResultCommand<>();
        if (br.hasErrors()) {
            resultCommand.setResult(ResultCommand.FAILED);
            resultCommand.setMessage(ValidatorMsgParser.getErrorMsg(br).toString());
            return resultCommand;
        }
        int result = ${tableName}Service.insertSelective(record);
        resultCommand.setMessage(result == 1 ? "新增成功" : "新增失败");
        resultCommand.setResult(result == 1 ? ResultCommand.SUCCESS : ResultCommand.FAILED);
        logger.info("新增方法出参:{}", result);
        return resultCommand;
    }

    @ApiOperation(value = "单条查询${tableComment}", httpMethod = HttpMethodTypeEnum.GET)
    @GetMapping("/single/{${primaryFieldName}}")
    @ResponseBody
    public ResultCommand<${capTableName}Model> selectByPrimaryKey(@PathVariable ${primaryJavaType} ${primaryFieldName}) {
        logger.info("单条查询方法入参:{}", ${primaryFieldName});
        ResultCommand<${capTableName}Model> resultCommand = new ResultCommand<>();
        ${capTableName}Model ${tableName}Model = ${tableName}Service.selectByPrimaryKey(${primaryFieldName});
        resultCommand.setMessage("查询成功");
        resultCommand.setResult(ResultCommand.SUCCESS);
        resultCommand.setResponseInfo(${tableName}Model);
        logger.info("单条查询方法出参:{}", ${tableName}Model);
        return resultCommand;
    }

    @ApiOperation(value = "修改${tableComment}", httpMethod = HttpMethodTypeEnum.PUT)
    @PutMapping
    @ResponseBody
    public ResultCommand<BaseObject> updateByPrimaryKeySelective(@Valid @RequestBody ${capTableName}Model record, BindingResult br) {
        logger.info("单条查询方法入参:{}", record);
        ResultCommand<BaseObject> resultCommand = new ResultCommand<>();
        if (br.hasErrors()) {
            resultCommand.setResult(ResultCommand.FAILED);
            resultCommand.setMessage(ValidatorMsgParser.getErrorMsg(br).toString());
            return resultCommand;
        }
        int result = ${tableName}Service.updateByPrimaryKeySelective(record);
        resultCommand.setMessage(result == 1 ? "修改成功" : "修改失败");
        resultCommand.setResult(result == 1 ? ResultCommand.SUCCESS : ResultCommand.FAILED);
        logger.info("单条查询方法出参:{}", result);
        return resultCommand;
    }

    @ApiOperation(value = "根据条件查询全部${tableComment}", httpMethod = HttpMethodTypeEnum.GET)
    @GetMapping("/all")
    @ResponseBody
    public ResultCommand<${capTableName}Model> selectAll(${capTableName}Model record) {
        logger.info("根据条件查询全部入参:{}", record);
        ResultCommand<${capTableName}Model> resultCommand = new ResultCommand<>();
        List<${capTableName}Model> ${tableName}Model = ${tableName}Service.selectAll(record);
        resultCommand.setMessage("查询成功");
        resultCommand.setResult(ResultCommand.SUCCESS);
        resultCommand.setResponseInfos(${tableName}Model);
        logger.info("根据条件查询全部出参:{}", ${tableName}Model);
        return resultCommand;
    }

    @ApiOperation(value = "根据条件分页查询${tableComment}", httpMethod = HttpMethodTypeEnum.GET)
    @GetMapping
    @ResponseBody
    public ResultCommand<${capTableName}Model> selectPageAll(${capTableName}Model record) {
        logger.info("根据条件分页查询全部入参:{}", record);
        ResultCommand<${capTableName}Model> resultCommand = new ResultCommand<>();
        Page<${capTableName}Model> ${tableName}Model = ${tableName}Service.selectPageAll(record);
        resultCommand.setTotalRows(${tableName}Model.getTotal());
        resultCommand.setMessage("查询成功");
        resultCommand.setResult(ResultCommand.SUCCESS);
        resultCommand.setResponseInfos(${tableName}Model.getResult());
        logger.info("根据条件分页查询全部出参:{}", ${tableName}Model);
        return resultCommand;
    }
}
