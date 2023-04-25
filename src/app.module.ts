import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { EventsModule } from './events/events.module';
import { TypeOrmModule } from "@nestjs/typeorm";
import { Event } from "./events/event.entity";
import { UsersModule } from './users/users.module';
import {User} from "./users/user.entity";

@Module({
  imports: [TypeOrmModule.forRoot({
    type: 'sqlite',
    database: 'db.sqlite',
    entities: [Event, User],
    synchronize: true
  }), EventsModule, UsersModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
