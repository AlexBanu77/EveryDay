import { Body, Controller, Get, Post } from '@nestjs/common';
import { CreateEventDto } from "./dtos/create-event.dto";

@Controller('events')
export class EventsController {
    @Post()
    createEvent(@Body() body: CreateEventDto) {
        console.log(body);
    }
}
