import { Test, TestingModule } from '@nestjs/testing';
import { EventsService } from './events.service';
import { TypeOrmModule } from "@nestjs/typeorm";
import { Event } from "./event.entity";
import { TypeORMTestingModule } from "../test-utils/TypeORMTestingModule";

describe('EventsService', () => {
  let service: EventsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [TypeORMTestingModule([Event]),TypeOrmModule.forFeature([Event])],
      providers: [EventsService],
    }).compile();

    service = module.get<EventsService>(EventsService);
  });

  describe('create', () => {
    it('should create event', async () => {
      //Arrange
      const payload = {
        date: new Date(),
        organizer: "Dummy",
        location: "data"
      };

      // Act
      const event = await service.create(payload);

      //Assert
      expect(event.date).toBe(payload.date);
      expect(event.organizer).toBe(payload.organizer);
      expect(event.location).toBe(payload.location);
    })

    it('should not find event if provided id does not exist on update', async () => {
      //Arrange
      const payload = {
        date: new Date(),
        organizer: "Dummy",
        location: "data"
      };

      // Act
      const eventPromise = () => {
        return service.update(11111,payload);
      }
      let event;
      eventPromise().then((e) => {
        event = e
        //Assert
        expect(event).toThrowError();
      });
    })
  })
});
