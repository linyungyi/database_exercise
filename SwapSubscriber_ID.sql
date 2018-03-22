create proc SwapSubscriber_ID
(@Operator varchar(20),
 @FirstID  varchar(20),
 @SecID	   varchar(20)
)
as
begin
	declare @result int,
		@count_item int,
		@Target varchar(50),
		@First_tempstr varchar(10),
		@Sec_tempstr varchar(10),
		@count_item1 int,
		@count_item2 int,
		@DBServer varchar(20),
		@APServer varchar(20),
		@IsLocal char(1)

	
	select @result=0
	select @count_item=0
	select @First_tempstr='****'
	select @Sec_tempstr='####'

	exec check_DBServer @FirstID output,@DBServer output,@IsLocal output,@APServer output,@result output
	
	if @result !=0
	begin
		select 'result'=@result
		return @result
	end
	
	if @IsLocal='0'
	begin
		select 'result'=1
		return @result
	end 

	exec check_DBServer @SecID output,@DBServer output,@IsLocal output,@APServer output,@result output
	
	if @result !=0
	begin
		select 'result'=@result
		return @result
	end
	
	if @IsLocal='0'
	begin
		select 'result'=1
		return @result
	end 
	
	select @count_item1=count(*) from Account_Internal
	where Subscriber_ID=@FirstID
	
	select @count_item2=count(*) from Account_Internal
	where Subscriber_ID=@SecID

	if (@count_item1 =0) or (@count_item2 =0)
	begin
		select @result=1
		select 'result'=@result
		return @result
	end

	update Account_Internal
	set Subscriber_ID=@Sec_tempstr
	where Subscriber_ID=@FirstID
	
	update Account
	set Subscriber_ID=@Sec_tempstr
	where Subscriber_ID=@FirstID
	
	update Account_Internal
	set Subscriber_ID=@First_tempstr
	where Subscriber_ID=@SecID

	update Account
	set Subscriber_ID=@First_tempstr
	where Subscriber_ID=@SecID	

	update SubscriberStatList
	set Subscriber_ID=@Sec_tempstr
	where Subscriber_ID=@FirstID
		
	update SubscriberStatList
	set Subscriber_ID=@First_tempstr
	where Subscriber_ID=@SecID
	
	update Account_Internal
	set Subscriber_ID=@FirstID
	where Subscriber_ID=@First_tempstr

	update Account
	set Subscriber_ID=@FirstID
	where Subscriber_ID=@First_tempstr

	update Account_Internal
	set Subscriber_ID=@SecID
	where Subscriber_ID=@Sec_tempstr

	update Account
	set Subscriber_ID=@SecID
	where Subscriber_ID=@Sec_tempstr
	
	update SubscriberStatList
	set Subscriber_ID=@FirstID
	where Subscriber_ID=@First_tempstr
		
	update SubscriberStatList
	set Subscriber_ID=@SecID
	where Subscriber_ID=@Sec_tempstr
	
	
	select @Target=@FirstID+' swap to '+@SecID
	
	exec InsEventLog @Operator,10,9,@FirstID,null,@Target
	
	select @Target=@SecID+' swap to '+@FirstID
	
	exec InsEventLog @Operator,10,9,@SecID,null,@Target
	
	select 'result'=@result
end
return 
