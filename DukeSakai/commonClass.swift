
import Foundation

//for course selection
class Membership {
    var name: String;
    var siteId: String;
    var term: String;
    var instructor: String
    var lastModified: Int64
    init(name: String, siteId: String, term: String, instructor: String, lastModified: Int64) {
        self.name = name
        self.siteId = siteId
        self.term = term
        self.instructor = instructor
        self.lastModified = lastModified
    }
}

class Term {
    var termName: String;
    var courses: [Membership];
    
    init(termName: String, courses: [Membership]) {
        self.termName = termName
        self.courses = courses
    }
}

class Grade {
    var item: String
    var grade: String
    var point: Int
    init (item: String, grade: String, point: Int) {
        self.item = item
        self.grade = grade
        self.point = point
    }
}

class Assignment {
    var assignmentTitle: String
    var status: String
    var due: String
    var scale: String
    var instructions: String
    var dueTime: Int64
    init (assignmentTitle: String, status: String, due: String, scale: String, instructions: String, dueTime: Int64) {
        self.assignmentTitle = assignmentTitle
        self.status = status
        self.due = due
        self.scale = scale
        self.instructions = instructions
        self.dueTime = dueTime
    }
}

class Resource {
    var numChildren : Int
    var title : String
    var type : String
    var subView = [Resource]()
    var url : String
    
    
    init (numChildren : Int, title: String, type : String, url : String) {
        self.numChildren = numChildren
        self.title = title
        self.type = type
        self.url = url
    }
}


class CalendarEvent {
    var title : String
    var siteId : String
    var eventId : String
    var time : NSDate
    var ft_display : String
    var dayPosition : Int = 0
    var detail = ""
    var lt_display = ""
    
    init(title : String, siteId : String, eventId : String, time : NSDate, ft_display : String){
        self.title = title
        self.time = time
        self.siteId = siteId
        self.eventId = eventId
        self.ft_display = ft_display
    }
    
    
}

class Announce {
    var title: String
    var body: String
    var createdOn: Int64
    var author: String
    init (title: String, body: String, createdOn: Int64, author: String) {
        self.title = title
        self.body = body
        self.createdOn = createdOn
        self.author = author
    }
}

func getTermArray (uniqueTerm: [String], courseArray: [Membership]) -> [Term] {
    var termArray = [Term] ()
    for term1 in uniqueTerm {
        let termCurr = Term(termName: term1, courses: [Membership]())
        for course1 in courseArray {
            if (course1.term == term1) {
                termCurr.courses.append(course1)
            }
        }
        termCurr.courses = termCurr.courses.sorted() {$0.lastModified < $1.lastModified}
        termArray.append(termCurr)
    }
    return termArray
}


func getUniqueTerm (coursesArray: [Membership])->[String] {
    var termArray = [String]()
    
    for course in coursesArray {
        termArray.append(course.term);
    }
    return Array(Set(termArray))
 }

func sortTerm(_ s1: String, _ s2: String) -> Bool {
    var s1N = -1
    var s2N = -1
    if (s1 == "Project") {
        return false
    }
    if (s2 == "Project") {
        return true
        
    }
    if (s1 != "Project" && s2 != "Project") {
        if(s1.substring(from: 0, to: 4) != s2.substring(from: 0, to: 4)) {
            return s1 > s2
        } else {
            
            if(strStr(s1, "Fall") != -1) {
                s1N = 1
            }
            if(strStr(s1, "Summer Term - Full") != -1) {
                s1N = 2
            }
            if(strStr(s1, "Summer Term 2") != -1) {
                s1N = 3
            }
            if(strStr(s1, "Summer Term 1") != -1) {
                s1N = 4
            }
            if(strStr(s1, "Spring") != -1) {
                s1N = 5
            }
            if(strStr(s1, "Winter") != -1) {
                s1N = 6
            }
            
            if(strStr(s2, "Fall") != -1) {
                s2N = 1
            }
            if(strStr(s2, "Summer Term - Full") != -1) {
                s2N = 2
            }
            if(strStr(s2, "Summer Term 2") != -1) {
                s2N = 3
            }
            if(strStr(s2, "Summer Term 1") != -1) {
                s2N = 4
            }
            if(strStr(s2, "Spring") != -1) {
                s2N = 5
            }
            if(strStr(s2, "Winter") != -1) {
                s2N = 6
            }
            return s2N > s1N
        }
    }
    return s2 > s1
    
}
