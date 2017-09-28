# Final Project- Bug Away
*Group Member:*
1.Zhe Mao (zm34)
2.Yuxiang Huang (yh164)
3.Chengzhang Ma (cm391)
## Functions Overview
<b>Log in</b> <br/>
<b>Course Selection</b><br/>
**Calendar View**<br/>
<b>Four basic functions</b><br/>
  1. Announcement
  2. GradeBook
  3. Announcement
  4. Resource
  
## Installation and Run
The project written in swift3 and please run the code in Xcode v8.3

## Sakai API Reference

### Recourse
https://sakai.duke.edu/direct/content/site/{siteId}.json

### Announcement
https://sakai.duke.edu/direct/announcement/site/{siteId}.json?n=100&d=3000<br/>
get recent 3000 days 100 announcements

### Assignment
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
We used an open source project as the base of our calendar view. The project can be found in https://github.com/LitterL/CalendarDemo

## User Guide
Refer to Document **User Guide**


