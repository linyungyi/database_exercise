/*
MySQL Backup
Source Host:           192.168.11.254
Source Server Version: 4.0.20a-nt
Source Database:       hippo_ajax
Date:                  2006/08/10 20:32:36
*/

SET FOREIGN_KEY_CHECKS=0;
use hippo_ajax;
#----------------------------
# Table structure for t_suggest
#----------------------------
CREATE TABLE `t_suggest` (
  `f_id` int(4) unsigned NOT NULL auto_increment,
  `f_suggestion` varchar(100) default '',
  `f_description` varchar(200) default '',
  PRIMARY KEY  (`f_id`)
) TYPE=MyISAM;
#----------------------------
# Records for table t_suggest
#----------------------------


insert  into t_suggest values 
(1, 'abc', '這是學英文的第一次'), 
(2, 'abcd', '狗咬豬'), 
(3, '中文', '就是你的輸入法'), 
(4, '中間', '不左也不右');

