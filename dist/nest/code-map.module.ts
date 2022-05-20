import { Module } from '@nestjs/common';
import { CodeMapService } from './code-map.service';
import { CodeMapController } from './code-map.controller';

@Module({
  controllers: [CodeMapController],
  providers: [CodeMapService],
})
export class CodeMapModule {}
