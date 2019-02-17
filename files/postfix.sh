#!/bin/bash
# Author: Daniel Gordi (danitfk)
# Date: 02/Feb/2019
function help {
	echo "Usage: ./postfix.sh [count_queue|count_deferred|count_all|delete|delete_deferred|flush|delayed_reason|top_sender|top_recipients|top_domain]"
	echo "       count_fast: Count all files in /var/spool/postfix with find command (not really accuierd by gives you the idea)"
	echo "       count_deferred: Display only deferred emails in queue"
	echo "       count_all: Display all emails in queue with separated statistics for active and deferred emails in queue"
	echo "       delete: Delete all emails in queue"
        echo "       delete_deferred: Delete only deferred emails in queue"
	echo "       delete_domain: Delete only emails with specific domain. eg: ./postfix.sh delete_domain yahoo.com"
        echo "       flush: Process all emails in queue immediately"
	echo "       delayed_reason: Display reasons to block our emails"
	echo "       top_sender: Display top email senders in queue"
	echo "       top_recipients: Display top 30 email recipients in queue"
	echo "       top_domain: Display top 30 domain name of recipients email in queue"
	echo "       monitoring_active: [SPECIAL-FOR-ZABBIX] Print only number of Active mails in queue"
        echo "       monitoring_deferred: [SPECIAL-FOR-ZABBIX] Print only number of Deferred mails in queue"
        echo "       monitoring_all: [SPECIAL-FOR-ZABBIX] Print only number of All mails in queue"


}

function sudo_check {
	if [ "$(whoami)" != "root" ]; then
       	 echo "Sorry, You must run this script with root privileges"
      	 exit 1
	fi
}
function count_all {
	postqueue -j | cut -d"\"" -f4 | sort | uniq -c > /tmp/postfix.txt
	active_queue=$(grep active /tmp/postfix.txt | awk {'print $1'})
	if [ "$active_queue" -lt 1 ]; then
		active_queue="0"
	fi
	deferred_queue=$(grep deferred /tmp/postfix.txt | awk {'print $1'})
	total_queue=$(expr $active_queue + $deferred_queue)
	echo "TOTAL EMAILS IN QUEUE: $total_queue"
	echo "ACTIVE EMAILS IN QUEUE: $active_queue"
	echo "DEFERRED EMAILS IN QUEUE: $deferred_queue"

}
function count_fast {
	sudo_check
	sudo find /var/spool/postfix -type f | wc -l

}

function count_deferred {
	count=$(postqueue -j | cut -d"\"" -f4 | grep deferred | wc -l)
	echo "DEFERRED EMAILS IN QUEUE: $count"
}

function delete {
	sudo_check
	sudo postsuper -d ALL
}

function delete_deferred {
	sudo_check
	sudo postsuper -d ALL deferred
}

function flush {
	sudo_check
	sudo postqueue -f
}


function delayed_reason {
	echo "   Count - Reason"
	postqueue -j | grep -o "delay_reason.*" | cut -d"\"" -f3 | grep -o said.*  | sed 's/said: //g' | sort | uniq -c
}

function top_sender {
	echo "Top Sender in Queue"
	postqueue -j | grep -o sender.* | cut -d"\"" -f3 | sort | uniq -c | sort -nr
}


function top_recipients {
	postqueue -j | grep -o address.* | cut -d"," -f1 | sed 's/address": "//g' | sed 's/"//g' | sort | uniq -c | sort -nr | head -n30
}

function top_domain {
	postqueue -j | grep -o address.* | cut -d"," -f1 | sed 's/address": "//g' | sed 's/"//g' | grep -o "@.*" | sed 's/@//g' | cut -d "}" -f1 | sort | uniq -c | sort -nr | head -n30
}

function delete_domain {
	sudo_check
	if [ "$arg1" == "" ];then
		echo "Please provide domain name."
		echo "Usage: ./postfix.sh delete_domain yahoo.com"
		exit 1
	fi
	ids=$(postqueue -j | grep $arg1 | grep -o queue_id.* | cut -d"\"" -f3)
	for id in $ids
	do
		sudo postsuper -d $id
	done


}

function monitoring_active {
	export COUNT=$(postqueue -j | grep -o queue_name.* | cut -d"\"" -f3 | grep active | wc -l)
	print_number
}

function monitoring_deferred {
	export COUNT=$(postqueue -j | grep -o queue_name.* | cut -d"\"" -f3 | grep deferred | wc -l)
	print_number
}

function monitoring_all {
	export COUNT=$(postqueue -j | grep -o queue_name.* | cut -d"\"" -f3 | wc -l)
	print_number
}

function print_number {
	if [ "$COUNT" == "" ] || [ "$COUNT" -lt 1 ]; then
		export COUNT="0"
		echo $COUNT
	else
		echo $COUNT
	fi
	unset COUNT
}
if [ "$1" == "" ]; then

	help
	exit 1
else
        if [[ "$2" != "" ]]; then
                export arg1=$2
        else
                export unset arg1
        fi

	$1 $arg1
	exit 0

fi

help
exit 1

1
