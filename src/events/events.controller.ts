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
        console.log("I dont want your body")
        return this.eventsService.create(body);
    }

    @Get("/:id")
    findEvent(@Param('id') id: string){
        return this.eventsService.findOne(parseInt(id)) ?? new NotFoundException('No event found');
    }

    @Get()
    findAll(){
        return this.eventsService.find();
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
