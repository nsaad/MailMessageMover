# MailMessageMover
A Mac OS X mail filing application that allows you to easily move emails from one folder to another

You can either build from source using Xcode, or you can use the "release" version provided. This won't be kept as up to date, but the latest changes were made in Oct 2015 to improve the code, clean up, and fix a few bugs.

## Suggestions for setting this up:

- Copy the "MailMessageMover" application from the latest "release" folder into your "Applications" folder

- Open "Automater" by searching for it in Spotlight
- Create a new "Document" of type "Service"
- Search for the action "Launch Application" and drag it to the Workflow area
- From the drop down, choose the "MailMessageMover" application
- Save the service (let's assume MailMoverService) with whatever name you want, but remember it to re-use it later 

- Open "System Preferences"
- Click into "Keyboard"
- Click into "Shortcuts"
- Select "Services" on the left
- Scroll to the bottom to the "General" section, and next to your service "MailMoverService", double click into the keyboard shortcut area and choose your desired shortcut.
 
You should be able to now use this keyboard shortcut at any point in time. Bear in mind that for the first usage (also after a restart), you may need to click on the menu bar of whichever application you have open, click the first Menu Item with the application name (ex: Safari), and hover over "Services". You should now see your Service with your keyboard shortcut. You can either click it or just click out and directly use the keyboard shortcut.

## How it works:
- The MailMessageMover application is very simple. Assume you are using Mac Mail, you select an email(s) to move, then use your keyboard shorcut to open the MailMessageMover. It'll show the subject of the email you are moving. Just start typing any portion of the folder name you want to move your email(s) to. The list of all the folders will be filtered out to show the folders that match.

If there is only one folder that matches, hitting "Enter" or the "Move Message" button, the message will be moved immediately.
If there is more than one folder that matches, hitting "Enter" will select the first folder in the list but giving you the opportunity to choose the folder you want. Then you will need to click "Enter" or the "Move Mail" button again.

For any questions, issues, or comments please feel free to create a new issue in this Github repository.
Cheers.

