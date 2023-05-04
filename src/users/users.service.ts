import { Injectable } from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {Repository} from "typeorm";
import {User} from "./user.entity";


@Injectable()
export class UsersService {
    constructor(@InjectRepository(User) private repo: Repository<User>) {}

    create(body: any){
        const user = this.repo.create(body);
        return this.repo.save(user);
    }

    async getAuth(body: any){
        const user: any = await this.find(body.username);
        return user.password === body.password;
    }

    find(username: string) {
        // @ts-ignore
        return this.repo.findOne({
            where:{
                username: username,
            },
        });
    }
}

