import {Injectable, NotFoundException} from '@nestjs/common';
import { Repository } from "typeorm";
import { InjectRepository } from "@nestjs/typeorm";
import { Event } from "./event.entity";
import {CreateEventDto} from "./dtos/create-event.dto";

@Injectable()
export class EventsService {
    constructor(@InjectRepository(Event) private repo: Repository<Event>) {}

    create(body: CreateEventDto){
        const event = this.repo.create(body);
        return this.repo.save(event);
    }

    findOne(id: number) {
        // @ts-ignore
        return this.repo.findOne(id);
    }

    find(date: Date) {
        // @ts-ignore
        return this.repo.find({date});
    }

    async update(id: number, attrs: Partial<Event>) {
        const event = await this.findOne(id);
        if (!event){
            throw new NotFoundException('event not found')
        }
        Object.assign(event, attrs);
        return this.repo.save(event);
    }

    async remove(id: number) {
        const event = await this.findOne(id);
        if (!event){
            throw new NotFoundException('event not found')
        }
        return this.repo.remove(event);
    }
}
