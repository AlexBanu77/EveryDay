import { Entity, Column, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Event {
    @PrimaryGeneratedColumn()
    id: number;
    @Column()
    date: Date;
    @Column()
    organizer: string;
    @Column()
    location: string;

    // more props to come!
}