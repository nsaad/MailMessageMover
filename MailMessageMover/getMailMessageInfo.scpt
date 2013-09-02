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
		set messageDetail to "Message: [" & subject of firstMsg & "]"
	else
		set messageDetail to "No message selected"
	end if
	
	set workingInMessage to ("Working in [" & currFolderName & "] of account [" & currAccount & "]\n" & messageDetail)
	
	return workingInMessage
end try

