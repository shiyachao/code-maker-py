package com.ec.oas.service;

import com.ec.oas.mapper.CodeMapMapper;
import com.ec.oas.model.CodeMapModel;
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
public class CodeMapService {
    Logger logger = LoggerFactory.getLogger(getClass());
    @Autowired
    public CodeMapMapper codeMapMapper;

    /**
     * 删除基础数据
     *
     * @param codeMapId
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public int deleteByPrimaryKey(String codeMapId) {
        int result = -1;
        try {
            result = codeMapMapper.deleteByPrimaryKey(codeMapId);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("删除数据异常{}", e.getMessage());
        }
        return result;
    }

    /**
     * 新增基础数据
     *
     * @param record
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public int insertSelective(CodeMapModel record) {
        int result = -1;
        try {
            result = codeMapMapper.insertSelective(record);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("新增数据异常{}", e.getMessage());
        }
        return result;
    }

    /**
     * 根据主键查询基础数据
     *
     * @param codeMapId
     * @return
     */
    public CodeMapModel selectByPrimaryKey(String codeMapId) {
        return codeMapMapper.selectByPrimaryKey(codeMapId);
    }

    /**
     * 修改基础数据
     *
     * @param record
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public int updateByPrimaryKeySelective(CodeMapModel record) {
        int result = -1;
        try {
            result = codeMapMapper.updateByPrimaryKeySelective(record);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("修改数据异常{}", e.getMessage());
        }
        return result;
    }

    /**
     * 根据条件查询所有基础数据
     *
     * @param record
     * @return
     */
    public List<CodeMapModel> selectAll(CodeMapModel record) {
        try {
            return codeMapMapper.selectAll(record);
        } catch (Exception e) {
            logger.error("根据条件查询全部数据异常{}", e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 根据条件分页查询基础数据
     *
     * @param record
     * @return
     */
    public Page<CodeMapModel> selectPageAll(CodeMapModel record) {
        if (record.getCurrent() <= 0 || record.getPageSize() <= 0) {
            logger.error("分页参数异常，页码：{},条数：{}", record.getCurrent(), record.getPageSize());
            return null;
        }
        try {
            PageHelper.startPage(record.getCurrent(), record.getPageSize());
            return codeMapMapper.selectPageAll(record);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("根据条件查询全部数据异常{}", e.getMessage());
        }
        return null;
    }
}
