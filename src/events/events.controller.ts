import {Body, Controller, Get, Post, Patch, Param, Query, Delete, NotFoundException} from '@nestjs/common';
import { CreateEventDto } from "./dtos/create-event.dto";
import { EventsService } from "./events.service";
import {UpdateEventDto} from "./dtos/update-event.dto";

@Controller('events')
export class EventsController {

    constructor(private eventsService: EventsService) {
    }
    @Post()
    createEvent(@Body() body: CreateEventDto) {
        this.eventsService.create(body);
    }

    @Get("/:id")
    findEvent(@Param('id') id: string){
        return this.eventsService.findOne(parseInt(id)) ?? new NotFoundException('No event found');
    }

    @Get()
    findAll(@Query('date') date: Date){
        return this.eventsService.find(date);
    }

    @Delete('/:id')
    removeEvent(@Param('id') id: string){
        return this.eventsService.remove(parseInt(id));
    }

    @Patch('/:id')
    updateEvent(@Param('id') id: string, @Body() body: UpdateEventDto){
        return this.eventsService.update(parseInt(id), body);
    }
}
