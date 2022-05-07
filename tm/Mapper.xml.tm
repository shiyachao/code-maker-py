<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.${comName}.${dbName}.mapper.${capTableName}Mapper" >
  <resultMap id="BaseResultMap" type="com.${comName}.${dbName}.model.${capTableName}Model" >
    % for item in columns:
        % if item['isPri']:
    <id column="${item['dbFieldName']}" property="${item['fieldName']}" jdbcType="${item['jdbcType']}" />
        % else:
    <result column="${item['dbFieldName']}" property="${item['fieldName']}" jdbcType="${item['jdbcType']}" />
        % endif
    % endfor
  </resultMap>
  <sql id="Base_Column_List" >
    % for i in range(len(columns)):
${'\t'}${columns[i]['dbFieldName']}${'' if i == len(columns) - 1 else ','}\
    % endfor

  </sql>
  <select id="selectByPrimaryKey" resultMap="BaseResultMap" parameterType="java.lang.${primary['javaType']}" >
    select 
    <include refid="Base_Column_List" />
    from ${dbTableName}
    where ${primary['dbFieldName']} = #{${primary['fieldName']},jdbcType=${primary['jdbcType']}}
  </select>
  <delete id="deleteByPrimaryKey" parameterType="java.lang.${primary['javaType']}" >
    delete from ${dbTableName}
    where ${primary['dbFieldName']} = #{${primary['fieldName']},jdbcType=${primary['jdbcType']}}
  </delete>
  <insert id="insertSelective" parameterType="com.${comName}.${dbName}.model.${capTableName}Model" >
    insert into ${dbTableName}
    <trim prefix="(" suffix=")" suffixOverrides="," >
      % for item in columns:
      <if test="${item['fieldName']} != null" >
        ${item['dbFieldName']},
      </if>
      % endfor
    </trim>
    <trim prefix="values (" suffix=")" suffixOverrides="," >
      % for item in columns:
      <if test="${item['fieldName']} != null" >
        #{${item['fieldName']},jdbcType=${item['jdbcType']}},
      </if>
      % endfor
    </trim>
  </insert>
  <update id="updateByPrimaryKeySelective" parameterType="com.${comName}.${dbName}.model.${capTableName}Model" >
    update ${dbTableName}
    <set >
      % for item in columns:
      <if test="${item['fieldName']} != null" >
        ${item['dbFieldName']} = #{${item['fieldName']},jdbcType=${item['jdbcType']}},
      </if>
      % endfor
    </set>
    where ${primary['dbFieldName']} = #{${primary['fieldName']},jdbcType=${primary['jdbcType']}}
  </update>
  <select id="selectAll" resultMap="BaseResultMap" parameterType="com.${comName}.${dbName}.model.${capTableName}Model" >
    select
    <include refid="Base_Column_List" />
    from ${dbTableName}
    <where>
      1=1
      % for item in columns:
      <if test="${item['fieldName']} != null and ${item['fieldName']} != ''" >
        and ${item['dbFieldName']} = #{${item['fieldName']},jdbcType=${item['jdbcType']}}
      </if>
      % endfor
    </where>
  </select>

  <select id="selectPageAll" resultMap="BaseResultMap" parameterType="com.${comName}.${dbName}.model.${capTableName}Model" >
    select
    <include refid="Base_Column_List" />
    from ${dbTableName}
    <where>
      1=1
      % for item in columns:
      <if test="${item['fieldName']} != null and ${item['fieldName']} != ''" >
        and ${item['dbFieldName']} = #{${item['fieldName']},jdbcType=${item['jdbcType']}}
      </if>
      % endfor
    </where>
  </select>
</mapper>