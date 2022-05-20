/**
 * 基础数据接口
 * codeMapId 基础数据主键
 * codeMapName 基础数据名称
 * codeType 基础数据类型：00，人员类别；
 * status 状态：00，正常；99，停用；
 * regTime 创建时间
 * updTime 更新时间
 */
import { Get, Post, Patch, Delete } from "@/components/util/axios";

/**
 * 基础数据列表查询(分页)
 */
export function listCodeMap(data){
  return Get("/code-map", data);
}
/**
 * 新增基础数据
 */
export function addCodeMap(data){
  return Post("/code-map", data);
}
/**
 * 修改基础数据
 */
export function editCodeMap(codeMapId, data){
  return Patch(`/code-map/${codeMapId}`, data);
}
/**
 * 删除基础数据(主键，单条删除)
 */
export function delCodeMap(codeMapId){
  return Delete(`/code-map/${codeMapId}`);
}
/**
 * 查询全部基础数据(不分页)
 */
export function listCodeMapAll(data){
  return Get("/code-map/all", data);
}
/**
 * 查询单条基础数据(主键查询)
 */
export function singleCodeMap(codeMapId){
  return Get(`/code-map/${codeMapId}`);
}