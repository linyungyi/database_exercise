/*
MySQL Backup
Source Host:           192.168.11.254
Source Server Version: 4.0.20a-nt
Source Database:       hippo_ajax
Date:                  2006/09/01 09:48:46
*/

SET FOREIGN_KEY_CHECKS=0;
use hippo_ajax;
#----------------------------
# Table structure for t_search_base
#----------------------------
CREATE TABLE `t_search_base` (
  `f_id` int(4) unsigned NOT NULL auto_increment,
  `f_kind_no` int(4) NOT NULL default '0',
  `f_str` text NOT NULL,
  PRIMARY KEY  (`f_id`)
) TYPE=MyISAM;
#----------------------------
# Records for table t_search_base
#----------------------------


insert  into t_search_base values 
(1, 2, 'ATARI又再發表了多張Xbox 360駕駛遊戲《Test Drive Unlimited》的最新遊戲畫面，今次所發表的圖片之中，除了以往可以看到的漂亮駕駛情況以及風景之外，更包括了選擇角色時的畫面。'), 
(2, 1, 'i/1.jpg'), 
(3, 2, '這個遊戲將會以夏威夷的Oahu小島為舞台，遊戲中會將這個小島的真實情況鉅細無遺地營造出來，包括地形路面的高低起伏，甚至是路邊的電燈柱以至是垃圾箱的位置都會和真實的一模一樣！\r\n玩者在遊戲中駕駛著心愛的汽車在路面上自由行駛，當遇到其他車輛時就可以進行突發式的公路比賽。遊戲對應Xbox Live，路上的車輛都會是由其他玩家所駕駛。另外，遊戲更具有Marketplace機能，玩家可以定期下載新車種以及零件等東西。\r\nXbox 360《Test Drive Unlimited》預定在今年6月推出。售格59.99美元。'), 
(4, 1, 'i/2.jpg'), 
(5, 1, 'i/3.jpg'), 
(6, 3, '這款Xbox 360的賽車遊戲必敗阿！'), 
(7, 1, 'i/4.jpg'), 
(8, 3, '遊戲已經上市了！剛在光華商場看到，還有很多貨，快去搶購喔！'), 
(9, 3, '有沒有人已經拿到摩托車了？遊戲自由度高，目前上手10小時！'), 
(10, 3, '有誰要報名？我們一起組隊線上尬車！？'), 
(11, 3, '有沒有人看見林志穎？'), 
(12, 3, '有沒有人知道會有中文版的推出？'), 
(13, 3, '我給妳的幸福，就是我當你的司機...'), 
(14, 3, '深深愛上開車的樂趣～哈～'), 
(15, 3, '開車就開車，不要說太多話啦！'), 
(16, 3, '美好的風景，美好的音樂，Test Drive: Unlimited叫人無所不能阿!');

