#!/usr/bin/bash

# DEVELOPED BY:   JONES, ETHAN
#                 VERNER, PETER
#                 DEB, SUPARNO
# This code is to be used as a user friendly menu to control different aspects
# of crontab. The user will be able to display jobs, insert new jobs, edit 
# existing jobs, remove old jobs and remove all jobs, without the need of knowing
# how to use the crontab commands or knowing the structure of crontab itself.

CrontabEdit=/tmp/Crontab            # Variable is used for the location of the editing file

# Verify if tmp file exists and if not creates it
if [ -f "$CrontabEdit" ]; then      
    touch /tmp/Crontab              
fi

crontab -l > $CrontabEdit           # Puts the existing crontab jobs into the file we are using

# Field variables to store user inputs
job_list=''
minute=''
hour=''
day=''
month=''
dow=''

####################################################
# The main menu to navigate the different commands #
####################################################
main_menu(){
  # Display options to users 
  cat << EOF
  1. Display crontab jobs
  2. Insert a job
  3. Edit a job
  4. Remove a job
  5. Remove all jobs
  9. Exit
EOF
    read -p "Please select one of the above: " choice         # Gets users to choose an option
    
    # Uses user input to select an option which are in forms of functions
    case $choice in

    1) display_jobs;;
    2) insert_job;;
    3) edit_job;;
    4) remove_job;;
    5) remove_all_jobs;;
    9) echo "Program Terminated";;
    *) echo error, please try again.
       main_menu;;
    esac
}

####################################################
# Used as a way to get back to the menu or leave   #
# program.                                         #
####################################################
go_back(){
  cat << EOF
  1. Go Back
  2. Exit
EOF
  read -p "Please select one of the above: " choice      # Gets users to choose an option
    
  case $choice in

  # Goes back to the main menu
  1) main_menu
     ;;
  # Exits program
  2) echo "Program terminated..."
    ;;
  # Deals with exeption handling
  *) echo Invalid input, please try again.
    go_back
    ;;
  esac
}

####################################################
# Code for showing all crontab jobs                #
####################################################
display_task(){
# Format for showing crontab jobs    
cat << EOF
Minutes	Hours	Days	Month	DOW	Command    
EOF
crontab -l    # Crontab command to show crontabs
}

####################################################
# Displays all crontab jobs                        #
####################################################
display_jobs(){
  display_task

    go_back
}

####################################################
# Function for inserting minutes                   #
####################################################
insert_minute(){
  cat << EOF
  1. A specific minute
  2. Every minute (*)
  3. Every X minute(s)
  4. Between X and Y minutes
  5. Multiple specified minute(s)
EOF

  read -p "Please select an option: " min_option

  case $min_option in

  # For specific minute selection
  1) read -p "Please enter a specific minute (0-59): " spec_min
     if [[ ! "$spec_min" =~ ^[0-9]+$ ]] || [ $spec_min -gt 59 ] || [ $spec_min -lt 0 ]
     then
     echo "ERROR! Please try again..."
     insert_minute
     else
     minute="$spec_min" 
     fi
     ;;
  # For every minute selection
  2) minute='*'
     ;;
  # How often in minutes selection
  3) read -p "How often would you like to run the task? (0-59) " x_min
     if [[ ! "$x_min" =~ ^[0-9]+$ ]] || [ $x_min -gt 59 ] || [ $x_min -lt 0 ]
     then
     echo "ERROR! Please try again..."
     insert_minute
     else
     minute='*/'"$x_min" 
     fi
     ;;
  # In between minutes selection 
  4) read -p "Enter first minute (0-59): " first_minute
     if [[ ! "$first_minute" =~ ^[0-9]+$ ]] || [ $first_minute -gt 59 ] || [ $first_minute-lt 0 ]
     then
     echo "ERROR! Please try again..."
     insert_minute
     else
     read -p "Enter second minute (0-59): " second_minute
      if [[ ! "$second_minute" =~ ^[0-9]+$ ]] || [ $second_minute -gt 59 ] || [ $second_minute -lt 0 ]
     then
     echo "ERROR! Please try again..."
     insert_minute
     else
     minute="$first_minute"'-'"$second_minute" 
     fi
     fi
     ;;
  # Specific amount of minutes selection
  5) read -p "How many specific minutes do you want to add: " min_count
  if [[ ! "$min_count" =~ ^[0-9]+$ ]]
     then
     echo "ERROR! Please try again..."
     insert_minute
     else
     for value in $(seq 1 $min_count)
     do
         read -p "Enter a minute (0-59): " min
         if [[ ! "$min" =~ ^[0-9]+$ ]] || [ $min -gt 59 ] || [ $min -lt 0 ]
         then
         echo "ERROR! Please try again..."
         insert_minute
         else
         if [ -z "$minute" ]
           then 
               minute="$min"
           else
               minute="$minute"','"$min"
         fi
         fi
     done 
  fi
     ;;
  # Error handling
  *) echo You have entered an incorrect input, please try again.
     insert_minute 
     ;;
  esac
}

####################################################
# Function for inserting hours                     #
####################################################
insert_hour(){
  cat << EOF
  1. A specific hour
  2. Every hour (*)
  3. Every X hours(s)
  4. Between X and Y hours
  5. Multiple specified hours(s)
EOF

  read -p "Please select an option: " hrs_option

  case $hrs_option in
  
  # For specific hour selection
  1) read -p "Please enter a specific hour (0-23): " spec_hrs
  if [[ ! "$spec_hrs" =~ ^[0-9]+$ ]] || [ $spec_hrs -gt 23 ] || [ $spec_hrs -lt 0 ]
  then
  echo "ERROR! Please try again..."
  insert_hour
  else
  hour="$spec_hrs"
  fi
  ;;
  # For every hour selection
  2) hour='*'
  ;;
  # How often in hours selection
  3) read -p "How often would you like to run the task? (0-23)" x_hrs
  if [[ ! "$x_hrs" =~ ^[0-9]+$ ]] || [ $x_hrs -gt 23 ] || [ $x_hrs -lt 0 ]
  then
  echo "ERROR! Please try again..."
  insert_hour
  else
  hour='*/'"$x_hrs"
  fi
  ;;
  # In between hours selection
  4) read -p "Enter first hour (0-23): " first_hour
  if [[ ! "$first_hour" =~ ^[0-9]+$ ]] || [ $first_hour -gt 23 ] || [ $first_hour -lt 0 ]
     then
     echo "ERROR! Please try again..."
     insert_hour
     else
     read -p "Enter second hour (0-23): " second_hour
      if [[ ! "$second_hour" =~ ^[0-9]+$ ]] || [ $second_hour -gt 23 ] || [ $second_hour -lt 0 ]
     then
     echo "ERROR! Please try again..."
     insert_hour
     else
     hour="$first_hour"'-'"$second_hour"
     fi
     fi
     ;;
  # Specific amount of hours selection
  5) read -p "How many specific hours do you want to add: " hrs_count
  if [[ "hrs_count" =~ ^[0-9]+$ ]]
     then
     echo "ERROR! Please try again..."
     insert_hour
     else
     for value in $(seq 1 $hrs_count)
     do
       read -p "Enter an hour (0-23): " hrs
        if [[ ! "$hrs" =~ ^[0-9]+$ ]] || [ $hrs -gt 23 ] || [ $hrs -lt 0 ]
       then
       echo "ERROR! Please try again..."
       insert_hour
       else
       if [ -z "$hour" ]
         then 
             hour="$hrs"
         else
             hour="$hour"','"$hrs"
       fi
       fi
     done
  fi
     ;;
  # Error handling
  *) echo You have entered an incorrect input, please try again.
     insert_hour
     ;;
  esac
}

####################################################
# Function for inserting day of the month          #
####################################################
insert_day(){
  cat << EOF
  1. A specific day
  2. Every day (*)
  3. Every X day(s)
  4. Between X and Y days
  5. Multiple specified day(s)
EOF

read -p "Please select an option: " day_option

  case $day_option in
  
  # For specific day selection
  1) read -p "Please enter a specific day (1-31): " spec_day
  if [[ ! "$spec_day" =~ ^[0-9]+$ ]] || [ $spec_day -gt 31 ] || [ $spec_day -lt 1 ]
     then
     echo "ERROR! Please try again..."
     insert_day
     else
     day="$spec_day"
  fi
     ;;
  # For every day selection
  2) day='*'
     ;;
  # How often in days selection
  3) read -p "How often would you like to run the task? (1-31)" x_day
  if [[ ! "$x_day" =~ ^[0-9]+$ ]] || [ $x_day -gt 31 ] || [ $x_day -lt 1 ]
     then
     echo "ERROR! Please try again..."
     insert_day
     else
     day='*/'"$x_day"
  fi
     ;;
  # In between days selection
  4) read -p "Enter first day (1-31): " first_day
  if [[ ! "$first_day" =~ ^[0-9]+$ ]] || [ $first_day -gt 31 ] || [ $first_day -lt 1 ]
     then
     echo "ERROR! Please try again..."
     insert_day
     else
     read -p "Enter second day (1-31): " second_day
      if [[ ! "$second_day" =~ ^[0-9]+$ ]] || [ $second_day -gt 31 ] || [ $second_day -lt 1 ]
     then
     echo "ERROR! Please try again..."
     insert_day
     else
     day="$first_day"'-'"$second_day"
     fi
     fi
     ;;
  # Specific amount of days selection
  5) read -p "How many specific days do you want to add: " day_count
  if [[ "$day_count" =~ ^[0-9]+$ ]]
     then
     echo "ERROR! Please try again..."
     insert_day
     else
     for value in $(seq 1 $day_count)
     do
       read -p "Enter a day (1-31): " day1
       if [[ ! "$day1" =~ ^[0-9]+$ ]] || [ $day1 -gt 31 ] || [ $day1 -lt 1 ]
       then
       echo "ERROR! Please try again..."
       insert_day
       else
       if [ -z "$day" ]
         then 
             day="$day1"
         else
             day="$day"','"$day1"
       fi
       fi
     done
     fi
     ;;
  # Error handling
  *) echo You have entered an incorrect input, please try again.
     insert_day
     ;;
  esac
}

####################################################
# Function for inserting the month                 #
####################################################
insert_month(){
cat << EOF
  1. A specific month
  2. Every month (*)
  3. Every X month(s)
  4. Between X and Y months
  5. Multiple specified month(s)
EOF

  read -p "Please select an option: " month_option

  case $month_option in
  
  # For specific month selection
  1) read -p "Please enter a specific day (1-12): " spec_month
  if [[ ! "$spec_month" =~ ^[0-9]+$ ]] || [ $spec_month -gt 12 ] || [ $spec_month -lt 1 ]
     then
     echo "ERROR! Please try again..."
     insert_month
     else
     month="$spec_month"
     fi
     ;;
  # For every month selection
  2) month='*'
     ;;
  # How oftern in months selection
  3) read -p "How often would you like to run the task? (1-12)" x_day
  if [[ ! "$x_month" =~ ^[0-9]+$ ]] || [ $x_month -gt 12 ] || [ $x_month -lt 1 ]
     then
     echo "ERROR! Please try again..."
     insert_month
     else
     month='*/'"$x_month"
     fi
     ;;
  # In etween months selection
  4) read -p "Enter first month (1-12): " first_month
  if [[ ! "$first_month" =~ ^[0-9]+$ ]] || [ $first_month -gt 12 ] || [ $first_month -lt 1 ]
     then
     echo "ERROR! Please try again..."
     insert_month
     else
     read -p "Enter second month (1-12): " second_month
     if [[ ! "$second_month" =~ ^[0-9]+$ ]] || [ $second_month -gt 12 ] || [ $second_month -lt 1 ]
     then
     echo "ERROR! Please try again..."
     else
     month="$first_month"'-'"$second_month"
     fi
     fi
     ;;
  5) read -p "How many specific months do you want to add: " month_count
   if [[ ! "$month_count" =~ ^[0-9]+$ ]]
     then
     echo "Please enter a number"
     insert_month
     else
     for value in $(seq 1 $month_count)
     do
       read -p "Enter a month (1-12): " mnth
        if [[ ! "$mnth" =~ ^[0-9]+$ ]] || [ $mnth -gt 12 ] || [ $mnth -lt 1 ]
       then
       echo "ERROR! Please try again..."
       insert_month
       else
       if [ -z "$month" ]
         then 
             month="$mnth"
         else
             month="$month"','"$mnth"
        fi
        fi
     done
     fi
     ;;
  # Error handling
  *) echo You have entered an incorrect input, please try again.
     insert_month
     ;;
  esac
} 

####################################################
# Function for adding day of the week              #
####################################################
insert_dow(){
  cat << EOF
  1. A specific day of the week
  2. Every day of the week (*)
  3. Every X day of the week(s)
  4. Between X and Y day of the weeks
  5. Multiple specified day of the week(s)
EOF

  read -p "Please select an option: " dow_option
  
  case $dow_option in
  
  # For specific day of the week selection
  1) read -p "Please enter a specific day (0-6): " spec_dow
  if [[ ! "$spec_dow" =~ ^[0-9]+$ ]] || [ $spec_dow -gt 6 ] || [ $spec_dow -lt 0 ]
    then
    echo "ERROR! Please try again..."
    insert_dow
    else
     case $spec_dow in
     0) spec_dow="Sun";;
     1) spec_dow="Mon";;
     2) spec_dow="Tue";;
     3) spec_dow="Wed";;
     4) spec_dow="Thu";;
     5) spec_dow="Fri";;
     6) spec_dow="Sat";;
     esac
     dow="$spec_dow"
     fi
     ;;
  # For every day of the week selection
  2) dow='*'
     ;;
  # How often in days of the week selection  
  3) read -p "How often would you like to run the task? (0-6)" x_dow
   if [[ ! "$x_dow" =~ ^[0-9]+$ ]] || [ $x_dow -gt 6 ] || [ $x_dow -lt 0 ]
     then
     echo "ERROR! Please try again..."
     insert_dow
     else
     dow='*/'"$x_dow"
     fi
     ;;
  # In between days of the week selection
  4) read -p "Enter first day of the week (0-6): " first_dow
   if [[ ! "$first_dow" =~ ^[0-9]+$ ]] || [ $first_dow -gt 6 ] || [ $first_dow -lt 0 ]
     then
     echo "ERROR! Please try again..."
     insert_dow
     else
     case $first_dow in
     0) first_dow="Sun";;
     1) first_dow="Mon";;
     2) first_dow="Tue";;
     3) first_dow="Wed";;
     4) first_dow="Thu";;
     5) first_dow="Fri";;
     6) first_dow="Sat";;
     esac

     read -p "Enter day of the week (0-6): " second_dow
      if [[ ! "$second_dow" =~ ^[0-9]+$ ]] || [ $second_dow -gt 6 ] || [ $second_dow -lt 0 ]
     then
     echo "ERROR! Please try again..."
     insert_dow
     else
     case $second_dow in
     0) second_dow="Sun";;
     1) second_dow="Mon";;
     2) second_dow="Tue";;
     3) second_dow="Wed";;
     4) second_dow="Thu";;
     5) second_dow="Fri";;
     6) second_dow="Sat";;
     esac

     dow="$first_dow"'-'"$second_dow"
     fi
     fi
     ;;
  # Specific amount of days of the week selection
  5) read -p "How many specific days of the week do you want to add: " dow_count
   if [[ ! "$dow_count" =~ ^[0-9]+$ ]]
     then
     echo "ERROR! Please try again..."
     insert_dow
     else
     for value in $(seq 1 $dow_count)
     do
       read -p "Enter a day of the week (0-6): " dow1
       if [[ ! "$dow1" =~ ^[0-9]+$ ]] || [ $dow1 -gt 6 ] || [ $dow1 -lt 0 ]
       then
       echo "ERROR! Please try again..."
       insert_dow
       else
       if [ -z "$dow" ]
       then 
           dow="$dow1"
       else
           dow="$dow"','"$dow1"
       fi
       fi
     done
     fi
     ;;
  # Exeption handling
  *) echo you have entered an incorrect input, please try again.
     insert_dow
     ;;
  esac
}

####################################################
# Function for creating new crontab command        #
####################################################
insert_command(){
   read -p "Please enter a task: " task
    
    if [ "$task" = "" ]
    then
    echo "ERROR! Please try again..."
    insert_command
    else
    job_list=$task
    fi
}

####################################################
# Function for cleaning variables                  #
####################################################
unset_job(){
unset minute hour day month dow job_list
}

####################################################
# Function for writing the command onto crontab    #
####################################################
insert_job(){
   # Running the functions for the new crontab
    insert_minute
    insert_hour
    insert_day
    insert_month
    insert_dow
    insert_command
    
    # Adds the variales to the tmp crontab file for export
    printf '%s\n' "$minute	$hour	$day	$month	$dow	$job_list" >> "$CrontabEdit"
    
    crontab /tmp/Crontab    # Adds the new crontab that is in the tmp file
    unset_job               # Cleans variables for reuse
    go_back
}

####################################################
# Function for editing existing crontab jobs       #
####################################################
edit_job(){
  display_task
  lines=$(cat $CrontabEdit | wc -l)

  read -p "Which command would you like to edit?: (1-*) " command_index
  if [[ ! "$command_index" =~ ^[0-9]+$ ]]
    then
      echo "ERROR! Enter a line number (1-*)"
  edit_job
  else
  if [[ $command_index -gt $lines ]]
    then
       echo "ERROR! Command does not exist!"
  edit_job
  else
    insert_minute
    insert_hour
    insert_day
    insert_month
    insert_dow
    insert_command
  sed -i ""$command_index"s@.*@$minute $hour $day  $month   $dow  $job_list@" /tmp/Crontab
  crontab /tmp/Crontab
  unset_job
  go_back
  fi
  fi
}

####################################################
# Function for removing a crontab job              #
####################################################
remove_job(){
    display_task
    lines=$(cat $CrontabEdit | wc -l)
    
    # Asks users which crontab they want to remove
    read -p "Please select which index to remove: (1-*): " index_choice
    if [[ ! "$index_choice" =~ ^[0-9]+$ ]]
    then
    echo "ERROR! Enter a line number (1-*)"
    remove_job
    else
    if [[ $index_choice -gt $lines ]]
    then
    echo "ERROR! Command does not exist!"
    remove_job
    else

    # Removes the selected crontab
    sed -i "${index_choice}d" /tmp/Crontab

    crontab /tmp/Crontab      # Updates the crontab with the updates tmp file
    go_back
    fi
    fi
}

####################################################
# Function for removing all crontab jobs           #
####################################################
remove_all_jobs(){
    cat << EOF
    1. Delete all tasks in list
    2. Press any other key to go back to main menu
EOF

    read -p "Please select one of the above: " choice

    # If statement for users choice input
    if [ $choice -eq 1 ]
    then
    echo "All tasks in list deleted!"
    > /tmp/Crontab            # Deletes everything in the file
    crontab /tmp/Crontab      # Updates the crontab with blank file
    else
    main_menu
    fi

    go_back
}

main_menu
