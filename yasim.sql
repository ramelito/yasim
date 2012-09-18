CREATE TABLE IF NOT EXISTS namespaces (
id INTEGER PRIMARY KEY AUTOINCREMENT,
ns_id INTEGER NOT NULL,
ns_name VARCHAR( 255 ) NOT NULL,
ns_desc TEXT  NOT NULL,
ns_btime DATETIME NOT NULL
);

CREATE TABLE IF NOT EXISTS ns_exp (
ns_etime DATETIME NOT NULL,
id REFERENCES namespaces(id)
);

CREATE TABLE IF NOT EXISTS user_roles (
id INTEGER PRIMARY KEY AUTOINCREMENT,
ur_id INTEGER NOT NULL,
ur_name VARCHAR( 255 )  NOT NULL,
ur_desc TEXT  NOT NULL,
ur_btime DATETIME NOT NULL,
ns_id REFERENCES namespaces(ns_id)
);

CREATE TABLE IF NOT EXISTS ur_exp (
ur_etime DATETIME NOT NULL,
id REFERENCES user_roles (id)
);

CREATE TABLE IF NOT EXISTS user_groups (
id INTEGER PRIMARY KEY AUTOINCREMENT,
ug_id INTEGER NOT NULL,
ug_name VARCHAR( 255 )  NOT NULL,
ug_desc TEXT  NOT NULL,
ug_btime DATETIME NOT NULL,
ns_id REFERENCES namespaces (ns_id)
);

CREATE TABLE IF NOT EXISTS ug_exp (
ug_etime DATETIME NOT NULL,
id REFERENCES user_groups (id)
);

CREATE TABLE IF NOT EXISTS users (
id INTEGER PRIMARY KEY AUTOINCREMENT,
usr_id INTEGER NOT NULL,
usr_name VARCHAR( 255 )  NOT NULL,
usr_pass TEXT NOT NULL,
usr_btime DATETIME NOT NULL,
ns_id REFERENCES namespaces (ns_id)
);

CREATE TABLE IF NOT EXISTS usr_exp (
usr_etime DATETIME NOT NULL,
id REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS user_info (
id INTEGER PRIMARY KEY AUTOINCREMENT,
ui_cname VARCHAR( 255 ) NOT NULL,
ui_sname VARCHAR( 255 ) NOT NULL,
ui_company VARCHAR( 255 ) NOT NULL,
ui_email VARCHAR( 255 ) NOT NULL,
ui_phone VARCHAR( 255 ) NOT NULL,
ui_desc TEXT NOT NULL,
ui_btime DATETIME NOT NULL,
ns_id REFERENCES namespaces (ns_id),
usr_id REFERENCES users (usr_id)
);

CREATE TABLE IF NOT EXISTS ui_exp (
ui_etime DATETIME NOT NULL,
id REFERENCES user_info (id)
);

CREATE TABLE IF NOT EXISTS ur_ug_map (
id INTEGER PRIMARY KEY AUTOINCREMENT,
urg_id INTEGER NOT NULL,
urg_btime DATETIME NOT NULL,
ur_id REFERENCES user_roles (ur_id),
ug_id REFERENCES user_groups (ug_id),
ns_id REFERENCES namespaces (ns_id)
);

CREATE TABLE IF NOT EXISTS urg_exp (
urg_etime DATETIME NOT NULL,
id REFERENCES ur_ug_info (id)
);

CREATE TABLE IF NOT EXISTS ug_usr_map (
id INTEGER PRIMARY KEY AUTOINCREMENT,
uug_id INTEGER NOT NULL,
uug_btime DATETIME NOT NULL,
ug_id REFERENCES user_groups (ug_id),
usr_id REFERENCES users (usr_id),
ns_id REFERENCES namespaces (ns_id)
);

CREATE TABLE IF NOT EXISTS uug_exp (
uug_etime DATETIME NOT NULL,
id REFERENCES ug_usr_info (id)
);

CREATE TABLE IF NOT EXISTS device_roles (
id INTEGER PRIMARY KEY AUTOINCREMENT,
dr_id INTEGER NOT NULL,
dr_name VARCHAR( 255 )  NOT NULL,
dr_desc TEXT  NOT NULL,
dr_btime DATETIME NOT NULL,
ns_id REFERENCES namespaces (ns_id)
);

CREATE TABLE IF NOT EXISTS dr_exp (
dr_etime DATETIME NOT NULL,
id REFERENCES device_roles (id)
);

CREATE TABLE IF NOT EXISTS device_groups (
id INTEGER PRIMARY KEY AUTOINCREMENT,
dg_id INTEGER NOT NULL,
dg_name VARCHAR( 255 )  NOT NULL,
dg_desc TEXT  NOT NULL,
dg_btime DATETIME NOT NULL,
ns_id REFERENCES namespaces (ns_id)
);

CREATE TABLE IF NOT EXISTS dg_exp (
dg_etime DATETIME NOT NULL,
id REFERENCES device_groups (id)
);

CREATE TABLE IF NOT EXISTS devices (
id INTEGER PRIMARY KEY AUTOINCREMENT,
dev_id INTEGER NOT NULL,
dev_name VARCHAR( 255 )  NOT NULL,
dev_desc TEXT  NOT NULL,
dev_btime DATETIME NOT NULL,
ns_id REFERENCES namespaces (ns_id)
);

CREATE TABLE IF NOT EXISTS dev_exp (
dev_etime DATETIME NOT NULL,
id REFERENCES devices (id)
);

CREATE TABLE IF NOT EXISTS dr_dg_map (
id INTEGER PRIMARY KEY AUTOINCREMENT,
drg_id INTEGER NOT NULL,
drg_btime DATETIME NOT NULL,
dr_id REFERENCES device_roles (dr_id),
dg_id REFERENCES device_groups (dg_id),
ns_id REFERENCES namespaces (ns_id)
);

CREATE TABLE IF NOT EXISTS drg_exp (
drg_etime DATETIME NOT NULL,
id REFERENCES dr_dg_map (id)
);

CREATE TABLE IF NOT EXISTS dg_dev_map (
id INTEGER PRIMARY KEY AUTOINCREMENT,
ddg_id INTEGER NOT NULL,
ddg_btime DATETIME NOT NULL,
dg_id REFERENCES device_groups (dg_id),
dev_id REFERENCES devices (dev_id),
ns_id REFERENCES namespaces (ns_id)
);

CREATE TABLE IF NOT EXISTS ddg_exp (
ddg_etime DATETIME NOT NULL,
id REFERENCES dg_dev_map (id)
);

CREATE TABLE IF NOT EXISTS udr_map (
id INTEGER PRIMARY KEY AUTOINCREMENT,
udr_id INTEGER NOT NULL,
udr_desc TEXT NOT NULL,
udr_btime DATETIME NOT NULL,
ns_id REFERENCES namespaces (ns_id),
ur_id REFERENCES user_roles (ur_id),
dr_id REFERENCES device_roles (dr_id)
);

CREATE TABLE IF NOT EXISTS udr_exp (
udr_etime DATETIME NOT NULL,
id REFERENCES udr_map (id)
);
