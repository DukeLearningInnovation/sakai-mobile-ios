
# DukeSakai Mobile Application
[Sakai](https://www.sakailms.org/) provides very useful tools, both for students and professors, in the classroom. This project seeks to leverage those tools, and the wide use of mobile technology by integrating both pieces together in an easy to use application.
## Getting Started

In order to be granted access to the DukeSakai Mobile App repository, please contact Prof. Ric Telford (ric.telford@duke.edu) at Duke University, Center for Mobile Development. Once you have access to the repository, these instructions will get you a copy of the project up and running on your local machine for development and testing purposes. The project does not have any prerequisites, other than it must be run on Xcode 10.2 or later, with Swift 4.2 or later.

See deployment for notes on how to deploy the project on a live system.

### Cloning Through The Command Line

It is recommended that, if you want to clone this project, you use the **HTTPs option**, the steps to do this successfully are the following:

 1. Open the terminal.
 
 2. Change the current working directory to the location where you want the cloned directory to be made (make sure it is a git repository).
 
 3. Type the following command, and run it.
	```
	$ git clone https://gitlab.oit.duke.edu/MobileCenter/dukesakai.git
	```
	Note: you may be prompted to enter your GitLab username and password.
	
 4. Your local clone will be created. You can now start working on this project!

If you choose to use the **SSH option**

 1. Open the terminal.
 
 2. Change the current working directory to the location where you want the cloned directory to be made (make sure it is a git repository).

 3. Make sure you have added an SSH Key to your GitLab account, and if you have not done this already, access the [GitLab Guide](https://docs.gitlab.com/ee/ssh/) and follow their steps to setup your SSH Key Pair.
 
 4. Once you have verified step 3, type and run the following command.
	```
	$ git clone git@gitlab.oit.duke.edu:MobileCenter/dukesakai.git
	```
	Note: here you may be prompted for a password, and must provide your SSH key passphrase.

 5. Your local clone will be created. You can now start working on this project!

### Direct Download From The Repository

Another option to get this project running on your local computer is to download the entire package from GitLab, this can be achieved by clicking on the "Cloud Download" icon to the right of the project screen. There you can choose the type of compressed file you would like to download.

Once you have downloaded the project, make sure to extract all files and placed them into your desired directory.

To run this project you can choose between the Xcode simulators provided, or run it on your own device. Follow the same steps you would when running any other App. The App will run on any device with iOS 10 or above.

## App Overview
The application is, at the moment, a read-only type of application, meaning that all data available on Sakai web can be displayed in the app as well, but no data can be transferred, or uploaded by the user.

Main App Navigation Path:

**Log in --> Course Selection OR Calendar View**

If a course is selected, there are different screens which display different information about it, and the main four are the following:
1. Announcement
2. GradeBook
3. Announcement
4. Resource

If the calendar is selected, it will display an interactive calendar view, with the events registered on Sakai in the user's account.

More in-depth information about these views and navigation inside the app can be found in the [user guide](##User-Guide) section.


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
We used an open source project as the base of our calendar view. The project can be found in https://github.com/LitterL/CalendarDemo

## User Guide
Refer to Document **User Guide**

## Contributors
Andres Hernandez Guerra
Niral Shah
Zhe Mao
Yuxiang Huang
Chengzhang Ma
