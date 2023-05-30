import { Injectable } from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {Repository} from "typeorm";
import {User} from "./user.entity";


@Injectable()
export class UsersService {
    constructor(@InjectRepository(User) private repo: Repository<User>) {}

    async create(body: any){
        try{
            await this.find(body.username);
            return false;
        } catch (e) {
            const user = this.repo.create(body);
            await this.repo.save(user);
            return true;
        }
    }

    async getAuth(body: any){
        try {
            const user: any = await this.find(body.username);
            return user.password === body.password;
        } catch (e) {
            return false;
        }
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

