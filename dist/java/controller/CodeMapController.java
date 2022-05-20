package com.ec.oas.controller;
import org.springframework.stereotype.Controller;
import com.ec.commons.command.ResultCommand;
import com.ec.commons.constant.base.HttpMethodTypeEnum;
import com.ec.commons.mode.BaseObject;
import com.ec.oas.service.CodeMapService;
import com.ec.oas.model.CodeMapModel;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;
import com.github.pagehelper.Page;

import java.util.List;

@Api(value = "基础数据", tags = "基础数据")
@Controller
@RequestMapping("/code-map")
public class CodeMapController {
    Logger logger = LoggerFactory.getLogger(getClass());
    @Autowired
    private CodeMapService codeMapService;

    @ApiOperation(value = "删除基础数据", httpMethod = HttpMethodTypeEnum.DELETE)
    @DeleteMapping("/{codeMapId}")
    @ResponseBody
    public ResultCommand<BaseObject> deleteByPrimaryKey(@PathVariable String codeMapId) {
        logger.info("删除方法入参:{}", codeMapId);
        ResultCommand<BaseObject> resultCommand = new ResultCommand<>();
        int result = codeMapService.deleteByPrimaryKey(codeMapId);
        resultCommand.setMessage(result == 1 ? "删除成功" : "删除失败");
        resultCommand.setResult(result == 1 ? ResultCommand.SUCCESS : ResultCommand.FAILED);
        logger.info("删除方法出参:{}", result);
        return resultCommand;
    }

    @ApiOperation(value = "新增基础数据", httpMethod = HttpMethodTypeEnum.POST)
    @PostMapping
    @ResponseBody
    public ResultCommand<BaseObject> insertSelective(@Valid @RequestBody CodeMapModel record, BindingResult br) {
        logger.info("新增方法入参:{}", record);
        ResultCommand<BaseObject> resultCommand = new ResultCommand<>();
        if (br.hasErrors()) {
            resultCommand.setResult(ResultCommand.FAILED);
            resultCommand.setMessage(ValidatorMsgParser.getErrorMsg(br).toString());
            return resultCommand;
        }
        int result = codeMapService.insertSelective(record);
        resultCommand.setMessage(result == 1 ? "新增成功" : "新增失败");
        resultCommand.setResult(result == 1 ? ResultCommand.SUCCESS : ResultCommand.FAILED);
        logger.info("新增方法出参:{}", result);
        return resultCommand;
    }

    @ApiOperation(value = "单条查询基础数据", httpMethod = HttpMethodTypeEnum.GET)
    @GetMapping("/single/{codeMapId}")
    @ResponseBody
    public ResultCommand<CodeMapModel> selectByPrimaryKey(@PathVariable String codeMapId) {
        logger.info("单条查询方法入参:{}", codeMapId);
        ResultCommand<CodeMapModel> resultCommand = new ResultCommand<>();
        CodeMapModel codeMapModel = codeMapService.selectByPrimaryKey(codeMapId);
        resultCommand.setMessage("查询成功");
        resultCommand.setResult(ResultCommand.SUCCESS);
        resultCommand.setResponseInfo(codeMapModel);
        logger.info("单条查询方法出参:{}", codeMapModel);
        return resultCommand;
    }

    @ApiOperation(value = "修改基础数据", httpMethod = HttpMethodTypeEnum.PUT)
    @PutMapping
    @ResponseBody
    public ResultCommand<BaseObject> updateByPrimaryKeySelective(@Valid @RequestBody CodeMapModel record, BindingResult br) {
        logger.info("单条查询方法入参:{}", record);
        ResultCommand<BaseObject> resultCommand = new ResultCommand<>();
        if (br.hasErrors()) {
            resultCommand.setResult(ResultCommand.FAILED);
            resultCommand.setMessage(ValidatorMsgParser.getErrorMsg(br).toString());
            return resultCommand;
        }
        int result = codeMapService.updateByPrimaryKeySelective(record);
        resultCommand.setMessage(result == 1 ? "修改成功" : "修改失败");
        resultCommand.setResult(result == 1 ? ResultCommand.SUCCESS : ResultCommand.FAILED);
        logger.info("单条查询方法出参:{}", result);
        return resultCommand;
    }

    @ApiOperation(value = "根据条件查询全部基础数据", httpMethod = HttpMethodTypeEnum.GET)
    @GetMapping("/all")
    @ResponseBody
    public ResultCommand<CodeMapModel> selectAll(CodeMapModel record) {
        logger.info("根据条件查询全部入参:{}", record);
        ResultCommand<CodeMapModel> resultCommand = new ResultCommand<>();
        List<CodeMapModel> codeMapModel = codeMapService.selectAll(record);
        resultCommand.setMessage("查询成功");
        resultCommand.setResult(ResultCommand.SUCCESS);
        resultCommand.setResponseInfos(codeMapModel);
        logger.info("根据条件查询全部出参:{}", codeMapModel);
        return resultCommand;
    }

    @ApiOperation(value = "根据条件分页查询基础数据", httpMethod = HttpMethodTypeEnum.GET)
    @GetMapping
    @ResponseBody
    public ResultCommand<CodeMapModel> selectPageAll(CodeMapModel record) {
        logger.info("根据条件分页查询全部入参:{}", record);
        ResultCommand<CodeMapModel> resultCommand = new ResultCommand<>();
        Page<CodeMapModel> codeMapModel = codeMapService.selectPageAll(record);
        resultCommand.setTotalRows(codeMapModel.getTotal());
        resultCommand.setMessage("查询成功");
        resultCommand.setResult(ResultCommand.SUCCESS);
        resultCommand.setResponseInfos(codeMapModel.getResult());
        logger.info("根据条件分页查询全部出参:{}", codeMapModel);
        return resultCommand;
    }
}
