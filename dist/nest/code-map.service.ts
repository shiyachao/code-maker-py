import { Injectable } from '@nestjs/common';
import { CommonException } from 'src/common/common.exception';
import { Brackets, EntityManager } from 'typeorm';
import {
  CodeMap,
  CodeTypeEnumCn,
  StatusEnumCn,
  CreateCodeMapDto,
  SelectCodeMapDto,
  UpdateCodeMapDto,
} from './code-map.model';

@Injectable()
export class CodeMapService {
  constructor(private readonly entityManager: EntityManager) {}

  /**
   * 新增基础数据
   * @param createCodeMapDto
   */
  async create(createCodeMapDto: CreateCodeMapDto) {
    if (createCodeMapDto.codeMapId) {
      const codeMapExist = await this.entityManager.findOne(CodeMap, createCodeMapDto.codeMapId);
      if (codeMapExist) throw new CommonException('基础数据已经存在');
    }
    const codeMapEntity = new CodeMap();
    Object.assign(codeMapEntity, createCodeMapDto);
    await this.entityManager.insert(CodeMap, codeMapEntity);
  }

  /**
   * 分页查询基础数据
   * @param selectCodeMapDto
   * @returns [CodeMap[], number]
   */
  async findByPage(
    selectCodeMapDto: SelectCodeMapDto,
  ): Promise<[CodeMap[], number]> {
    const { current, pageSize } = selectCodeMapDto;
    const codeMapPage = await this.entityManager
      .createQueryBuilder(CodeMap, 'codeMap')
      .where(
        new Brackets((qb) => {
          qb.where('1 = 1');
          if (selectCodeMapDto.codeType)
            qb.andWhere('codeMap.codeType = :codeType', {
              codeType: selectCodeMapDto.codeType,
            });
          if (selectCodeMapDto.status)
            qb.andWhere('codeMap.status = :status', {
              status: selectCodeMapDto.status,
            });
        }),
      )
      .offset(pageSize * (current - 1))
      .limit(pageSize)
      .orderBy(
        `codeMap.${selectCodeMapDto.sortField}`,
        selectCodeMapDto.sortOrder,
      )
      .getManyAndCount();
    codeMapPage[0] = codeMapPage[0].map((item) => {
      item.codeTypeCn = CodeTypeEnumCn[item.codeType];
      item.statusCn = StatusEnumCn[item.status];
      return item;
    });
    return codeMapPage;
  }

  /**
   * 查询所有基础数据
   * @param selectCodeMapDto
   * @returns CodeMap[]
   */
  async findAll(
    selectCodeMapDto: SelectCodeMapDto = new SelectCodeMapDto(),
  ): Promise<CodeMap[]> {
    let codeMapList = await this.entityManager
      .createQueryBuilder(CodeMap, 'codeMap')
      .where(
        new Brackets((qb) => {
          qb.where('1 = 1');
          if (selectCodeMapDto.codeType)
            qb.andWhere('codeMap.codeType = :codeType', {
              codeType: selectCodeMapDto.codeType,
            });
          if (selectCodeMapDto.status)
            qb.andWhere('codeMap.status = :status', {
              status: selectCodeMapDto.status,
            });
        }),
      )
      .orderBy(
        `codeMap.${selectCodeMapDto.sortField}`,
        selectCodeMapDto.sortOrder,
      )
      .getMany();
    codeMapList = codeMapList.map((item) => {
      item.codeTypeCn = CodeTypeEnumCn[item.codeType];
      item.statusCn = StatusEnumCn[item.status];
      return item;
    });
    return codeMapList;
  }

  /**
   * 按codeMapId查询基础数据
   * @param codeMapId
   * @returns CodeMap
   */
  async findOne(codeMapId: string): Promise<CodeMap> {
    const codeMap = await this.entityManager.findOne(CodeMap, codeMapId);
    if (codeMap) {
      codeMap.codeTypeCn = CodeTypeEnumCn[codeMap.codeType];
      codeMap.statusCn = StatusEnumCn[codeMap.status];
    }
    return codeMap;
  }

  /**
   * 基础数据修改
   * @param codeMapId
   * @param updateCodeMapDto
   */
  async update(codeMapId: string, updateCodeMapDto: UpdateCodeMapDto) {
    await this.entityManager.update(CodeMap, codeMapId, updateCodeMapDto);
  }

  /**
   * 基础数据删除
   * @param codeMapId
   */
  async remove(codeMapId: string) {
    await this.entityManager.delete(CodeMap, codeMapId);
  }
}
