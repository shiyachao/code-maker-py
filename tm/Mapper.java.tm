package com.${comName}.${dbName}.mapper;

import com.${comName}.${dbName}.model.${capTableName}Model;
import org.apache.ibatis.annotations.Mapper;
import com.github.pagehelper.Page;

import java.util.List;

@Mapper
public interface ${capTableName}Mapper {
    int deleteByPrimaryKey(${primary['javaType']} ${primary['fieldName']});

    int insertSelective(${capTableName}Model record);

    ${capTableName}Model selectByPrimaryKey(${primary['javaType']} ${primary['fieldName']});

    int updateByPrimaryKeySelective(${capTableName}Model record);

    List<${capTableName}Model> selectAll(${capTableName}Model record);

    Page<${capTableName}Model> selectPageAll(${capTableName}Model record);
}