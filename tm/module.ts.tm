import { Module } from '@nestjs/common';
import { ${capTableName}Service } from './${tableNameByCon}.service';
import { ${capTableName}Controller } from './${tableNameByCon}.controller';

@Module({
  controllers: [${capTableName}Controller],
  providers: [${capTableName}Service],
})
export class ${capTableName}Module {}
