--
--  XYZAppDelegate.applescript
--  MailMessageMover
--
--  Created by Nabeel Saad on 06/08/2013.
--  Copyright (c) 2013 Nabeel Saad. All rights reserved.
--

script XYZAppDelegate
	property parent : class "NSObject"
    property theMailbox : ""
    property userInput : missing value
    property testLabel : missing value
    
    property currFolderName : "default"
    property currAccount : ""
    property messageSubject : ""
    
    property messageInfo: missing value
    property mailboxes : missing value
    
    on buttonClicked_(sender)
        display alert "Hello there " & theMailbox
    end buttonClicked_
	
    on cancelClicked_(sender)
        quit
    end cancelClicked_
    
    --on testButtonClick_(sender)
        --set content of mailboxes to {{task:"A"}}
        --set content of outline view 1 to {"One", "Two"}
        --set content of outline view 1 of scroll view 1 of window 1 to {"One", "Three"}
        --set currFolderName & " account: " & currAccount to textInputField's stringValue()
    --end testButtonClick_
    
    on inputReceived_(sender)
            display dialog theMailbox
    end inputReceived_
    
    on getMessageInfo_()
        tell application "Mail" to try
        
        --Get the current mailbox
        set currentMailboxes to (selected mailboxes of message viewer 1)
        
        --Get it's name and account
        repeat with box in currentMailboxes
            set currFolderName to (name of box)
            set currBox to box
            set currAccount to name of (account of box)
        end repeat
        
        --Get the current message subject
        set currMsgsList to selected messages of the front message viewer
		if (exists currMsgsList) then
			set firstMsg to first item of currMsgsList
            set messageSubject to subject of firstMsg
        end if
        
        messageInfo's setStringValue_("Working in [" & currFolderName & "] of account [" & currAccount & "]\nWith the message [" & messageSubject & "]")
        
        end try
    end getMessageInfo_
	
    on applicationWillFinishLaunching_(aNotification)
        display dialog "hello there - in application will finish launching"
		-- Insert code here to initialize your application before any files are opened
        my getMessageInfo_()
        
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
	
end script