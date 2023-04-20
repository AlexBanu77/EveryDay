import { IsString, IsDate } from "class-validator";

export class CreateEventDto{
    @IsDate()
    date: Date;
    @IsString()
    organizer: string;
    @IsString()
    location: string;
}