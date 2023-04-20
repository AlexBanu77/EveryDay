import {IsString, IsOptional, IsDate} from 'class-validator';

export class UpdateEventDto {
    @IsDate()
    @IsOptional()
    date: Date;
    @IsString()
    @IsOptional()
    organizer: string;
    @IsOptional()
    @IsString()
    location: string;
}