-- create database reqres;

drop table if exists  customers;
drop table if exists config_properties;

create table customers
(
  returncode varchar(100), 
  messageid varchar(100), 
  messagetext varchar(100), 
  userexistsind varchar(100), 
  ssn4 varchar(12)
);

insert into customers values('success', '100', 'potential customer', '1', '000-00-0000');

select * from customers;

drop function if exists f_checkuser;
drop function if exists xtable;

CREATE FUNCTION f_checkuser(p_customerId varchar, p_customerCode varchar) RETURNS INTEGER
as 
$$    
BEGIN 
 RETURN (1);
END
;
$$ language PLPGSQL;


select f_checkuser('x', 'y');


CREATE OR REPLACE FUNCTION xtable(p_customerCheck integer) RETURNS setof customers
    AS
'
select * from customers;
' language sql;

select xtable(1) ;

select * from (select xtable(1)) as xtable;

create table configs_properties
(
        application varchar(100),
        profile varchar(100),
	label varchar(100),
        token varchar(100),
        value varchar(100)
);

-- select token as 'key', value, application, profile, label from configs_properties;

insert into configs_properties values ('myapp', 'default', 'master', 'direction', 'north');

delete from configs_properties where token = 'greet';

update configs_properties set value='sup' where token='greet';


insert into configs_properties values ('config-client', 'default', 'master', 'greet', 'Howdy');
insert into configs_properties values ('config-client', 'default', 'master', 'spring.rabbitmq.host', 'localhost');
insert into configs_properties values ('config-client', 'default', 'master', 'spring.rabbitmq.port', '5672');
insert into configs_properties values ('config-client', 'default', 'master', 'spring.rabbitmq.username', 'guest');
insert into configs_properties values ('config-client', 'default', 'master', 'spring.rabbitmq.password', 'guest');
insert into configs_properties values ('config-client', 'default', 'master', 'spring.cloud.bus.trace.enabled', 'true');
insert into configs_properties values ('config-client', 'default', 'master', 'spring.cloud.bus.enabled', 'true');
insert into configs_properties values ('config-client', 'default', 'master', 'spring.cloud.bus.refresh.enabled', 'true');
insert into configs_properties values ('config-client', 'default', 'master', 'management.endpoints.web.exposure.include', '*');
