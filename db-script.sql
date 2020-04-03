create database nve;

create table customers
(
  returncode varchar(100), 
  messageid varchar(100), 
  messagetext varchar(100), 
  userexistsind varchar(100), 
  ssn4 varchar(12)
)

insert into customers values('success', '100', 'potential customer', '1', '000-00-0000')
;

select * from customers
;

drop function f_checkuser;
drop function xtable;

CREATE FUNCTION f_checkuser(p_customerId varchar(100), p_customerCode varchar(100)) RETURNS bool
    DETERMINISTIC
BEGIN 
 RETURN (true);
END
;

select f_checkuser('x', 'y') from dual
;

CREATE FUNCTION xtable(p_customerCheck int) RETURNS VARCHAR(100)
    DETERMINISTIC
BEGIN 
 RETURN ('customers');
END
;

select xtable(1) from dual
;

select returncode, messageid, messagetext, userexistsind, ssn4 from (select xtable(1) as xtable from dual) as xtable
;

--from (select  xtable(1) from dual) as xtable


create table configs.properties 
(
	application varchar(100),
	profile varchar(100),
	label varchar(100),
	token varchar(100),
	value varchar(100)
)
;


drop table configs.properties
;

select token as 'key', value, application, profile, label from configs.properties
;

insert into configs.properties values ('myapp', 'default', 'master', 'direction', 'north')
;

delete from configs.properties where token = 'greet'
;

update configs.properties set value='sup' where token='greet'
;


insert into configs.properties values ('config-client', 'default', 'master', 'greet', 'Howdy')
;
insert into configs.properties values ('config-client', 'default', 'master', 'spring.rabbitmq.host', 'localhost')
;
insert into configs.properties values ('config-client', 'default', 'master', 'spring.rabbitmq.port', '5672')
;
insert into configs.properties values ('config-client', 'default', 'master', 'spring.rabbitmq.username', 'guest')
;
insert into configs.properties values ('config-client', 'default', 'master', 'spring.rabbitmq.password', 'guest')
;
insert into configs.properties values ('config-client', 'default', 'master', 'spring.cloud.bus.trace.enabled', 'true')
;
insert into configs.properties values ('config-client', 'default', 'master', 'spring.cloud.bus.enabled', 'true')
;
insert into configs.properties values ('config-client', 'default', 'master', 'spring.cloud.bus.refresh.enabled', 'true')
;
insert into configs.properties values ('config-client', 'default', 'master', 'management.endpoints.web.exposure.include', '*')
;

