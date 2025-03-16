#!/bin/bash  
  
# Function to display a stylish header 
print_header() {     zenity --info -
title="Event Reminder " \  
        --text="==============================\nEvent Registration & 
Reminder  
Scheduler\n=============================="  
}  
  
# Display header 
print_header  
  
# Collect multiple inputs in a single window using zenity  
form_output=$(zenity --forms --title="Event Registration & Reminder 
Scheduler" \  
  --text="Please enter the details of the event" \  
  --add-entry="Event Name" \  
  --add-entry="Email" \  
  --add-calendar="Event Date" \  
  --add-entry="Event Time (HH:MM AM/PM)" \  
  --add-entry="Description")  
  
# Check if the user pressed Cancel or closed the 
window if [ $? -ne 0 ]; then     zenity --error -
title="Event  Scheduler" \         --text="Form 
canceled. Exiting script."     exit 1 fi  
  
# Extract the individual fields from the form output  
IFS="|" read -r event_name email event_date event_time description  
<<<"$form_output"  
  
# Validate email format  
if [[ ! "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; 
then     zenity --error --title="Event Registration & Reminder Scheduler" \         --text="Invalid email address provided. Please try again."     exit 1 fi  
8   
   
  
# Convert event time to 24-hour format  
event_time_24=$(date -d "$event_time" +"%H:%M")  
  
# Convert event date and time to seconds since epoch 
event_date_secs=$(date -d "$event_date $event_time_24" +%s)  
  
# Calculate the date for 2 days before the event 
start_date=$(date -d "$event_date -2 days" +%Y-%m-%d)  
  
# Function to send email 
send_email() {  
    subject="Reminder: $event_name"     body="Hello,\n\nThis is 
a reminder for your event:\n\nReminder:  
$event_name\nDescription: $description\nDate: $event_date\nTime:  
$event_time\n\nBest Regards,\nReminder Script"  
  
    # Send the email using msmtp  
    echo -e "To: $email\nSubject: $subject\n\n$body" | msmtp --debug 
from=default -t  
  
    # Log email delivery 
status     if [ $? -eq 0 ]; 
then  
        zenity --info --title="Reminder Scheduler" --text="Email 
sent successfully to $email."     else  
        zenity --error --title="Reminder Scheduler" --text="Failed to 
send email. Check ~/.msmtp.log for details."     fi  
}  
  
# Confirmation email for adding the reminder subject="Reminder 
Added to System" body="Hello,\n\nYour reminder has been 
successfully added:\n\nReminder:  
$event_name\nDescription: $description\nDate: $event_date\nTime:  
$event_time\n\nYou will receive daily reminders starting two days before 
the event.\n\nBest Regards,\nReminder Script"  
echo -e "To: $email\nSubject: $subject\n\n$body" | msmtp --debug -
from=default  -t  
  
# Create a valid script filename  
safe_event_name=$(echo "$event_name" | tr -d '[:space:]' | tr -cd  
'[:alnum:]._')  
cron_script="/tmp/send_email_${safe_event_name}.sh"  
9   
   
  
# Create the cron script 
cat <<EOL > 
"$cron_script"  
#!/bin/bash  
current_date_secs=\$(date +%s)  
if [ \$current_date_secs -gt $event_date_secs ]; then  
    crontab -l | grep -v "$cron_script" | crontab -  # Remove cron job 
after event date  
    rm -f "$cron_script"                            # Clean up the 
script     exit 0 fi  
$(declare -f send_email)  
send_email  
EOL  
  
# Make the script executable 
chmod +x "$cron_script"  
  
# Schedule the cron job to run daily from 2 days before the event  
cron_time=$(date -d "$start_date" +"%M %H")  # Schedule at the same time as 
START_DATE  
(crontab -l 2>/dev/null; echo "$cron_time * * * bash $cron_script") | 
crontab -   
# Confirmation message with Zenity  
zenity --info --title="Event Registration & Reminder Scheduler" \  
    --text="Event and reminder scheduled successfully!\n\nDetails:\nEvent 
Name:  
$event_name\nEmail: $email\nEvent Date: $event_date\nEvent Time:  
$event_time\nDescription: $description\n\nYou will receive reminders two 
days before the event."  
^C  
shravan@shravanshetty:~$ chmod +x demo3_singlewindow 
shravan@shravanshetty:~$ ./demo3_singlewindow  
./demo3_singlewindow: line 6: --text===============================\nEvent  
Registration & Reminder Scheduler\n==============================: command 
not found ^C  
shravan@shravanshetty:~$ cat>demo3_singlewindow  
#!/bin/bash  
  
# Function to display a stylish header 
print_header() {  
    zenity --info --title="Event Reminder " \  
        --text="==============================\nEvent  
10   
   
Scheduler\n=============================="  
}  
  
# Display header 
print_header  
  
# Collect multiple inputs in a single window using zenity  
form_output=$(zenity --forms --title="Event Registration & Reminder 
Scheduler" \  
  --text="Please enter the details of the event" \  
  --add-entry="Event Name" \  
  --add-entry="Email" \  
  --add-calendar="Event Date" \  
  --add-entry="Event Time (HH:MM AM/PM)" \  
  --add-entry="Description")  
  
# Check if the user pressed Cancel or closed the 
window if [ $? -ne 0 ]; then  
    zenity --error --title="Event  
Scheduler" \         --text="Form canceled. 
Exiting script."     exit 1 fi  
  
# Extract the individual fields from the form output  
IFS="|" read -r event_name email event_date event_time description  
<<<"$form_output"  
  
# Validate email format  
if [[ ! "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; 
then     zenity --error --title="Event Registration & Reminder Scheduler" \  
        --text="Invalid email address provided. Please try 
again."     exit 1 fi  
  
# Convert event time to 24-hour format 
event_time_24=$(date -d "$event_time" +"%H:%M")  
  
# Convert event date and time to seconds since epoch 
event_date_secs=$(date -d "$event_date $event_time_24" +%s)  
  
# Calculate the date for 2 days before the event 
start_date=$(date -d "$event_date -2 days" +%Y-%m-%d) # 
Function to send email send_email() {  
    subject="Reminder: $event_name"     body="Hello,\n\nThis is 
a reminder for your event:\n\nReminder:  
$event_name\nDescription: $description\nDate: $event_date\nTime:  
11   
   
$event_time\n\nBest Regards,\nReminder Script"  
  
    # Send the email using msmtp  
    echo -e "To: $email\nSubject: $subject\n\n$body" | msmtp --debug 
from=default -t  
  
    # Log email delivery 
status     if [ $? -eq 0 ]; 
then  
        zenity --info --title="Reminder Scheduler" --text="Email 
sent successfully to $email."     else  
        zenity --error --title="Reminder Scheduler" --text="Failed to 
send email. Check ~/.msmtp.log for details."     fi  
}  
  
# Confirmation email for adding the reminder subject="Reminder 
Added to System" body="Hello,\n\nYour reminder has been 
successfully added:\n\nReminder:  
$event_name\nDescription: $description\nDate: $event_date\nTime:  
$event_time\n\nYou will receive daily reminders starting two days before 
the event.\n\nBest Regards,\nReminder Script"  
echo -e "To: $email\nSubject: $subject\n\n$body" | msmtp --debug -
from=default  -t  
  
# Create a valid script filename  
safe_event_name=$(echo "$event_name" | tr -d '[:space:]' | tr -cd  
'[:alnum:]._')  
cron_script="/tmp/send_email_${safe_event_name}.sh"  
  
# Create the cron script 
cat <<EOL > 
"$cron_script"  
#!/bin/bash  
current_date_secs=\$(date +%s)  
if [ \$current_date_secs -gt $event_date_secs ]; then     crontab -l | 
grep -v "$cron_script" | crontab -  # Remove cron job after event date  
    rm -f "$cron_script"                            # Clean up the script  
    exit 
0 fi  
$(declare -f send_email) 
send_email  
EOL  
12   
   
  
# Make the script executable 
chmod +x "$cron_script"  
  
# Schedule the cron job to run daily from 2 days before the event  
cron_time=$(date -d "$start_date" +"%M %H")  # Schedule at the same time as 
START_DATE  
(crontab -l 2>/dev/null; echo "$cron_time * * * bash $cron_script") | 
crontab -   
# Confirmation message with Zenity  
zenity --info --title="Event Registration & Reminder Scheduler" \  