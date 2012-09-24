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

test -f $HOME/.yasimrc && source $HOME/.yasimrc

help_usage() {

echo "	
Yasim usage
	--help, -h		show this information

Ssh
	--root-login		ssh root login for execution on devices
	--root-sshkey		ssh identity file for execution on devices

Database
	--init			database initialize (previous db will be DELETED!)
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

User groups (with valid ns-id)
        --add-ug                add new user group
        --expire-ug             expire existing user group
        --show-all-ug           show all user groups
        --show-active-ug        show active user groups
        --show-expired-ug       show expired user groups
        --ug-id                 user group id (mandatory)
        --ug-name               user group name (mandatory)
        --ug-desc               user group description (mandatory)
        --ug-btime              user group begin of use time (optional)
        --ug-etime              user group expire of use time (optional)
        --ug-tsn-id             user group transaction id to expire (mandatory)

User role and group binding (with valid ns-id, ur-id and ug-id)
	--add-urg		add bind between user role and group
	--expire-urg		expire bind between user role and group
        --show-all-urg          show all user role and group bindings
        --show-active-urg       show active user role and group bindings
        --show-expired-urg      show expired user role and group bindings
	--urg-id		user role and group bind id (mandatory)
	--urg-btime		user role and group binding begin of use time (optional)
	--urg-etime		user role and group binding end of use time (optional)
	--urg-tsn-id		user role and group transaction id to expire (mandatory)

Users (with valid ns-id)
        --add-usr                add new user
        --expire-usr             expire existing user
        --show-all-usr           show all users
        --show-active-usr        show active users
        --show-expired-usr       show expired users
        --usr-id                 user id (mandatory)
        --usr-name               user name (mandatory)
        --usr-btime              user begin of use time (optional)
        --usr-etime              user expire of use time (optional)
        --usr-tsn-id             user transaction id to expire (mandatory)

User info (with valid ns-id)
        --add-ui                add new user info
        --expire-ui             expire existing user info
        --show-all-ui           show all users
        --show-active-ui        show active users
        --show-expired-ui       show expired users
        --ui-cname              user info first name (optional)
        --ui-sname              user info last name (optional)
        --ui-company            user info company (optional)
        --ui-email              user info email (optional)
        --ui-phone              user info phone (optional)
        --ui-desc               user info description (optional)
        --ui-btime              user info begin of use time (optional)
        --ui-etime              user info expire of use time (optional)
        --ui-tsn-id             user info transaction id to expire (mandatory)

User and group binding (with valid ns-id, usr-id and ug-id)
        --add-uug               add bind between user and group
        --expire-uug            expire bind between user and group
        --show-all-uug          show all user and group bindings
        --show-active-uug       show active user and group bindings
        --show-expired-uug      show expired user and group bindings
        --uug-id                user and group bind id (mandatory)
        --uug-btime             user and group binding begin of use time (optional)
        --uug-etime             user and group binding end of use time (optional)
        --uug-tsn-id            user and group transaction id to expire (mandatory)

Device roles (with valid ns-id)
        --add-dr                add new device role
        --expire-dr             expire existing device role
        --show-all-dr           show all device roles
        --show-active-dr        show active device roles
        --show-expired-dr       show expired device roles
        --dr-id                 device role id (mandatory)
        --dr-name               device role name (mandatory)
        --dr-desc               device role description (mandatory)
        --dr-btime              device role begin of use time (optional)
        --dr-etime              device role expire of use time (optional)
        --dr-tsn-id             device role transaction id to expire (mandatory)

Device groups (with valid ns-id)
        --add-dg                add new device group
        --expire-dg             expire existing device group
        --show-all-dg           show all device groups
        --show-active-dg        show active device groups
        --show-expired-dg       show expired device groups
        --dg-id                 device group id (mandatory)
        --dg-name               device group name (mandatory)
        --dg-desc               device group description (mandatory)
        --dg-btime              device group begin of use time (optional)
        --dg-etime              device group expire of use time (optional)
        --dg-tsn-id             device group transaction id to expire (mandatory)

Devices (with valid ns-id)
        --add-dev                add new device
        --expire-dev             expire existing device
        --show-all-dev           show all users
        --show-active-dev        show active users
        --show-expired-dev       show expired users
        --dev-id                 device id (mandatory)
        --dev-name               device name (mandatory)
        --dev-desc               device description (mandatory)
        --dev-btime              device begin of use time (optional)
        --dev-etime              device expire of use time (optional)
        --dev-tsn-id             device transaction id to expire (mandatory)

Device role and group binding (with valid ns-id, dr-id and dg-id)
        --add-drg               add bind between device role and group
        --expire-drg            expire bind between device role and group
        --show-all-drg          show all device role and group bindings
        --show-active-drg       show active device role and group bindings
        --show-expired-drg      show expired device role and group bindings
        --drg-id                device role and group bind id (mandatory)
        --drg-btime             device role and group binding begin of use time (optional)
        --drg-etime             device role and group binding end of use time (optional)
        --drg-tsn-id            device role and group transaction id to expire (mandatory)

Device and group binding (with valid ns-id, dev-id and dg-id)
        --add-ddg               add bind between device and group
        --expire-ddg            expire bind between device and group
        --show-all-ddg          show all device and group bindings
        --show-active-ddg       show active device and group bindings
        --show-expired-ddg      show expired device and group bindings
        --ddg-id                device and group bind id (mandatory)
        --ddg-btime             device and group binding begin of use time (optional)
        --ddg-etime             device and group binding end of use time (optional)
        --ddg-tsn-id            device and group transaction id to expire (mandatory)

Device and user roles binding (with valid ns-id, dr-id and ur-id)
        --add-udr               add bind between device and user roles
        --expire-udr            expire bind between device and user roles
        --show-all-udr          show all device and user roles bindings
        --show-active-udr       show active device and user roles bindings
        --show-expired-udr      show expired device and user roles bindings
        --udr-id                device and user roles bind id (mandatory)
        --udr-btime             device and user roles binding begin of use time (optional)
        --udr-etime             device and user roles binding end of use time (optional)
        --udr-tsn-id            device and user roles transaction id to expire (mandatory)

Additional show stuff
	--show-uur-map		show all active user and user role mappings
	--show-ddr-map		show all active device and device role mappings
	--show-ud-map		show all active user and device mappings

Executions
	--pretend		show what will do without actual write actions
	--exec-scnA		removing users from devices
	--exec-scnB		add new users on devices
	--exec-scnC		add new user on devices (with valid usr-name)
	--exec-scnD		add users on a new device (with valid dev-name)
"
}

#Global funcs

chk_sw () {

	local failed=0
	local msg_fail="Check sqlite3. Failed."
	type -P sqlite3 &>/dev/null || (echo $msg_fail; failed=1)

	msg_fail="Check ssh. Failed."
	type -P ssh &>/dev/null || (echo $msg_fail; failed=1)

	msg_fail="Check diff. Failed."
	type -P diff &>/dev/null || (echo $msg_fail; failed=1)

	msg_fail="Check cat. Failed."
	type -P cat &>/dev/null || (echo $msg_fail; failed=1)

	msg_fail="Check grep. Failed."
	type -P grep &>/dev/null || (echo $msg_fail; failed=1)
	
	[ $failed -eq 1 ] && exit 1
}

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

check_root_ssh () {

	msg="Provide valid root login and ssh key for execution.\n"
	msg="${msg}./yasim.sh --root-login <root-login> --root-sshkey <root-identity-file>"
	[ "X$root_sshkey" == "X" -o "X$root_login" == "X" ] && echo -e "$msg"
	[ "X$root_sshkey" == "X" -o "X$root_login" == "X" ] && exit 1
	sshopts="-l $root_login -i $root_sshkey"
	scpopts="-i $root_sshkey $root_login@"
}

check_keys_repo () {

	msg="Provide valid path to keys repo.\n"
	msg="${msg}./yasim.sh --keys-repo <path_to_keys_repo>"
	[ "X$keys_repo" == "X" ] && echo -e "$msg"
	[ "X$keys_repo" == "X" ] && echo 1 
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

	local q="select * from namespaces order by ns_btime desc"
	sqlite3 $sqlite3opts $db_file "$q"
}

show_active_ns () {

	local q="select * from namespaces"
	q="$q where id not in (select id from ns_exp)"
	q="$q and namespaces.ns_btime < datetime('now','localtime')"
	q="$q order by ns_btime desc"
	sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_ns () {

	local q="select * from namespaces"
	q="$q inner join ns_exp on namespaces.id=ns_exp.id"
	q="$q where ns_exp.ns_etime < datetime('now','localtime')"
	q="$q group by namespaces.id"
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
        local q="select * from user_roles where ns_id=$ns_id order by ur_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_ur () {

	check_ns
        local q="select * from user_roles"
        q="$q where id not in (select id from ur_exp)"
	q="$q and user_roles.ur_btime < datetime('now','localtime')"
	q="$q and ns_id=$ns_id"
        q="$q order by ur_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_ur () {

	check_ns
        local q="select * from user_roles"
	q="$q inner join ur_exp on ur_exp.id=user_roles.id"
	q="$q where ur_exp.ur_etime < datetime('now','localtime')"
	q="$q and user_roles.ns_id=$ns_id"
	q="$q group by user_roles.id"
        q="$q order by ur_exp.ur_etime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#User groups funcs

add_ug () {

        check_ns
        [ "X$ug_id" == "X" ] && exit 1
        [ "X$ug_name" == "X" ] && exit 1
        [ "X$ug_desc" == "X" ] && exit 1
        [ "X$ug_btime" == "X" ] && ug_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into user_groups (ug_id,ug_name,ug_desc,ug_btime,ns_id)"
        q="$q values ($ug_id,'$ug_name','$ug_desc','$ug_btime',$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_ug () {

        [ "X$ug_tsn_id" == "X" ] && exit 1
        [ "X$ug_etime" == "X" ] && ug_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into ug_exp (id,ug_etime) values ($ug_tsn_id,'$ug_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}


show_all_ug () {

        check_ns
        local q="select * from user_groups where ns_id=$ns_id order by ug_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_ug () {

        check_ns
        local q="select * from user_groups"
        q="$q where id not in (select id from ug_exp)"
        q="$q and user_groups.ug_btime < datetime('now','localtime')"
        q="$q and ns_id=$ns_id"
        q="$q order by ug_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_ug () {

        check_ns
        local q="select * from user_groups"
	q="$q inner join ug_exp on ug_exp.id=user_groups.id"
        q="$q where ug_exp.ug_etime < datetime('now','localtime')"
        q="$q and user_groups.ns_id=$ns_id"
	q="$q group by user_groups.id"
        q="$q order by ug_exp.ug_etime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#User role and group binding funcs

add_urg () {

        check_ns
        [ "X$urg_id" == "X" ] && exit 1
	[ "X$ur_id" == "X" ] && exit 1
	[ "X$ug_id" == "X" ] && exit 1
        [ "X$urg_btime" == "X" ] && urg_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into ur_ug_map (urg_id,urg_btime,ur_id,ug_id,ns_id)"
        q="$q values ($urg_id,'$urg_btime',$ur_id,$ug_id,$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_urg () {

        [ "X$urg_tsn_id" == "X" ] && exit 1
        [ "X$urg_etime" == "X" ] && urg_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into urg_exp (id,urg_etime) values ($urg_tsn_id,'$urg_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_urg () {

        check_ns
	local q="select ur_ug_map.id, ur_ug_map.urg_id, ur_ug_map.ug_id, ur_ug_map.ur_id,"
	q="$q ur_ug_map.urg_btime, ur_ug_map.ns_id,"
	q="$q user_groups.ug_name, user_roles.ur_name"
	q="$q from ur_ug_map"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
	q="$q where ur_ug_map.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
	q="$q group by ur_ug_map.id"
	q="$q order by user_groups.ug_id, user_roles.ur_id, urg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_urg () {

        check_ns
	local q="select ur_ug_map.id, ur_ug_map.urg_id, ur_ug_map.ug_id, ur_ug_map.ur_id,"
	q="$q ur_ug_map.urg_btime, ur_ug_map.ns_id,"
	q="$q user_groups.ug_name, user_roles.ur_name"
	q="$q from ur_ug_map"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
        q="$q where ur_ug_map.id not in (select id from urg_exp)"
        q="$q and user_groups.id not in (select id from ug_exp)"
        q="$q and user_roles.id not in (select id from ur_exp)"
        q="$q and ur_ug_map.urg_btime < datetime('now','localtime')"
        q="$q and user_groups.ug_btime < datetime('now','localtime')"
        q="$q and user_roles.ur_btime < datetime('now','localtime')"
        q="$q and ur_ug_map.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
	q="$q group by ur_ug_map.id"
	q="$q order by user_groups.ug_id, user_roles.ur_id, urg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_urg () {

        check_ns
	local q="select ur_ug_map.id, ur_ug_map.urg_id, ur_ug_map.ug_id, ur_ug_map.ur_id,"
	q="$q ur_ug_map.urg_btime, ur_ug_map.ns_id,"
	q="$q user_groups.ug_name, user_roles.ur_name, urg_exp.urg_etime"
	q="$q from ur_ug_map"
	q="$q inner join urg_exp on urg_exp.id=ur_ug_map.id"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
        q="$q where ur_ug_map.urg_btime < datetime('now','localtime')"
        q="$q and ur_ug_map.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
	q="$q group by ur_ug_map.id"
	q="$q order by user_groups.ug_id, user_roles.ur_id, urg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#User funcs

add_usr () {

        check_ns
        [ "X$usr_id" == "X" ] && exit 1
        [ "X$usr_name" == "X" ] && exit 1
        [ "X$usr_btime" == "X" ] && usr_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into users (usr_id,usr_name,usr_btime,ns_id)"
        q="$q values ($usr_id,'$usr_name','$usr_btime',$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_usr () {

        [ "X$usr_tsn_id" == "X" ] && exit 1
        [ "X$usr_etime" == "X" ] && usr_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into usr_exp (id,usr_etime) values ($usr_tsn_id,'$usr_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_usr () {

        check_ns
        local q="select * from users"
	q="$q left join user_info on users.usr_id=user_info.usr_id"
	q="$q where users.ns_id=$ns_id"
	q="$q and user_info.ns_id=$ns_id"
	q="$q order by users.usr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_usr () {

        check_ns
        local q="select * from users"
        q="$q left join user_info on users.usr_id=user_info.usr_id"
        q="$q where users.id not in (select id from usr_exp)"
        q="$q and user_info.id not in (select id from ui_exp)"
        q="$q and users.usr_btime < datetime('now','localtime')"
        q="$q and user_info.ui_btime < datetime('now','localtime')"
        q="$q and users.ns_id=$ns_id"
        q="$q and user_info.ns_id=$ns_id"
        q="$q order by users.usr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_usr () {

        check_ns
        local q="select * from users"
	q="$q inner join usr_exp on usr_exp.id=users.id"
        q="$q left join user_info on users.usr_id=user_info.usr_id"
        q="$q where usr_exp.usr_etime < datetime('now','localtime')"
        q="$q and users.ns_id=$ns_id"
        q="$q and user_info.ns_id=$ns_id"
        q="$q order by usr_exp.usr_etime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#User info funcs

add_ui () {

        check_ns
	[ "X$usr_id" == "X" ] && exit 1
        [ "X$ui_cname" == "X" ] && ui_cname="Anonymous"
        [ "X$ui_sname" == "X" ] && ui_sname="Anonymous"
        [ "X$ui_company" == "X" ] && ui_company="Unknown"
        [ "X$ui_email" == "X" ] && ui_email="Unknown"
        [ "X$ui_phone" == "X" ] && ui_phone="Unknown"
        [ "X$ui_desc" == "X" ] && ui_desc="Unknown"
        [ "X$ui_btime" == "X" ] && ui_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into user_info"
	q="$q (ui_cname,ui_sname,ui_company,ui_email,"
	q="$q ui_phone,ui_desc,ui_btime,usr_id,ns_id)"
        q="$q values ('$ui_cname','$ui_sname','$ui_company','$ui_email',"
	q="$q '$ui_phone','$ui_desc','$ui_btime',$usr_id,$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"
}

expire_ui () {

        [ "X$ui_tsn_id" == "X" ] && exit 1
        [ "X$ui_etime" == "X" ] && ui_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into ui_exp (id,ui_etime) values ($ui_tsn_id,'$ui_etime');"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_all_ui () {

        check_ns
        local q="select * from user_info where ns_id=$ns_id order by ui_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_ui () {

        check_ns
        local q="select * from user_info"
        q="$q where id not in (select id from ui_exp)"
        q="$q and ui_btime < datetime('now','localtime')"
        q="$q and ns_id=$ns_id"
        q="$q order by ui_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_ui () {

        check_ns
        local q="select user_info.*, ui_exp.ui_etime from user_info"
	q="$q inner join ui_exp on ui_exp.id=user_info.id"
        q="$q where ui_exp.ui_etime < datetime('now','localtime')"
        q="$q and user_info.ns_id=$ns_id"
        q="$q order by ui_exp.ui_etime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#Services funcs

add_svc () {

        check_ns
        [ "X$svc_id" == "X" ] && exit 1
        [ "X$svc_name" == "X" ] && exit 1
        [ "X$svc_desc" == "X" ] && exit 1
        [ "X$svc_btime" == "X" ] && svc_btime=$(date "+%Y-%m-%d %H:%M:%S")
        local q="insert or rollback into services (svc_id,svc_name,svc_desc,svc_btime,ns_id)"
        q="$q values ($svc_id,'$svc_name','$svc_desc','$svc_btime',$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_svc () {

        [ "X$svc_tsn_id" == "X" ] && exit 1
        [ "X$svc_etime" == "X" ] && svc_etime=$(date "+%Y-%m-%d %H:%M:%S")
        local q="insert or rollback into svc_exp (id,svc_etime) values ($svc_tsn_id,'$svc_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_svc () {

        check_ns
        local q="select * from services"
	q="$q where services.ns_id=$ns_id"
	q="$q order by services.svc_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_svc () {

        check_ns
        local q="select * from services"
        q="$q where services.id not in (select id from svc_exp)"
        q="$q and services.svc_btime < datetime('now','localtime')"
        q="$q and services.ns_id=$ns_id"
        q="$q order by services.svc_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_svc () {

        check_ns
        local q="select * from services"
	q="$q inner join svc_exp on svc_exp.id=services.id"
        q="$q and svc_exp.svc_etime < datetime('now','localtime')"
        q="$q and services.ns_id=$ns_id"
        q="$q order by svc_exp.svc_etime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#Service user passes funcs

add_sup () {

        check_ns
        [ "X$sup_enc" == "X" ] && exit 1
        [ "X$svc_id" == "X" ] && exit 1
        [ "X$usr_id" == "X" ] && exit 1
        [ "X$sup_btime" == "X" ] && sup_btime=$(date "+%Y-%m-%d %H:%M:%S")
        local q="insert or rollback into svc_upass (sup_enc,sup_btime,usr_id,svc_id,ns_id)"
        q="$q values ('$sup_enc','$sup_btime',$usr_id,$svc_id,$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_sup () {

        [ "X$sup_tsn_id" == "X" ] && exit 1
        [ "X$sup_etime" == "X" ] && sup_etime=$(date "+%Y-%m-%d %H:%M:%S")
        local q="insert or rollback into sup_exp (id,sup_etime) values ($sup_tsn_id,'$sup_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_sup () {

        check_ns
        local q="select svc_upass.*,services.svc_name, users.usr_name"
	q="$q from svc_upass"
	q="$q left join services on services.svc_id=svc_upass.svc_id"
	q="$q left join users on users.usr_id=svc_upass.usr_id"
	q="$q where svc_upass.ns_id=$ns_id"
	q="$q and services.ns_id=$ns_id"
	q="$q and users.ns_id=$ns_id"
	q="$q group by svc_upass.id"
	q="$q order by svc_upass.sup_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_sup () {

        check_ns
        local q="select svc_upass.*, services.svc_name, users.usr_name"
	q="$q from svc_upass"
	q="$q left join services on services.svc_id=svc_upass.svc_id"
	q="$q left join users on users.usr_id=svc_upass.usr_id"
        q="$q where svc_upass.id not in (select id from sup_exp)"
        q="$q and services.id not in (select id from svc_exp)"
        q="$q and users.id not in (select id from usr_exp)"
        q="$q and svc_upass.sup_btime < datetime('now','localtime')"
        q="$q and services.svc_btime < datetime('now','localtime')"
        q="$q and users.usr_btime < datetime('now','localtime')"
        q="$q and svc_upass.ns_id=$ns_id"
	q="$q and services.ns_id=$ns_id"
	q="$q and users.ns_id=$ns_id"
        q="$q order by svc_upass.sup_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_sup () {

        check_ns
        local q="select svc_upass.*, sup_exp.sup_etime, services.svc_name,"
	q="$q users.usr_name"
	q="$q from svc_upass"
	q="$q inner join sup_exp on sup_exp.id=svc_upass.id"
	q="$q left join services on services.svc_id=svc_upass.svc_id"
	q="$q left join users on users.usr_id=svc_upass.usr_id"
        q="$q where sup_exp.sup_etime < datetime('now','localtime')"
        q="$q and svc_upass.ns_id=$ns_id"
	q="$q and services.ns_id=$ns_id"
	q="$q and users.ns_id=$ns_id"
	q="$q group by svc_upass.id"
        q="$q order by sup_exp.sup_etime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}
#User and group binding funcs

add_uug () {

        check_ns
        [ "X$uug_id" == "X" ] && exit 1
        [ "X$usr_id" == "X" ] && exit 1
        [ "X$ug_id" == "X" ] && exit 1
        [ "X$uug_btime" == "X" ] && uug_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into ug_usr_map (uug_id,uug_btime,usr_id,ug_id,ns_id)"
        q="$q values ($uug_id,'$uug_btime',$usr_id,$ug_id,$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_uug () {

        [ "X$uug_tsn_id" == "X" ] && exit 1
        [ "X$uug_etime" == "X" ] && uug_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into uug_exp (id,uug_etime) values ($uug_tsn_id,'$uug_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_uug () {

        check_ns
        local q="select ug_usr_map.id, ug_usr_map.uug_id, ug_usr_map.ug_id, ug_usr_map.usr_id,"
        q="$q ug_usr_map.uug_btime, ug_usr_map.ns_id,"
        q="$q users.usr_name, user_groups.ug_name"
        q="$q from ug_usr_map"
        q="$q left join user_groups on ug_usr_map.ug_id=user_groups.ug_id"
        q="$q left join users on ug_usr_map.usr_id=users.usr_id"
        q="$q where ug_usr_map.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and users.ns_id=$ns_id"
        q="$q group by ug_usr_map.id"
        q="$q order by users.usr_id, user_groups.ug_id, uug_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_uug () {

        check_ns
        local q="select ug_usr_map.id, ug_usr_map.uug_id, ug_usr_map.ug_id, ug_usr_map.usr_id,"
        q="$q ug_usr_map.uug_btime, ug_usr_map.ns_id,"
        q="$q users.usr_name, user_groups.ug_name"
        q="$q from ug_usr_map"
        q="$q left join user_groups on ug_usr_map.ug_id=user_groups.ug_id"
        q="$q left join users on ug_usr_map.usr_id=users.usr_id"
        q="$q where ug_usr_map.id not in (select id from uug_exp)"
        q="$q and user_groups.id not in (select id from ug_exp)"
        q="$q and users.id not in (select id from usr_exp)"
        q="$q and ug_usr_map.uug_btime < datetime('now','localtime')"
        q="$q and user_groups.ug_btime < datetime('now','localtime')"
        q="$q and users.usr_btime < datetime('now','localtime')"
        q="$q and ug_usr_map.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and users.ns_id=$ns_id"
        q="$q group by ug_usr_map.id"
        q="$q order by users.usr_id, user_groups.ug_id, uug_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_uug () {

        check_ns
        local q="select ug_usr_map.id, ug_usr_map.uug_id, ug_usr_map.ug_id, ug_usr_map.usr_id,"
        q="$q ug_usr_map.uug_btime, ug_usr_map.ns_id,"
        q="$q users.usr_name, user_groups.ug_name, uug_exp.uug_etime "
        q="$q from ug_usr_map"
	q="$q inner join uug_exp on uug_exp.id=ug_usr_map.id"
        q="$q left join user_groups on ug_usr_map.ug_id=user_groups.ug_id"
        q="$q left join users on ug_usr_map.usr_id=users.usr_id"
        q="$q where ug_usr_map.uug_btime < datetime('now','localtime')"
        q="$q and ug_usr_map.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and users.ns_id=$ns_id"
        q="$q group by ug_usr_map.id"
        q="$q order by users.usr_id, user_groups.ug_id, uug_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#Device roles funcs

add_dr () {

        check_ns
        [ "X$dr_id" == "X" ] && exit 1
        [ "X$dr_name" == "X" ] && exit 1
        [ "X$dr_desc" == "X" ] && exit 1
        [ "X$dr_btime" == "X" ] && dr_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into device_roles (dr_id,dr_name,dr_desc,dr_btime,ns_id)"
        q="$q values ($dr_id,'$dr_name','$dr_desc','$dr_btime',$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_dr () {

        [ "X$dr_tsn_id" == "X" ] && exit 1
        [ "X$dr_etime" == "X" ] && dr_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into dr_exp (id,dr_etime) values ($dr_tsn_id,'$dr_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_dr () {

        check_ns
        local q="select * from device_roles where ns_id=$ns_id order by dr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_dr () {

        check_ns
        local q="select * from device_roles"
        q="$q where id not in (select id from dr_exp)"
        q="$q and device_roles.dr_btime < datetime('now','localtime')"
        q="$q and ns_id=$ns_id"
        q="$q order by dr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_dr () {

        check_ns
        local q="select device_roles.*, dr_exp.dr_etime"
	q="$q from device_roles"
	q="$q inner join dr_exp on dr_exp.id=device_roles.id"
        q="$q where dr_exp.dr_etime < datetime('now','localtime')"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q order by dr_exp.dr_etime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#Device groups funcs

add_dg () {

        check_ns
        [ "X$dg_id" == "X" ] && exit 1
        [ "X$dg_name" == "X" ] && exit 1
        [ "X$dg_desc" == "X" ] && exit 1
        [ "X$dg_btime" == "X" ] && dg_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into device_groups (dg_id,dg_name,dg_desc,dg_btime,ns_id)"
        q="$q values ($dg_id,'$dg_name','$dg_desc','$dg_btime',$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_dg () {

        [ "X$dg_tsn_id" == "X" ] && exit 1
        [ "X$dg_etime" == "X" ] && dg_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into dg_exp (id,dg_etime) values ($dg_tsn_id,'$dg_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}


show_all_dg () {

        check_ns
        local q="select * from device_groups where ns_id=$ns_id order by dg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_dg () {

        check_ns
        local q="select * from device_groups"
        q="$q where id not in (select id from dg_exp)"
        q="$q and device_groups.dg_btime < datetime('now','localtime')"
        q="$q and ns_id=$ns_id"
        q="$q order by dg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_dg () {

        check_ns
        local q="select device_groups.*, dg_exp.dg_etime from device_groups"
	q="$q inner join dg_exp on dg_exp.id=device_groups.id"
        q="$q where dg_exp.dg_etime < datetime('now','localtime')"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q order by dg_exp.dg_etime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#Device funcs

add_dev () {

        check_ns
        [ "X$dev_id" == "X" ] && exit 1
        [ "X$dev_name" == "X" ] && exit 1
        [ "X$dev_desc" == "X" ] && exit 1
        [ "X$dev_btime" == "X" ] && dev_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into devices (dev_id,dev_name,dev_desc,dev_btime,ns_id)"
        q="$q values ($dev_id,'$dev_name','$dev_desc','$dev_btime',$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_dev () {

        [ "X$dev_tsn_id" == "X" ] && exit 1
        [ "X$dev_etime" == "X" ] && dev_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into dev_exp (id,dev_etime) values ($dev_tsn_id,'$dev_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_dev () {

        check_ns
        local q="select * from devices"
#        q="$q left join user_info on devices.dev_id=user_info.dev_id"
        q="$q where devices.ns_id=$ns_id order by devices.dev_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_dev () {

        check_ns
        local q="select * from devices"
        q="$q where devices.id not in (select id from dev_exp)"
        q="$q and devices.dev_btime < datetime('now','localtime')"
        q="$q and devices.ns_id=$ns_id"
        q="$q order by devices.dev_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_dev () {

        check_ns
        local q="select * from devices"
	q="$q inner join dev_exp on dev_exp.id=devices.id"
        q="$q where dev_exp.dev_etime < datetime('now','localtime')"
        q="$q and devices.ns_id=$ns_id"
        q="$q order by dev_exp.dev_etime desc"

        sqlite3 $sqlite3opts $db_file "$q"
}

add_drg () {

        check_ns
        [ "X$drg_id" == "X" ] && exit 1
        [ "X$dr_id" == "X" ] && exit 1
        [ "X$dg_id" == "X" ] && exit 1
        [ "X$drg_btime" == "X" ] && drg_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into dr_dg_map (drg_id,drg_btime,dr_id,dg_id,ns_id)"
        q="$q values ($drg_id,'$drg_btime',$dr_id,$dg_id,$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_drg () {

        [ "X$drg_tsn_id" == "X" ] && exit 1
        [ "X$drg_etime" == "X" ] && drg_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into drg_exp (id,drg_etime) values ($drg_tsn_id,'$drg_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_drg () {

        check_ns
        local q="select dr_dg_map.id, dr_dg_map.drg_id, dr_dg_map.dg_id, dr_dg_map.dr_id,"
        q="$q dr_dg_map.drg_btime, dr_dg_map.ns_id,"
        q="$q device_groups.dg_name, device_roles.dr_name"
        q="$q from dr_dg_map"
        q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
        q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
        q="$q where dr_dg_map.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q group by dr_dg_map.id"
        q="$q order by device_groups.dg_id, device_roles.dr_id, drg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_drg () {

        check_ns
        local q="select dr_dg_map.id, dr_dg_map.drg_id, dr_dg_map.dg_id, dr_dg_map.dr_id,"
        q="$q dr_dg_map.drg_btime, dr_dg_map.ns_id,"
        q="$q device_groups.dg_name, device_roles.dr_name"
        q="$q from dr_dg_map"
        q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
        q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
        q="$q where dr_dg_map.id not in (select id from drg_exp)"
        q="$q and device_groups.id not in (select id from dg_exp)"
        q="$q and device_roles.id not in (select id from dr_exp)"
        q="$q and dr_dg_map.drg_btime < datetime('now','localtime')"
        q="$q and device_groups.dg_btime < datetime('now','localtime')"
        q="$q and device_roles.dr_btime < datetime('now','localtime')"
        q="$q and dr_dg_map.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q group by dr_dg_map.id"
        q="$q order by device_groups.dg_id, device_roles.dr_id, drg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_drg () {

        check_ns
        local q="select dr_dg_map.id, dr_dg_map.drg_id, dr_dg_map.dg_id, dr_dg_map.dr_id,"
        q="$q dr_dg_map.drg_btime, dr_dg_map.ns_id,"
        q="$q device_groups.dg_name, device_roles.dr_name, drg_exp.drg_etime"
        q="$q from dr_dg_map"
	q="$q inner join drg_exp on dr_dg_map.id=drg_exp.id"
        q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
        q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
        q="$q where dr_dg_map.drg_btime < datetime('now','localtime')"
        q="$q and dr_dg_map.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q group by dr_dg_map.id"
        q="$q order by device_groups.dg_id, device_roles.dr_id, drg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#Device and group binding funcs

add_ddg () {

        check_ns
        [ "X$ddg_id" == "X" ] && exit 1
        [ "X$dev_id" == "X" ] && exit 1
        [ "X$dg_id" == "X" ] && exit 1
        [ "X$ddg_btime" == "X" ] && ddg_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into dg_dev_map (ddg_id,ddg_btime,dev_id,dg_id,ns_id)"
        q="$q values ($ddg_id,'$ddg_btime',$dev_id,$dg_id,$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_ddg () {

        [ "X$ddg_tsn_id" == "X" ] && exit 1
        [ "X$ddg_etime" == "X" ] && ddg_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into ddg_exp (id,ddg_etime) values ($ddg_tsn_id,'$ddg_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_ddg () {

        check_ns
        local q="select dg_dev_map.id, dg_dev_map.ddg_id, dg_dev_map.dg_id, dg_dev_map.dev_id,"
        q="$q dg_dev_map.ddg_btime, dg_dev_map.ns_id,"
        q="$q devices.dev_name, device_groups.dg_name"
        q="$q from dg_dev_map"
        q="$q left join device_groups on dg_dev_map.dg_id=device_groups.dg_id"
        q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
        q="$q where dg_dev_map.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q and devices.ns_id=$ns_id"
        q="$q group by dg_dev_map.id"
        q="$q order by devices.dev_id, device_groups.dg_id, ddg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_ddg () {

        check_ns
        local q="select dg_dev_map.id, dg_dev_map.ddg_id, dg_dev_map.dg_id, dg_dev_map.dev_id,"
        q="$q dg_dev_map.ddg_btime, dg_dev_map.ns_id,"
        q="$q devices.dev_name, device_groups.dg_name"
        q="$q from dg_dev_map"
        q="$q left join device_groups on dg_dev_map.dg_id=device_groups.dg_id"
        q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
        q="$q where dg_dev_map.id not in (select id from ddg_exp)"
        q="$q and device_groups.id not in (select id from dg_exp)"
        q="$q and devices.id not in (select id from dev_exp)"
        q="$q and dg_dev_map.ddg_btime < datetime('now','localtime')"
        q="$q and device_groups.dg_btime < datetime('now','localtime')"
        q="$q and devices.dev_btime < datetime('now','localtime')"
        q="$q and dg_dev_map.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q and devices.ns_id=$ns_id"
        q="$q group by dg_dev_map.id"
        q="$q order by devices.dev_id, device_groups.dg_id, ddg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_ddg () {

        check_ns
        local q="select dg_dev_map.id, dg_dev_map.ddg_id, dg_dev_map.dg_id, dg_dev_map.dev_id,"
        q="$q dg_dev_map.ddg_btime, dg_dev_map.ns_id,"
        q="$q devices.dev_name, device_groups.dg_name, ddg_exp.ddg_etime "
        q="$q from dg_dev_map"
	q="$q inner join ddg_exp on ddg_exp.id=dg_dev_map.id"
        q="$q left join device_groups on dg_dev_map.dg_id=device_groups.dg_id"
        q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
        q="$q where dg_dev_map.ddg_btime < datetime('now','localtime')"
        q="$q and dg_dev_map.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q and devices.ns_id=$ns_id"
        q="$q group by dg_dev_map.id"
        q="$q order by devices.dev_id, device_groups.dg_id, ddg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#Device and user roles binding funcs

add_udr () {

        check_ns
        [ "X$udr_id" == "X" ] && exit 1
        [ "X$udr_desc" == "X" ] && exit 1
        [ "X$dr_id" == "X" ] && exit 1
        [ "X$ur_id" == "X" ] && exit 1
        [ "X$udr_btime" == "X" ] && udr_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into udr_map (udr_id,udr_desc,udr_btime,dr_id,ur_id,ns_id)"
        q="$q values ($udr_id,'$udr_desc','$udr_btime',$dr_id,$ur_id,$ns_id);"
        sqlite3 $sqlite3opts $db_file "$q"

}

expire_udr () {

        [ "X$udr_tsn_id" == "X" ] && exit 1
        [ "X$udr_etime" == "X" ] && udr_etime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into udr_exp (id,udr_etime) values ($udr_tsn_id,'$udr_etime');"
        sqlite3 $sqlite3opts $db_file "$q"

}

show_all_udr () {

        check_ns
        local q="select udr_map.id, udr_map.udr_id, udr_map.dr_id, udr_map.ur_id,"
        q="$q udr_map.udr_desc, udr_map.udr_btime, udr_map.ns_id,"
        q="$q device_roles.dr_name, user_roles.ur_name"
        q="$q from udr_map"
        q="$q left join device_roles on udr_map.dr_id=device_roles.dr_id"
        q="$q left join user_roles on udr_map.ur_id=user_roles.ur_id"
        q="$q where udr_map.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q group by udr_map.id"
        q="$q order by device_roles.dr_id, user_roles.ur_id, udr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_udr () {

        check_ns
        local q="select udr_map.id, udr_map.udr_id, udr_map.dr_id, udr_map.ur_id,"
        q="$q udr_map.udr_desc, udr_map.udr_btime, udr_map.ns_id,"
        q="$q device_roles.dr_name, user_roles.ur_name"
        q="$q from udr_map"
        q="$q left join device_roles on udr_map.dr_id=device_roles.dr_id"
        q="$q left join user_roles on udr_map.ur_id=user_roles.ur_id"
        q="$q where udr_map.id not in (select id from udr_exp)"
        q="$q and device_roles.id not in (select id from dr_exp)"
        q="$q and user_roles.id not in (select id from ur_exp)"
        q="$q and udr_map.udr_btime < datetime('now','localtime')"
        q="$q and device_roles.dr_btime < datetime('now','localtime')"
        q="$q and user_roles.ur_btime < datetime('now','localtime')"
        q="$q and udr_map.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q group by udr_map.id"
        q="$q order by device_roles.dr_id, user_roles.ur_id, udr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_udr () {

        check_ns
        local q="select udr_map.id, udr_map.udr_id, udr_map.dr_id, udr_map.ur_id,"
        q="$q udr_map.udr_desc, udr_map.udr_btime, udr_map.ns_id,"
        q="$q device_roles.dr_name, user_roles.ur_name, udr_exp.udr_etime "
        q="$q from udr_map"
	q="$q inner join udr_exp on udr_exp.id=udr_map.id"
        q="$q left join device_roles on udr_map.dr_id=device_roles.dr_id"
        q="$q left join user_roles on udr_map.ur_id=user_roles.ur_id"
        q="$q where udr_map.udr_btime < datetime('now','localtime')"
        q="$q and udr_map.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q group by udr_map.id"
        q="$q order by device_roles.dr_id, user_roles.ur_id, udr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_uur_map () {

	check_ns
	local q="select users.usr_name, user_roles.ur_name"
	q="$q from ur_ug_map"
	q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join ug_usr_map on ur_ug_map.ug_id=ug_usr_map.ug_id"
	q="$q left join users on ug_usr_map.usr_id=users.usr_id"
	q="$q where ur_ug_map.id not in (select id from urg_exp)"
	q="$q and user_roles.id not in (select id from ur_exp)"
	q="$q and user_groups.id not in (select id from ug_exp)"
	q="$q and ug_usr_map.id not in (select id from uug_exp)"
	q="$q and users.id not in (select id from usr_exp)"
	q="$q and ur_ug_map.urg_btime < datetime('now','localtime')"
	q="$q and user_roles.ur_btime < datetime('now','localtime')"
	q="$q and user_groups.ug_btime < datetime('now','localtime')"
	q="$q and ug_usr_map.uug_btime < datetime('now','localtime')"
	q="$q and users.usr_btime < datetime('now','localtime')"
	q="$q and ur_ug_map.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and ug_usr_map.ns_id=$ns_id"
        q="$q and users.ns_id=$ns_id"
	q="$q group by users.usr_name, user_roles.ur_name"
	q="$q order by users.usr_name"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_ddr_map () {

	check_ns
	local q="select devices.dev_name, device_roles.dr_name"
	q="$q from dr_dg_map"
	q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
	q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
	q="$q left join dg_dev_map on dr_dg_map.dg_id=dg_dev_map.dg_id"
	q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
	q="$q where dr_dg_map.id not in (select id from drg_exp)"
	q="$q and device_roles.id not in (select id from dr_exp)"
	q="$q and device_groups.id not in (select id from dg_exp)"
	q="$q and dg_dev_map.id not in (select id from ddg_exp)"
	q="$q and devices.id not in (select id from dev_exp)"
	q="$q and dr_dg_map.drg_btime < datetime('now','localtime')"
	q="$q and device_roles.dr_btime < datetime('now','localtime')"
	q="$q and device_groups.dg_btime < datetime('now','localtime')"
	q="$q and dg_dev_map.ddg_btime < datetime('now','localtime')"
	q="$q and devices.dev_btime < datetime('now','localtime')"
	q="$q and dr_dg_map.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q and dg_dev_map.ns_id=$ns_id"
        q="$q and devices.ns_id=$ns_id"
	q="$q group by devices.dev_name, device_roles.dr_name"
	q="$q order by devices.dev_name"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_ud_map () {
	
	check_ns
        local q="select devices.dev_name, users.usr_name"
        q="$q from udr_map"
	q="$q left join ur_ug_map on udr_map.ur_id=ur_ug_map.ur_id"
        q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join ug_usr_map on ur_ug_map.ug_id=ug_usr_map.ug_id"
	q="$q left join users on ug_usr_map.usr_id=users.usr_id"
        q="$q left join dr_dg_map on udr_map.dr_id=dr_dg_map.dr_id"
	q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
	q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
	q="$q left join dg_dev_map on dr_dg_map.dg_id=dg_dev_map.dg_id"
	q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
        q="$q where udr_map.id not in (select id from udr_exp)"
	q="$q and ur_ug_map.id not in (select id from urg_exp)"
	q="$q and user_roles.id not in (select id from ur_exp)"
	q="$q and user_groups.id not in (select id from ug_exp)"
	q="$q and ug_usr_map.id not in (select id from uug_exp)"
	q="$q and users.id not in (select id from usr_exp)"
	q="$q and dr_dg_map.id not in (select id from drg_exp)"
	q="$q and device_roles.id not in (select id from dr_exp)"
	q="$q and device_groups.id not in (select id from dg_exp)"
	q="$q and dg_dev_map.id not in (select id from ddg_exp)"
	q="$q and devices.id not in (select id from dev_exp)"
	q="$q and udr_map.udr_btime < datetime('now','localtime')"
	q="$q and ur_ug_map.urg_btime < datetime('now','localtime')"
	q="$q and user_roles.ur_btime < datetime('now','localtime')"
	q="$q and user_groups.ug_btime < datetime('now','localtime')"
	q="$q and ug_usr_map.uug_btime < datetime('now','localtime')"
	q="$q and users.usr_btime < datetime('now','localtime')"
	q="$q and dr_dg_map.drg_btime < datetime('now','localtime')"
	q="$q and device_roles.dr_btime < datetime('now','localtime')"
	q="$q and device_groups.dg_btime < datetime('now','localtime')"
	q="$q and dg_dev_map.ddg_btime < datetime('now','localtime')"
	q="$q and devices.dev_btime < datetime('now','localtime')"
        q="$q and udr_map.ns_id=$ns_id"
        q="$q and ur_ug_map.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and ug_usr_map.ns_id=$ns_id"
        q="$q and users.ns_id=$ns_id"
        q="$q and dr_dg_map.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q and dg_dev_map.ns_id=$ns_id"
        q="$q and devices.ns_id=$ns_id"
	q="$q group by devices.dev_name, users.usr_name"
        sqlite3 $sqlite3opts $db_file "$q"
}

get_full_ul () {

        check_ns
        local q="select usr_name from users"
        q="$q where users.id not in"
        q="$q (select id from usr_exp)"
        q="$q and users.usr_btime < datetime('now','localtime')"
        q="$q and users.ns_id=$ns_id"
        q="$q order by users.usr_name"
        sqlite3 $db_file "$q"
}

get_full_dl () {

        check_ns
        local q="select dev_name from devices"
        q="$q where id not in"
        q="$q (select id from dev_exp)"
        q="$q and dev_btime < datetime('now','localtime')"
        q="$q and ns_id=$ns_id"
	q="$q group by dev_name"
        q="$q order by dev_name"
        sqlite3 $db_file "$q"
}

get_dev_roles () {

        check_ns
	[ "X$1" == "X" ] && exit 1 || local dev_name1=$1

        local q="select dr_name from device_roles"
	q="$q left join dr_dg_map on device_roles.dr_id=dr_dg_map.dr_id"
	q="$q left join device_groups on device_groups.dg_id=dr_dg_map.dg_id"
	q="$q left join dg_dev_map on device_groups.dg_id=dg_dev_map.dg_id"
	q="$q left join devices on devices.dev_id=dg_dev_map.dev_id"
        q="$q where device_roles.id not in (select id from dr_exp)"
        q="$q and dr_dg_map.id not in (select id from drg_exp)"
        q="$q and device_groups.id not in (select id from dg_exp)"
        q="$q and dg_dev_map.id not in (select id from ddg_exp)"
        q="$q and devices.id not in (select id from dev_exp)"
        q="$q and device_roles.dr_btime < datetime('now','localtime')"
        q="$q and dr_dg_map.drg_btime < datetime('now','localtime')"
        q="$q and device_groups.dg_btime < datetime('now','localtime')"
        q="$q and dg_dev_map.ddg_btime < datetime('now','localtime')"
        q="$q and devices.dev_btime < datetime('now','localtime')"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q and dr_dg_map.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q and dg_dev_map.ns_id=$ns_id"
        q="$q and devices.ns_id=$ns_id"
	q="$q and devices.dev_name='$dev_name1'"
	q="$q group by device_roles.dr_name"
        q="$q order by device_roles.dr_name"
        sqlite3 $db_file "$q"
}

get_dev_uns () {

	check_ns
	[ "X$1" == "X" ] && exit 1 || local dev_name1=$1

        local q="select users.usr_name"
        q="$q from udr_map"
	q="$q left join ur_ug_map on udr_map.ur_id=ur_ug_map.ur_id"
        q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join ug_usr_map on ur_ug_map.ug_id=ug_usr_map.ug_id"
	q="$q left join users on ug_usr_map.usr_id=users.usr_id"
        q="$q left join dr_dg_map on udr_map.dr_id=dr_dg_map.dr_id"
	q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
	q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
	q="$q left join dg_dev_map on dr_dg_map.dg_id=dg_dev_map.dg_id"
	q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
        q="$q where udr_map.id not in (select id from udr_exp)"
	q="$q and ur_ug_map.id not in (select id from urg_exp)"
	q="$q and user_roles.id not in (select id from ur_exp)"
	q="$q and user_groups.id not in (select id from ug_exp)"
	q="$q and ug_usr_map.id not in (select id from uug_exp)"
	q="$q and users.id not in (select id from usr_exp)"
	q="$q and dr_dg_map.id not in (select id from drg_exp)"
	q="$q and device_roles.id not in (select id from dr_exp)"
	q="$q and device_groups.id not in (select id from dg_exp)"
	q="$q and dg_dev_map.id not in (select id from ddg_exp)"
	q="$q and devices.id not in (select id from dev_exp)"
	q="$q and udr_map.udr_btime < datetime('now','localtime')"
	q="$q and ur_ug_map.urg_btime < datetime('now','localtime')"
	q="$q and user_roles.ur_btime < datetime('now','localtime')"
	q="$q and user_groups.ug_btime < datetime('now','localtime')"
	q="$q and ug_usr_map.uug_btime < datetime('now','localtime')"
	q="$q and users.usr_btime < datetime('now','localtime')"
	q="$q and dr_dg_map.drg_btime < datetime('now','localtime')"
	q="$q and device_roles.dr_btime < datetime('now','localtime')"
	q="$q and device_groups.dg_btime < datetime('now','localtime')"
	q="$q and dg_dev_map.ddg_btime < datetime('now','localtime')"
	q="$q and devices.dev_btime < datetime('now','localtime')"
        q="$q and udr_map.ns_id=$ns_id"
        q="$q and ur_ug_map.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and ug_usr_map.ns_id=$ns_id"
        q="$q and users.ns_id=$ns_id"
        q="$q and dr_dg_map.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q and dg_dev_map.ns_id=$ns_id"
        q="$q and devices.ns_id=$ns_id"
	q="$q and devices.dev_name='$dev_name1'"
	q="$q group by users.usr_name"
        sqlite3 $db_file "$q"
}

get_usr_dns () {

	check_ns
	[ "X$1" == "X" ] && exit 1 || local usr_name1=$1

        local q="select devices.dev_name"
        q="$q from udr_map"
	q="$q left join ur_ug_map on udr_map.ur_id=ur_ug_map.ur_id"
        q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join ug_usr_map on ur_ug_map.ug_id=ug_usr_map.ug_id"
	q="$q left join users on ug_usr_map.usr_id=users.usr_id"
        q="$q left join dr_dg_map on udr_map.dr_id=dr_dg_map.dr_id"
	q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
	q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
	q="$q left join dg_dev_map on dr_dg_map.dg_id=dg_dev_map.dg_id"
	q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
        q="$q where udr_map.id not in (select id from udr_exp)"
	q="$q and ur_ug_map.id not in (select id from urg_exp)"
	q="$q and user_roles.id not in (select id from ur_exp)"
	q="$q and user_groups.id not in (select id from ug_exp)"
	q="$q and ug_usr_map.id not in (select id from uug_exp)"
	q="$q and users.id not in (select id from usr_exp)"
	q="$q and dr_dg_map.id not in (select id from drg_exp)"
	q="$q and device_roles.id not in (select id from dr_exp)"
	q="$q and device_groups.id not in (select id from dg_exp)"
	q="$q and dg_dev_map.id not in (select id from ddg_exp)"
	q="$q and devices.id not in (select id from dev_exp)"
	q="$q and udr_map.udr_btime < datetime('now','localtime')"
	q="$q and ur_ug_map.urg_btime < datetime('now','localtime')"
	q="$q and user_roles.ur_btime < datetime('now','localtime')"
	q="$q and user_groups.ug_btime < datetime('now','localtime')"
	q="$q and ug_usr_map.uug_btime < datetime('now','localtime')"
	q="$q and users.usr_btime < datetime('now','localtime')"
	q="$q and dr_dg_map.drg_btime < datetime('now','localtime')"
	q="$q and device_roles.dr_btime < datetime('now','localtime')"
	q="$q and device_groups.dg_btime < datetime('now','localtime')"
	q="$q and dg_dev_map.ddg_btime < datetime('now','localtime')"
	q="$q and devices.dev_btime < datetime('now','localtime')"
        q="$q and udr_map.ns_id=$ns_id"
        q="$q and ur_ug_map.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and ug_usr_map.ns_id=$ns_id"
        q="$q and users.ns_id=$ns_id"
        q="$q and dr_dg_map.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q and dg_dev_map.ns_id=$ns_id"
        q="$q and devices.ns_id=$ns_id"
	q="$q and users.usr_name='$usr_name1'"
	q="$q group by devices.dev_name"
        sqlite3 $db_file "$q"
}

chk_usr () {

	check_ns
	[ "X$1" == "X" ] && exit 1 || local usr_name1=$1

	local local q="select count(*) from users"
	q="$q where users.id not in (select id from usr_exp)"
	q="$q and users.usr_btime < datetime('now','localtime')"
	q="$q and users.usr_name='$usr_name1'"
        
	sqlite3 $db_file "$q"
}

chk_dev () {

	check_ns
	[ "X$1" == "X" ] && exit 1 || local dev_name1=$1
        
	local local q="select count(*) from devices"
	q="$q where devices.id not in (select id from dev_exp)"
	q="$q and devices.dev_btime < datetime('now','localtime')"
	q="$q and devices.dev_name='$dev_name1'"

	sqlite3 $db_file "$q"
}

get_usr_pass () {

        check_ns
	test "X$1" == "X" && exit 1 || local usr_from_db1=$1

        local q="select sup_enc from svc_upass"
	q="$q left join services on services.svc_id=svc_upass.svc_id"
	q="$q left join users on users.usr_id=svc_upass.usr_id"
        q="$q where svc_upass.id not in (select id from sup_exp)"
	q="$q and services.id not in (select id from svc_exp)"
	q="$q and users.id not in (select id from usr_exp)"
        q="$q and svc_upass.sup_btime < datetime('now','localtime')"
        q="$q and services.svc_btime < datetime('now','localtime')"
        q="$q and users.usr_btime < datetime('now','localtime')"
        q="$q and svc_upass.ns_id=$ns_id"
        q="$q and services.ns_id=$ns_id"
        q="$q and users.ns_id=$ns_id"
	q="$q and services.svc_name='ssh'"
	q="$q and users.usr_name='$usr_from_db1'"
	q="$q limit 1"
        sqlite3 $db_file "$q"
}

get_ug_on_dev () {

        check_ns
	[ "X$1" == "X" ] && exit 1 || local usr_name1=$1
	[ "X$2" == "X" ] && exit 1 || local dev_name1=$2

        local q="select user_groups.ug_name"
        q="$q from udr_map"
	q="$q left join ur_ug_map on udr_map.ur_id=ur_ug_map.ur_id"
        q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join ug_usr_map on ur_ug_map.ug_id=ug_usr_map.ug_id"
	q="$q left join users on ug_usr_map.usr_id=users.usr_id"
        q="$q left join dr_dg_map on udr_map.dr_id=dr_dg_map.dr_id"
	q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
	q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
	q="$q left join dg_dev_map on dr_dg_map.dg_id=dg_dev_map.dg_id"
	q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
        q="$q where udr_map.id not in (select id from udr_exp)"
	q="$q and ur_ug_map.id not in (select id from urg_exp)"
	q="$q and user_roles.id not in (select id from ur_exp)"
	q="$q and user_groups.id not in (select id from ug_exp)"
	q="$q and ug_usr_map.id not in (select id from uug_exp)"
	q="$q and users.id not in (select id from usr_exp)"
	q="$q and dr_dg_map.id not in (select id from drg_exp)"
	q="$q and device_roles.id not in (select id from dr_exp)"
	q="$q and device_groups.id not in (select id from dg_exp)"
	q="$q and dg_dev_map.id not in (select id from ddg_exp)"
	q="$q and devices.id not in (select id from dev_exp)"
	q="$q and udr_map.udr_btime < datetime('now','localtime')"
	q="$q and ur_ug_map.urg_btime < datetime('now','localtime')"
	q="$q and user_roles.ur_btime < datetime('now','localtime')"
	q="$q and user_groups.ug_btime < datetime('now','localtime')"
	q="$q and ug_usr_map.uug_btime < datetime('now','localtime')"
	q="$q and users.usr_btime < datetime('now','localtime')"
	q="$q and dr_dg_map.drg_btime < datetime('now','localtime')"
	q="$q and device_roles.dr_btime < datetime('now','localtime')"
	q="$q and device_groups.dg_btime < datetime('now','localtime')"
	q="$q and dg_dev_map.ddg_btime < datetime('now','localtime')"
	q="$q and devices.dev_btime < datetime('now','localtime')"
        q="$q and udr_map.ns_id=$ns_id"
        q="$q and ur_ug_map.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
        q="$q and ug_usr_map.ns_id=$ns_id"
        q="$q and users.ns_id=$ns_id"
        q="$q and dr_dg_map.ns_id=$ns_id"
        q="$q and device_roles.ns_id=$ns_id"
        q="$q and device_groups.ns_id=$ns_id"
        q="$q and dg_dev_map.ns_id=$ns_id"
        q="$q and devices.ns_id=$ns_id"
	q="$q and devices.dev_name='$dev_name1'"
	q="$q and users.usr_name='$usr_name1'"
	#q="$q group by users.usr_name"
        sqlite3 $db_file "$q"
}

get_usr_rls_in_grp () {

        check_ns
	[ "X$1" == "X" ] && exit 1 || local grp_name1=$1

	local q="select user_roles.ur_name"
	q="$q from user_roles"
	q="$q left join ur_ug_map on user_roles.ur_id=ur_ug_map.ur_id"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q where ur_ug_map.id not in (select id from urg_exp)"
	q="$q and user_groups.id not in (select id from ug_exp)"
	q="$q and user_roles.id not in (select id from ur_exp)"
	q="$q and ur_ug_map.urg_btime < datetime('now','localtime')"
	q="$q and user_roles.ur_btime < datetime('now','localtime')"
	q="$q and user_groups.ug_btime < datetime('now','localtime')"
        q="$q and ur_ug_map.ns_id=$ns_id"
        q="$q and user_roles.ns_id=$ns_id"
        q="$q and user_groups.ns_id=$ns_id"
	q="$q and user_groups.ug_name='$grp_name1'"
        sqlite3 $db_file "$q"
}

chk_rsa () {

	check_root_ssh
	check_keys_repo

	test "X$1" == "X" && exit 1 || local dev_name1=$1
	test "X$2" == "X" && exit 1 || local usr_from_db1=$2

	local exec1
	#check rsa_key
	local rsakey="$keys_repo/$usr_from_db1.id_rsa.pub"
	if [ -e "$rsakey" ] ; then
		local rk_from_svr=$(mktemp)
		local usr_ssh_dir="/home/$usr_from_db1/.ssh"
		ssh $sshopts $dev_name1 "sudo mkdir -p $usr_ssh_dir"
		ssh $sshopts $dev_name1 "sudo cat $usr_ssh_dir/authorized_keys" > $rk_from_svr
		if diff $rsakey $rk_from_svr >/dev/null ; then
			echo "$usr_from_db1 RSA pub key on $dev_name1 is ok."
		else
			echo "$usr_from_db1 RSA pub key on $dev_name1 is not ok. Fixing."
			local exec1="cat - | sudo tee $usr_ssh_dir/authorized_keys"
			[ "$pretend" == 1 ] || cat "$rsakey" | ssh $sshopts $dev_name1 $exec1
		fi
		rm $rk_from_svr
	else
		echo "$rsakey not found in $keys_repo."
	fi
}

chk_shell () {

	check_root_ssh

	test "X$1" == "X" && exit 1 || local dev_name1=$1
	test "X$2" == "X" && exit 1 || local usr_from_db1=$2

	local exec1
	#check shell
	local exec1="cat /etc/passwd | grep -w $usr_from_db1 | cut -d: -f7"
	local usr_shell=$(ssh $sshopts $dev_name1 $exec1)

	if [ "$usr_shell" == "/bin/sh" -o "$usr_shell" == "/bin/bash" ]; then
		echo "User $usr_from_db1 shell is ok."
	else
		echo "User $usr_from_db1 shell is not ok. Fixing."
		for dev_role1 in $(get_dev_roles $dev_name1); do
			case $dev_role1 in
				"busybox")
					echo "Device armed with busybox utilities."
					echo "Not easy task. Researching..."
					break
					;;
				"ubuntu"|"rhel"|"debian")
					echo "Device armed with ubuntu utilities."
					exec1="sudo usermod -s /bin/bash $usr_from_db1"
					ssh $sshopts $dev_name1 $exec1
					break
					;;
			esac

		done
	fi
}

chk_pass () {

	check_root_ssh

	test "X$1" == "X" && exit 1 || local dev_name1=$1
	test "X$2" == "X" && exit 1 || local usr_from_db1=$2

	local exec1
	local usr_pass_on_svr
	local usr_pass_from_db
	#check password (look at shadow file)
	exec1="sudo cat /etc/shadow | grep -w $usr_from_db1 | cut -d: -f2"
	usr_pass_on_svr=$(ssh $sshopts $dev_name1 $exec1)
	usr_pass_from_db=$(get_usr_pass $usr_from_db1)
	if [ "$usr_pass_on_svr" == "$usr_pass_from_db" ]; then
		echo "User $usr_from_db1 password is ok."
	else
		echo "User $usr_from_db1 password is not ok. Fixing."
		for dev_role1 in $(get_dev_roles $dev_name1); do
			case $dev_role1 in
				"*")
					exec1="sudo echo '$usr_from_db1:$usr_pass_from_db' | sudo chpasswd -e"
					[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
					break
					;;
			esac
		done
	fi
}

chk_su () {

	check_root_ssh

	test "X$1" == "X" && exit 1 || local dev_name1=$1
	test "X$2" == "X" && exit 1 || local usr_from_db1=$2

	local exec1
	local dev_role1
	local usr_grp1
	local usr_roles1

	#here we get groups connected to dev through roles
	#and then get roles list for the user-dev pair
	for usr_grp1 in $(get_ug_on_dev $usr_from_db1 $dev_name1); do
		usr_rls1="$usr_roles1 $(get_usr_rls_in_grp $usr_grp1)"
	done

	#check superuser ability
	[ "$(grep -wc superuser <<< $usr_rls1)" == 1 ]  && is_dsu1=1 || is_dsu1=0

	exec1="sudo cat /etc/group | grep -w wheel | grep -wc $usr_from_db1"
	[ "$(ssh $sshopts $dev_name1 $exec1)" == 1 ] && is_ssu1=1 || is_ssu1=0

	if [ "$is_dsu1" == 1 -a "$is_dsu1" != "$is_ssu1" ]; then
		echo "User $usr_from_db1 should be superuser on $dev_name1 but he is not."
		for usr_role1 in $usr_rls1; do
			for dev_role1 in $(get_dev_roles $dev_name1); do
				case "${usr_role1}_${dev_role1}" in
					"superuser_busybox")
						exec1="sudo addgroup $usr_from_db1 wheel"
						[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
						;;
					"superuser_ubuntu")
						exec1="sudo adduser $usr_from_db1 wheel"
						[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
						;;
				esac
			done
		done
	fi

	if [ "$is_dsu1" == 0 -a "$is_dsu1" != "$is_ssu1" ]; then
		echo "User $usr_from_db1 should not be superuser on $dev_name1 but he is."
		for usr_role1 in $usr_rls1; do
			for dev_role1 in $(get_dev_roles $dev_name1); do
				case "${usr_role1}_${dev_role1}" in
					"superuser_busybox")
						exec1="sudo delgroup $usr_from_db1 wheel"
						[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
						;;
					"superuser_ubuntu")
						exec1="sudo deluser $usr_from_db1 wheel"
						[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
						;;
				esac
			done
		done
	fi
}

chk_usr_on_dev () {

	test "X$1" == "X" && exit 1 || local dev_name1=$1
	test "X$2" == "X" && exit 1 || local usr_from_db1=$2

	chk_rsa $dev_name1 $usr_from_db1
	chk_shell $dev_name1 $usr_from_db1
	chk_pass $dev_name1 $usr_from_db1
	chk_su $dev_name1 $usr_from_db1
}

add_usr_on_dev () {

	check_root_ssh
	check_keys_repo

	test "X$1" == "X" && exit 1 || local dev_name1=$1
	test "X$2" == "X" && exit 1 || local usr_from_db1=$2
	
	echo "Check if user $usr_from_db1 exists on $dev_name1."
	local exec1="cat /etc/passwd | grep -wc $usr_from_db1"
	local usr_exists=$(ssh $sshopts $dev_name1 $exec1)
	if [ $usr_exists -eq 1 ]; then
		echo "User exists!"
		chk_usr_on_dev $dev_name1 $usr_from_db1
		return 0
	fi

	local usr_pass=$(get_usr_pass $usr_from_db1)
	local usr_ssh_dir="/home/$usr_from_db1/.ssh"
	local rsakey="$keys_repo/$usr_from_db1.id_rsa.pub"

	local dev_role1
	local usr_grp1
	local usr_rls1
	local usr_role1
	local usr_added=0
	local exec1

	for dev_role1 in $(get_dev_roles $dev_name1); do
		case "$dev_role1" in
			"busybox")
				echo "Device armed with busybox utilities."
				exec1="sudo adduser -D $usr_from_db1"
				[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
				usr_added=1
				break
				;;
			"ubuntu"|"rhel"|"debian")
				echo "Device armed with ubuntu utilities."
				exec1="sudo adduser $usr_from_db1"
				[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
				usr_added=1
				break
				;;
		esac
	done

	[ "$usr_added" == 1 ] || return 0

	exec1="sudo echo '$usr_from_db1:$usr_pass' | sudo chpasswd -e"
	[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
	exec1="sudo mkdir -p $usr_ssh_dir"
	[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
	if [ -e "$rsakey" ] ; then
		local exec1="cat - | sudo tee $usr_ssh_dir/authorized_keys"
		[ "$pretend" == 1 ] || cat "$rsakey" | ssh $sshopts $dev_name1 $exec1
	else
		echo "$rsakey not found in $keys_repo."
	fi
	
	#here we get groups connected to dev through roles
	#and then get roles list for the user-dev pair
	for usr_grp1 in $(get_ug_on_dev $usr_from_db1 $dev_name1); do
		usr_rls1="$usr_roles1 $(get_usr_rls_in_grp $usr_grp1)"
	done

	for usr_role1 in $usr_rls1; do
		for dev_role1 in $(get_dev_roles $dev_name1); do
			case "${usr_role1}_${dev_role1}" in
				"superuser_busybox")
					echo "User $usr_from_db1 should be a su on $dev_name1 (busybox)."
					exec1="sudo addgroup $usr_from_db1 wheel"
					[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
					;;
				"superuser_ubuntu")
					echo "User $usr_from_db1 should be a su on $dev_name1 (ubuntu)."
					exec1="sudo adduser $usr_from_db1 wheel"
					[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
					;;
			esac
		done
	done
}

add_usrs_on_dev () {

	[ "X$1" == "X" ] && exit 1 || local dev_name1=$1

	#get list of users from db
	echo "Get user list for $dev_name1 from db."
	local usrs_from_db1=$(get_dev_uns $dev_name1)
	echo $usrs_from_db1
	
	#add users on device one by one
	local usr_from_db1
	for usr_from_db1 in $usrs_from_db1; do	
		echo "Add $usr_from_db1 to $dev_name1."
		add_usr_on_dev $dev_name1 $usr_from_db1
	done
}

add_usr_on_devs () {

	[ "X$1" == "X" ] && exit 1 || local usr_name1=$1

	#get list of devices from db
	echo "Get devices list for $usr_name1 from db."
	local devs_from_db1=$(get_usr_dns $usr_name1)
	echo $devs_from_db1

	#add user on devices one by one
	local dev_from_db1
	for dev_from_db1 in $devs_from_db1; do	
		echo "Add $usr_name1 to $dev_from_db1."
		add_usr_on_dev $dev_from_db1 $usr_name1
	done
}

rm_usr_on_dev () {

	check_root_ssh
	[ "X$1" == "X" ] && exit 1 || local dev_name1=$1
	[ "X$2" == "X" ] && exit 1 || local usr_to_rm1=$2

	local dev_role1
	local exec1
	for dev_role1 in $(get_dev_roles $dev_name1); do
		case $dev_role1 in
			"*")
				exec1="sudo deluser $usr_to_rm1; sudo rm -r /home/$usr_to_rm1"
				[ "$pretend" == 1 ] || ssh $sshopts $dev_name1 $exec1
				break
				;;
		esac
	done
}

rm_usrs_on_dev () {

	check_root_ssh
	[ "X$1" == "X" ] && exit 1 || local dev_name1=$1

	#get list of users from db
	echo "Get user list for $dev_name1 from db."
	local usrs_from_db1=$(mktemp)
	get_dev_uns $dev_name1 > $usrs_from_db1

	#sedding retrieved passwd with known user list (root, daemon, etc...)
	usrs_from_svr1=$(mktemp)
	usrs_from_svr2=$(mktemp)
	local exec1="cat /etc/passwd | cut -d: -f1"
	ssh $sshopts $dev_name1 $exec1 > $usrs_from_svr1
	./knownusers.sed $usrs_from_svr1 > $usrs_from_svr2
	rm $usrs_from_svr1

	#get list of users on serverside to delete
	local usr_rm_lst1=$(sort $usrs_from_svr2 $usrs_from_db1 $usrs_from_db1 | uniq -u)

	#read user delete list and perform user remove on the server (device specific)
	echo "User list to be removed from $dev_name1: $usr_rm_lst1"
	local usr_to_rm1
	for usr_to_rm1 in $usr_rm_lst1; do
		echo "Deleting $usr_to_rm1 from $dev_name1."
		rm_usr_on_dev $dev_name1 $usr_to_rm1
	done
	rm $usrs_from_db1 $usrs_from_svr2
}

exec_scnA () {

	echo "Scenario A. Removing users on the devices."
	echo "Get device list from db."


	local dev_list1=$(get_full_dl)
	echo $dev_list1
	local dev_name1
	for dev_name1 in $dev_list1; do
		echo "Let's remove users on $dev_name1."
		rm_usrs_on_dev $dev_name1
	done
}

exec_scnB () {

	echo "Scenario B. Adding new users on the devices."
	echo "Get device list from db."
	local dev_list1=$(get_full_dl)
	echo $dev_list1
	local dev_name1
	for dev_name1 in $dev_list1; do
		echo "Let's add users on $dev_name1."
		add_usrs_on_dev $dev_name1
	done
}

exec_scnC () {

	[ "X$usr_name" == "X" ] && exit 1
	
	echo "Scenario C. Add new user on the devices."

	#does user exist?
	[ "$(chk_usr $usr_name)" == 0 ] && exit 1

	add_usr_on_devs $usr_name
}

exec_scnD () {

	[ "X$dev_name" == "X" ] && exit 1

	echo "Scenario D. Add users on the new device."

	#does device exist?
	[ "$(chk_dev $dev_name)" == 0 ] && exit 1

	add_usrs_on_dev $dev_name
}

shortopts="h"

#global keys
longopts="help"

#ssh keys

longopts="$longopts,keys-repo,root-login:,root-sshkey:"

#database keys
longopts="$longopts,init,db-file:,db-scheme:"

#namespace keys
longopts="$longopts,add-ns,expire-ns,show-all-ns,show-active-ns,show-expired-ns"
longopts="$longopts,ns-id:,ns-name:,ns-desc:,ns-btime:,ns-etime:,ns-tsn-id:"

#user roles keys
longopts="$longopts,add-ur,expire-ur,show-all-ur,show-active-ur,show-expired-ur"
longopts="$longopts,ur-id:,ur-name:,ur-desc:,ur-btime:,ur-etime:,ur-tsn-id:"

#user groups keys
longopts="$longopts,add-ug,expire-ug,show-all-ug,show-active-ug,show-expired-ug"
longopts="$longopts,ug-id:,ug-name:,ug-desc:,ug-btime:,ug-etime:,ug-tsn-id:"

#user role and group bind keys
longopts="$longopts,add-urg,expire-urg,show-all-urg,show-active-urg,show-expired-urg"
longopts="$longopts,urg-id:,urg-btime:,urg-etime:,urg-tsn-id:"

#user keys
longopts="$longopts,add-usr,expire-usr,show-all-usr,show-active-usr,show-expired-usr"
longopts="$longopts,usr-id:,usr-name:,usr-btime:,usr-etime:,usr-tsn-id:"

#user info keys
longopts="$longopts,add-ui,expire-ui,show-all-ui,show-active-ui,show-expired-ui"
longopts="$longopts,ui-cname:,ui-sname:,ui-company:,ui-email:,ui-phone:"
longopts="$longopts,ui-desc:,ui-btime:,ui-etime:,ui-tsn-id:"

#services keys
longopts="$longopts,add-svc,expire-svc,show-all-svc,show-active-svc,show-expired-svc"
longopts="$longopts,svc-id:,svc-name:,svc-desc:,svc-btime:,svc-etime:,svc-tsn-id:"

#services passes for users
longopts="$longopts,add-sup,expire-sup,show-all-sup,show-active-sup,show-expired-sup"
longopts="$longopts,sup-enc:,sup-btime:,sup-etime:,sup-tsn-id:"

#user and group bind keys
longopts="$longopts,add-uug,expire-uug,show-all-uug,show-active-uug,show-expired-uug"
longopts="$longopts,uug-id:,uug-btime:,uug-etime:,uug-tsn-id:"

#device roles keys
longopts="$longopts,add-dr,expire-dr,show-all-dr,show-active-dr,show-expired-dr"
longopts="$longopts,dr-id:,dr-name:,dr-desc:,dr-btime:,dr-etime:,dr-tsn-id:"

#device groups keys
longopts="$longopts,add-dg,expire-dg,show-all-dg,show-active-dg,show-expired-dg"
longopts="$longopts,dg-id:,dg-name:,dg-desc:,dg-btime:,dg-etime:,dg-tsn-id:"

#device keys
longopts="$longopts,add-dev,expire-dev,show-all-dev,show-active-dev,show-expired-dev"
longopts="$longopts,dev-id:,dev-name:,dev-desc:,dev-btime:,dev-etime:,dev-tsn-id:"

#device role and group bind keys
longopts="$longopts,add-drg,expire-drg,show-all-drg,show-active-drg,show-expired-drg"
longopts="$longopts,drg-id:,drg-btime:,drg-etime:,drg-tsn-id:"

#device and group bind keys
longopts="$longopts,add-ddg,expire-ddg,show-all-ddg,show-active-ddg,show-expired-ddg"
longopts="$longopts,ddg-id:,ddg-btime:,ddg-etime:,ddg-tsn-id:"

#device and user roles bind keys
longopts="$longopts,add-udr,expire-udr,show-all-udr,show-active-udr,show-expired-udr"
longopts="$longopts,udr-id:,udr-desc:,udr-btime:,udr-etime:,udr-tsn-id:"

#show stuff
longopts="$longopts,show-uur-map,show-ddr-map,show-ud-map"

#executions
longopts="$longopts,pretend"
longopts="$longopts,exec-scnA,exec-scnB,exec-scnC,exec-scnD"

t=$(getopt -o $shortopts --long $longopts -n 'yasim' -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$t"

while true ; do
	case "$1" in
		-h|--help) help_usage ; break ;;
		--keys-repo) keys_repo=$2; shift 2;;
		--root-login) root_login=$2; shift 2;;
		--root-sshkey) root_sshkey=$2; shift 2;;
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
                --ug-id) ug_id=$2; shift 2;;
                --ug-name) ug_name=$2; shift 2;;
                --ug-desc) ug_desc=$2; shift 2;;
                --ug-btime) ug_btime=$2; shift 2;;
                --ug-etime) ug_etime=$2; shift 2;;
                --ug-tsn-id) ug_tsn_id=$2; shift 2;;
                --add-ug) add_ug=1; shift;;
                --expire-ug) expire_ug=1; shift;;
                --show-all-ug) show_all_ug=1; shift;;
                --show-active-ug) show_active_ug=1; shift;;
                --show-expired-ug) show_expired_ug=1; shift;;
		--urg-id) urg_id=$2; shift 2;;
                --urg-btime) urg_btime=$2; shift 2;;
		--urg-etime) urg_etime=$2; shift 2;;
		--urg-tsn-id) urg_tsn_id=$2; shift 2;;
		--add-urg) add_urg=1; shift;;
		--expire-urg) expire_urg=1; shift;;
		--show-all-urg) show_all_urg=1; shift;;
		--show-active-urg) show_active_urg=1; shift;;
		--show-expired-urg) show_expired_urg=1; shift;;
		--usr-id) usr_id=$2; shift 2;;
                --usr-name) usr_name=$2; shift 2;;
                --usr-btime) usr_btime=$2; shift 2;;
                --usr-etime) usr_etime=$2; shift 2;;
                --usr-tsn-id) usr_tsn_id=$2; shift 2;;
                --add-usr) add_usr=1; shift;;
                --expire-usr) expire_usr=1; shift;;
                --show-all-usr) show_all_usr=1; shift;;
                --show-active-usr) show_active_usr=1; shift;;
                --show-expired-usr) show_expired_usr=1; shift;;
                --ui-cname) ui_cname=$2; shift 2;;
                --ui-sname) ui_sname=$2; shift 2;;
                --ui-company) ui_company=$2; shift 2;;
                --ui-email) ui_email=$2; shift 2;;
                --ui-phone) ui_phone=$2; shift 2;;
                --ui-desc) ui_desc=$2; shift 2;;
                --ui-btime) ui_btime=$2; shift 2;;
                --ui-etime) ui_etime=$2; shift 2;;
                --ui-tsn-id) ui_tsn_id=$2; shift 2;;
                --add-ui) add_ui=1; shift;;
                --expire-ui) expire_ui=1; shift;;
                --show-all-ui) show_all_ui=1; shift;;
                --show-active-ui) show_active_ui=1; shift;;
                --show-expired-ui) show_expired_ui=1; shift;;
		--svc-id) svc_id=$2; shift 2;;
                --svc-name) svc_name=$2; shift 2;;
                --svc-desc) svc_desc=$2; shift 2;;
                --svc-btime) svc_btime=$2; shift 2;;
                --svc-etime) svc_etime=$2; shift 2;;
                --svc-tsn-id) svc_tsn_id=$2; shift 2;;
                --add-svc) add_svc=1; shift;;
                --expire-svc) expire_svc=1; shift;;
                --show-all-svc) show_all_svc=1; shift;;
                --show-active-svc) show_active_svc=1; shift;;
                --show-expired-svc) show_expired_svc=1; shift;;
		--sup-enc) sup_enc=$2; shift 2;;
                --sup-btime) sup_btime=$2; shift 2;;
                --sup-etime) sup_etime=$2; shift 2;;
                --sup-tsn-id) sup_tsn_id=$2; shift 2;;
                --add-sup) add_sup=1; shift;;
                --expire-sup) expire_sup=1; shift;;
                --show-all-sup) show_all_sup=1; shift;;
                --show-active-sup) show_active_sup=1; shift;;
                --show-expired-sup) show_expired_sup=1; shift;;
                --uug-id) uug_id=$2; shift 2;;
                --uug-btime) uug_btime=$2; shift 2;;
                --uug-etime) uug_etime=$2; shift 2;;
                --uug-tsn-id) uug_tsn_id=$2; shift 2;;
                --add-uug) add_uug=1; shift;;
                --expire-uug) expire_uug=1; shift;;
                --show-all-uug) show_all_uug=1; shift;;
                --show-active-uug) show_active_uug=1; shift;;
                --show-expired-uug) show_expired_uug=1; shift;;
                --dr-id) dr_id=$2; shift 2;;
                --dr-name) dr_name=$2; shift 2;;
                --dr-desc) dr_desc=$2; shift 2;;
                --dr-btime) dr_btime=$2; shift 2;;
                --dr-etime) dr_etime=$2; shift 2;;
                --dr-tsn-id) dr_tsn_id=$2; shift 2;;
                --add-dr) add_dr=1; shift;;
                --expire-dr) expire_dr=1; shift;;
                --show-all-dr) show_all_dr=1; shift;;
                --show-active-dr) show_active_dr=1; shift;;
                --show-expired-dr) show_expired_dr=1; shift;;
                --dg-id) dg_id=$2; shift 2;;
                --dg-name) dg_name=$2; shift 2;;
                --dg-desc) dg_desc=$2; shift 2;;
                --dg-btime) dg_btime=$2; shift 2;;
                --dg-etime) dg_etime=$2; shift 2;;
                --dg-tsn-id) dg_tsn_id=$2; shift 2;;
                --add-dg) add_dg=1; shift;;
                --expire-dg) expire_dg=1; shift;;
                --show-all-dg) show_all_dg=1; shift;;
                --show-active-dg) show_active_dg=1; shift;;
                --show-expired-dg) show_expired_dg=1; shift;;
                --dev-id) dev_id=$2; shift 2;;
                --dev-name) dev_name=$2; shift 2;;
                --dev-desc) dev_desc=$2; shift 2;;
                --dev-btime) dev_btime=$2; shift 2;;
                --dev-etime) dev_etime=$2; shift 2;;
                --dev-tsn-id) dev_tsn_id=$2; shift 2;;
                --add-dev) add_dev=1; shift;;
                --expire-dev) expire_dev=1; shift;;
                --show-all-dev) show_all_dev=1; shift;;
                --show-active-dev) show_active_dev=1; shift;;
                --show-expired-dev) show_expired_dev=1; shift;;
                --drg-id) drg_id=$2; shift 2;;
                --drg-btime) drg_btime=$2; shift 2;;
                --drg-etime) drg_etime=$2; shift 2;;
                --drg-tsn-id) drg_tsn_id=$2; shift 2;;
                --add-drg) add_drg=1; shift;;
                --expire-drg) expire_drg=1; shift;;
                --show-all-drg) show_all_drg=1; shift;;
                --show-active-drg) show_active_drg=1; shift;;
                --show-expired-drg) show_expired_drg=1; shift;;
                --ddg-id) ddg_id=$2; shift 2;;
                --ddg-btime) ddg_btime=$2; shift 2;;
                --ddg-etime) ddg_etime=$2; shift 2;;
                --ddg-tsn-id) ddg_tsn_id=$2; shift 2;;
                --add-ddg) add_ddg=1; shift;;
                --expire-ddg) expire_ddg=1; shift;;
                --show-all-ddg) show_all_ddg=1; shift;;
                --show-active-ddg) show_active_ddg=1; shift;;
                --show-expired-ddg) show_expired_ddg=1; shift;;
                --udr-id) udr_id=$2; shift 2;;
                --udr-desc) udr_desc=$2; shift 2;;
                --udr-btime) udr_btime=$2; shift 2;;
                --udr-etime) udr_etime=$2; shift 2;;
                --udr-tsn-id) udr_tsn_id=$2; shift 2;;
                --add-udr) add_udr=1; shift;;
                --expire-udr) expire_udr=1; shift;;
                --show-all-udr) show_all_udr=1; shift;;
                --show-active-udr) show_active_udr=1; shift;;
                --show-expired-udr) show_expired_udr=1; shift;;
		--show-uur-map) show_uur_map=1; shift ;;
		--show-ddr-map) show_ddr_map=1; shift ;;
		--show-ud-map) show_ud_map=1; shift ;;
		--pretend) pretend=1; shift ;;
		--exec-scnA) exec_scnA=1; shift ;;
		--exec-scnB) exec_scnB=1; shift ;;
		--exec-scnC) exec_scnC=1; shift ;;
		--exec-scnD) exec_scnD=1; shift ;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done

chk_sw

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

#User groups block

[ "$add_ug" == 1 ] && add_ug

[ "$expire_ug" == 1 ] && expire_ug

[ "$show_all_ug" == 1 ] && show_all_ug

[ "$show_active_ug" == 1 ] && show_active_ug

[ "$show_expired_ug" == 1 ] && show_expired_ug

#User role and group binding block

[ "$add_urg" == 1 ] && add_urg

[ "$expire_urg" == 1 ] && expire_urg

[ "$show_all_urg" == 1 ] && show_all_urg

[ "$show_active_urg" == 1 ] && show_active_urg

[ "$show_expired_urg" == 1 ] && show_expired_urg

#User block

[ "$add_usr" == 1 ] && add_usr

[ "$expire_usr" == 1 ] && expire_usr

[ "$show_all_usr" == 1 ] && show_all_usr

[ "$show_active_usr" == 1 ] && show_active_usr

[ "$show_expired_usr" == 1 ] && show_expired_usr

#User info block

[ "$add_ui" == 1 ] && add_ui

[ "$expire_ui" == 1 ] && expire_ui

[ "$show_all_ui" == 1 ] && show_all_ui

[ "$show_active_ui" == 1 ] && show_active_ui

[ "$show_expired_ui" == 1 ] && show_expired_ui

#Services block

[ "$add_svc" == 1 ] && add_svc

[ "$expire_svc" == 1 ] && expire_svc

[ "$show_all_svc" == 1 ] && show_all_svc

[ "$show_active_svc" == 1 ] && show_active_svc

[ "$show_expired_svc" == 1 ] && show_expired_svc

#Service user passes block

[ "$add_sup" == 1 ] && add_sup

[ "$expire_sup" == 1 ] && expire_sup

[ "$show_all_sup" == 1 ] && show_all_sup

[ "$show_active_sup" == 1 ] && show_active_sup

[ "$show_expired_sup" == 1 ] && show_expired_sup

#User and group binding block

[ "$add_uug" == 1 ] && add_uug

[ "$expire_uug" == 1 ] && expire_uug

[ "$show_all_uug" == 1 ] && show_all_uug

[ "$show_active_uug" == 1 ] && show_active_uug

[ "$show_expired_uug" == 1 ] && show_expired_uug

#Device roles block

[ "$add_dr" == 1 ] && add_dr

[ "$expire_dr" == 1 ] && expire_dr

[ "$show_all_dr" == 1 ] && show_all_dr

[ "$show_active_dr" == 1 ] && show_active_dr

[ "$show_expired_dr" == 1 ] && show_expired_dr

#Device groups block

[ "$add_dg" == 1 ] && add_dg

[ "$expire_dg" == 1 ] && expire_dg

[ "$show_all_dg" == 1 ] && show_all_dg

[ "$show_active_dg" == 1 ] && show_active_dg

[ "$show_expired_dg" == 1 ] && show_expired_dg

#Device block

[ "$add_dev" == 1 ] && add_dev

[ "$expire_dev" == 1 ] && expire_dev

[ "$show_all_dev" == 1 ] && show_all_dev

[ "$show_active_dev" == 1 ] && show_active_dev

[ "$show_expired_dev" == 1 ] && show_expired_dev

#Device role and group binding block

[ "$add_drg" == 1 ] && add_drg

[ "$expire_drg" == 1 ] && expire_drg

[ "$show_all_drg" == 1 ] && show_all_drg

[ "$show_active_drg" == 1 ] && show_active_drg

[ "$show_expired_drg" == 1 ] && show_expired_drg

#Device and group binding block

[ "$add_ddg" == 1 ] && add_ddg

[ "$expire_ddg" == 1 ] && expire_ddg

[ "$show_all_ddg" == 1 ] && show_all_ddg

[ "$show_active_ddg" == 1 ] && show_active_ddg

[ "$show_expired_ddg" == 1 ] && show_expired_ddg

#Device and user roles binding block

[ "$add_udr" == 1 ] && add_udr

[ "$expire_udr" == 1 ] && expire_udr

[ "$show_all_udr" == 1 ] && show_all_udr

[ "$show_active_udr" == 1 ] && show_active_udr

[ "$show_expired_udr" == 1 ] && show_expired_udr

#show additional stuff

[ "$show_uur_map" == 1 ] && show_uur_map

[ "$show_ddr_map" == 1 ] && show_ddr_map

[ "$show_ud_map" == 1 ] && show_ud_map

#executions

[ "$exec_scnA" == 1 ] && exec_scnA

[ "$exec_scnB" == 1 ] && exec_scnB

[ "$exec_scnC" == 1 ] && exec_scnC

[ "$exec_scnD" == 1 ] && exec_scnD
