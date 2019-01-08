DROP PACKAGE LDS_NEW.LD_PKG_SYSTEM_SETTING;

CREATE OR REPLACE PACKAGE LDS_NEW.ld_pkg_system_setting
as
    procedure p_get_code_group ( p_cur_groups  out sys_refcursor);
    procedure p_get_code_list ( as_group_name in varchar2, p_cur_codes  out sys_refcursor );
    procedure p_get_parent_code_list (as_group_name in varchar2, p_cur_codes  out sys_refcursor);
    procedure p_get_drop_down_list ( as_group_name in varchar2, as_parent in varchar2, p_cur_codes  out sys_refcursor);
    procedure p_get_system_parm (p_cur_parm  out sys_refcursor);
    procedure p_save_system_parm (as_parm_code in varchar,as_parm_value in varchar,as_update_by in varchar,as_updated_date in varchar,p_msg out varchar2);
    procedure sp_insertorupdate_code ( as_group_name in varchar2,
                                       as_code in varchar2,
                                       as_code_active            in     varchar2,
                                       as_description            in     varchar2,
                                       as_parent_code in varchar2,
                                       an_display_seq            in     number,

                                       p_msg                     out varchar2   );
   procedure sp_delete_code (as_group_name in varchar2,
                             as_code       in varchar2,
                            p_msg          out varchar2
    );
end ld_pkg_system_setting ;
/


DROP PACKAGE LDS_NEW.LD_PKG_USER;

CREATE OR REPLACE PACKAGE LDS_NEW.ld_pkg_user
as

   procedure p_get_login_status(as_user_id in varchar2, as_pwd in varchar2, as_success   out varchar2);
   procedure p_get_user_in_search(as_search_text in varchar2, p_cur_user   out sys_refcursor);
   procedure p_get_user(as_user_id in varchar2, as_user_name in varchar2, p_cur_user   out sys_refcursor);
   procedure p_get_user_picklist(as_user_id in varchar2, as_team_section in varchar2, p_cur_user   out sys_refcursor);
 procedure p_insupd_user (as_user_id in varchar2, as_user_name in varchar2, as_os_authentication in varchar2, as_pwd in varchar2,
                           as_designation in varchar2, as_department in varchar2, as_status in varchar2, as_admin_prev in varchar2, as_phone in varchar2,
                            as_email varchar2, as_user in varchar2, p_msg out varchar2);
   procedure p_change_pwd (as_user_id in varchar2, as_pwd in varchar2);
   procedure p_get_username(as_user_id in varchar2, p_cur_user out sys_refcursor);
   procedure p_get_username_by_userid(as_user_id in varchar2, p_cur_user out sys_refcursor);
   procedure p_get_user_details(as_user_id in varchar2, p_cur_user out sys_refcursor);
   procedure p_get_user_from_directory(as_user_id in varchar2, p_cur_user out sys_refcursor);

   procedure p_delete_user(as_user_id in varchar2, p_msg out varchar2);
end ld_pkg_user;
/



DROP PACKAGE BODY LDS_NEW.LD_PKG_SYSTEM_SETTING;

CREATE OR REPLACE PACKAGE BODY LDS_NEW.ld_pkg_system_setting
as
  --get functions
  procedure p_get_code_group ( p_cur_groups  out sys_refcursor)
    as
    begin
       open p_cur_groups for
            select distinct c.group_name AS group_name
              from   ld_code c
          order by  c.group_name asc;
  end p_get_code_group;
 
 procedure p_get_code_list (as_group_name in varchar2, p_cur_codes  out sys_refcursor)
    as
    begin

       open p_cur_codes for
            select c.group_name, c.code, c.code_active, c.description, c.display_seq, c.parent_code,
                   decode(h.parent_group, null, 'NO', 'YES') parent_flag,
                 cg.group_name_desc
              from   ld_code c
              inner join ld_code_group cg on c.group_name = cg.group_name
             left outer join ld_code_hierarchy h on  c.group_name = h.child_group
            where c.group_name = as_group_name
          order by   display_seq asc;

  end p_get_code_list;
  
  
  procedure p_get_parent_code_list (as_group_name in varchar2, p_cur_codes  out sys_refcursor)
    as
    begin

       open p_cur_codes for
            select  cp.code, cp.description
              from   ld_code cp,  ld_code_hierarchy h
                where   cp.group_name = h.parent_group
                 and   exists (select '' from ld_code ch where ch.group_name = h.child_group and ch.group_name = as_group_name)
              order by   cp.display_seq asc;


  end p_get_parent_code_list;
  procedure p_get_drop_down_list (as_group_name in varchar2, as_parent in varchar2, p_cur_codes  out sys_refcursor)
    as
    begin
       if length(as_parent) > 0 then
           open p_cur_codes for
                select group_name, code, code_active, description, display_seq, parent_code
                  from   ld_code
                where group_name = as_group_name and parent_code = as_parent
                union all
                select as_group_name, null, 'Y', null, -999 display_seq, null parent_code
                from dual
              order by   display_seq asc;
       else
           open p_cur_codes for
                select group_name, code, code_active, description, display_seq, parent_code
                  from   ld_code
                where group_name = as_group_name
                union all
                select as_group_name, null, 'Y', null, -999 display_seq, null parent_code
                from dual
              order by   display_seq asc;
       end if;

  end p_get_drop_down_list;


   procedure p_get_system_parm (p_cur_parm  out sys_refcursor)
    as
    begin
       open p_cur_parm for
            select  parm_code,
                    parm_desc,
                    parm_value,
                    update_by,
                    to_char(update_date, 'DD MON YYYY HH24:MI')    update_date,
                    display_in_app
              from  ld_system_parm
              order by parm_desc;
  end p_get_system_parm;

   procedure p_save_system_parm (as_parm_code in varchar,as_parm_value in varchar,as_update_by in varchar,as_updated_date in varchar,p_msg out varchar2)
    as
    begin
            update ld_system_parm

            set parm_value = as_parm_value,
                update_by = as_update_by,
                update_date = as_updated_date

           where parm_code= as_parm_code;
           p_msg := 'System Setting has been modified Successfully.';
  end p_save_system_parm;

  --insert or update funtions
   procedure sp_insertorupdate_code (
   as_group_name             in     varchar2,
   as_code                   in     varchar2,
   as_code_active            in     varchar2,
   as_description            in     varchar2,
   as_parent_code            in     varchar2,
   an_display_seq            in     number,
   p_msg                     out varchar2
    )
   as

   n_count   number;
   begin
      select   count (1)
        into   n_count
        from   ld_code
        where group_name = as_group_name and code = as_code;

      if n_count = 0 then               --this to validate the record is already exist or not
         insert into ld_code (group_name,
                                code,
                                code_active,
                                description,
                                parent_code,
                                display_seq)
           values   (as_group_name,
                     as_code,
                     as_code_active,
                     as_description,
                     as_parent_code,
                     an_display_seq);
         p_msg := 'Reference data has been Added Successfully.';
      else
         update   ld_code
         set   code_active = as_code_active,
               description = as_description,
               display_seq = an_display_seq,
               parent_code = as_parent_code
         where   group_name = as_group_name and code = as_code;
         p_msg := 'Reference data has been updated Successfully.';
      end if;

   end sp_insertorupdate_code;
   --delete function
   procedure sp_delete_code (
   as_group_name             in     varchar2,
   as_code                   in     varchar2,
   p_msg                     out varchar2
    )
   as

   begin


         delete  from ld_code
         where   group_name = as_group_name and code = as_code;
         p_msg := 'Reference data has been deleted Successfully.';


   end sp_delete_code;
end ld_pkg_system_setting ;
/


DROP PACKAGE BODY LDS_NEW.LD_PKG_USER;

CREATE OR REPLACE PACKAGE BODY LDS_NEW.ld_pkg_user
as

  /******************************************************************************/
  /* To Get a user details                  */
  /******************************************************************************/
  procedure p_get_login_status(as_user_id in varchar2, as_pwd in varchar2, as_success   out varchar2)
  as
  i_count integer;
  begin
      select count(*) into i_count from ld_user_master where user_id = as_user_id;
      if i_count > 0 then
        select count(*) into i_count from ld_user_master where user_id = as_user_id and pwd = as_pwd;
        if i_count > 0 then
           as_success := 'SUCCESS';
        else
           as_success := 'Invalid Password...';
        end if;
      else
        as_success := 'Invalid User Name...';
      end if;
  end p_get_login_status;
  /******************************************************************************/
  /* To Get a user details                  */
  /******************************************************************************/
  procedure p_get_user_in_search(as_search_text in varchar2, p_cur_user   out sys_refcursor)
  as
  s_sql varchar2(1000);
  s_search_text varchar2(1000);
  begin
    s_search_text := lower(as_search_text);
    s_sql := 'select user_id,
                user_name          ,
                os_authentication,
                pwd,
                designation,
                department               ,
                status             ,
                admin_prev         ,
                phone          ,
                e_mail             ,
                insert_by          ,
                to_char (insert_date,''DD MON YYYY HH24:MI'') insert_date,
                update_by          ,
                to_char (update_date,''DD MON YYYY HH24:MI'') update_date
        from ld_user_master ';
      if length(as_search_text) > 0 then
        s_sql := s_sql || 'where lower(user_id) like ''%' || s_search_text || '%'' or lower(user_name) like ''%' || s_search_text || '%'' 
                 or lower(designation) like ''%' || s_search_text || '%'' or lower(department) like ''%' || s_search_text || '%''';
      end if;
      dbms_output.put_line(s_sql);
    open p_cur_user for s_sql;

  end p_get_user_in_search ;

   procedure p_get_user(as_user_id in varchar2, as_user_name in varchar2, p_cur_user   out sys_refcursor)
  as
  s_sql varchar2(1000);
  begin
    s_sql := 'select user_id,
                user_name          ,
                os_authentication,
                pwd,
                designation,
                department               ,
                status             ,
                admin_prev         ,
                phone          ,
                e_mail             ,
                insert_by          ,
                to_char (insert_date,''DD MON YYYY HH24:MI'') insert_date,
                update_by          ,
                to_char (update_date,''DD MON YYYY HH24:MI'') update_date
        from ld_user_master ';
      if length(as_user_id) > 0 then
        s_sql := s_sql || 'where user_id = ''' || as_user_id || '''';
      elsif length(as_user_name) > 0 then
        s_sql := s_sql || 'where user_name = ''' || as_user_name || '''';
      end if;
      -- dbms_output.put_line(s_sql);
    open p_cur_user for s_sql;

  end p_get_user ;


  /******************************************************************************/
  /* To Get a user picklist                    */
  /******************************************************************************/
  procedure p_get_user_picklist(as_user_id in varchar2, as_team_section in varchar2, p_cur_user   out sys_refcursor)
  as
  begin
    open p_cur_user for
        select null user_id, null user_name from dual
        union all
        select user_id,
                user_name

        from ld_user_master
        where user_id = decode(as_user_id, 'ALL', user_id, as_user_id);
  end p_get_user_picklist ;
  /******************************************************************************/
  /* To insert or update user            */
  /******************************************************************************/
  procedure p_insupd_user (as_user_id in varchar2, as_user_name in varchar2, as_os_authentication in varchar2, as_pwd in varchar2,
                           as_designation in varchar2, as_department in varchar2, as_status in varchar2, as_admin_prev in varchar2, as_phone in varchar2,
                            as_email varchar2, as_user in varchar2, p_msg out varchar2)
  as
  i_count   integer;
  begin
    select count(1) into i_count from ld_user_master where user_id = as_user_id;
    if i_count > 0 then

        update ld_user_master set user_name     = as_user_name     ,
                                os_authentication  = as_os_authentication,
                                pwd             = as_pwd,
                                designation     = as_designation,
                                department      = as_department  ,
                                status          = as_status  ,
                                admin_prev      = as_admin_prev ,
                                phone         = as_phone  ,
                                e_mail          = as_email  ,
                                update_by       = as_user  ,
                                update_date     = sysdate
         where user_id = as_user_id;
         p_msg:='User modified Succesfully';
    else
        insert into ld_user_master (user_id,
                            user_name          ,
                            os_authentication,
                            pwd,
                            designation,
                            department               ,
                            status             ,
                            admin_prev         ,
                            phone          ,
                            e_mail             ,
                            insert_by          ,
                            insert_date)
                    values (as_user_id,
                            as_user_name,
                            as_os_authentication,
                            as_pwd,
                            as_designation,
                            as_department,
                            as_status,
                            as_admin_prev ,
                            as_phone          ,
                            as_email,
                            as_user,
                            sysdate);
                   p_msg:='User added Succesfully';
    end if;
   end p_insupd_user;
    procedure p_change_pwd (as_user_id in varchar2, as_pwd in varchar2)
    as
    begin
        update ld_user_master set pwd = as_pwd where user_id = as_user_id;
        commit;
    end p_change_pwd;

 procedure p_get_username(as_user_id in varchar2, p_cur_user out sys_refcursor)
  as
 ls_sql varchar2(200);
  begin
    ls_sql := 'select user_id from sr_user_master where lower(user_id) like ''' || lower(as_user_id) || '%'' or lower(user_name) like ''%' || lower(as_user_id) || '%''';

    open p_cur_user for ls_sql
        ;
  end p_get_username ;

  procedure p_get_username_by_userid(as_user_id in varchar2, p_cur_user out sys_refcursor)
  as
  begin
  open p_cur_user for
  select user_name,admin_prev from ld_user_master where user_id=as_user_id;


  end p_get_username_by_userid ;


  procedure p_get_user_details(as_user_id in varchar2, p_cur_user out sys_refcursor)
  as
  begin

   if as_user_id ='ALL' then
             open p_cur_user for
              select User_Id,
               employee_Name,
               email,
               tel_no,
               mobile,
               department,
               division
             from LD_TBL_V_PERSON;

    else

        open p_cur_user for
        select User_Id,
           employee_Name,
           email,
           tel_no,
           mobile,
           department,
           division
        from LD_TBL_V_PERSON
        where User_Id = as_user_id;

        end if;

  end p_get_user_details ;

  procedure p_get_user_from_directory(as_user_id in varchar2, p_cur_user out sys_refcursor)
  as
  begin


    if as_user_id is not null then
                   open p_cur_user for

                    select  User_Id,
                    employee_Name,
                    email,
                    tel_no,
                    mobile,
                    department,
                    division
                    from ld_TBL_V_PERSON
                    where User_Id not in(select User_Id from ld_user_master) ;



       end if;

  end p_get_user_from_directory;

  procedure p_delete_user(as_user_id in varchar2, p_msg out varchar2)
  as
  begin

    delete from ld_user_master
    where user_id = as_user_id;
    p_msg:='User has been deleted Succesfully';

  end p_delete_user;
end ld_pkg_user;
/


