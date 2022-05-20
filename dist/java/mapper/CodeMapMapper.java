package com.ec.oas.mapper;

import com.ec.oas.model.CodeMapModel;
import org.apache.ibatis.annotations.Mapper;
import com.github.pagehelper.Page;

import java.util.List;

@Mapper
public interface CodeMapMapper {
    int deleteByPrimaryKey(String codeMapId);

    int insertSelective(CodeMapModel record);

    CodeMapModel selectByPrimaryKey(String codeMapId);

    int updateByPrimaryKeySelective(CodeMapModel record);

    List<CodeMapModel> selectAll(CodeMapModel record);

    Page<CodeMapModel> selectPageAll(CodeMapModel record);
}