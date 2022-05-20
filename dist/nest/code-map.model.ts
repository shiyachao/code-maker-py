import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Allow, IsNotEmpty, MaxLength } from 'class-validator';
import { CommonConstant, CommonEntity, dateFormatTransformer, RequestDto } from 'src/common/common.model';
import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { Decimal, NumberMaxLength } from 'src/common/common.Decorator';

/**
 * 数据库实体entity
 */
@Entity('t_code_map')
export class CodeMap extends CommonEntity {
  @ApiPropertyOptional({ description: '基础数据主键' })
  @PrimaryGeneratedColumn('uuid', { name: 'code_map_id' })
  codeMapId: string;
  @ApiPropertyOptional({ description: '基础数据名称' })
  @Column({ name: 'code_map_name' })
  codeMapName: string;
  @ApiPropertyOptional({ description: '基础数据类型：00，人员类别；' })
  @Column({ name: 'code_type' })
  codeType: string;
  @ApiPropertyOptional({ description: '基础数据类型描述' })
  codeTypeCn: string;
  @ApiPropertyOptional({ description: '状态：00，正常；99，停用；' })
  @Column({ name: 'status' })
  status: string;
  @ApiPropertyOptional({ description: '状态描述' })
  statusCn: string;
}
/**
 * 枚举
 */
export enum CodeTypeEnum {
  NORMAL = '00',
}
export const CodeTypeEnumCn: { [key in CodeTypeEnum]: string } = {
  [CodeTypeEnum.NORMAL]: '人员类别',
};
export enum StatusEnum {
  NORMAL = '00',
  NORMAL = '99',
}
export const StatusEnumCn: { [key in StatusEnum]: string } = {
  [StatusEnum.NORMAL]: '正常',
  [StatusEnum.NORMAL]: '停用',
};
/**
 * 查询入参dto
 */
export class SelectCodeMapDto extends RequestDto {
  @ApiPropertyOptional({ description: '基础数据类型：00，人员类别；' })
  @Allow()
  codeType: string;
  @ApiPropertyOptional({ description: '状态：00，正常；99，停用；' })
  @Allow()
  status: string;
}
/**
 * 新增dto
 */
export class CreateCodeMapDto {
  @ApiPropertyOptional({ description: '基础数据主键' })
  @MaxLength(36, { message: '基础数据主键最大长度36' })
  codeMapId: string;
  @ApiProperty({ description: '基础数据名称' })
  @IsNotEmpty({ message: '基础数据名称不能为空' })
  @MaxLength(20, { message: '基础数据名称最大长度20' })
  codeMapName: string;
  @ApiProperty({ description: '基础数据类型：00，人员类别；' })
  @IsNotEmpty({ message: '基础数据类型不能为空' })
  @MaxLength(2, { message: '基础数据类型最大长度2' })
  codeType: string;
  @ApiProperty({ description: '状态：00，正常；99，停用；' })
  @IsNotEmpty({ message: '状态不能为空' })
  @MaxLength(2, { message: '状态最大长度2' })
  status: string;
}
/**
 * 修改dto
 */
export class UpdateCodeMapDto {
  @ApiProperty({ description: '基础数据名称' })
  @IsNotEmpty({ message: '基础数据名称不能为空' })
  @MaxLength(20, { message: '基础数据名称最大长度20' })
  codeMapName: string;
  @ApiProperty({ description: '基础数据类型：00，人员类别；' })
  @IsNotEmpty({ message: '基础数据类型不能为空' })
  @MaxLength(2, { message: '基础数据类型最大长度2' })
  codeType: string;
  @ApiProperty({ description: '状态：00，正常；99，停用；' })
  @IsNotEmpty({ message: '状态不能为空' })
  @MaxLength(2, { message: '状态最大长度2' })
  status: string;
}
