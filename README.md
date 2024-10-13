# Bash Russian Roulette (BRR)  

_**Created by Neptune, with love**_

Not so complex bash script game where you can play the infamous Russian Roulette on your PC!

### I CREATED THIS SCRIPT WITH PURE EDUCATIONAL AND ENTERTAINMENT PURPOSES IN MIND. I CLAIM NO RESPONSIBILITY IF YOU DEAL ANY KIND OF DAMAGE TO YOUR SYSTEM. THE COMMANDS INSIDE THIS SCRIPT ARE DANGEROUS AND SHOULD NOT BE MESSED WITH!

**RUN IN A VIRTUAL MACHINE**

![Screenshot from 2024-10-12 23-11-46](https://github.com/user-attachments/assets/5ab04dd8-8b79-44a1-8c7c-93973703049c)

## Intro

So, the idea of a computer version of the Russian Roulette game seemed like a pretty fun and interesting idea to develop and create for me. It's nothing new too, there's a lot of "one-liner roulettes" that consists in picking a random number between two fixed digits and executing "rm -rf --no-preserve-root /" if you're unlucky. The thing is that these roulettes are ok, but they don't even have consistency in mind because you have to execute the script again and again to lose, that's like loading a bullet in the revolver, shoot it, throw it away if you didn't delete your entire OS and repeating the process again and again! The correct way of doing this should be storing this randomly generated number inside a variable and then give the user the option to interact with the script. This way, the probability of losing increases as you get far into the rounds. It's a very simple thing to understand, and I was very bored, so I started making my own version.

This is not a very complex or complicated script, in fact it's one of my first scripts ever!, that's why I'm sorry if something doesn't work perfect on every GNU/Linux distribution. I made it in a way that (as far as I know) it's very compatible with any distro (you don't need to install any package aside from the script itself). 

This was a very fun thing to make, so I can say that I'm very satisfied with the final result. You can make improvements and upgrade the code if you want tho, do whatever you want. Feel free to read it, understand it and change it as you please (but be very cautious about executing it and comment out every line that has some form of command execution).

Now, let's talk about the execution of the script and the roulette itself.

## INSTALLATION

You can download the contents of this repository as a zip file and unzip it, download every individual file or use git clone (you will need to install the git package in that case). If you have git installed, run:

    git clone https://github.com/wMsneptune/Bash-Russian-Roulette-BRR-.git && cd Bash-Russian-Roulette-BRR-

## 0) COMMANDS

**0.1)** Open a terminal with CTRL+ALT+T or search in your applications' menu/search bar for some form of terminal emulator. Then, navigate to the folder where the script and this file are stored with cd.

    cd <folder path>

**0.2.1)** The script needs root privileges to run because of the nature of the commands that it contains (and also as a failsafe to prevent normal users damaging the system). Each number represents an argument that is necessary for selecting the method that the roulette will use when you lose to make the operative system or your disk a mess **(SEE ITEM 5)**. Before executing sudo, make sure you can use it and that you are in the sudoers file in the /etc/ directory. 

    chmod +x RUSSIANROULETTE.sh
    
    sudo ./RUSSIANROULETTE.sh <1, 2 or 3>
    
You can also execute:

    su

You will be prompted for root's password. When the correct password is introduced you will become root and now you can run the script without using sudo (don't forget about the argument!).

    ./RUSSIANROULETTE.sh <1, 2 or 3>

## 1) SHELLTRAP AND SIGNALS

![Screenshot from 2024-10-12 21-16-41](https://github.com/user-attachments/assets/84b13071-2799-410d-ab87-797da46dd2b6)

First, we have a shell trap that ignores different signals and keeps the script running once executed. The ignored signals are SIGINT (Interrupt | CTRL + C), SIGTSTP (Terminal Stop | CTRL + Z), SIGQUIT (Exit | CTRL + \ ) & SIGTERM (Terminate | Can only be sent with kill or programmatically). I made this trap in the first place because I must ensure that the execution of the script can't be interrupted in any way, so the deletion of important files, the entire file system or the disk is inevitable. The only signal that can't be handled in any way is SIGKILL. This signal can be sent with the kill command or on a GUI process manager. Also, I didn't include the signal SIGHUP (Hangup the process), because I don't see it like a necessary component to add. If one of the execution methods is evaluated, there's nothing to do really, so you can kill the roulette itself by closing the terminal window. For sending the SIGKILL signal to the process, you need to run:

![Screenshot from 2024-10-12 22-12-57](https://github.com/user-attachments/assets/e41f18cb-1e9d-48d0-8cb8-824c027cbfcc)

You can also do:    

    su
   
    kill -9 <PID of /bin/bash>

## 2) FIRST IF STATEMENT: FAILSAFE

![Screenshot from 2024-10-13 18-30-44](https://github.com/user-attachments/assets/66437bbc-302f-4214-ba30-ee6684fc6fa5)

Right next to the shell trap, we have the IF statement that checks whether your EUID is equal to 0 (this is the way for checking that you are executing the script with administrative privileges). Root is the superuser in any GNU/Linux system and his EUID or UID it's always equal to 0, users in the system have UIDs different from 0. If the IF statement concludes that your EUID is non-equal to zero, then the script exits with error code 1.

## 3) PID

![Screenshot from 2024-10-13 18-32-21](https://github.com/user-attachments/assets/a0d9ba4c-7981-4d54-9509-d767f00e525e)

"PID" is the ID of the process (the script). This value is stored in the variable PID (original at best) for later use in the kill switch in the sixth round. I decided to use $$ instead of $BASH_PID because it offers major compatibility with versions of bash older than 4.0. As I said in the comments of the script, don't use it with subshells, you can mess things up, and you are better using $BASH_PID, this way you'll always get the PID of the current process in execution.

## 4) DISK VARIABLE

![Screenshot from 2024-10-13 18-33-59](https://github.com/user-attachments/assets/a4747d94-4dd4-4c53-9a94-05d791684d06)

The variable $DISK executes a command that obtains the name of your physical disk. The command uses the tool df, an integrated core util of the system that shows information about the file system. "tail -n +2" skips the first line of the output of the command and discards it, "awk '{print 1}'" extracts the field which has the partition associated with the / of the file system, and "sed 's/[0-9]*//g'" deletes any number next to the name of the disk. With all of that, you got a consistent command that works no matter what name your disk has. Works with LVM and VMs, didn't test with encrypted machines. The result is stored in the variable, used later in the second execution method.

## 5) EXECUTION METHODS

![Screenshot from 2024-10-13 18-38-10](https://github.com/user-attachments/assets/8e71a8e1-0203-4a39-ad7a-38e9dea107d2)

I made 3 different commands that will be executed when you lose. You can choose what method the roulette will use by passing the argument I mentioned earlier. The selected argument will be stored at the variable $SELECTED. Then, this variable will be used in a case construct. If the argument equals 1, the newly created $BULLET_TYPE variable will be equal to the first execution method, and so on and so forth. 

**5.1)** The first and the most classic method is the "rm -rf --no-preserve-root /". The command rm refers to the action of removing files or directories. Since every single thing in GNU/Linux is a file or directory, you can delete everything from existence. The switch -r means "recursive", finds directories, subdirectories and files and deletes them, and the switch -f means "force", which never prompts what files/directories are being removed and ignores errors and warnings. The option "--no-preserve-root /" ignores a failsafe that doesn't let you delete the / directory. The STDOUT and STDERR of this command is then sent to /dev/null (no terminal output is shown), and the process is run in the background thanks to the last "&". "nohup" is a command that lets you manage the SIGHUP signal (for uninterrupted execution even if the terminal closes). You can still (theoretically) interrupt any of the methods I included to the roulette detecting the PID of the newly created process and sending the SIGKILL signal, but damage will be dealt to the system anyway, and you can only do that if you're fast enough (or maybe with a external script).

**5.2)** Second method is very funny to me. Using the data stored in the variable $DISK and the dd tool (aka disk destroyer), it overwrites the entire disk with zeroes using /dev/zero, a special device that contains a stream of infinite binary zeroes. The result is completely destructive, and the disk is absolutely wiped to the point that it's very hard to recover the data that existed there before the execution of the command. The execution time depends on factors like the write speed and other characteristics of your disk. SSDs are way faster than HHDs. A +500GB HHD could take hours to overwrite with zeroes, but an SSD is way faster and can take minutes from what I tested. 

**5.3)** The final and one of the most creatives, the "file emptier". This command uses find, a very common tool available in every GNU/Linux system, and makes a recursive search from the / directory of every file on the file system (find / -type f). Then, it executes the copy option (-exec cp /dev/null "{}" \;) and overwrites the contents of every single file with the contents of /dev/null (which is empty), essentially emptying all the existing files on the system. There's no need to explain the consequences of the execution of the commands I previously mentioned, so, don't play with fire if you don't want to get burned.

## 6) ERROR CODES AND SANITIZATION

![Screenshot from 2024-10-13 18-52-41](https://github.com/user-attachments/assets/5b0dc770-eecd-4981-bbcc-ac102f6391f4)
![Screenshot from 2024-10-13 18-53-06](https://github.com/user-attachments/assets/fe16dcdc-c3a0-461c-81bf-332a7bdffc57)

As a recent correction, I re-organized the code and included different IF statements to check, verify and sanitize variables and the argument that needs to be introduced for the program to run. I fixed a flaw where you could put a special character and the program would still run anyway. This was a significant error, because the program couldn't select one of the three execution methods to evaluate. Also, I included quotes to the variables evaluated in the for loop and in the final while loop to mitigate any error that could happen. 

There can be 4 error codes. Error code 1 happens when you don't execute the roulette as root (the failsafe). Error code 2 appears when less or more than one argument are introduced in the command line when you are trying to execute the script. Error code 3 triggers when you put a character non-equal to number 1, 2 or 3 (it also triggers when you put special characters). Finally, I made a final IF statement to check whether the $BULLET_IN_CHAMBER variable has a number between 1 and 6 stored. This is a little bit overkill because the shuf command with the options I used will always produce an integer of those specifics, but better be sure y'know. If somehow the variable has a number non-equal to 1-6, error code 4 triggers and execution stops.

If you want to check the exit code after executing the script (or after running any command or program), you can run:

    echo $?

## 7) SHUFFLE, BULLET AND ROUNDS

![Screenshot from 2024-10-13 18-55-31](https://github.com/user-attachments/assets/cbe5b002-c80b-4658-9b68-39760d3b3243)
![Screenshot from 2024-10-13 18-55-52](https://github.com/user-attachments/assets/569fefe1-60c3-4432-90f0-dab917072303)

The probability of the bullet being on a certain position of the "cylinder" of the revolver is given by the command "shuf -i 1-6 -n1", which produces a single random integer between 1-6 representing the bullet and then it's stored in the $BULLET_IN_CHAMBER variable. The game consists of 6 rounds, 6 opportunities where you can shoot the revolver (or kill the script if you achieve to survive until the last round). To make the game dynamic, a for loop is implemented to see if the randomly generated integer is equal to the number of the round. If this is equal, then you're dead and the script takes the chosen execution method and then runs it in the background, unlinking it from the terminal where you play the game. That process is also "shell trapped", which means that it ignores the previously mentioned signals except SIGKILL, but it's already too late if the command is executed.

## 8) FINAL WHILE LOOP AND CASE

![Screenshot from 2024-10-13 18-56-15](https://github.com/user-attachments/assets/5f1657c8-c770-4aa5-8740-a11a9ce744e1)
![Screenshot from 2024-10-13 18-56-33](https://github.com/user-attachments/assets/e10b73db-b97f-4578-8c20-105e3092bac6)

The last part of the program consists firstly of a printf line showing you the options available and the read command. I made this part this way because putting the printf/read command inside the while loop resulted in the repetition of the prompt when the default case was triggered. In other words, if you mistype the keywords, the first message would appear again and again. The options are simple, you can kill the process by typing "KILL" and the SIGKILL signal will be sent using the $PID variable of the start of the script. If you chose to type "SHOOT" however... no explanation needed. 

## EXTRA: DECORATIONS

![Screenshot from 2024-10-13 13-39-38](https://github.com/user-attachments/assets/e2549988-6409-4dc2-9771-a1789c572938)
![Screenshot from 2024-10-13 13-54-22](https://github.com/user-attachments/assets/68c49d5b-221d-4a6c-a371-1fc8e4d13281)
![Screenshot from 2024-10-13 13-40-09](https://github.com/user-attachments/assets/695bb24a-aac9-4e5b-8667-3ed4ae19b5f5)
![Screenshot from 2024-10-13 18-58-35](https://github.com/user-attachments/assets/fc8ab2a4-df26-4502-9bd6-52c730cf1df5)

Firstly, I implemented some colors to make the program more good-looking and original. Managing these colors was something tedious (especially when I wanted to apply them in the read commands), but the final is result is 100% worth it. I think I could have used printf instead of echo with the -e flag in everything, but it's not that important and I wanted to preserve the empty lines for better readabilty. In addition, I included a banner, an animated spinner to simulate the wait time when the script loads the revolver, a while loop in which the script asks you if you're ready to play and and ascii art of Oppenheimer's face when you select to shoot yourself in the last round. 

## ACKNOWLEDGEMENTS

This was the entire explanation. For more info, you can see the comments I made or ask me whatever you want. Thanks to my friend Sloudy, he motivated me to keep coding this silly game <3. Hope you enjoy and win the game in your main PC, my friend!

![F3GWSkFboAAho4O](https://github.com/user-attachments/assets/2f9a48e7-cacf-4e2f-ba00-2638bbaf2ce7)
