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
        --usr-pass               user password (mandatory)
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
        q="select * from user_groups where ns_id=$ns_id order by ug_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_ug () {

        check_ns
        q="select * from user_groups"
        q="$q where id not in"
        q="$q (select id from ug_exp)"
        q="$q and user_groups.ug_btime < datetime('now','localtime')"
        q="$q and ns_id=$ns_id"
        q="$q order by ug_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_ug () {

        check_ns
        q="select user_groups.*, ug_exp.ug_etime from user_groups, ug_exp"
        q="$q where user_groups.id==ug_exp.id"
        q="$q and ug_exp.ug_etime < datetime('now','localtime')"
        q="$q and user_groups.ns_id=$ns_id"
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
	q="select ur_ug_map.id, ur_ug_map.urg_id, ur_ug_map.ug_id, ur_ug_map.ur_id,"
	q="$q ur_ug_map.urg_btime, ur_ug_map.ns_id,"
	q="$q user_groups.ug_name, user_roles.ur_name"
	q="$q from ur_ug_map"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
	q="$q where ur_ug_map.ns_id=$ns_id"
	q="$q group by ur_ug_map.id"
	q="$q order by user_groups.ug_id, user_roles.ur_id, urg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_urg () {

        check_ns
	q="select ur_ug_map.id, ur_ug_map.urg_id, ur_ug_map.ug_id, ur_ug_map.ur_id,"
	q="$q ur_ug_map.urg_btime, ur_ug_map.ns_id,"
	q="$q user_groups.ug_name, user_roles.ur_name"
	q="$q from ur_ug_map"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
        q="$q where ur_ug_map.id not in"
        q="$q (select id from urg_exp)"
        q="$q and ur_ug_map.urg_btime < datetime('now','localtime')"
        q="$q and ur_ug_map.ns_id=$ns_id"
	q="$q group by ur_ug_map.id"
	q="$q order by user_groups.ug_id, user_roles.ur_id, urg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_urg () {

        check_ns
	q="select ur_ug_map.id, ur_ug_map.urg_id, ur_ug_map.ug_id, ur_ug_map.ur_id,"
	q="$q ur_ug_map.urg_btime, ur_ug_map.ns_id,"
	q="$q user_groups.ug_name, user_roles.ur_name, urg_exp.urg_etime"
	q="$q from ur_ug_map, urg_exp"
	q="$q left join user_groups on ur_ug_map.ug_id=user_groups.ug_id"
	q="$q left join user_roles on ur_ug_map.ur_id=user_roles.ur_id"
        q="$q where ur_ug_map.id in"
        q="$q (select id from urg_exp)"
        q="$q and ur_ug_map.urg_btime < datetime('now','localtime')"
        q="$q and ur_ug_map.ns_id=$ns_id"
	q="$q group by ur_ug_map.id"
	q="$q order by user_groups.ug_id, user_roles.ur_id, urg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

#User funcs

add_usr () {

        check_ns
        [ "X$usr_id" == "X" ] && exit 1
        [ "X$usr_name" == "X" ] && exit 1
        [ "X$usr_pass" == "X" ] && exit 1
        [ "X$usr_btime" == "X" ] && usr_btime=$(date "+%Y-%m-%d %H:%M:%S")
        q="insert or rollback into users (usr_id,usr_name,usr_pass,usr_btime,ns_id)"
        q="$q values ($usr_id,'$usr_name','$usr_pass','$usr_btime',$ns_id);"
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
        q="select * from users"
	q="$q left join user_info on users.usr_id=user_info.usr_id"
	q="$q where users.ns_id=$ns_id order by users.usr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_usr () {

        check_ns
        q="select * from users"
        q="$q left join user_info on users.usr_id=user_info.usr_id"
        q="$q where users.id not in"
        q="$q (select id from usr_exp)"
        q="$q and user_info.id not in"
        q="$q (select id from ui_exp)"
        q="$q and users.usr_btime < datetime('now','localtime')"
        q="$q and users.ns_id=$ns_id"
        q="$q order by users.usr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_usr () {

        check_ns
        q="select * from users"
        q="$q left join user_info on users.usr_id=user_info.usr_id"
        q="$q inner join usr_exp on users.id=usr_exp.id"
        q="$q and usr_exp.usr_etime < datetime('now','localtime')"
        q="$q and users.ns_id=$ns_id"
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
        q="select * from user_info where ns_id=$ns_id order by ui_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_ui () {

        check_ns
        q="select * from user_info"
        q="$q where id not in"
        q="$q (select id from ui_exp)"
        q="$q and ui_btime < datetime('now','localtime')"
        q="$q and ns_id=$ns_id"
        q="$q order by ui_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_ui () {

        check_ns
        q="select user_info.*, ui_exp.ui_etime from user_info, ui_exp"
        q="$q where user_info.id in"
        q="$q (select id from ui_exp)"
        q="$q and ui_exp.ui_etime < datetime('now','localtime')"
        q="$q and user_info.ns_id=$ns_id"
        q="$q order by ui_exp.ui_etime desc"
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
        q="select ug_usr_map.id, ug_usr_map.uug_id, ug_usr_map.ug_id, ug_usr_map.usr_id,"
        q="$q ug_usr_map.uug_btime, ug_usr_map.ns_id,"
        q="$q users.usr_name, user_groups.ug_name"
        q="$q from ug_usr_map"
        q="$q left join user_groups on ug_usr_map.ug_id=user_groups.ug_id"
        q="$q left join users on ug_usr_map.usr_id=users.usr_id"
        q="$q where ug_usr_map.ns_id=$ns_id"
        q="$q group by ug_usr_map.id"
        q="$q order by users.usr_id, user_groups.ug_id, uug_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_uug () {

        check_ns
        q="select ug_usr_map.id, ug_usr_map.uug_id, ug_usr_map.ug_id, ug_usr_map.usr_id,"
        q="$q ug_usr_map.uug_btime, ug_usr_map.ns_id,"
        q="$q users.usr_name, user_groups.ug_name"
        q="$q from ug_usr_map"
        q="$q left join user_groups on ug_usr_map.ug_id=user_groups.ug_id"
        q="$q left join users on ug_usr_map.usr_id=users.usr_id"
        q="$q where ug_usr_map.id not in"
        q="$q (select id from uug_exp)"
        q="$q and ug_usr_map.uug_btime < datetime('now','localtime')"
        q="$q and ug_usr_map.ns_id=$ns_id"
        q="$q group by ug_usr_map.id"
        q="$q order by users.usr_id, user_groups.ug_id, uug_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_uug () {

        check_ns
        q="select ug_usr_map.id, ug_usr_map.uug_id, ug_usr_map.ug_id, ug_usr_map.usr_id,"
        q="$q ug_usr_map.uug_btime, ug_usr_map.ns_id,"
        q="$q users.usr_name, user_groups.ug_name, uug_exp.uug_etime "
        q="$q from ug_usr_map, uug_exp"
        q="$q left join user_groups on ug_usr_map.ug_id=user_groups.ug_id"
        q="$q left join users on ug_usr_map.usr_id=users.usr_id"
        q="$q where ug_usr_map.id in"
        q="$q (select id from uug_exp)"
        q="$q and ug_usr_map.uug_btime < datetime('now','localtime')"
        q="$q and ug_usr_map.ns_id=$ns_id"
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
        q="select * from device_roles where ns_id=$ns_id order by dr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_dr () {

        check_ns
        q="select * from device_roles"
        q="$q where id not in"
        q="$q (select id from dr_exp)"
        q="$q and device_roles.dr_btime < datetime('now','localtime')"
        q="$q and ns_id=$ns_id"
        q="$q order by dr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_dr () {

        check_ns
        q="select device_roles.*, dr_exp.dr_etime from device_roles, dr_exp"
        q="$q where device_roles.id==dr_exp.id"
        q="$q and dr_exp.dr_etime < datetime('now','localtime')"
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
        q="select * from device_groups where ns_id=$ns_id order by dg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_dg () {

        check_ns
        q="select * from device_groups"
        q="$q where id not in"
        q="$q (select id from dg_exp)"
        q="$q and device_groups.dg_btime < datetime('now','localtime')"
        q="$q and ns_id=$ns_id"
        q="$q order by dg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_dg () {

        check_ns
        q="select device_groups.*, dg_exp.dg_etime from device_groups, dg_exp"
        q="$q where device_groups.id==dg_exp.id"
        q="$q and dg_exp.dg_etime < datetime('now','localtime')"
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
        q="select * from devices"
#        q="$q left join user_info on devices.dev_id=user_info.dev_id"
        q="$q where devices.ns_id=$ns_id order by devices.dev_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_dev () {

        check_ns
        q="select * from devices"
#        q="$q left join user_info on devices.dev_id=user_info.dev_id"
        q="$q where devices.id not in"
        q="$q (select id from dev_exp)"
#        q="$q and user_info.id not in"
#        q="$q (select id from ui_exp)"
        q="$q and devices.dev_btime < datetime('now','localtime')"
        q="$q and devices.ns_id=$ns_id"
        q="$q order by devices.dev_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_dev () {

        check_ns
        q="select * from devices"
#        q="$q left join user_info on devices.dev_id=user_info.dev_id"
        q="$q inner join dev_exp on devices.id=dev_exp.id"
        q="$q and dev_exp.dev_etime < datetime('now','localtime')"
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
        q="select dr_dg_map.id, dr_dg_map.drg_id, dr_dg_map.dg_id, dr_dg_map.dr_id,"
        q="$q dr_dg_map.drg_btime, dr_dg_map.ns_id,"
        q="$q device_groups.dg_name, device_roles.dr_name"
        q="$q from dr_dg_map"
        q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
        q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
        q="$q where dr_dg_map.ns_id=$ns_id"
        q="$q group by dr_dg_map.id"
        q="$q order by device_groups.dg_id, device_roles.dr_id, drg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_drg () {

        check_ns
        q="select dr_dg_map.id, dr_dg_map.drg_id, dr_dg_map.dg_id, dr_dg_map.dr_id,"
        q="$q dr_dg_map.drg_btime, dr_dg_map.ns_id,"
        q="$q device_groups.dg_name, device_roles.dr_name"
        q="$q from dr_dg_map"
        q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
        q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
        q="$q where dr_dg_map.id not in"
        q="$q (select id from drg_exp)"
        q="$q and dr_dg_map.drg_btime < datetime('now','localtime')"
        q="$q and dr_dg_map.ns_id=$ns_id"
        q="$q group by dr_dg_map.id"
        q="$q order by device_groups.dg_id, device_roles.dr_id, drg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_drg () {

        check_ns
        q="select dr_dg_map.id, dr_dg_map.drg_id, dr_dg_map.dg_id, dr_dg_map.dr_id,"
        q="$q dr_dg_map.drg_btime, dr_dg_map.ns_id,"
        q="$q device_groups.dg_name, device_roles.dr_name, drg_exp.drg_etime"
        q="$q from dr_dg_map, drg_exp"
        q="$q left join device_groups on dr_dg_map.dg_id=device_groups.dg_id"
        q="$q left join device_roles on dr_dg_map.dr_id=device_roles.dr_id"
        q="$q where dr_dg_map.id in"
        q="$q (select id from drg_exp)"
        q="$q and dr_dg_map.drg_btime < datetime('now','localtime')"
        q="$q and dr_dg_map.ns_id=$ns_id"
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
        q="select dg_dev_map.id, dg_dev_map.ddg_id, dg_dev_map.dg_id, dg_dev_map.dev_id,"
        q="$q dg_dev_map.ddg_btime, dg_dev_map.ns_id,"
        q="$q devices.dev_name, device_groups.dg_name"
        q="$q from dg_dev_map"
        q="$q left join device_groups on dg_dev_map.dg_id=device_groups.dg_id"
        q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
        q="$q where dg_dev_map.ns_id=$ns_id"
        q="$q group by dg_dev_map.id"
        q="$q order by devices.dev_id, device_groups.dg_id, ddg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_ddg () {

        check_ns
        q="select dg_dev_map.id, dg_dev_map.ddg_id, dg_dev_map.dg_id, dg_dev_map.dev_id,"
        q="$q dg_dev_map.ddg_btime, dg_dev_map.ns_id,"
        q="$q devices.dev_name, device_groups.dg_name"
        q="$q from dg_dev_map"
        q="$q left join device_groups on dg_dev_map.dg_id=device_groups.dg_id"
        q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
        q="$q where dg_dev_map.id not in"
        q="$q (select id from ddg_exp)"
        q="$q and dg_dev_map.ddg_btime < datetime('now','localtime')"
        q="$q and dg_dev_map.ns_id=$ns_id"
        q="$q group by dg_dev_map.id"
        q="$q order by devices.dev_id, device_groups.dg_id, ddg_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_ddg () {

        check_ns
        q="select dg_dev_map.id, dg_dev_map.ddg_id, dg_dev_map.dg_id, dg_dev_map.dev_id,"
        q="$q dg_dev_map.ddg_btime, dg_dev_map.ns_id,"
        q="$q devices.dev_name, device_groups.dg_name, ddg_exp.ddg_etime "
        q="$q from dg_dev_map, ddg_exp"
        q="$q left join device_groups on dg_dev_map.dg_id=device_groups.dg_id"
        q="$q left join devices on dg_dev_map.dev_id=devices.dev_id"
        q="$q where dg_dev_map.id in"
        q="$q (select id from ddg_exp)"
        q="$q and dg_dev_map.ddg_btime < datetime('now','localtime')"
        q="$q and dg_dev_map.ns_id=$ns_id"
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
        q="select udr_map.id, udr_map.udr_id, udr_map.dr_id, udr_map.ur_id,"
        q="$q udr_map.udr_desc, udr_map.udr_btime, udr_map.ns_id,"
        q="$q device_roles.dr_name, user_roles.ur_name"
        q="$q from udr_map"
        q="$q left join device_roles on udr_map.dr_id=device_roles.dr_id"
        q="$q left join user_roles on udr_map.ur_id=user_roles.ur_id"
        q="$q where udr_map.ns_id=$ns_id"
        q="$q group by udr_map.id"
        q="$q order by device_roles.dr_id, user_roles.ur_id, udr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_active_udr () {

        check_ns
        q="select udr_map.id, udr_map.udr_id, udr_map.dr_id, udr_map.ur_id,"
        q="$q udr_map.udr_desc, udr_map.udr_btime, udr_map.ns_id,"
        q="$q device_roles.dr_name, user_roles.ur_name"
        q="$q from udr_map"
        q="$q left join device_roles on udr_map.dr_id=device_roles.dr_id"
        q="$q left join user_roles on udr_map.ur_id=user_roles.ur_id"
        q="$q where udr_map.id not in"
        q="$q (select id from udr_exp)"
        q="$q and udr_map.udr_btime < datetime('now','localtime')"
        q="$q and udr_map.ns_id=$ns_id"
        q="$q group by udr_map.id"
        q="$q order by device_roles.dr_id, user_roles.ur_id, udr_btime desc"
        sqlite3 $sqlite3opts $db_file "$q"
}

show_expired_udr () {

        check_ns
        q="select udr_map.id, udr_map.udr_id, udr_map.dr_id, udr_map.ur_id,"
        q="$q udr_map.udr_desc, udr_map.udr_btime, udr_map.ns_id,"
        q="$q device_roles.dr_name, user_roles.ur_name, udr_exp.udr_etime "
        q="$q from udr_map, udr_exp"
        q="$q left join device_roles on udr_map.dr_id=device_roles.dr_id"
        q="$q left join user_roles on udr_map.ur_id=user_roles.ur_id"
        q="$q where udr_map.id in"
        q="$q (select id from udr_exp)"
        q="$q and udr_map.udr_btime < datetime('now','localtime')"
        q="$q and udr_map.ns_id=$ns_id"
        q="$q group by udr_map.id"
        q="$q order by device_roles.dr_id, user_roles.ur_id, udr_btime desc"
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

#user groups keys
longopts="$longopts,add-ug,expire-ug,show-all-ug,show-active-ug,show-expired-ug"
longopts="$longopts,ug-id:,ug-name:,ug-desc:,ug-btime:,ug-etime:,ug-tsn-id:"

#user role and group bind keys
longopts="$longopts,add-urg,expire-urg,show-all-urg,show-active-urg,show-expired-urg"
longopts="$longopts,urg-id:,urg-btime:,urg-etime:,urg-tsn-id:"

#user keys
longopts="$longopts,add-usr,expire-usr,show-all-usr,show-active-usr,show-expired-usr"
longopts="$longopts,usr-id:,usr-name:,usr-pass:,usr-btime:,usr-etime:,usr-tsn-id:"

#user info keys
longopts="$longopts,add-ui,expire-ui,show-all-ui,show-active-ui,show-expired-ui"
longopts="$longopts,ui-cname:,ui-sname:,ui-company:,ui-email:,ui-phone:"
longopts="$longopts,ui-desc:,ui-btime:,ui-etime:,ui-tsn-id:"

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
                --usr-pass) usr_pass=$2; shift 2;;
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

