/*
MySQL Backup
Source Host:           192.168.11.254
Source Server Version: 4.0.20a-nt
Source Database:       hippo_ajax
Date:                  2006/09/01 12:30:54
*/

SET FOREIGN_KEY_CHECKS=0;
use hippo_ajax;
#----------------------------
# Table structure for t_md5
#----------------------------
CREATE TABLE `t_md5` (
  `f_id` int(4) unsigned NOT NULL auto_increment,
  `f_cmd` varchar(200) NOT NULL default '',
  `f_md5` text NOT NULL,
  `f_memo` varchar(200) NOT NULL default '',
  PRIMARY KEY  (`f_id`)
) TYPE=MyISAM;
#----------------------------
# Records for table t_md5
#----------------------------


insert  into t_md5 values 
(1, '3', '206db3ed8b8d1eaee86f42b3c9cc8afd', 'find_news');

