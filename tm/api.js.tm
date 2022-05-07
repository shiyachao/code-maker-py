/**
 * ${tableComment}接口
 % for item in columns:
 * ${item['fieldName']} ${item['fieldComment']}
 % endfor
 */
import { Get, Post, Patch, Delete } from "@/components/util/axios";

/**
 * ${tableComment}列表查询(分页)
 */
export function list${capTableName}(data){
  return Get("/${apiUrl}", data);
}
/**
 * 新增${tableComment}
 */
export function add${capTableName}(data){
  return Post("/${apiUrl}", data);
}
/**
 * 修改${tableComment}
 */
export function edit${capTableName}(${primary['fieldName']}, data){
  return Patch(`/${apiUrl}/${'${'+primary['fieldName']+'}'}`, data);
}
/**
 * 删除${tableComment}(主键，单条删除)
 */
export function del${capTableName}(${primary['fieldName']}){
  return Delete(`/${apiUrl}/${'${'+primary['fieldName']+'}'}`);
}
/**
 * 查询全部${tableComment}(不分页)
 */
export function list${capTableName}All(data){
  return Get("/${apiUrl}/all", data);
}
/**
 * 查询单条${tableComment}(主键查询)
 */
export function single${capTableName}(${primary['fieldName']}){
  return Get(`/${apiUrl}/${'${'+primary['fieldName']+'}'}`);
}