/*
MySQL Backup
Source Host:           192.168.11.254
Source Server Version: 4.0.20a-nt
Source Database:       hippo_ajax
Date:                  2006/08/31 14:45:16
*/

SET FOREIGN_KEY_CHECKS=0;
use hippo_ajax;
#----------------------------
# Table structure for t_test
#----------------------------
CREATE TABLE `t_test` (
  `f_id` int(4) unsigned NOT NULL auto_increment,
  `f_email` varchar(200) NOT NULL default '',
  `f_name` varchar(200) NOT NULL default '',
  PRIMARY KEY  (`f_id`)
) TYPE=MyISAM;
#----------------------------
# Records for table t_test
#----------------------------


insert  into t_test values 
(1, 'david@gmail.com', 'David'), 
(2, 'hippo@gmail.com', 'Hippo'), 
(3, 'emily@gmail.com', 'Emily'), 
(4, 'service@gmail.com', 'service');

