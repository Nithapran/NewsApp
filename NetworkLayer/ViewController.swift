//
//  ViewController.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-05.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        RequestService().createRequest()
        
        
        var person = Person(name: "Nitha", age: "12")
        var job = Job(jobName: "SE")
        
        person.job = job
        job.person = person
        
        person.job = nil
        job.person = nil
        
    }


}

class Person {
    var name:String
    var age: String
    var job: Job?
    
    init (name: String, age: String) {
        self.name = name
        self.age = age
    }
}


class Job {
    var jobName: String
    var person: Person?
    
    init(jobName: String) {
        self.jobName = jobName
    }
}
