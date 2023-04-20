import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { EventsModule } from './events/events.module';
import { TypeOrmModule } from "@nestjs/typeorm";
import { Event } from "./events/event.entity";

@Module({
  imports: [TypeOrmModule.forRoot({
    type: 'sqlite',
    database: 'db.sqlite',
    entities: [Event],
    synchronize: true
  }), EventsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
