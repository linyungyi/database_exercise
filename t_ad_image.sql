/*
MySQL Backup
Source Host:           192.168.11.254
Source Server Version: 4.0.20a-nt
Source Database:       hippo_ajax
Date:                  2006/08/24 18:10:27
*/

SET FOREIGN_KEY_CHECKS=0;
use hippo_ajax;
#----------------------------
# Table structure for t_ad_image
#----------------------------
CREATE TABLE `t_ad_image` (
  `f_id` int(4) NOT NULL default '0',
  `f_image_path` varchar(200) NOT NULL default '',
  `f_image_alt` varchar(200) default NULL,
  PRIMARY KEY  (`f_id`,`f_image_path`)
) TYPE=MyISAM;
#----------------------------
# Records for table t_ad_image
#----------------------------


insert  into t_ad_image values 
(0, 'i/ad01.png', 'pic1'), 
(0, 'i/ad02.png', 'pic2');

