<%
	primaryFieldName = primary['fieldName']
%>\
import { Injectable } from '@nestjs/common';
import { CommonException } from 'src/common/common.exception';
import { Brackets, EntityManager } from 'typeorm';
import {
  ${capTableName},
  % if enums:
  % for item in enums:
  ${item['capFieldName']}EnumCn,
  % endfor
  % endif
  Create${capTableName}Dto,
  Select${capTableName}Dto,
  Update${capTableName}Dto,
} from './${tableNameByCon}.model';

@Injectable()
export class ${capTableName}Service {
  constructor(private readonly entityManager: EntityManager) {}

  /**
   * 新增${tableComment}
   * @param create${capTableName}Dto
   */
  async create(create${capTableName}Dto: Create${capTableName}Dto) {
    if (create${capTableName}Dto.${primaryFieldName}) {
      const ${tableName}Exist = await this.entityManager.findOne(${capTableName}, create${capTableName}Dto.${primaryFieldName});
      if (${tableName}Exist) throw new CommonException('${tableComment}已经存在');
    }
    const ${tableName}Entity = new ${capTableName}();
    Object.assign(${tableName}Entity, create${capTableName}Dto);
    await this.entityManager.insert(${capTableName}, ${tableName}Entity);
  }

  /**
   * 分页查询${tableComment}
   * @param select${capTableName}Dto
   * @returns [${capTableName}[], number]
   */
  async findByPage(
    select${capTableName}Dto: Select${capTableName}Dto,
  ): Promise<[${capTableName}[], number]> {
    const { current, pageSize } = select${capTableName}Dto;
    const ${tableName}Page = await this.entityManager
      .createQueryBuilder(${capTableName}, '${tableName}')
      % if enums:
      .where(
        new Brackets((qb) => {
          qb.where('1 = 1');
          % for item in enums:
          if (select${capTableName}Dto.${item['fieldName']})
            qb.andWhere('${tableName}.${item['fieldName']} = :${item['fieldName']}', {
              ${item['fieldName']}: select${capTableName}Dto.${item['fieldName']},
            });
          % endfor
        }),
      )
      % endif
      .offset(pageSize * (current - 1))
      .limit(pageSize)
      .orderBy(
        `${tableName}.${'${'}select${capTableName}Dto.sortField${'}'}`,
        select${capTableName}Dto.sortOrder,
      )
      .getManyAndCount();
    % if enums:
    ${tableName}Page[0] = ${tableName}Page[0].map((item) => {
      % for item in enums:
      item.${item['fieldName']}Cn = ${item['capFieldName']}EnumCn[item.${item['fieldName']}];
      % endfor
      return item;
    });
    % endif
    return ${tableName}Page;
  }

  /**
   * 查询所有${tableComment}
   * @param select${capTableName}Dto
   * @returns ${capTableName}[]
   */
  async findAll(
    select${capTableName}Dto: Select${capTableName}Dto = new Select${capTableName}Dto(),
  ): Promise<${capTableName}[]> {
    let ${tableName}List = await this.entityManager
      .createQueryBuilder(${capTableName}, '${tableName}')
      % if enums:
      .where(
        new Brackets((qb) => {
          qb.where('1 = 1');
          % for item in enums:
          if (select${capTableName}Dto.${item['fieldName']})
            qb.andWhere('${tableName}.${item['fieldName']} = :${item['fieldName']}', {
              ${item['fieldName']}: select${capTableName}Dto.${item['fieldName']},
            });
          % endfor
        }),
      )
      % endif
      .orderBy(
        `${tableName}.${'${'}select${capTableName}Dto.sortField${'}'}`,
        select${capTableName}Dto.sortOrder,
      )
      .getMany();
    % if enums:
    ${tableName}List = ${tableName}List.map((item) => {
      % for item in enums:
      item.${item['fieldName']}Cn = ${item['capFieldName']}EnumCn[item.${item['fieldName']}];
      % endfor
      return item;
    });
    % endif
    return ${tableName}List;
  }

  /**
   * 按${primaryFieldName}查询${tableComment}
   * @param ${primaryFieldName}
   * @returns ${capTableName}
   */
  async findOne(${primaryFieldName}: string): Promise<${capTableName}> {
    const ${tableName} = await this.entityManager.findOne(${capTableName}, ${primaryFieldName});
    % if enums:
    if (${tableName}) {
      % for item in enums:
      ${tableName}.${item['fieldName']}Cn = ${item['capFieldName']}EnumCn[${tableName}.${item['fieldName']}];
      % endfor
    }
    % endif
    return ${tableName};
  }

  /**
   * ${tableComment}修改
   * @param ${primaryFieldName}
   * @param update${capTableName}Dto
   */
  async update(${primaryFieldName}: string, update${capTableName}Dto: Update${capTableName}Dto) {
    await this.entityManager.update(${capTableName}, ${primaryFieldName}, update${capTableName}Dto);
  }

  /**
   * ${tableComment}删除
   * @param ${primaryFieldName}
   */
  async remove(${primaryFieldName}: string) {
    await this.entityManager.delete(${capTableName}, ${primaryFieldName});
  }
}
