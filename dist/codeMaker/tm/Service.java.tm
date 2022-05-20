package com.${comName}.${dbName}.service;

import com.${comName}.${dbName}.mapper.${capTableName}Mapper;
import com.${comName}.${dbName}.model.${capTableName}Model;
import com.github.pagehelper.PageHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import com.github.pagehelper.Page;

import java.util.List;

@Service
public class ${capTableName}Service {
    Logger logger = LoggerFactory.getLogger(getClass());
    @Autowired
    public ${capTableName}Mapper ${tableName}Mapper;

    /**
     * 删除${tableComment}
     *
     * @param ${primary['fieldName']}
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public int deleteByPrimaryKey(${primary['javaType']} ${primary['fieldName']}) {
        int result = -1;
        try {
            result = ${tableName}Mapper.deleteByPrimaryKey(${primary['fieldName']});
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("删除数据异常{}", e.getMessage());
        }
        return result;
    }

    /**
     * 新增${tableComment}
     *
     * @param record
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public int insertSelective(${capTableName}Model record) {
        int result = -1;
        try {
            result = ${tableName}Mapper.insertSelective(record);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("新增数据异常{}", e.getMessage());
        }
        return result;
    }

    /**
     * 根据主键查询${tableComment}
     *
     * @param ${primary['fieldName']}
     * @return
     */
    public ${capTableName}Model selectByPrimaryKey(${primary['javaType']} ${primary['fieldName']}) {
        return ${tableName}Mapper.selectByPrimaryKey(${primary['fieldName']});
    }

    /**
     * 修改${tableComment}
     *
     * @param record
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public int updateByPrimaryKeySelective(${capTableName}Model record) {
        int result = -1;
        try {
            result = ${tableName}Mapper.updateByPrimaryKeySelective(record);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("修改数据异常{}", e.getMessage());
        }
        return result;
    }

    /**
     * 根据条件查询所有${tableComment}
     *
     * @param record
     * @return
     */
    public List<${capTableName}Model> selectAll(${capTableName}Model record) {
        try {
            return ${tableName}Mapper.selectAll(record);
        } catch (Exception e) {
            logger.error("根据条件查询全部数据异常{}", e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 根据条件分页查询${tableComment}
     *
     * @param record
     * @return
     */
    public Page<${capTableName}Model> selectPageAll(${capTableName}Model record) {
        if (record.getCurrent() <= 0 || record.getPageSize() <= 0) {
            logger.error("分页参数异常，页码：{},条数：{}", record.getCurrent(), record.getPageSize());
            return null;
        }
        try {
            PageHelper.startPage(record.getCurrent(), record.getPageSize());
            return ${tableName}Mapper.selectPageAll(record);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("根据条件查询全部数据异常{}", e.getMessage());
        }
        return null;
    }
}
