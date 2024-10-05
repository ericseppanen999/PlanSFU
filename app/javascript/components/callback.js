export class Callback {
    constructor(){
        this.subscribers = [];
    }

    subscribe(func) {
        this.subscribers.push(func);
    }

    trigger(...args){
        this.subscribers.forEach((subscriber) => {
            subscriber(...args);
        });
    }
}

export const AddCourseCallback = new Callback();

export const RemoveCourseCallback = new Callback();