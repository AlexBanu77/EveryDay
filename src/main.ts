import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import {ValidationPipe} from "@nestjs/common";
import * as cors from "cors";

async function bootstrap() {
  process.on('uncaughtException', function (err) {
    console.error(err);
  });
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe({
    transformOptions:{
      enableImplicitConversion:true
    },
    whitelist:true,
  },))
  app.use(cors());
  await app.listen(5001);
}
bootstrap();
