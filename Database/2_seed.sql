DECLARE @date date

set @date =  CURRENT_TIMESTAMP;

insert into [d_channel] values(1001,'web',@date,@date);

insert into [d_channel] values(1002,'mobile',@date,@date);


DECLARE @date date

set @date =  CURRENT_TIMESTAMP;

insert into [d_region] values(1001,'east',@date,@date);
insert into [d_region] values(1002,'west',@date,@date);    
insert into [d_region] values(1003,'north',@date,@date);    
insert into [d_region] values(1004,'south',@date,@date);    

insert into [d_country] values(1001,'IND','INDIA','INR',@date,@date);

insert into [d_city] values(1001,'BANGALORE','BNG',1001,1004,12.97,77.59,@date,@date);

insert into [d_organiser] values(1001,'PHEONIX',1001,1001,@date,@date);

insert into [d_reseller] values(1001,'RESELLER1',1001,1001,@date,@date);

insert into [d_reseller] values(1002,'RESELLER2',1001,1001,@date,@date);

insert into [d_event] values(1001,'diwalimusicdhamaka',1001,1001,@date,@date,'music',@date,@date);

insert into [d_customer] values(1001,'changu','mangu',1001,1001,@date,@date);

insert into [d_customer] values(1002,'humpty','dumpty',1001,1001,@date,@date);


insert into [d_address] values(1001,'addressline1','addressline2',12.97,77.59
,'9019061711','9019061711','a@dummy.com'
,@date,@date);

insert into [d_event_seller] values(1001,1001,1001,0,'organiser',0
,@date,@date);

insert into [d_event_seller] values(1002,1001,1001,1001,'reseller',10
,@date,@date);

insert into [d_event_seller] values(1003,1001,1001,1002,'reseller',10
,@date,@date);

insert into [f_transaction] values(2001,1001,1001,1001,1001,5,50,0,
@date,@date);
insert into [f_transaction] values(2002,1001,1002,1001,1001,5,50,5,
@date,@date);
insert into [f_transaction] values(2003,1001,1003,1002,1001,5,50,5,
@date,@date);