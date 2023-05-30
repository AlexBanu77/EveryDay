import { Test, TestingModule } from '@nestjs/testing';
import { TypeOrmModule } from "@nestjs/typeorm";
import { TypeORMTestingModule } from "../test-utils/TypeORMTestingModule";
import { UsersService } from "./users.service";
import { User } from "./user.entity";

describe('UsersService', () => {
  let service: UsersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [TypeORMTestingModule([User]),TypeOrmModule.forFeature([User])],
      providers: [UsersService],
    }).compile();

    service = module.get<UsersService>(UsersService);
  });

  describe('create', () => {
    it('should create user', async () => {
      //Arrange
      function makeid(length) {
        let result = '';
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        const charactersLength = characters.length;
        let counter = 0;
        while (counter < length) {
          result += characters.charAt(Math.floor(Math.random() * charactersLength));
          counter += 1;
        }
        return result;
      }

      const payload = {
        username: makeid(5),
        password: "data"
      };

      // Act
      const user = await service.create(payload);

      //Assert
      expect(user).toBe(true);
    })
  })

  describe('not create', () => {
    it('should not create user', async () => {
      //Arrange
      const payload = {
        username: "Alex",
        password: "data"
      };

      // Act
      const user = await service.create(payload);

      //Assert
      expect(user).toBe(false);
    })
  })
});
