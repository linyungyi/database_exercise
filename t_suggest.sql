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
(1, 'abc', '�o�O�ǭ^�媺�Ĥ@��'), 
(2, 'abcd', '���r��'), 
(3, '����', '�N�O�A����J�k'), 
(4, '����', '�����]���k');

