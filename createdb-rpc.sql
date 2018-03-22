print "##### Create Stroed Procedures #####"
print "*** create proc check_Account_Consistency ***"
drop proc check_Account_Consistency
go
:r check_Account_Consistency.sql
go
grant exec on check_Account_Consistency to Umsgrp
go
--
print "*** create proc check_APServer ***"
drop proc check_APServer
go
:r check_APServer.sql
go
grant exec on check_APServer to Umsgrp
go
--
print "*** create proc check_DBServer ***"
drop proc check_DBServer
go
:r check_DBServer.sql
go
grant exec on check_DBServer to Umsgrp
go
--
print "*** create proc check_FileExist ***"
drop proc check_FileExist
go
:r check_FileExist.sql
go
grant exec on check_FileExist to Umsgrp
go
--
print "*** create proc check_MBDir ***"
drop proc check_MBDir
go
:r check_MBDir.sql
go
grant exec on check_MBDir to Umsgrp
go
--
print "*** create proc check_Network ***"
drop proc check_Network
go
:r check_Network.sql
go
grant exec on check_Network to Umsgrp
go
--
print "*** create proc check_Prefix ***"
drop proc check_Prefix
go
:r check_Prefix.sql
go
grant exec on check_Prefix to Umsgrp
go
--
print "*** create proc check_Virtual_Prefix ***"
drop proc check_Virtual_Prefix
go
:r check_Virtual_Prefix.sql
go
grant exec on check_Virtual_Prefix to Umsgrp
go
--
print "*** create proc del_Mail_ID ***"
drop proc del_Mail_ID
go
:r del_Mail_ID.sql
go
grant exec on del_Mail_ID to Umsgrp
go
--
print "*** create proc get_CallType ***"
drop proc get_CallType
go
:r get_CallType.sql
go
grant exec on get_CallType to Umsgrp
go
--
print "*** create proc get_Circuit_Group ***"
drop proc get_Circuit_Group
go
:r get_Circuit_Group.sql
go
grant exec on get_Circuit_Group to Umsgrp
go
--
print "*** create proc get_FullPath_02 ***"
drop proc get_FullPath_02
go
:r get_FullPath_02.sql
go
grant exec on get_FullPath_02 to Umsgrp
go
--
print "*** create proc get_FullPath_04 ***"
drop proc get_FullPath_04
go
:r get_FullPath_04.sql
go
grant exec on get_FullPath_04 to Umsgrp
go
--
print "*** create proc get_FullPath_07 ***"
drop proc get_FullPath_07
go
:r get_FullPath_07.sql
go
grant exec on get_FullPath_07 to Umsgrp
go
--
print "*** create proc get_FullPath ***"
drop proc get_FullPath
go
:r get_FullPath.sql
go
grant exec on get_FullPath to Umsgrp
go
--
print "*** create proc get_Distribution ***"
drop proc get_Distribution
go
:r get_Distribution.sql
go
grant exec on get_Distribution to Umsgrp
go
--
print "*** create proc get_FileServer ***"
drop proc get_FileServer
go
:r get_FileServer.sql
go
grant exec on get_FileServer to Umsgrp
go
--
print "*** create proc get_Mail ***"
drop proc get_Mail
go
:r get_Mail.sql
go
grant exec on get_Mail to Umsgrp
go
--
print "*** create proc get_MailID_byMode ***"
drop proc get_MailID_byMode
go
:r get_MailID_byMode.sql
go
grant exec on get_MailID_byMode to Umsgrp
go
--
print "*** create proc get_MBDir ***"
drop proc get_MBDir
go
:r get_MBDir.sql
go
grant exec on get_MBDir to Umsgrp
go
--
print "*** create proc get_MsgText ***"
drop proc get_MsgText
go
:r get_MsgText.sql
go
grant exec on get_MsgText to Umsgrp
go
--
print "*** create proc get_NotifyMsgFile ***"
drop proc get_NotifyMsgFile
go
:r get_NotifyMsgFile.sql
go
grant exec on get_NotifyMsgFile to Umsgrp
go
grant exec on get_NotifyMsgFile to Webgrp
go
--
print "*** create proc get_Notify_Schedule ***"
drop proc get_Notify_Schedule
go
:r get_Notify_Schedule.sql
go
grant exec on get_Notify_Schedule to Umsgrp
go
--
print "*** create proc get_NotifyTime ***"
drop proc get_NotifyTime
go
:r get_NotifyTime.sql
go
grant exec on get_NotifyTime to Umsgrp
go
--
print "*** create proc get_Reg_System_ID ***"
drop proc get_Reg_System_ID
go
:r get_Reg_System_ID.sql
go
grant exec on get_Reg_System_ID to Umsgrp
go
--
print "*** create proc ins_CallRecord ***"
drop proc ins_CallRecord
go
:r ins_CallRecord.sql
go
grant exec on ins_CallRecord to Umsgrp
go
--
print "*** create proc ins_Distribution_Group ***"
drop proc ins_Distribution_Group
go
:r ins_Distribution_Group.sql
go
grant exec on ins_Distribution_Group to Umsgrp
go
--
print "*** create proc ins_Mail ***"
drop proc ins_Mail
go
:r ins_Mail.sql
go
grant exec on ins_Mail to Umsgrp
go
--
print "*** create proc ins_NotifyQueue_byType ***"
drop proc ins_NotifyQueue_byType
go
:r ins_NotifyQueue_byType.sql
go
grant exec on ins_NotifyQueue_byType to Umsgrp
go
grant exec on ins_NotifyQueue_byType to Webgrp
go
--
print "*** create proc ins_NotifyQueue_byAccount ***"
drop proc ins_NotifyQueue_byAccount
go
:r ins_NotifyQueue_byAccount.sql
go
grant exec on ins_NotifyQueue_byAccount to Umsgrp
go
grant exec on ins_NotifyQueue_byAccount to Webgrp
go
--
print "*** create proc ins_RemoteDatatoLocal_02 ***"
drop proc ins_RemoteDatatoLocal_02
go
:r ins_RemoteDatatoLocal_02.sql
go
grant exec on ins_RemoteDatatoLocal_02 to Umsgrp
go
--
print "*** create proc ins_RemoteDatatoLocal_04 ***"
drop proc ins_RemoteDatatoLocal_04
go
:r ins_RemoteDatatoLocal_04.sql
go
grant exec on ins_RemoteDatatoLocal_04 to Umsgrp
go
--
print "*** create proc ins_RemoteDatatoLocal_07 ***"
drop proc ins_RemoteDatatoLocal_07
go
:r ins_RemoteDatatoLocal_07.sql
go
grant exec on ins_RemoteDatatoLocal_07 to Umsgrp
go
--
print "*** create proc ins_ServiceClass ***"
drop proc ins_ServiceClass
go
:r ins_ServiceClass.sql
go
grant exec on ins_ServiceClass to Umsgrp
go
--
print "*** create proc ins_SubscriberStatData ***"
drop proc ins_SubscriberStatData
go
:r ins_SubscriberStatData.sql
go
grant exec on ins_SubscriberStatData to Umsgrp
go
--
print "*** create proc ins_Working_Distribution ***"
drop proc ins_Working_Distribution
go
:r ins_Working_Distribution.sql
go
grant exec on ins_Working_Distribution to Umsgrp
go
--
print "*** create proc ins_Working_Distribution_02 ***"
drop proc ins_Working_Distribution_02
go
:r ins_Working_Distribution_02.sql
go
grant exec on ins_Working_Distribution_02 to Umsgrp
go
--
print "*** create proc ins_Working_Distribution_04 ***"
drop proc ins_Working_Distribution_04
go
:r ins_Working_Distribution_04.sql
go
grant exec on ins_Working_Distribution_04 to Umsgrp
go
--
print "*** create proc ins_Working_Distribution_07 ***"
drop proc ins_Working_Distribution_07
go
:r ins_Working_Distribution_07.sql
go
grant exec on ins_Working_Distribution_07 to Umsgrp
go
--
print "*** create proc upd_Mail_Flag ***"
drop proc upd_Mail_Flag
go
:r upd_Mail_Flag.sql
go
grant exec on upd_Mail_Flag to Umsgrp
go
--
print "*** create proc InsEventLog  ***"
drop proc InsEventLog 
go
:r InsEventLog.sql 
go
grant exec on InsEventLog to Umsgrp
go
grant exec on InsEventLog to Webgrp
go
--
print "*** create proc upd_ServiceClass  ***"
drop proc upd_ServiceClass 
go
:r upd_ServiceClass.sql 
go
grant exec on upd_ServiceClass to Umsgrp
go
--
print "*** create proc AccountAdd ***"
drop proc AccountAdd
go
:r AccountAdd.sql
go
grant exec on AccountAdd to Umsgrp
go
--
print "*** create proc AccountCount ***"
drop proc AccountCount
go
:r AccountCount.sql
go
grant exec on AccountCount to Umsgrp
go
--
print "*** create proc AccountDelete ***"
drop proc AccountDelete
go
:r AccountDelete.sql
go
grant exec on AccountDelete to Umsgrp
go
--
print "*** create proc AccountRemove ***"
drop proc AccountRemove
go
:r AccountRemove.sql
go
grant exec on AccountRemove to Umsgrp
go
--
print "*** create proc AccountRemoveSOPS ***"
drop proc AccountRemoveSOPS
go
:r AccountRemoveSOPS.sql
go
grant exec on AccountRemoveSOPS to Umsgrp
go
--
print "*** create proc AccountFail ***"
drop proc AccountFail
go
:r AccountFail.sql
go
grant exec on AccountFail to Umsgrp
go
--
print "*** create proc AccountRequest ***"
drop proc AccountRequest
go
:r AccountRequest.sql
go
grant exec on AccountRequest to Umsgrp
go
--
print "*** create proc AccountRequestCancel ***"
drop proc AccountRequestCancel
go
:r AccountRequestCancel.sql
go
grant exec on AccountRequestCancel to Umsgrp
go
--
print "*** create proc AccountRequestSOPS ***"
drop proc AccountRequestSOPS
go
:r AccountRequestSOPS.sql
go
grant exec on AccountRequestSOPS to Umsgrp
go
--
print "*** create proc AccountRequestCancel ***"
drop proc AccountRequestCancel
go
:r AccountRequestCancel.sql
go
grant exec on AccountRequestCancel to Umsgrp
go
--
print "*** create proc GetCallType ***"
drop proc GetCallType
go
:r GetCallType.sql
go
grant exec on GetCallType to Umsgrp
go
--
print "*** create proc GetJobList ***"
drop proc GetJobList
go
:r GetJobList.sql
go
grant exec on GetJobList to Umsgrp
go
--
print "*** create proc ChangeStrtoNum ***"
drop proc ChangeStrtoNum
go
:r ChangeStrtoNum.sql
go
grant exec on ChangeStrtoNum to Umsgrp
go
--
print "*** create proc ChangeSubscriberID ***"
drop proc ChangeSubscriberID
go
:r ChangeSubscriberID.sql
go
grant exec on ChangeSubscriberID to Umsgrp
go
--
print "*** create proc CDRStatistic ***"
drop proc CDRStatistic
go
:r CDRStatistic.sql
go
grant exec on CDRStatistic to Umsgrp
go
--

print "*** create proc DelAccountForFileServer ***"
drop proc DelAccountForFileServer
go
:r DelAccountForFileServer.sql
go
grant exec on DelAccountForFileServer to Umsgrp
go
--
print "*** create proc DelDBMigration ***"
drop proc DelDBMigration
go
:r DelDBMigration.sql
go
grant exec on DelDBMigration to Umsgrp
go
--
print "*** create proc DelLocalMigration ***"
drop proc DelLocalMigration
go
:r DelLocalMigration.sql
go
grant exec on DelLocalMigration to Umsgrp
go
--
print "*** create proc CopyDistributionList ***"
drop proc CopyDistributionList
go
:r CopyDistributionList.sql
go
grant exec on CopyDistributionList to Umsgrp
go
--
print "*** create proc Del_DistributionList ***"
drop proc Del_DistributionList
go
:r Del_DistributionList.sql
go
grant exec on Del_DistributionList to Umsgrp
go
--
print "*** create proc DeleteExpiredMail ***"
drop proc DeleteExpiredMail
go
:r DeleteExpiredMail.sql
go
grant exec on DeleteExpiredMail to Umsgrp
go
--
print "*** create proc Exec_Remotesql ***"
drop proc Exec_Remotesql
go
:r Exec_Remotesql.sql
go
grant exec on Exec_Remotesql to Umsgrp
go
--
print "*** create proc GetBroadcastStatus ***"
drop proc GetBroadcastStatus
go
:r GetBroadcastStatus.sql
go
grant exec on GetBroadcastStatus to Umsgrp
go
--
print "*** create proc GetCDRID ***"
drop proc GetCDRID
go
:r GetCDRID.sql
go
grant exec on GetCDRID to Umsgrp
go
--
print "*** create proc GetSubfolderList ***"
drop proc GetSubfolderList
go
:r GetSubfolderList.sql
go
grant exec on GetSubfolderList to Umsgrp
go
--
print "*** create proc Ins_DistributionList ***"
drop proc Ins_DistributionList
go
:r Ins_DistributionList.sql
go
grant exec on Ins_DistributionList to Umsgrp
go
--
print "*** create proc IsAccountValid ***"
drop proc IsAccountValid
go
:r IsAccountValid.sql
go
grant exec on IsAccountValid to Umsgrp
go
--
print "*** create proc Ins_NotifyQueue ***"
drop proc Ins_NotifyQueue
go
:r Ins_NotifyQueue.sql
go
grant exec on Ins_NotifyQueue to Umsgrp
go
grant exec on Ins_NotifyQueue to Webgrp
go
--
print "*** create proc InsRemoteMail  ***"
drop proc InsRemoteMail
go
:r InsRemoteMail.sql
go
grant exec on InsRemoteMail to Umsgrp
go
--
print "*** create proc NoNewMail ***"
drop proc NoNewMail
go
:r NoNewMail.sql
go
grant exec on NoNewMail to Umsgrp
go
grant exec on NoNewMail to Webgrp
go
--
print "*** create proc NoNewMail_Internal ***"
drop proc NoNewMail_Internal
go
:r NoNewMail_Internal.sql
go
grant exec on NoNewMail_Internal to Umsgrp
go
grant exec on NoNewMail_Internal to Webgrp
go
--
print "*** create proc NewMailArrival ***"
drop proc NewMailArrival
go
:r NewMailArrival.sql
go
grant exec on NewMailArrival to Umsgrp
go
grant exec on NewMailArrival to Webgrp
go
--
print "*** create proc NewMailArrival_Internal ***"
drop proc NewMailArrival_Internal
go
:r NewMailArrival_Internal.sql
go
grant exec on NewMailArrival_Internal to Umsgrp
go
grant exec on NewMailArrival_Internal to Webgrp
go
--
print "*** create proc upd_Mail_Count ***"
drop proc upd_Mail_Count
go
:r upd_Mail_Count.sql
go
grant exec on upd_Mail_Count to Umsgrp
go
--
print "*** create proc ReCount_Mail ***"
drop proc ReCount_Mail
go
:r ReCount_Mail.sql
go
grant exec on ReCount_Mail to Umsgrp
go
--
print "*** create proc Re_DB_Migration ***"
drop proc Re_DB_Migration
go
:r Re_DB_Migration.sql
go
grant exec on Re_DB_Migration to Umsgrp
go
--
print "*** create proc ReIns_Mail ***"
drop proc ReIns_Mail
go
:r ReIns_Mail.sql
go
grant exec on ReIns_Mail to Umsgrp
go
--
print "*** create proc ServiceClassChange ***"
drop proc ServiceClassChange
go
:r ServiceClassChange.sql
go
grant exec on ServiceClassChange to Umsgrp
go
--
print "*** create proc ServiceProfileChange ***"
drop proc ServiceProfileChange
go
:r ServiceProfileChange.sql
go
grant exec on ServiceProfileChange to Umsgrp
go
--
print "*** create proc StoreCDR ***"
drop proc StoreCDR
go
:r StoreCDR.sql
go
grant exec on StoreCDR to Umsgrp
go
--
print "*** create proc SwapSubscriber_ID ***"
drop proc SwapSubscriber_ID
go
:r SwapSubscriber_ID.sql
go
grant exec on SwapSubscriber_ID to Umsgrp
go
--
print "*** create proc Sync_DB_Migration ***"
drop proc Sync_DB_Migration
go
:r Sync_DB_Migration.sql
go
grant exec on Sync_DB_Migration to Umsgrp
go
--
print "*** create proc QueryAccountStatus ***"
drop proc QueryAccountStatus
go
:r QueryAccountStatus.sql
go
grant exec on QueryAccountStatus to Umsgrp
go
--
print "*** create proc VPUDeleteMail ***"
drop proc VPUDeleteMail
go
:r VPUDeleteMail.sql
go
grant exec on VPUDeleteMail to Umsgrp
go
--
print "*** create proc VPUForwardMail ***"
drop proc VPUForwardMail
go
:r VPUForwardMail.sql
go
grant exec on VPUForwardMail to Umsgrp
go
--
print "*** create proc VPUNotifyQueueGetCH ***"
drop proc VPUNotifyQueueGetCH
go
:r VPUNotifyQueueGetCH.sql
go
grant exec on VPUNotifyQueueGetCH to Umsgrp
go
--
print "*** create proc VPUNotifyQueueGetNonCH ***"
drop proc VPUNotifyQueueGetNonCH
go
:r VPUNotifyQueueGetNonCH.sql
go
grant exec on VPUNotifyQueueGetNonCH to Umsgrp
go
--

print "*** create proc VPUNotifyQueueSave ***"
drop proc VPUNotifyQueueSave
go
:r VPUNotifyQueueSave.sql
go
grant exec on VPUNotifyQueueSave to Umsgrp
go
--
print "*** create proc VPUQueryMBStatus ***"
drop proc VPUQueryMBStatus
go
:r VPUQueryMBStatus.sql
go
grant exec on VPUQueryMBStatus to Umsgrp
go
--
print "*** create proc VPURetrieveMail ***"
drop proc VPURetrieveMail
go
:r VPURetrieveMail.sql
go
grant exec on VPURetrieveMail to Umsgrp
go
--
print "*** create proc VPUSetMBStatus ***"
drop proc VPUSetMBStatus
go
:r VPUSetMBStatus.sql
go
grant exec on VPUSetMBStatus to Umsgrp
go
--
print "----Create ISP stored procedures-----"
print "*** create proc get_ISP_FileServer ***"
drop proc get_ISP_FileServer
go
:r get_ISP_FileServer.sql
go
grant exec on get_ISP_FileServer to Umsgrp
go
--
print "*** create proc get_ISP_MBDir ***"
drop proc get_ISP_MBDir
go
:r get_ISP_MBDir.sql
go
grant exec on get_ISP_MBDir to Umsgrp
go
--
print "*** create proc Ins_ISP_MsgOwner ***"
drop proc Ins_ISP_MsgOwner
go
:r Ins_ISP_MsgOwner.sql
go
grant exec on Ins_ISP_MsgOwner to Umsgrp
go
--
print "*** create proc ISP_AccountAdd ***"
drop proc ISP_AccountAdd
go
:r ISP_AccountAdd.sql
go
grant exec on ISP_AccountAdd to Umsgrp
go
--
print "*** create proc ISP_AccountDelete ***"
drop proc ISP_AccountDelete
go
:r ISP_AccountDelete.sql
go
grant exec on ISP_AccountDelete to Umsgrp
go
--
print "*** create proc ISP_AccountFail ***"
drop proc ISP_AccountFail
go
:r ISP_AccountFail.sql
go
grant exec on ISP_AccountFail to Umsgrp
go
--
print "*** create proc ISP_AccountAdd ***"
drop proc ISP_AccountAdd
go
:r ISP_AccountAdd.sql
go
grant exec on ISP_AccountAdd to Umsgrp
go
--
print "*** create proc ISP_Ins_NotifyQueue ***"
drop proc ISP_Ins_NotifyQueue
go
:r ISP_Ins_NotifyQueue.sql
go
grant exec on ISP_Ins_NotifyQueue to Umsgrp
go
--
print "*** create proc PIS_CalculateServiceFee ***"
drop proc PIS_CalculateServiceFee
go
:r PIS_CalculateServiceFee.sql
go
grant exec on PIS_CalculateServiceFee to Umsgrp
go
--
print "*** create proc PIS_GetServiceUnit ***"
drop proc PIS_GetServiceUnit
go
:r PIS_GetServiceUnit.sql
go
grant exec on PIS_GetServiceUnit to Umsgrp
go
--

print "---- Create VOIP Stroed Procedures -----"
print "*** create proc VPU_Tel_Gw ***"
drop proc VPU_Tel_Gw
go
:r VPU_Tel_Gw.sql
go
grant exec on VPU_Tel_Gw to Umsgrp
go
--


