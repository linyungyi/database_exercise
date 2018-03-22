print "##### Create Stroed Procedures for Schedule #####"
print "*** create proc SH_Check_DBStatus ***"
drop proc SH_Check_DBStatus
go
:r SH_Check_DBStatus.sql
go
grant exec on SH_Check_DBStatus to Umsgrp
go
--
print "*** create proc SH_Count_Login ***"
drop proc SH_Count_Login
go
:r SH_Count_Login.sql
go
grant exec on SH_Count_Login to Umsgrp
go
--
print "*** create proc SH_Count_RemoteLogin ***"
drop proc SH_Count_RemoteLogin
go
:r SH_Count_RemoteLogin.sql
go
grant exec on SH_Count_RemoteLogin to Umsgrp
go
--
print "*** create proc SH_DB_Migration ***"
drop proc SH_DB_Migration
go
:r SH_DB_Migration.sql
go
grant exec on SH_DB_Migration to Umsgrp
go
--
print "*** create proc SH_Del_BroadcastStatus ***"
drop proc SH_Del_BroadcastStatus
go
:r SH_Del_BroadcastStatus.sql
go
grant exec on SH_Del_BroadcastStatus to Umsgrp
go
--
print "*** create proc SH_Del_ExpiredDateLog ***"
drop proc SH_Del_ExpiredDateLog
go
:r SH_Del_ExpiredDateLog.sql
go
grant exec on SH_Del_ExpiredDateLog to Umsgrp
go
--
print "*** create proc SH_Del_RemoteLogin ***"
drop proc SH_Del_RemoteLogin
go
:r SH_Del_RemoteLogin.sql
go
grant exec on SH_Del_RemoteLogin to Umsgrp
go
--
print "*** create proc SH_Ins_DailyCall ***"
drop proc SH_Ins_DailyCall
go
:r SH_Ins_DailyCall.sql
go
grant exec on SH_Ins_DailyCall to Umsgrp
go
--

print "*** create proc SH_Ins_DailyStat ***"
drop proc SH_Ins_DailyStat
go
:r SH_Ins_DailyStat.sql
go
grant exec on SH_Ins_DailyStat to Umsgrp
go
--
print "*** create proc SH_Ins_DBLogin ***"
drop proc SH_Ins_DBLogin
go
:r SH_Ins_DBLogin.sql
go
grant exec on SH_Ins_DBLogin to Umsgrp
go
--
print "*** create proc SH_Ins_E1Traffic ***"
drop proc SH_Ins_E1Traffic
go
:r SH_Ins_E1Traffic.sql
go
grant exec on SH_Ins_E1Traffic to Umsgrp
go
--
print "*** create proc SH_Ins_SubscriberStatData ***"
drop proc SH_Ins_SubscriberStatData
go
:r SH_Ins_SubscriberStatData.sql
go
grant exec on SH_Ins_SubscriberStatData to Umsgrp
go
--
print "*** create proc SH_Mass_BroadCast ***"
drop proc SH_Mass_BroadCast
go
:r SH_Mass_BroadCast.sql
go
grant exec on SH_Mass_BroadCast to Umsgrp
go
--
print "*** create proc SH_Move_CallRecord ***"
drop proc SH_Move_CallRecord
go
:r SH_Move_CallRecord.sql
go
grant exec on SH_Move_CallRecord to Umsgrp
go
--

print "*** create proc SH_ReDB_Migration ***"
drop proc SH_ReDB_Migration
go
:r SH_ReDB_Migration.sql
go
grant exec on SH_ReDB_Migration to Umsgrp
go
--
print "*** create proc SH_RenotifyNewMail ***"
drop proc SH_RenotifyNewMail
go
:r SH_RenotifyNewMail.sql
go
grant exec on SH_RenotifyNewMail to Umsgrp
go
--
print "*** create proc SH_Rollback_Migration ***"
drop proc SH_Rollback_Migration
go
:r SH_Rollback_Migration.sql
go
grant exec on SH_Rollback_Migration to Umsgrp
go
--
print "*** create proc SH_rpt_mCDRCount ***"
drop proc SH_rpt_mCDRCount
go
:r SH_rpt_mCDRCount.sql
go
grant exec on SH_rpt_mCDRCount to Umsgrp
go
