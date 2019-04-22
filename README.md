
# DukeSakai Application
[Sakai](https://www.sakailms.org/) is a very useful tool, both for students and 
professors, in the classroom. This project seeks to leverage those tools, and 
the wide use of mobile technology by integrating both pieces together in an easy
to use application.

## App Overview
The application is, at the moment, a read-only type of application, meaning that
all data available on Sakai web can be displayed in the app, but no data can be 
transferred, or uploaded by app users.


App Navigation:

<b>Log in</b> <br/>
<b>Course Selection</b><br/>
**Calendar View**<br/>
<b>Four basic functions</b><br/>
  1. Announcement
  2. GradeBook
  3. Announcement
  4. Resource
  
## Installation and Run
The project is currently written in Swift 4.2 and please run the code in Xcode v8.3

## Sakai API Reference

### Resources
https://sakai.duke.edu/direct/content/site/{siteId}.json

### Announcements
https://sakai.duke.edu/direct/announcement/site/{siteId}.json?n=100&d=3000<br/>
get recent 3000 days 100 announcements

### Assignments
https://sakai.duke.edu/direct/assignment/site/{siteId}.json

### GradeBook
get the grade item list: <br/>
https://sakai.duke.edu/direct/gradebook/site/{siteId}.json<br/>
for each grade item detail: <br/>
https://sakai.duke.edu/direct/gradebook/item/{siteId}/{item_name}.json

### Calendar
https://sakai.duke.edu/direct/calendar/my.json?firstDate={start_date}&lastDate={end_date}<br/>
get all calendar event between start_date and end_date

## Reference
We used an open source project as the base of our calendar view. The project can
be found in https://github.com/LitterL/CalendarDemo

## User Guide
Refer to Document **User Guide**

## Contributors
Andres Hernandez Guerra
Niral Shah
Zhe Mao
Yuxiang Huang
Chengzhang Ma

