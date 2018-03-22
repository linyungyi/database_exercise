/*
MySQL Backup
Source Host:           192.168.11.254
Source Server Version: 4.0.20a-nt
Source Database:       hippo_ajax
Date:                  2006/08/24 17:45:39
*/

SET FOREIGN_KEY_CHECKS=0;
use hippo_ajax;
#----------------------------
# Table structure for t_ad_text
#----------------------------
CREATE TABLE `t_ad_text` (
  `f_id` int(4) unsigned NOT NULL auto_increment,
  `f_url` varchar(200) NOT NULL default '',
  `f_text` varchar(200) NOT NULL default '',
  PRIMARY KEY  (`f_id`)
) TYPE=MyISAM;
#----------------------------
# Records for table t_ad_text
#----------------------------


insert  into t_ad_text values 
(1, 'http://www.google.com/', 'google'), 
(2, 'http://tw.yahoo.com', 'yahoo'), 
(3, 'http://shopping.pchome.com.tw/', 'pchome');

