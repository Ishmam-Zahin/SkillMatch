create table job_types(
  id int primary key generated always as identity,
  type_name varchar(100) not null
);

CREATE TABLE jobs(
  id bigint primary key generated always as identity,
  user_id uuid,
  type_id int,
  title varchar(200) not null,
  upload_date date default current_date,
  deadline_date date not null,
  dsc text not null,
  total_applicant int default 0,
  active boolean default true,
  foreign key (user_id) references auth.users(id) on delete cascade,
  foreign key (type_id) references job_types(id) on delete cascade
);

create table comments(
  id bigint generated always as identity primary key,
  user_id uuid,
  job_id bigint,
  com_time timestamp default current_timestamp,
  com_text varchar(200) not null,
  foreign key (user_id) references auth.users(id) on delete cascade,
  foreign key (job_id) references jobs(id) on delete cascade
);

create table job_applicant(
  user_id uuid,
  job_id bigint,
  apply_date date default current_date,
  foreign key (user_id) references auth.users(id) on delete cascade,
  foreign key (job_id) references jobs(id) on delete cascade
);

create view get_job_list as
select A.id, A.user_id, A.active, C.id as type_id, C.type_name, A.title, A.dsc, A.deadline_date, B.raw_user_meta_data->'name' as user_name, B.raw_user_meta_data->'image_url' as user_image_url
from (jobs as A join auth.users as B on A.user_id = B.id) join job_types as C on A.type_id = C.id;

create view search_users as
select id, email, raw_user_meta_data->>'name' as name, raw_user_meta_data->>'phone' as phone, raw_user_meta_data->>'address' as address, raw_user_meta_data->>'image_url' as image_url from auth.users;


CREATE FUNCTION get_job_detail(j_id int)
RETURNS TABLE(
    id bigint,
    user_id uuid,
    type_id int,
    title varchar,
    upload_date date,
    deadline_date date,
    description text,
    total_applicant int,
    active boolean,
    user_image text,
    name text,
    address text,
    user_email varchar
) AS
$$
BEGIN
    RETURN QUERY
    SELECT 
        j.id,
        j.user_id,
        j.type_id,
        j.title,
        j.upload_date,
        j.deadline_date,
        j.dsc AS description,
        j.total_applicant,
        j.active,
        u.raw_user_meta_data->>'image_url' AS user_image,
        u.raw_user_meta_data->>'name' as name,
        u.raw_user_meta_data->>'address' as address,
        u.email as user_email
    FROM jobs AS j
    JOIN auth.users AS u ON j.user_id = u.id
    WHERE j.id = j_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

create function auto_increment_applicant_num()
returns trigger as
$$
begin
update jobs
set total_applicant = total_applicant + 1
where id = new.job_id;

return new;
end;
$$ LANGUAGE plpgsql SECURITY DEFINER;

create trigger aftre_insert_jobapplicant
after insert on job_applicant
for each row execute function auto_increment_applicant_num();


CREATE FUNCTION get_comments(jobId bigint)
RETURNS TABLE(
  id bigint,
  user_id uuid,
  job_id bigint,
  com_time timestamp,
  com_text varchar,
  user_name text,
  user_image text
)
AS
$$
BEGIN
  RETURN QUERY
  SELECT 
    C.id, 
    C.user_id, 
    C.job_id, 
    C.com_time, 
    C.com_text, 
    B.raw_user_meta_data->>'name' AS user_name, 
    B.raw_user_meta_data->>'image_url' AS user_image
  FROM 
    jobs J
  JOIN 
    comments C ON J.id = C.job_id
  JOIN 
    auth.users B ON C.user_id = B.id
  WHERE 
    J.id = jobId;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
