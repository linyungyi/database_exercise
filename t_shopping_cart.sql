/*
MySQL Backup
Source Host:           10.160.100.166
Source Server Version: 5.0.22-community-nt
Source Database:       hippo_ajax
Date:                  2006/08/16 15:52:25
*/

SET FOREIGN_KEY_CHECKS=0;
use hippo_ajax;
#----------------------------
# Table structure for t_shopping_cart
#----------------------------
CREATE TABLE `t_shopping_cart` (
  `f_id` int(4) unsigned NOT NULL auto_increment,
  `f_product_id` varchar(20) NOT NULL,
  `f_product_detail` varchar(200) NOT NULL,
  `f_product_price` int(10) NOT NULL,
  PRIMARY KEY  (`f_id`)
) ENGINE=MYISAM CHARACTER SET big5 COLLATE big5_chinese_ci;
#----------------------------
# Records for table t_shopping_cart
#----------------------------

set names 'big5';

insert  into t_shopping_cart values 
(1, '10001', 'Test Drive Unlimited(XBOX360遊戲)', 2100), 
(2, '10002', 'Need For Speed: Carbon(PC遊戲)', 1980), 
(3, '10003', 'XBOX360主機', 8910), 
(4, '10004', 'ViewSonic 22吋螢幕', 11250);

