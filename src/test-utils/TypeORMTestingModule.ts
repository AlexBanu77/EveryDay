import { TypeOrmModule } from '@nestjs/typeorm';
import { Event } from "../events/event.entity";
import { User } from "../users/user.entity";

export const TypeORMTestingModule = (entities: any[]) =>
  TypeOrmModule.forRoot({
    type: 'sqlite',
    database: 'db.sqlite',
    entities: [...entities],
    synchronize: true
  });