import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Allow, IsNotEmpty, MaxLength } from 'class-validator';
import { CommonConstant, CommonEntity, dateFormatTransformer, RequestDto } from 'src/common/common.model';
import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { Decimal, NumberMaxLength } from 'src/common/common.Decorator';

/**
 * 数据库实体entity
 */
@Entity('${dbTableName}')
export class ${capTableName} extends CommonEntity {
% for item in columns:
<%
	fieldName = item['fieldName']
	dbFieldName = item['dbFieldName']
	tsType = item['tsType']
	blank = item['blank']
	comment = item['fieldComment']
	commentName = item['commentName']
%>\
  % if fieldName not in ['regTime', 'updTime']:
  @ApiPropertyOptional({ description: '${comment}' })
    % if item['isPri']:
  @PrimaryGeneratedColumn('uuid', { name: '${dbFieldName}' })
    % elif tsType == 'Date':
  @Column({
    name: '${dbFieldName}',
    % if item['pureFieldType'] == 'date':
    transformer: dateFormatTransformer(CommonConstant.DATE_FORMAT),
    % elif item['pureFieldType'] == 'time':
    transformer: dateFormatTransformer(CommonConstant.TIME_FORMAT),
    % else:
    transformer: dateFormatTransformer(CommonConstant.DATETIME_FORMAT),
    % endif
  })
    % else:
  @Column({ name: '${dbFieldName}' })
    % endif
  ${fieldName}: ${tsType};
    % if item['commentEnum']:
  @ApiPropertyOptional({ description: '${commentName}描述' })
  ${fieldName}Cn: string;
    % endif
  % endif
% endfor
}
/**
 * 枚举
 */
% for item in enums:
export enum ${item['capFieldName']}Enum {
    % for enumItem in item['commentEnum']:
  NORMAL = '${enumItem['value']}',
    % endfor
}
export const ${item['capFieldName']}EnumCn: { [key in ${item['capFieldName']}Enum]: string } = {
    % for enumItem in item['commentEnum']:
  [${item['capFieldName']}Enum.NORMAL]: '${enumItem['label']}',
    % endfor
};
% endfor
/**
 * 查询入参dto
 */
export class Select${capTableName}Dto extends RequestDto {
  % for item in enums:
  @ApiPropertyOptional({ description: '${item['fieldComment']}' })
  @Allow()
  ${item['fieldName']}: ${item['tsType']};
  % endfor
}
/**
 * 新增dto
 */
export class Create${capTableName}Dto {
% for item in columns:
<%
	fieldName = item['fieldName']
	dbFieldName = item['dbFieldName']
	tsType = item['tsType']
	blank = item['blank']
	comment = item['fieldComment']
	commentName = item['commentName']
	max = item['max'] if 'max' in item.keys() else ''
%>\
  % if fieldName not in ['regTime', 'updTime']:
    % if not blank and not item['isPri']:
  @ApiProperty({ description: '${comment}' })
  @IsNotEmpty({ message: '${commentName}不能为空' })
    % else:
  @ApiPropertyOptional({ description: '${comment}' })
    % endif
    % if tsType == 'string':
  @MaxLength(${max}, { message: '${commentName}最大长度${max}' })
    % endif
    % if tsType == 'number':
      % if 'pointMax' in item.keys():
  @Decimal(${max}, ${item['pointMax']}, { message: '${commentName}小数点前最多${max}位，小数点最多${item['pointMax']}位' })
      % else:
  @NumberMaxLength(${max}, { message: '${commentName}最大长度${max}位' })
      % endif
    % endif
    % if item['tsType'] == 'Date' and blank:
  @Allow()
    % endif
  ${fieldName}: ${tsType};
  % endif
% endfor
}
/**
 * 修改dto
 */
export class Update${capTableName}Dto {
  % for item in columns:
<%
	fieldName = item['fieldName']
	dbFieldName = item['dbFieldName']
	tsType = item['tsType']
	blank = item['blank']
	comment = item['fieldComment']
	commentName = item['commentName']
	max = item['max'] if 'max' in item.keys() else ''
%>\
  % if fieldName not in ['regTime', 'updTime'] and not item['isPri']:
    % if not blank:
  @ApiProperty({ description: '${comment}' })
  @IsNotEmpty({ message: '${commentName}不能为空' })
    % else:
  @ApiPropertyOptional({ description: '${comment}' })
    % endif
    % if tsType == 'string':
  @MaxLength(${max}, { message: '${commentName}最大长度${max}' })
    % endif
    % if tsType == 'number':
      % if 'pointMax' in item.keys():
  @Decimal(${max}, ${item['pointMax']}, { message: '${commentName}小数点前最多${max}位，小数点最多${item['pointMax']}位' })
      % else:
  @NumberMaxLength(${max}, { message: '${commentName}最多${max}位' })
      % endif
    % endif
    % if item['tsType'] == 'Date' and blank:
  @Allow()
    % endif
  ${fieldName}: ${tsType};
  % endif
% endfor
}
