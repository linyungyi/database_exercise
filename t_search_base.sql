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
(1, 2, 'ATARI�S�A�o��F�h�iXbox 360�r�p�C���mTest Drive Unlimited�n���̷s�C���e���A�����ҵo���Ϥ������A���F�H���i�H�ݨ쪺�}�G�r�p���p�H�έ������~�A��]�A�F��ܨ���ɪ��e���C'), 
(2, 1, 'i/1.jpg'), 
(3, 2, '�o�ӹC���N�|�H�L�¦i��Oahu�p�q���R�x�A�C�����|�N�o�Ӥp�q���u�걡�p�d�ӵL��a��y�X�ӡA�]�A�a�θ��������C�_��A�ƦܬO���䪺�q�O�W�H�ܬO�U���c����m���|�M�u�ꪺ�@�Ҥ@�ˡI\r\n���̦b�C�����r�p�ۤ߷R���T���b�����W�ۥѦ�p�A��J���L�����ɴN�i�H�i���o�����������ɡC�C������Xbox Live�A���W���������|�O�Ѩ�L���a�Ҿr�p�C�t�~�A�C����㦳Marketplace����A���a�i�H�w���U���s���إH�ιs�󵥪F��C\r\nXbox 360�mTest Drive Unlimited�n�w�w�b���~6����X�C���59.99�����C'), 
(4, 1, 'i/2.jpg'), 
(5, 1, 'i/3.jpg'), 
(6, 3, '�o��Xbox 360���ɨ��C�����Ѫ��I'), 
(7, 1, 'i/4.jpg'), 
(8, 3, '�C���w�g�W���F�I��b���ذӳ��ݨ�A�٦��ܦh�f�A�֥h�m�ʳ�I'), 
(9, 3, '���S���H�w�g���켯�����F�H�C���ۥѫװ��A�ثe�W��10�p�ɡI'), 
(10, 3, '���֭n���W�H�ڭ̤@�_�ն��u�W�����I�H'), 
(11, 3, '���S���H�ݨ��L�ӿo�H'), 
(12, 3, '���S���H���D�|�����媩�����X�H'), 
(13, 3, '�ڵ��p�����֡A�N�O�ڷ�A���q��...'), 
(14, 3, '�`�`�R�W�}�����ֽ�㫢��'), 
(15, 3, '�}���N�}���A���n���Ӧh�ܰաI'), 
(16, 3, '���n�������A���n�����֡ATest Drive: Unlimited�s�H�L�Ҥ����!');

