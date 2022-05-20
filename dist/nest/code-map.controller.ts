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
  CodeMap,
  CreateCodeMapDto,
  SelectCodeMapDto,
  UpdateCodeMapDto,
} from './code-map.model';
import { CodeMapService } from './code-map.service';

@ApiTags('基础数据')
@Controller('code-map')
@UseGuards(JwtAuthGuard)
export class CodeMapController {
  constructor(private readonly codeMapService: CodeMapService) {}

  /**
   * 新增基础数据
   * @param createCodeMapDto
   */
  @ApiOperation({ summary: '新增基础数据' })
  @Post()
  async create(@Body() createCodeMapDto: CreateCodeMapDto) {
    await this.codeMapService.create(createCodeMapDto);
    return '基础数据添加成功';
  }

  /**
   * 分页查询基础数据
   * @param selectCodeMapDto
   * @returns CodeMap[]
   */
  @ApiOperation({ summary: '分页查询基础数据' })
  @ApiResponse({ type: CodeMap })
  @Get()
  async findByPage(@Query() selectCodeMapDto: SelectCodeMapDto) {
    const responseDto = new ResponseDto<CodeMap[]>();
    const [list, count] = await this.codeMapService.findByPage(
      selectCodeMapDto,
    );
    responseDto.total = count;
    responseDto.data = list;
    return responseDto;
  }

  /**
   * 查询所有基础数据
   * @param selectCodeMapDto
   * @returns CodeMap[]
   */
  @ApiOperation({ summary: '查询所有基础数据' })
  @ApiResponse({ type: CodeMap })
  @Get('all')
  async findAll(
    @Query() selectCodeMapDto: SelectCodeMapDto,
  ): Promise<CodeMap[]> {
    return await this.codeMapService.findAll(selectCodeMapDto);
  }

  /**
   * 按codeMapId查询基础数据
   * @param codeMapId
   * @returns CodeMap
   */
  @ApiOperation({ summary: '按codeMapId查询基础数据' })
  @ApiResponse({ type: CodeMap })
  @Get(':codeMapId')
  async findOne(@Param('codeMapId') codeMapId: string): Promise<CodeMap> {
    return await this.codeMapService.findOne(codeMapId);
  }

  /**
   * 基础数据修改
   * @param codeMapId
   * @param updateCodeMapDto
   */
  @ApiOperation({ summary: '基础数据修改' })
  @Patch(':codeMapId')
  async update(
    @Param('codeMapId') codeMapId: string,
    @Body() updateCodeMapDto: UpdateCodeMapDto,
  ) {
    await this.codeMapService.update(codeMapId, updateCodeMapDto);
    return '基础数据修改成功';
  }

  /**
   * 基础数据删除
   * @param codeMapId
   */
  @ApiOperation({ summary: '基础数据删除' })
  @Delete(':codeMapId')
  async remove(@Param('codeMapId') codeMapId: string) {
    await this.codeMapService.remove(codeMapId);
    return '基础数据删除成功';
  }
}
