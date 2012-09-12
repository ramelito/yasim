#!/bin/bash
#    Yet another simple identity management
#    Copyright (C) 2012  Anton Komarov
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


sqlite3opts="-header"

help_usage() {

echo "	
Yasim usage
	--help, -h		show this information

Database
	--init			database initialize
	--db-scheme		database scheme (mandatory)
	--db-file		database filename (mandatory)

Namespaces
	--add-ns		add new namespace
	--expire-ns		expire existing namespace
	--show-all-ns		show all namespaces
	--show-active-ns	show active namespaces
	--show-expired-ns	show expired namespaces
	--ns-id			namespace id (mandatory)
	--ns-name		namespace name (mandatory)
	--ns-desc		namespace description (mandatory)
	--ns-btime		namespace begin of use time (optional)
	--ns-etime		namespace expire of use time (optional)
	--ns-tsn-id		namespace transaction id to expire (mandatory)

User roles (with valid ns-id)
        --add-ur                add new user role
        --expire-ur             expire existing user role
        --show-all-ur           show all user roles
        --show-active-ur        show active user roles
        --show-expired-ur       show expired user roles
        --ur-id                 user role id (mandatory)
        --ur-name               user role name (mandatory)
        --ur-desc               user role description (mandatory)
        --ur-btime              user role begin of use time (optional)
        --ur-etime              user role expire of use time (optional)
        --ur-tsn-id             user role transaction id to expire (mandatory)
"
}

#Global funcs

init_db() {

	[ "X$db_file" == "X" ] && exit 1
	[ -f $db_file ] && rm $db_file
	[ -f $db_scheme ] && sqlite3 $db_file < $db_scheme || echo "Database scheme not exists!"

}

check_db () {

	msg="Init db: ./yasim.sh --init --db-scheme <db-scheme-file> --db-file <db-filename>"
	[ -f $db_file ] || echo $msg

}

check_ns () {

	msg="This operation works only with valid ns-id: ./yasim.sh --ns-id <ns_id>\n"
	msg="${msg}Valid ns-id can be found with command: ./yasim.sh --show-active-ns"
	[ "X$ns_id" == "X" ] && echo -e $msg
	[ "X$ns_id" == "X" ] && exit 1
}

#Namespace funcs

add_ns () {

	[ "X$ns_id" == "X" ] && exit 1
	[ "X$ns_name" == "X" ] && exit 1
	[ "X$ns_desc" == "X" ] && exit 1
	[ "X$ns_btime" == "X" ] && ns_btime=$(date "+%Y-%m-%d %H:%M:%S")
	q="insert or rollback into namespaces (ns_id,ns_name,ns_desc,ns_btime)"
	q="$q values ($ns_id,'$ns_name','$ns_desc','$ns_btime');"
	sqlite3 $sqlite3opts $db_file "$q"

}

expire_ns () {

	[ "X$ns_tsn_id" == "X" ] && exit 1
	[ "X$ns_etime" == "X" ] && ns_etime=$(date "+%Y-%m-%d %H:%M:%S")
	q="insert or rollback into ns_exp (id,ns_etime) values ($ns_tsn_id,'$ns_etime');"
	sqlite3 $sqlite3opts $db_file "$q"

}

show_all_ns () {

	q="select * from namespaces order by ns_btime desc"
	sqlite3 $sqlite3opts $db_file "$q"
}

show_active_ns () {

	q="select * from namespaces"
	q="$q where id not in"
	q="$q (select id from ns_exp)"
	q="$q and namespaces.ns_btime < datetime('now','localtime')"
	q="$q order by ns_btime desc"
	sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_ns () {

	q="select namespaces.*, ns_exp.ns_etime from namespaces, ns_exp"
	q="$q where namespaces.id==ns_exp.id and ns_exp.ns_etime < datetime('now','localtime')"
	q="$q order by ns_exp.ns_etime desc"
	sqlite3 $sqlite3opts $db_file "$q"
}

#User roles funcs

add_ur () {
	
	check_ns
        [ "X$ur_id" == "X" ] && exit 1
        [ "X$ur_name" == "X" ] && exit 1
        [ "X$ur_desc" == "X" ] && exit 1
        [ "X$ur_btime" == "X" ] && ur_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into user_roles (ur_id,ur_name,ur_desc,ur_btime,ns_id)"
        q="$q values ($ur_id,'$ur_name','$ur_desc','$ur_btime',$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_ur () {

        [ "X$ur_tsn_id" == "X" ] && exit 1
        [ "X$ur_etime" == "X" ] && ur_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into ur_exp (id,ur_etime) values ($ur_tsn_id,'$ur_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_ur () {

	check_ns
        q="select * from user_roles where ns_id=$ns_id order by ur_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_ur () {

	check_ns
        q="select * from user_roles"
        q="$q where id not in"
	q="$q (select id from ur_exp)"
	q="$q and user_roles.ur_btime < datetime('now','localtime')"
	q="$q and ns_id=$ns_id"
        q="$q order by ur_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_ur () {

	check_ns
        q="select user_roles.*, ur_exp.ur_etime from user_roles, ur_exp"
        q="$q where user_roles.id==ur_exp.id"
	q="$q and ur_exp.ur_etime < datetime('now','localtime')"
	q="$q and user_roles.ns_id=$ns_id"
        q="$q order by ur_exp.ur_etime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

shortopts="h"

#global keys
longopts="help,init,db-file:,db-scheme:"

#namespace keys
longopts="$longopts,add-ns,expire-ns,show-all-ns,show-active-ns,show-expired-ns"
longopts="$longopts,ns-id:,ns-name:,ns-desc:,ns-btime:,ns-etime:,ns-tsn-id:"

#user roles keys
longopts="$longopts,add-ur,expire-ur,show-all-ur,show-active-ur,show-expired-ur"
longopts="$longopts,ur-id:,ur-name:,ur-desc:,ur-btime:,ur-etime:,ur-tsn-id:"

t=$(getopt -o $shortopts --long $longopts -n 'yasim' -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$t"

while true ; do
	case "$1" in
		-h|--help) help_usage ; break ;;
		--db-scheme) db_scheme=$2; shift 2;;
		--db-file) db_file=$2; shift 2;;
		--init) init_db=1; shift ;;
		--ns-id) ns_id=$2; shift 2;;
		--ns-name) ns_name=$2; shift 2;;
		--ns-desc) ns_desc=$2; shift 2;;
		--ns-btime) ns_btime=$2; shift 2;;
		--ns-etime) ns_etime=$2; shift 2;;
		--ns-tsn-id) ns_tsn_id=$2; shift 2;;
		--add-ns) add_ns=1; shift;;
		--expire-ns) expire_ns=1; shift;;
		--show-all-ns) show_all_ns=1; shift;;
		--show-active-ns) show_active_ns=1; shift;;
		--show-expired-ns) show_expired_ns=1; shift;;
		--ur-id) ur_id=$2; shift 2;;
                --ur-name) ur_name=$2; shift 2;;
                --ur-desc) ur_desc=$2; shift 2;;
                --ur-btime) ur_btime=$2; shift 2;;
                --ur-etime) ur_etime=$2; shift 2;;
                --ur-tsn-id) ur_tsn_id=$2; shift 2;;
                --add-ur) add_ur=1; shift;;
                --expire-ur) expire_ur=1; shift;;
                --show-all-ur) show_all_ur=1; shift;;
                --show-active-ur) show_active_ur=1; shift;;
                --show-expired-ur) show_expired_ur=1; shift;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done

#Global block

[ "$init_db" == 1 ] && init_db || check_db


#Namespace block

[ "$add_ns" == 1 ] && add_ns

[ "$expire_ns" == 1 ] && expire_ns

[ "$show_all_ns" == 1 ] && show_all_ns

[ "$show_active_ns" == 1 ] && show_active_ns

[ "$show_expired_ns" == 1 ] && show_expired_ns

#User roles block

[ "$add_ur" == 1 ] && add_ur

[ "$expire_ur" == 1 ] && expire_ur

[ "$show_all_ur" == 1 ] && show_all_ur

[ "$show_active_ur" == 1 ] && show_active_ur

[ "$show_expired_ur" == 1 ] && show_expired_ur
