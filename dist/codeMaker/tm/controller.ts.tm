<%
	primaryFieldName = primary['fieldName']
%>\
import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Query,
} from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from 'src/auth/jwt.auth.guard';
import { ResponseDto } from 'src/common/common.model';
import {
  ${capTableName},
  Create${capTableName}Dto,
  Select${capTableName}Dto,
  Update${capTableName}Dto,
} from './${tableNameByCon}.model';
import { ${capTableName}Service } from './${tableNameByCon}.service';

@ApiTags('${tableComment}')
@Controller('${tableNameByCon}')
@UseGuards(JwtAuthGuard)
export class ${capTableName}Controller {
  constructor(private readonly ${tableName}Service: ${capTableName}Service) {}

  /**
   * 新增${tableComment}
   * @param create${capTableName}Dto
   */
  @ApiOperation({ summary: '新增${tableComment}' })
  @Post()
  async create(@Body() create${capTableName}Dto: Create${capTableName}Dto) {
    await this.${tableName}Service.create(create${capTableName}Dto);
    return '${tableComment}添加成功';
  }

  /**
   * 分页查询${tableComment}
   * @param select${capTableName}Dto
   * @returns ${capTableName}[]
   */
  @ApiOperation({ summary: '分页查询${tableComment}' })
  @ApiResponse({ type: ${capTableName} })
  @Get()
  async findByPage(@Query() select${capTableName}Dto: Select${capTableName}Dto) {
    const responseDto = new ResponseDto<${capTableName}[]>();
    const [list, count] = await this.${tableName}Service.findByPage(
      select${capTableName}Dto,
    );
    responseDto.total = count;
    responseDto.data = list;
    return responseDto;
  }

  /**
   * 查询所有${tableComment}
   * @param select${capTableName}Dto
   * @returns ${capTableName}[]
   */
  @ApiOperation({ summary: '查询所有${tableComment}' })
  @ApiResponse({ type: ${capTableName} })
  @Get('all')
  async findAll(
    @Query() select${capTableName}Dto: Select${capTableName}Dto,
  ): Promise<${capTableName}[]> {
    return await this.${tableName}Service.findAll(select${capTableName}Dto);
  }

  /**
   * 按${primaryFieldName}查询${tableComment}
   * @param ${primaryFieldName}
   * @returns ${capTableName}
   */
  @ApiOperation({ summary: '按${primaryFieldName}查询${tableComment}' })
  @ApiResponse({ type: ${capTableName} })
  @Get(':${primaryFieldName}')
  async findOne(@Param('${primaryFieldName}') ${primaryFieldName}: string): Promise<${capTableName}> {
    return await this.${tableName}Service.findOne(${primaryFieldName});
  }

  /**
   * ${tableComment}修改
   * @param ${primaryFieldName}
   * @param update${capTableName}Dto
   */
  @ApiOperation({ summary: '${tableComment}修改' })
  @Patch(':${primaryFieldName}')
  async update(
    @Param('${primaryFieldName}') ${primaryFieldName}: string,
    @Body() update${capTableName}Dto: Update${capTableName}Dto,
  ) {
    await this.${tableName}Service.update(${primaryFieldName}, update${capTableName}Dto);
    return '${tableComment}修改成功';
  }

  /**
   * ${tableComment}删除
   * @param ${primaryFieldName}
   */
  @ApiOperation({ summary: '${tableComment}删除' })
  @Delete(':${primaryFieldName}')
  async remove(@Param('${primaryFieldName}') ${primaryFieldName}: string) {
    await this.${tableName}Service.remove(${primaryFieldName});
    return '${tableComment}删除成功';
  }
}
