print "----- Create UMS trigger ------"
print "*** create Trigger tI_Distribution_List ***"
drop trigger tI_Distribution_List
go
:r tI_Distribution_List.tri
go
grant all on tI_Distribution_List to Umsgrp
go
sp_hidetext tI_Distribution_List
go
--
print "*** create Trigger tI_Mail ***"
drop trigger tI_Mail
go
:r tI_Mail.tri
go
grant all on tI_Mail to Umsgrp
go
sp_hidetext tI_Mail
go
--
print "*** create Trigger tI_MBEntry ***"
drop trigger tI_MBEntry
go
:r tI_MBEntry.tri
go
grant all on tI_MBEntry to Umsgrp
go
sp_hidetext tI_MBEntry
go
--
print "*** create Trigger tI_MBPhoneEntry ***"
drop trigger tI_MBPhoneEntry
go
:r tI_MBPhoneEntry.tri
go
grant all on tI_MBPhoneEntry to Umsgrp
go
sp_hidetext tI_MBPhoneEntry
go
--
print "*** create Trigger tI_Migration_Item_Rollback ***"
drop trigger tI_Migration_Item_Rollback
go
:r tI_Migration_Item_Rollback.tri
go
grant all on tI_Migration_Item_Rollback to Umsgrp
go
sp_hidetext tI_Migration_Item_Rollback
go
--
print "*** create Trigger tI_Migration_Item ***"
drop trigger tI_Migration_Item
go
:r tI_Migration_Item.tri
go
grant all on tI_Migration_Item to Umsgrp
go
sp_hidetext tI_Migration_Item
go
--
print "*** create Trigger tI_NotifyQueue ***"
drop trigger tI_NotifyQueue
go
:r tI_NotifyQueue.tri
go
grant all on tI_NotifyQueue to Umsgrp
go
sp_hidetext tI_NotifyQueue
go
--
print "*** create Trigger tI_Working_Distribution_List ***"
drop trigger tI_Working_Distribution_List
go
:r tI_Working_Distribution_List.tri
go
grant all on tI_Working_Distribution_List to Umsgrp
go
sp_hidetext tI_Working_Distribution_List
go
--
print "*** create Trigger tU_Mail ***"
drop trigger tU_Mail
go
:r tU_Mail.tri
go
grant all on tU_Mail to Umsgrp
go
sp_hidetext tU_Mail
go
--
print "*** create Trigger tU_Account ***"
drop trigger tU_Account
go
:r tU_Account.tri
go
grant all on tU_Account to Umsgrp
go
grant all on tU_Account to Webgrp
go
sp_hidetext tU_Account
go
--

print "*** create Trigger tU_Distribution_List ***"
drop trigger tU_Distribution_List
go
:r tU_Distribution_List.tri
go
grant all on tU_Distribution_List to Umsgrp
go
sp_hidetext tU_Distribution_List
go
--

print "*** create Trigger tU_Working_Distribution_List ***"
drop trigger tU_Working_Distribution_List
go
:r tU_Working_Distribution_List.tri
go
grant all on tU_Working_Distribution_List to Umsgrp
go
sp_hidetext tU_Working_Distribution_List
go
--
print "*** create Trigger tD_Working_Distribution_List ***"

drop trigger tD_Working_Distribution_List
go
:r tD_Working_Distribution_List.tri
go
grant all on tD_Working_Distribution_List to Umsgrp
go
sp_hidetext tD_Working_Distribution_List
go
--
