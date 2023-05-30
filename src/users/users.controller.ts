import {Body, Controller, Get, Post} from '@nestjs/common';
import {UsersService} from "./users.service";
import {UserDto} from "./dtos/user.dto";

@Controller('users')
export class UsersController {

    constructor(private usersService: UsersService) {
    }

    @Post()
    getAuth(@Body() body: UserDto){
        return this.usersService.getAuth(body);
    }

    @Post('/register')
    createUser(@Body() body: UserDto){
        return this.usersService.create(body);
    }
}
