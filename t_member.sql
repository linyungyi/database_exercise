/*
MySQL Backup
Source Host:           192.168.11.254
Source Server Version: 4.0.20a-nt
Source Database:       hippo_ajax
Date:                  2006/08/23 09:35:13
*/

SET FOREIGN_KEY_CHECKS=0;
use hippo_ajax;
#----------------------------
# Table structure for t_member
#----------------------------
CREATE TABLE `t_member` (
  `f_id` int(4) unsigned NOT NULL auto_increment,
  `f_email` varchar(20) NOT NULL default '',
  `f_pwd` varchar(20) NOT NULL default '',
  `f_name` varchar(20) NOT NULL default '',
  PRIMARY KEY  (`f_id`,`f_email`)
) TYPE=MyISAM;
#----------------------------
# Records for table t_member
#----------------------------


insert  into t_member values 
(1, 'david@gmail.com', '1234', 'David');

