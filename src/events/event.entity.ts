import { AfterInsert, AfterRemove, AfterUpdate, Entity, Column, PrimaryGeneratedColumn } from "typeorm";

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
    @AfterInsert()
    logInsert() {
        console.log("Inserted User with id", this.id);
    }
    @AfterRemove()
    logRemove() {
        console.log("Removed User with id", this.id);
    }
    @AfterUpdate()
    logUpdate() {
        console.log("Updated User with id", this.id);
    }
    // more props to come!
}