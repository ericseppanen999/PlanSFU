/*
A system for allowing frontend modules to communicate
*/

class Callback {
    constructor(){
        this.subscribers = [];
    }

    // Tells the system to call your function whenever the callback is fired
    subscribe(func) {
        this.subscribers.push(func);
    }

    // Fires the callback with args passed to its subscribers
    trigger(...args){
        this.subscribers.forEach((subscriber) => {
            subscriber(...args);
        });
    }
}

// Callback for handling adding courses from the main search to the terms tab
export const AddCourseCallback = new Callback();

// Callback for handling removing courses from the terms tab
export const RemoveCourseCallback = new Callback();