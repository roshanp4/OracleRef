DROP PROCEDURE LDS_NEW.ZZ_P_GET_ATTR_LIST_FOR_SEARCH;

CREATE OR REPLACE PROCEDURE LDS_NEW.zz_p_get_attr_list_for_search(as_user in varchar2, p_cur_attr out sys_refcursor)
as
begin
    open p_cur_attr for
    select  am.attr_id    ,
            attr_name    ,
            case when am.attr_id = sa.attr_id then 'true'  else 'false'  end as status
    from ld_attr_master am
    left join zz_ld_user_search_attribute sa  on am.attr_id = sa.attr_id
    and sa.user_id = as_user;

end zz_p_get_attr_list_for_search;
/


DROP PROCEDURE LDS_NEW.P_UPDATE_OBJECT_STATUS;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_update_object_status(an_object_id  in number,
                                                         as_status in varchar2 ,  p_msg out varchar )
as
i_count     integer;
begin
       update ld_object
       set status = as_status
       where object_id = an_object_id;
       p_msg := 'Object Status Modified Successfully.';
       commit;

end p_update_object_status;
/


DROP PROCEDURE LDS_NEW.P_UPDATE_OBJECT_PARENT_ID;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_update_object_parent_id(an_object_id  in number,
                                                         as_parent_id in varchar2 ,  p_msg out varchar )
as
i_count     integer;
begin
       update ld_object
       set parent_id = as_parent_id
       where object_id = an_object_id;
       p_msg := 'Object Parent ID Modified Successfully.';
       commit;

end p_update_object_parent_id;
/


DROP PROCEDURE LDS_NEW.P_UPDATE_OBJECT_FILEPATH;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_update_object_filePath(an_object_id  in number,
                                                         as_file_path in varchar2 ,  p_msg out varchar )
as
i_count     integer;
begin
       update ld_object
       set File_Path = as_file_path
       where object_id = an_object_id;
       p_msg := 'Object file path Modified Successfully.';
       commit;

end p_update_object_filePath;
/


DROP PROCEDURE LDS_NEW.P_SEARCH_OBJECT_LIST;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_search_object_List(an_Library_Id in number, p_cur_objects out sys_refcursor)
as
begin

    open p_cur_objects for
    select  object_id    ,
            object_name    ,
            object_type    , --F (Folder), D (Document)
            file_path    ,
            current_version    ,
            file_type    ,
          (case     when file_size <= 1024 then to_char(file_size) || ' Byte'
                    when file_size <= 1048576 then to_char(round(file_size/1024,2)) || ' KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || ' MB'
                    when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || ' GB'
                    else '0 KB'
             end) file_size,
            description,
            library_id    ,
            Status,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) icon_image_name,
            nvl(owner, insert_by) owner,
            insert_by    ,
            insert_date    ,
            update_by    ,
            update_date
    from ld_object
    WHERE library_id =an_Library_Id ;
end p_search_object_List;
/


DROP PROCEDURE LDS_NEW.P_SEARCH_LIBRARY;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_search_library(as_search_parm in varchar2, p_cur_library out sys_refcursor)
as
s_search_parm varchar2(300);
s_sql varchar2(1000);
begin
    s_search_parm := lower(as_search_parm);
    
    s_sql := 'select  library_id    ,
            library_name    ,
            parent_id    ,
            icon_image_name    ,
            description    ,
            nvl(owner, insert_by) owner    ,
            status    ,
            insert_by    ,
            insert_date    ,
            update_by    ,
            update_date
    from ld_library
    where (to_char(library_id) like ''%' || s_search_parm || '%'' or lower(library_name) like ''%' || s_search_parm || '%'' or lower(description) like ''%' || s_search_parm || '%'')'
    ;
    open p_cur_library for s_sql;
    dbms_output.put_line(s_sql);
end p_search_library;
/


DROP PROCEDURE LDS_NEW.P_SEARCH_ATTR_LIST;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_search_attr_list(as_status in varchar2, as_attr_name in varchar2, p_cur_attr out sys_refcursor)
as
s_search_text   varchar2(200);
begin
    s_search_text := lower(as_attr_name);
    open p_cur_attr for
    select  a.attr_id    ,
            a.attr_name    ,
            case a.data_type
                when 'S' then 'String'
                when 'N' then 'Number'
                when 'I' then 'Integer'
                when 'D' then 'Date'
            end as data_type,
            a.status,
                case a.style
                when 'TB' then 'Text Box'
                when 'CB' then 'Check box'
                when 'DL' then 'Dropdown List'
                when 'CL' then 'Checkbox List'
                when 'DT' then 'DateTime Picker'
                when 'NB' then 'Number'
                when 'RB' then 'Radio Button'
                when 'HL' then 'Hyper Link'
            end as style,
            a.style as stylesml,
            a.description,
            a.default_val_flag,
            a.default_val,
            a.val_mand,
            a.inherit_mand,
            a.library_id,
            decode(a.library_id, 0, 'System', l.library_name) library_name,
            a.insert_by    ,
            a.insert_date    ,
            a.update_by    ,
            a.update_date
    from ld_attr_master a
    left outer join ld_library l on a.library_id = l.library_id
    where a.library_id = 0 
    and (lower(a.attr_name) like  '%' || s_search_text ||'%' 
        or lower(a.description) like  '%' || s_search_text ||'%'
        or to_char(a.attr_id) = s_search_text) 
    
    order by a.attr_name asc;
    --where status = decode(as_status, 'f', status,  as_status) ;

end p_search_attr_list;
/


DROP PROCEDURE LDS_NEW.P_SAVE__USER_ROLE;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save__user_role( as_user_id in varchar2,
                                        as_role_id in varchar2,
                                        as_delete_flag in varchar2,
                                        p_msg out varchar)
as
begin

         if as_delete_flag = 'Y' then
                delete from ld_user_role where user_id = as_user_id;
         end if;

         if as_role_id <> 'D' then
              insert into ld_user_role (
                user_id   ,
                role_id,
                insert_by,
                insert_date,
                update_by   ,
                update_date)
               values(
                as_user_id,
                as_role_id,
                as_user_id,
                sysdate,
                null,
                null);
         p_msg :='New User Role Added successfully';
         end if;



    commit;
end p_save__user_role;
/


DROP PROCEDURE LDS_NEW.P_SAVE__ACCESS_ROLE;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save__access_role( as_role_id in varchar2,
                                        as_role_name in varchar2,
                                        as_description in varchar2,
                                        as_user_id in varchar2,
                                        p_msg out varchar)
as
--n_group_id   number;
i_count     integer;
begin
    select count(*) into i_count from ld_role_master where role_id = as_role_id;

    if i_count > 0 then
       update ld_role_master
            set role_id = as_role_id   ,
                role_name    = as_role_name,
                description    = as_description,
                update_by = as_user_id   ,
                update_date = sysdate
        where role_id =  as_role_id ;
        p_msg :='Access Role modified successfully';

    else

       insert into ld_role_master (
                role_id   ,
                role_name,
                description,
                insert_by,
                insert_date,
                update_by   ,
                update_date)
               values(
                as_role_id,
                as_role_name,
                as_description,
                as_user_id,
                sysdate,
                null,
                null);
         p_msg :='New Access Role Added successfully';
         end if;

    commit;
end p_save__access_role;
/


DROP PROCEDURE LDS_NEW.P_SAVE_USER_ROLE_MASTER;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_User_Role_Master(an_role_id  in number,
                                        as_role_name in varchar2,
                                        as_Description in varchar2,
                                        as_user in varchar2,
                                        p_msg  out varchar2)
as

n_role_id   number;
i_count     integer;
i_count_name     integer;
begin
    select count(*) into i_count from LD_USER_ROLE_MASTER where ROLE_ID = an_role_id;
    select count(*) into i_count_name from LD_USER_ROLE_MASTER where ROLE_NAME = as_role_name and ROLE_ID <> an_role_id;
     if i_count_name > 0 then
            p_msg := 'Role Name should not be same with previous.';
            return;
        end if;

    if i_count > 0 then
        update LD_USER_ROLE_MASTER
            set ROLE_NAME = as_role_name   ,
                DESCRIPTION = as_Description   ,
                update_by = as_user   ,
                update_date = sysdate
        where ROLE_ID =  an_role_id;
        p_msg := 'Updated Successfully.';
     else


        select nvl(max(ROLE_ID), 0) + 1 into n_role_id from LD_USER_ROLE_MASTER;
        insert into LD_USER_ROLE_MASTER
                (ROLE_ID    ,
                ROLE_NAME    ,
                DESCRIPTION,
                insert_by    ,
                insert_date    ,
                update_by    ,
                update_date )
        values (n_role_id    ,
                as_role_name    ,
                as_Description,
                as_user    ,
                sysdate    ,
                null    ,
                null )  ;
                p_msg := 'Inserted Successfully.';
      end if;
end p_save_User_Role_Master;
/


DROP PROCEDURE LDS_NEW.P_SAVE_SEARCH_ATTRIBUTES;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_search_attributes(as_user in varchar2,an_attr_id in number,as_delete_flag in varchar2 )
as
begin

    if as_delete_flag = 'Y' then
            delete from ld_user_search_attribute
            where user_id = as_user;

    elsif as_delete_flag = 'N' then
            insert into ld_user_search_attribute
                (
                    user_id,
                    attr_id
                 )
                VALUES
                (
                    as_user,
                    an_attr_id
                );
     end if;
end p_save_search_attributes;
/


DROP PROCEDURE LDS_NEW.P_SAVE_ROLE_MASTER;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_role_master(an_role_id  in number,
                                        as_role_name in varchar2,
                                        as_description in varchar2,
                                        as_user in varchar2,
                                        p_msg  out varchar2)
as

n_role_id   number;
i_count     integer;
i_count_name     integer;
begin
    select count(*) into i_count from ld_user_role_master where role_id = an_role_id;
    select count(*) into i_count_name from ld_user_role_master where role_name = as_role_name and role_id <> an_role_id;
     if i_count_name > 0 then
            p_msg := 'Role Name should not be same with previous.';
            return;
        end if;

    if i_count > 0 then
        update ld_user_role_master
            set role_name = as_role_name   ,
                description = as_description   ,
                update_by = as_user   ,
                update_date = sysdate
        where role_id =  an_role_id;
        p_msg := 'Updated Successfully.';
        dbms_output.put_line('ghfgffg');
     else


        select nvl(max(role_id), 0) + 1 into n_role_id from ld_user_role_master;
        insert into ld_user_role_master
                (role_id    ,
                role_name    ,
                description,
                insert_by    ,
                insert_date    ,
                update_by    ,
                update_date )
        values (n_role_id    ,
                as_role_name    ,
                as_description,
                as_user    ,
                sysdate    ,
                null    ,
                null )  ;
                p_msg := 'Inserted Successfully.';
      end if;
end p_save_role_master;
/


DROP PROCEDURE LDS_NEW.P_SAVE_OBJECT_NAME;

CREATE OR REPLACE PROCEDURE LDS_NEW.P_SAVE_OBJECT_NAME(an_object_id in number,as_file_path in varchar,as_object_name in varchar, an_version in number)
as
begin
    --open p_cur_group for
    update ld_object
    set object_name = as_object_name,
        file_path=as_file_path,
        current_version = an_version
    where object_id=an_object_id;

   --  update ld_object
   -- set file_path = (select replace(as_file_path,as_file_path,as_file_path_change)
   --                         from ld_object where file_path like '%'||as_file_path||'%')
   --  where object_id=an_object_id;

end P_SAVE_OBJECT_NAME;
/


DROP PROCEDURE LDS_NEW.P_SAVE_OBJECT_ATTR;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_object_attr(an_object_id  in number,
                                                an_version_number in number   ,
                                                an_attr_id in number   ,
                                                as_attr_val in varchar2   ,
                                                as_val_mand  in varchar2  ,
                                                as_style  in varchar2,
                                                as_user in varchar2)
as
i_count         integer;
s_data_type     varchar2(2);
s_val_string    varchar2(3000);
d_val_date      date;
n_val_number    number;
i_val_integer   integer;

begin
    select count(1) into i_count from ld_object_attribute
            where object_id = an_object_id
            and   version_number = an_version_number
            and   attr_id = an_attr_id;

    select data_type into s_data_type from ld_attr_master where   attr_id = an_attr_id;
    if s_data_type = 'S' then
       s_val_string := as_attr_val;
    elsif s_data_type = 'D' then
       d_val_date := to_date(as_attr_val);
    elsif s_data_type = 'N' then
       n_val_number := to_number(as_attr_val);
    elsif s_data_type = 'I' then
       i_val_integer := to_number(as_attr_val);
        end if;

    if i_count > 0 then

        update ld_object_attribute
            set data_type  = s_data_type ,
                val_string = s_val_string  ,
                val_date  = d_val_date ,
                val_number =  n_val_number  ,
                val_lob  = null ,
                val_mand =  as_val_mand ,
                style = as_style,
                update_by   = as_user ,
                update_date = sysdate
        where object_id =  an_object_id
        and   version_number = an_version_number
        and   attr_id = an_attr_id;

     else

        insert into ld_object_attribute
                (object_id    ,
                version_number    ,
                attr_id    ,
                data_type    ,
                val_string    ,
                val_date    ,
                val_number    ,
                val_lob    ,
                val_mand    ,
                style    ,
                update_by    ,
                update_date
                 )
        values (an_object_id    ,
                an_version_number    ,
                an_attr_id    ,
                s_data_type    ,
                s_val_string    ,
                d_val_date    ,
                n_val_number    ,
                null    ,
                as_val_mand    ,
                as_style    ,
                as_user    ,
                sysdate    )  ;
      end if;
      commit;
end p_save_object_attr;
/


DROP PROCEDURE LDS_NEW.P_SAVE_OBJECT_ACCESS;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_object_access(an_object_id  in number,
                                        as_user_id in varchar2,
                                        an_read_acc in number,
                                        an_add_acc in number,
                                        an_modify_acc in number,
                                        an_delete_acc in number,
                                        an_add_attr in number,
                                        an_edit_attr in number,
                                        an_delete_attr in number,
                                        an_edit_permission in number,
                                        as_is_user in varchar2,
                                        p_msg out varchar)
as
i_count     integer;
s_filepath varchar(300);

begin

    select count(*) into i_count from ld_object_access where object_id = an_object_id and user_id = as_user_id;

    select file_path into s_filepath from ld_object where object_id = an_object_id;
    /*
    select  LISTAGG(object_id, ',')  WITHIN GROUP (ORDER BY object_id)
    into objectIds
    from ld_object
    where file_path like filepath || '%';
 */
    if i_count > 0 then
       update ld_object_access la
            set read_acc = an_read_acc   ,
                add_acc    = an_add_acc,
                modify_acc    = an_modify_acc,
                delete_acc = an_delete_acc   ,
                add_attr    = an_add_attr,
                edit_attr    = an_edit_attr,
                delete_attr    = an_delete_attr,
                edit_permission    = an_edit_permission,
                is_user = as_is_user,
                update_by = as_user_id   ,
                update_date = sysdate
        where  exists  (select object_id   from ld_object lo
                              where lo.object_id=la.object_id and lo.file_path like s_filepath || '%')
         and user_id = as_user_id;
        p_msg :='Object Access modified successfully';

    else
       -- select nvl(max(group_id), 0) + 1 into n_group_id from ld_attr_group_master;
       insert into ld_object_access (
                object_id,
                user_id,
                read_acc,
                add_acc,
                modify_acc,
                delete_acc,
                add_attr,
                edit_attr,
                delete_attr,
                edit_permission,
                is_user,
                insert_by,
                insert_date,
                update_by,
                update_date)
               (
               select
                object_id,
                as_user_id,
                1,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                as_is_user,
                as_user_id,
                sysdate,
                null,
                null
                from ld_object
                where file_path like s_filepath || '%'
                 );
         p_msg :='New Access Added successfully';
         end if;

    commit;
end p_save_object_access;
/


DROP PROCEDURE LDS_NEW.P_SAVE_OBJECT;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_object(an_object_id  in number,
                                              as_object_name in varchar2,
                                              as_object_type in varchar2,
                                              as_file_path in varchar2,
                                              an_current_version in number,
                                              as_file_type in varchar2,
                                              an_file_size  in number,
                                              as_description in varchar2,
                                              an_library_id in number,
                                              as_icon_image_name in varchar2,
                                              as_user in varchar2,
                                              an_new_object_id out number,
                                              as_owner in varchar2,
                                              as_status varchar2,
                                              an_vault_id number,
                                              p_msg  out varchar2
                                              )
as
i_count     integer;
i_count_permission integer;
begin
    select count(*) into i_count from ld_object where object_id = an_object_id;

    if i_count > 0 then
        update ld_object
            set object_name = as_object_name   ,
                object_type = as_object_type   ,
                file_path   = as_file_path ,
                current_version = an_current_version   ,
                file_type  = as_file_type  ,
                file_size = an_file_size,
                description = as_description,
                update_by   = as_user ,
                update_date = sysdate   ,
                icon_image_name = as_icon_image_name ,
                status = as_status,
                vault_id = an_vault_id,
                library_id=an_library_id
        where object_id =  an_object_id; --changed.....to an_object_id; ROSHAN
     else
        select ld_object_id.nextval into an_new_object_id from dual ;
        insert into ld_object
                (object_id    ,
                object_name    ,
                object_type    ,
                file_path    ,
                current_version    ,
                file_type    ,
                file_size,
                description,
                library_id    ,
                owner,
                insert_by    ,
                insert_date    ,
                update_by    ,
                update_date    ,
                icon_image_name,
                status,
                vault_id)
        values(  an_new_object_id    ,
                as_object_name    ,
                as_object_type    ,
                as_file_path    ,
                an_current_version    ,
                as_file_type    ,
                an_file_size,
                as_description,
                an_library_id    ,
                as_owner,
                as_user    ,
                sysdate    ,
                null    ,
                null    ,
                as_icon_image_name,
                as_status,
                an_vault_id  );

         --To copy Parent attributes
         insert into ld_object_attribute
                (object_id,
                version_number,
                attr_id,
                data_type,
                val_string,
                val_date,
                val_number,
                val_lob,
                val_mand,
                style,
                update_by,
                update_date)
        select  an_new_object_id,
                an_current_version,
                attr_id ,
                data_type,
                null,
                null,
                null,
                null ,
                null,
                style ,
                update_by ,
                update_date
          from  ld_attr_master
         where  library_id = an_library_id;

--          --To Copy Parent Permission settings
--          select count(*) into i_count_permission from ld_object_access
--          where object_id = an_parent_id;

--          if i_count_permission > 0  then

--            insert into ld_object_access
--              (object_id,
--               user_id,
--               read_acc,
--               add_acc,
--               modify_acc,
--               delete_acc,
--               add_attr,
--               edit_attr,
--               delete_attr,
--               edit_permission,
--               insert_by,
--               insert_date,
--               update_by,
--               update_date,
--               is_user )
--             select
--               an_new_object_id,
--               user_id,
--               read_acc,
--               add_acc,
--               modify_acc,
--               delete_acc,
--               add_attr,
--               edit_attr,
--               delete_attr,
--               edit_permission,
--               insert_by,
--               insert_date,
--               update_by,
--               update_date,
--               is_user
--             from ld_object_access
--             where object_id = an_parent_id;
--          end if;
      end if;
end p_save_object;
/


DROP PROCEDURE LDS_NEW.P_SAVE_LIBRARY;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_library(an_library_id  in number,
                                              as_library_name in varchar2,
                                              an_parent_id in number,
                                              as_icon_image_name in varchar2,
                                              as_description in varchar2,
                                              as_owner in varchar2,
                                              as_status in varchar2,
                                              as_user  in varchar2,
                                              p_msg out varchar2,
                                              p_LibraryId out varchar2
                                              )
as
i_count     integer;
i_count_permission integer;
n_new_library_id    number;
n_group_id          number;
n_attr_id          number;
i_exists            int;
begin
    select count(*) into i_count from ld_library where library_id = an_library_id;

    if i_count > 0 then
        select count(*) into i_exists from ld_library where lower(library_name) = lower(as_library_name) and library_id <> an_library_id;
        if i_exists > 0 then
            p_msg :='Library name entered already exists in database';
            return;
        end if;
        update ld_library
            set library_name = as_library_name,
                parent_id = an_parent_id,
                icon_image_name = as_icon_image_name,
                description = as_description,
                owner = as_owner,
                status = as_status,
                update_by   = as_user ,
                update_date = sysdate 
        where library_id = an_library_id;
        p_msg := 'Library modified successfully';
     else
        select count(*) into i_exists from ld_library where lower(library_name) = lower(as_library_name);
        if i_exists > 0 then
            p_msg := 'Library name entered already exists in database';
            return;
        end if;
        
        select nvl(max(library_id), 0) + 1 into n_new_library_id from ld_library ;
        insert into ld_library
                (library_id    ,
                library_name    ,
                parent_id    ,
                icon_image_name    ,
                description    ,
                owner    ,
                status    ,
                insert_by    ,
                insert_date   )
        values( n_new_library_id,
                as_library_name    ,
                an_parent_id    ,
                as_icon_image_name    ,
                as_description    ,
                as_owner,     
                'A'    ,
                as_user    ,
                sysdate   );
                p_LibraryId:=n_new_library_id;
                
        -- Add an attribute with the same of library
        select nvl(max(attr_id), 0) into n_attr_id from ld_attr_master;
            insert into ld_attr_master
                    (attr_id    ,
                    library_id,
                    attr_name    ,
                    data_type    ,
                    status,
                    style,
                    description,
                    default_val_flag,
                    default_val,
                    val_mand,
                    inherit_mand,
                    insert_by    ,
                    insert_date    ,
                    update_by    ,
                    update_date )
            values( n_attr_id + 1,
                    n_new_library_id,
                    as_library_name    ,
                    'S'    ,
                    'A',
                    'DL',
                    null,
                    'N',
                    null,
                    'Y',
                    'Y',
                    as_user    ,
                    sysdate    ,
                    null    ,
                    null );
        
--         to copy parent attributes
        if an_parent_id > 0 then
           --copy attr group info
           
           select nvl(max(group_id), 0) into n_group_id from  ld_attr_group_master;
           insert into ld_attr_group_master
                select  n_group_id + rownum, 
                        n_new_library_id    ,
                        group_name    ,
                        'A'    ,
                        as_user    ,
                        sysdate    
                from ld_attr_group_master 
                where  library_id = an_parent_id;
            -- copy group attr mapping
                
           insert into ld_attr_group
                 select c.group_id    ,
                        ca.attr_id    ,
                        as_user    ,
                        sysdate    
                 from ld_attr_group_master p
                 inner join ld_attr_group_master c on p.library_id = c.library_id
                 inner join ld_attr_group ca on c.group_id = ca.group_id
                 where  p.library_id = an_parent_id
                 and c.library_id = n_new_library_id;
              
         --copy attributes
             
            select nvl(max(attr_id), 0) into n_attr_id from ld_attr_master;
            insert into ld_attr_master
                    (attr_id    ,
                    library_id,
                    attr_name    ,
                    data_type    ,
                    status,
                    style,
                    description,
                    default_val_flag,
                    default_val,
                    val_mand,
                    inherit_mand,
                    insert_by    ,
                    insert_date    ,
                    update_by    ,
                    update_date )
            select  n_attr_id + rownum,
                    n_new_library_id,
                    attr_name    ,
                    data_type    ,
                    status,
                    style,
                    description,
                    default_val_flag,
                    default_val,
                    val_mand,
                    inherit_mand,
                    as_user    ,
                    sysdate    ,
                    null    ,
                    null 
              from  ld_attr_master 
              where library_id = an_parent_id;

--          --to copy parent permission settings
--          select count(*) into i_count_permission from ld_object_access
--          where object_id = an_parent_id;

--          if i_count_permission > 0  then

--            insert into ld_object_access
--              (object_id,
--               user_id,
--               read_acc,
--               add_acc,
--               modify_acc,
--               delete_acc,
--               add_attr,
--               edit_attr,
--               delete_attr,
--               edit_permission,
--               insert_by,
--               insert_date,
--               update_by,
--               update_date,
--               is_user )
--             select
--               an_new_object_id,
--               user_id,
--               read_acc,
--               add_acc,
--               modify_acc,
--               delete_acc,
--               add_attr,
--               edit_attr,
--               delete_attr,
--               edit_permission,
--               insert_by,
--               insert_date,
--               update_by,
--               update_date,
--               is_user
--             from ld_object_access
--             where object_id = an_parent_id;
                
          end if;
           p_msg := 'Library created successfully';
           p_LibraryId:=n_new_library_id;
      end if;
end p_save_library;
/


DROP PROCEDURE LDS_NEW.P_SAVE_LDS_API_OBJECT;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_lds_api_object(an_object_id  in number,
                                              as_object_name in varchar2,
                                              as_object_type in varchar2,
                                              as_file_path in varchar2,
                                              an_current_version in number,
                                              as_file_type in varchar2,
                                              an_file_size  in number,
                                              as_description in varchar2,
                                              an_parent_id in number,
                                              as_icon_image_name in varchar2,
                                              as_user in varchar2,
                                              an_new_object_id out number,
                                              as_owner in varchar2
                                              )
as
i_count     integer;

begin
    select count(*) into i_count from ld_object where object_id = an_object_id;

    if i_count > 0 then
        update ld_object
            set object_name = as_object_name   ,
                object_type = as_object_type   ,
                file_path   = as_file_path ,
                current_version = an_current_version   ,
                file_type  = as_file_type  ,
                file_size = an_file_size,
                description = as_description,
                parent_id  = an_parent_id  ,
                update_by   = as_user ,
                update_date = sysdate   ,
                icon_image_name = as_icon_image_name
        where object_id =  an_object_id; --changed.....to an_object_id; ROSHAN
     else
        select ld_object_id.nextval into an_new_object_id from dual ;
        insert into ld_object
                (object_id    ,
                object_name    ,
                object_type    ,
                file_path    ,
                current_version    ,
                file_type    ,
                file_size,
                description,
                parent_id    ,
                owner,
                insert_by    ,
                insert_date    ,
                update_by    ,
                update_date    ,
                icon_image_name )
        values(  an_new_object_id    ,
                as_object_name    ,
                as_object_type    ,
                as_file_path    ,
                an_current_version    ,
                as_file_type    ,
                an_file_size,
                as_description,
                an_parent_id    ,
                as_owner,
                as_user    ,
                sysdate    ,
                null    ,
                null    ,
                as_icon_image_name   );

      end if;
end p_save_lds_api_object;
/


DROP PROCEDURE LDS_NEW.P_SAVE_ATTR_LIST_VAL;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_attr_list_val(an_attr_id  in number,
                                        as_val in varchar2,
                                        as_user in varchar2)
as

begin
        insert into LD_ATTR_LIST_VAL
                (ATTR_ID    ,
                VAL    ,
                UPDATE_BY    ,
                UPDATE_DATE)
        values (an_attr_id   ,
                as_val    , 
                as_user,            
                sysdate )  ;
end p_save_attr_list_val;
/


DROP PROCEDURE LDS_NEW.P_SAVE_ATTR_GROUP_MASTER;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_attr_group_master(an_group_id  in number,
                                        as_group_name in varchar2,
                                        as_status in varchar2,
                                        as_user in varchar,
                                        as_library_id in number,
                                        p_msg out varchar,
                                        GroupId out varchar)
as
n_group_id   number;
i_count     integer;
i_count_name integer;
begin
    select count(*) into i_count from ld_attr_group_master where group_id = an_group_id ;

        

    if i_count > 0 then
        select count(*) into i_count_name from ld_attr_group_master 
            where lower(group_name) = lower(as_group_name) and group_id <> an_group_id and library_id = as_library_id;
        if i_count_name > 0 then
            p_msg :='The entered already exists in database. Please try another one......';
            GroupId := 0;
            return;
        end if;
            
        update ld_attr_group_master
            set group_name = as_group_name   ,
                status    = as_status,
                library_id=as_library_id,
                update_by = as_user   ,
                update_date = sysdate
        where group_id =  an_group_id;
        p_msg :='Attribute Group modified successfully';
        GroupId := an_group_id;
     else
        select count(*) into i_count_name from ld_attr_group_master where lower(group_name) = lower(as_group_name);
        if i_count_name > 0 then
            p_msg :='The entered already exists in database. Please try another one.';
            GroupId := 0;
            return;
        end if;
        select nvl(max(group_id), 0) + 1 into n_group_id from ld_attr_group_master;
        insert into ld_attr_group_master
                (group_id    ,
                group_name    ,
                status,
                library_id,
                update_by    ,
                update_date )
        values (n_group_id    ,
                as_group_name    ,
                as_status,
                as_library_id,
                as_user    ,
                sysdate  );
         p_msg :='Attribute Group Added successfully';
         GroupId := n_group_id;
      end if;



    commit;
end p_save_attr_group_master;
/


DROP PROCEDURE LDS_NEW.P_SAVE_ATTR_GROUP;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_attr_group(an_group_id  in number,
                                        as_attr_id in number,
                                        
                                        as_user in varchar2,
                                        as_delete_flag in varchar2)
as

begin
     if as_delete_flag = 'Y' then
        delete from ld_attr_group where group_id = an_group_id;
     end if;
        insert into ld_attr_group
                (group_id    ,
                attr_id,
                
                update_by,
                update_date )
        values (an_group_id    ,
                as_attr_id,
                
                as_user,
                sysdate );

    commit;
end p_save_attr_group;
/


DROP PROCEDURE LDS_NEW.P_SAVE_ATTR;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_save_attr(
                                        an_attr_id  in number,
                                        
                                        as_attr_name in varchar2,
                                        as_data_type in varchar2,
                                        as_status in varchar2,
                                        as_user in varchar2,
                                       
                                        as_style in varchar2,
                                        as_description in varchar2,
                                        as_default_val_flag in varchar2,
                                        as_default_val  in varchar2,
                                        
                                        as_library_id in number,
                                        as_val_man in varchar2,
                                        as_inh_man in varchar2,
                                        p_msg  out varchar2,
                                        attributeid out number
                                        )
as

n_attr_id   number;
i_count     integer;
i_count_name     integer;
begin
    select count(*) into i_count from ld_attr_master where attr_id = an_attr_id;
    

    if i_count > 0 then
        select count(*) into i_count_name from ld_attr_master where library_id = as_library_id and lower(attr_name) = lower(as_attr_name) and attr_id <> an_attr_id;
        if i_count_name > 0 then
                p_msg := 'Attribute Name entered already exists in database.';
                return;
        end if;
        
        update ld_attr_master
            set attr_name = as_attr_name   ,
                data_type = as_data_type   ,
                status    = as_status,
                style = as_style,
                description = as_description,
                default_val_flag = as_default_val_flag,
                default_val = as_default_val,
                update_by = as_user   ,
                update_date = sysdate,
                val_mand = as_val_man,
                inherit_mand = as_inh_man,
                library_id = as_library_id
        where attr_id =  an_attr_id;
        p_msg := 'Updated Successfully.';
     else
        select count(*) into i_count_name from ld_attr_master where library_id = as_library_id and lower(attr_name) = lower(as_attr_name);
        if i_count_name > 0 then
                p_msg := 'Attribute Name entered already exists in database.';
                return;
        end if;

        select attr_id.nextval into n_attr_id from ld_attr_master;
        insert into ld_attr_master
                (attr_id    ,
                attr_name    ,
                data_type    ,
                status,
                style,
                description,
                default_val_flag,
                default_val,
                val_mand,
                inherit_mand,
                library_id,
                insert_by    ,
                insert_date    ,
                update_by    ,
                update_date )
        values (n_attr_id    ,
                as_attr_name    ,
                as_data_type    ,
                as_status,
                as_style,
                as_description,
                as_default_val_flag,
                as_default_val,
                as_val_man,
                as_inh_man,
                as_library_id,
                as_user    ,
                sysdate    ,
                null    ,
                null )  ;
                p_msg := 'Inserted Successfully.';
                attributeid := n_attr_id;
      end if;
end p_save_attr;
/


DROP PROCEDURE LDS_NEW.P_REPLACE_FOLDER_PATH;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_replace_folder_path( as_file_path  in varchar2,
                                                       as_new_file_path in varchar2)
as
begin
    update ld_object
    set file_path = REPLACE(file_path, as_file_path||'\', as_new_file_path||'\');
    commit;
end p_replace_folder_path;
/


DROP PROCEDURE LDS_NEW.P_GET_VAULT_ID;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_vault_id(an_library_id in number, p_vault_id out number, p_vault_path out varchar2)
as
n_vault_id    number;
i_count     int;
begin
    select parm_value into p_vault_path from ld_system_parm where parm_code = 'ROOT_PATH';

    select nvl(max(vault_id), 0) into n_vault_id from ld_vault where library_id = an_library_id and object_count < 100;
    if n_vault_id <=  0 then
        select nvl(max(vault_id), 0) + 1 into n_vault_id from ld_vault;
        insert into ld_vault values (n_vault_id, 'Vault' || lpad(to_char(n_vault_id), 2, '0'), an_library_id, '\Library' || to_char(an_library_id), 0);
     end if;
     p_vault_path := p_vault_path || '\Library' || to_char(an_library_id) || '\Vault' || lpad(to_char(n_vault_id), 2, '0');
     p_vault_id := n_vault_id;
     commit;
    dbms_output.put_line('Path:' || to_char(p_vault_id));
end p_get_vault_id;
/


DROP PROCEDURE LDS_NEW.P_GET_USER_SEARCH_ATTRIBUTE;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_user_search_attribute(as_user_id in varchar2, p_cur_search out sys_refcursor)
as
begin


        open p_cur_search for
        select
                s.attr_id,
                a.attr_name,
                a.data_type,
                decode(a.data_type,'S','VAL_STRING',a.data_type) data_type_desc
        from ld_user_search_attribute s ,
             ld_attr_master a
        where  s.attr_id = a.attr_id
        and s.user_id = as_user_id ;

end p_get_user_search_attribute;
/


DROP PROCEDURE LDS_NEW.P_GET_USER_ROLE;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_user_role(as_user_id varchar2,as_role_id varchar2, p_cur_access out sys_refcursor)
as
begin
    open p_cur_access for
    select
                user_id,
                role_id,
                insert_by,
                insert_date,
                update_by,
                update_date
        from ld_user_role
        where role_id =  decode(as_role_id, 'ALL', role_id, as_role_id)
        and user_id = decode(as_user_id, 'ALL', user_id, as_user_id);
end p_get_user_role;
/


DROP PROCEDURE LDS_NEW.P_GET_USER_NOT_IN_OBJ_ACCESS;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_user_not_in_obj_access(as_object_id in varchar2, as_is_user in varchar2 , p_cur_access out sys_refcursor)
as
begin
    open p_cur_access for

                SELECT user_id ,
                       ld_f_get_user_name_by_user_id(user_id) as user_name
                FROM ld_user_master WHERE NOT EXISTS
                (SELECT * FROM ld_object_access WHERE ld_object_access.user_id = ld_user_master.user_id
                and is_user=as_is_user and object_id = as_object_id);

end p_get_user_not_in_obj_access;
/


DROP PROCEDURE LDS_NEW.P_GET_SEARCH_RESULT;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_search_result(an_object_id in number, as_object_name in varchar , as_object_type in varchar , as_file_type in varchar ,
                                as_create_by in varchar, ad_mod_from_date in date, ad_mod_to_date in date, as_description in varchar ,
                                as_owner in varchar, as_attr_filter in varchar2, p_cur_search out sys_refcursor)
as

     s_sql varchar2(2000) := '';
     s_condition varchar2(2000) := '';
     d_mod_from_date date;
     d_mod_to_date date;
begin
     s_sql := 'select  object_id,
                object_name,
                object_type,
                file_path,
                current_version,
                file_type,
                (case when file_size <= 1024 then to_char(file_size) || '' Byte''
                    when file_size <= 1048576 then to_char(round(file_size/1024,2)) || '' KB''
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || '' MB''
                    when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || '' GB''
                    else ''0 KB''
                 end) file_size,
                description,
                parent_id    ,
                decode(icon_image_name, null, decode(object_type, ''F'', ''folder.png'', file_type || ''.png''), icon_image_name) icon_image_name,
                nvl(owner, create_by) owner,
                create_by    ,
                create_date    ,
                update_by    ,
                update_date
            from ld_object o where  ';


        if length(an_object_id) > 0 then
           s_condition := s_condition || ' and object_id = ' || an_object_id ;
        end if;

        if length(as_object_name) > 0 then
           s_condition := s_condition || ' and lower(object_name) like ''%' || lower(as_object_name) || '%''';
        end if;

        if length(as_object_type) > 0 then
           s_condition := s_condition || ' and object_type = ''' || as_object_type || '''';
        end if;

        if length(as_file_type) > 0 then
           s_condition := s_condition || ' and file_type = ''' || as_file_type || '''';
        end if;

          if length(as_create_by) > 0 then
           s_condition := s_condition || ' and lower(create_by) like ''%' || lower(as_create_by) || '%''';
        end if;

        d_mod_from_date := nvl(ad_mod_from_date, to_date('01 Jan 1900'));
        d_mod_to_date := nvl(ad_mod_to_date, sysdate);
        if d_mod_from_date > to_date('01 Jan 1900') or d_mod_to_date < sysdate then

           s_condition := s_condition || ' and nvl(update_date, create_date) >= to_date(''' || to_char(d_mod_from_date, 'DD MON YYYY')  || ''') and nvl(update_date, create_date) <= to_date(''' || to_char(d_mod_to_date, 'DD MON YYYY') || ''')' ;
        end if;

           if length(as_description) > 0 then
           s_condition := s_condition || ' and lower(description) like ''%' || lower(as_description) || '%''';
        end if;

         if length(as_owner) > 0 then
           s_condition := s_condition || ' and lower(owner) like ''%' || lower(as_owner) || '%''';
        end if;
        if length(as_attr_filter) > 0 then
           s_condition := ' and exists (select * from ld_object_attribute a where o.object_id = a.object_id
                                                and ' || as_attr_filter || ')' ;
        end if;


        if length(s_condition) > 0 then
            s_sql := s_sql || substr(s_condition, 5) || ' and o.status = ''A''';
        else
            --s_sql := '1=2';
             s_sql := substr(s_sql,1,length(s_sql)-7) || ' where o.object_id=-1'  ;

        end if;

        dbms_output.put_line(s_sql);
        --dbms_output.put_line(s_condition);

        open p_cur_search for s_sql;

 END p_get_search_result;
/


DROP PROCEDURE LDS_NEW.P_GET_SEARCH_ATTRIBUTE;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_search_attribute(an_search_id in number, p_cur_search out sys_refcursor)
as
begin

--roshan---
-----------

        open p_cur_search for
        select  s.search_id,
                s.attr_id,
                a.attr_name,
                a.data_type,
                decode(a.data_type,'S','VAL_STRING',a.data_type) data_type_desc
        from ld_search_attributes s ,
             ld_attr_master a
        where  s.attr_id = a.attr_id
        and s.search_id = an_search_id ;

end p_get_search_attribute;
/


DROP PROCEDURE LDS_NEW.P_GET_ROLE_NOT_IN_OBJ_ACCESS;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_role_not_in_obj_access(as_object_id in varchar2, as_is_user in varchar2 , p_cur_access out sys_refcursor)
as
begin
    open p_cur_access for

                SELECT role_id,
                       ld_f_get_role_name_by_role_id(role_id) as role_name
                FROM ld_user_role_master WHERE NOT EXISTS
                (SELECT * FROM ld_object_access WHERE ld_object_access.user_id = ld_role_master.role_id
                 and is_user = as_is_user and object_id = as_object_id);

end p_get_role_not_in_obj_access;
/


DROP PROCEDURE LDS_NEW.P_GET_ROLE_NOT_IN_ASSIGNED;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_role_not_in_assigned(as_user_id in varchar2, p_cur_user out sys_refcursor)
as
begin
    open p_cur_user for

          select role_id,
                 role_name
          from ld_user_role_master
          where role_id not in (select role_id from ld_user_role where user_id = decode(as_user_id, 'ALL', 'ALL', as_user_id));

end p_get_role_not_in_assigned;
/


DROP PROCEDURE LDS_NEW.P_GET_ROLE_MASTER;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_role_master(p_cur_access out sys_refcursor)
as
begin
    open p_cur_access for
    select
                role_id,
                role_name,
                description,
                insert_by,
                insert_date,
                update_by,
                update_date
        from ld_user_role_master;
end p_get_role_master;
/


DROP PROCEDURE LDS_NEW.P_GET_ROLE_ASSIGNED;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_role_assigned(as_user_id in varchar2, p_cur_user out sys_refcursor)
as
begin
    open p_cur_user for

          select role_id,
                 role_name
          from ld_user_role_master
          where role_id in (select role_id from ld_user_role where user_id = decode(as_user_id, 'ALL', 'ALL', as_user_id));

end p_get_role_assigned;
/


DROP PROCEDURE LDS_NEW.P_GET_OBJ_ATTR_GRID_VIEW;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_obj_attr_grid_view(an_object_id in number, p_cur_attr out sys_refcursor)
as
s_sql   varchar2(4000);

begin
    select  LISTAGG(ma.attr_name, ''',''') WITHIN GROUP (ORDER BY ma.attr_name)
        into s_sql
    from ld_object_attribute a, ld_attr_master ma
    where  ma.attr_id = a.attr_id and a.object_id = an_object_id;

--    s_sql := '''' || s_sql || '''';
    s_sql := 'select *
                from   (select o.object_id as ObjectId,
                o.object_NAME as ObjectName,
                o.object_type as ObjectType,
                o.ICON_IMAGE_NAME as IconImageName,
                o.file_path as FilePath,
                 ma.attr_name,
                               decode(a.attr_type, ''S'', a.val_string,
                                                   ''N'', a.val_number,
                                                   ''D'', a.val_date,
                                                   ''I'', a.val_integer) val
                        from ld_object o
                        left outer join ld_object_attribute a on o.object_id = a.object_id
                        left outer join ld_attr_master ma on ma.attr_id = a.attr_id
                        where  o.status = ''A''
                        and o.parent_id =  '|| to_char(an_object_id) ||' )
                pivot  (max(val)  for (attr_name) in (''' || s_sql || '''))';
    dbms_output.put_line(s_sql);
    open p_cur_attr for s_sql;
end p_get_obj_attr_grid_view;
/


DROP PROCEDURE LDS_NEW.P_GET_OBJECT_PATH;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_object_path (an_object_id in number, p_cur_path out sys_refcursor)
as
begin
    open p_cur_path for
        select  connect_by_root object_name object_name,
                connect_by_root library_id library_id,
                connect_by_root object_id object_id,
                connect_by_root file_path file_path
        from ld_object
        where   object_id = an_object_id
        connect by prior object_id  = library_id
        order by level desc;
end p_get_object_path;
/


DROP PROCEDURE LDS_NEW.P_GET_OBJECT_DETAILS;

CREATE OR REPLACE PROCEDURE LDS_NEW.P_GET_OBJECT_DETAILS(an_object_id in number, p_cur_objects out sys_refcursor)
as
begin

    open p_cur_objects for
    select  object_id    ,
            object_name    ,
            object_type    , --F (Folder), D (Document)
            file_path    ,
            current_version    ,
            file_type    ,
          (case     when file_size <= 1024 then to_char(file_size) || ' Byte'
                    when file_size <= 1048576 then to_char(round(file_size/1024,2)) || ' KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || ' MB'
                    when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || ' GB'
                    else '0 KB'
             end) file_size,
            description,
            status,
            file_size AS file_size_Full,
            library_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) icon_image_name,
            nvl(owner, insert_by) owner,
            insert_by    ,
            insert_date    ,
            update_by    ,
            update_date
    from ld_object
    where object_id = an_object_id ;

end P_GET_OBJECT_DETAILS;
/


DROP PROCEDURE LDS_NEW.P_GET_OBJECT_ATTR_LIST;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_object_attr_list(an_object_id in varchar2, p_cur_attr out sys_refcursor)
as
begin
    open p_cur_attr for
    select  nvl(ag.group_id, -1) group_id,
            nvl(agm.group_name, 'Extra') group_name,
            am.attr_id    ,
            am.attr_name    ,
            am.data_type    ,
            oa.version_number,
            decode(oa.data_type, 'S', oa.val_string,
                             'D', to_char(oa.val_date),
                             'N', to_char(oa.val_number)) attr_val,
            1 sort_order
    from ld_object_attribute oa
    inner join ld_attr_master am on oa.attr_id = am.attr_id  and am.status = 'A' --actual am.status = 'y' roshan
    left join ld_attr_group ag on ag.attr_id = oa.attr_id
    left join ld_attr_group_master agm on agm.group_id = ag.group_id
    where oa.object_id = an_object_id
    order by agm.group_name, am.attr_name
--    union all
--    select  0 group_id,
--            'Extra' group_name,
--            am.attr_id    ,
--            am.attr_name    ,
--            am.data_type  ,
--            oa.version_number,
--            decode(oa.data_type, 'S', oa.val_string,
--                             'D', to_char(oa.val_date),
--                             'N', to_char(oa.val_number)) attr_val,
--            2 sort_order
--    from ld_object_attribute oa
--    inner join ld_attr_master am on oa.attr_id = am.attr_id and am.status = 'A' --actual am.status = 'y' roshan
--    where oa.object_id = an_object_id
--    and not exists( select ''
--                        from ld_attr_group_master agm, ld_attr_group ag
--                         where oa.object_id = og.object_id and agm.group_id = og.group_id
--                            and agm.group_id=ag.group_id and  oa.attr_id = ag.attr_id)
--    order by sort_order, group_name 
    ;
end p_get_object_attr_list;
/


DROP PROCEDURE LDS_NEW.P_GET_OBJECT_ACCESS;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_object_access(as_object_id in varchar2, as_user_id in varchar2, as_is_user in varchar2 , p_cur_access out sys_refcursor)
as
begin
    open p_cur_access for
    select
                object_id,
                user_id,
                case
                     when as_is_user = 'U' then ld_f_get_user_name_by_user_id(user_id)
                     when as_is_user = 'R' then ld_f_get_role_name_by_role_id(user_id)
                     else user_id
                end as user_name,
                read_acc,
                add_acc,
                modify_acc,
                delete_acc,
                add_attr,
                edit_attr,
                delete_attr,
                edit_permission,
                is_user,
                insert_by,
                insert_date,
                update_by,
                update_date
        from zz_ld_object_access
        where object_id =  decode(as_object_id, 'ALL', object_id, as_object_id)
        and user_id = decode(as_user_id, 'ALL', user_id, as_user_id)
        and is_user = decode(as_is_user, 'ALL', is_user, as_is_user);
end p_get_object_access;
/


DROP PROCEDURE LDS_NEW.P_GET_LIBRARY_SIZE;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_library_size(an_library_id in number, p_cur_objects out sys_refcursor)
as
file_size varchar(500);
begin

    open p_cur_objects for

       select
            (case   when sum(file_size) <= 1024 then to_char(sum(file_size)) || 'Byte'
                    when sum(file_size) <= 1048576 then to_char(round(sum(file_size)/1024,2)) || 'KB'
                    when sum(file_size) < 1073741824 then to_char(round(sum(file_size)/1048576,2)) || 'MB'
                    when sum(file_size) > 1073741824 then to_char(round(sum(file_size)/1073741824,2)) || 'GB'
                    else '0KB'
             end) file_size
        from ld_object
        where library_id = an_library_id;

end p_get_library_size;
/


DROP PROCEDURE LDS_NEW.P_GET_LIBRARY_OBJECTS;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_library_objects(an_library_id in number, p_cur_objects out sys_refcursor)
as
begin
    open p_cur_objects for
    select  object_id    ,
            object_name    ,
            object_type    , --F (Folder), D (Document)
            file_path    ,
            current_version    ,
            file_type    ,
            (case   when file_size <= 1024 then to_char(file_size) || 'Byte'
                    when file_size <= 1048576 then to_char(round(file_size/1024,2)) || 'KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || 'MB'
                    when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || 'GB'
                    else null
             end) file_size,
            description,
            library_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) icon_image_name,
            nvl(owner, insert_by) owner,
            vault_id,
            insert_by    ,
            insert_date    ,
            update_by    ,
            update_date
    from ld_object
    where library_id = an_library_id
    and status = 'A';

end p_get_library_objects;
/


DROP PROCEDURE LDS_NEW.P_GET_LIBRARY_HIRARCHY;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_library_hirarchy(p_cur_hirarchy out sys_refcursor)
as
begin
    open p_cur_hirarchy for
     select library_id, library_name, parent_id,ICON_IMAGE_NAME 
        from ld_library
       order by library_name;
--        select library_id, library_name, parent_id,  rpad('-',(level - 1) * 3,'-') || library_name tree_node, level
--        from ld_library
--        connect by prior library_id = parent_id
--        start with parent_id = 0;
end p_get_library_hirarchy;
/


DROP PROCEDURE LDS_NEW.P_GET_LIBRARY_ATTR_LIST1;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_library_attr_list1(an_library_id in number, as_is_system_attr in varchar2, p_cur_attr out sys_refcursor)
as

begin
    
    if as_is_system_attr = 'Y' then
    
        open p_cur_attr for
        select  attr_id    ,
                attr_name    ,
                case data_type
                    when 'S' then 'String'
                    when 'N' then 'Number'
                    when 'I' then 'Integer'
                    when 'D' then 'Date'
                end as data_type,
                status,
                    case style
                    when 'TB' then 'Text Box'
                    when 'CB' then 'Check box'
                    when 'DL' then 'Dropdown List'
                    when 'CL' then 'Checkbox List'
                    when 'DT' then 'DateTime Picker'
                    when 'NB' then 'Number'
                    when 'RB' then 'Radio Button'
                    when 'HL' then 'Hyper Link'
                end as style,
                style as stylesml,
                description,
                default_val_flag,
                default_val,
                val_mand,
                inherit_mand,
                library_id,
                insert_by    ,
                insert_date    ,
                update_by    ,
                update_date
        from ld_attr_master a
        where library_id = 0 --and 1 = 2
        and not exists (select '' from ld_attr_master a1 where lower(trim(a1.attr_name)) = lower(trim(a.attr_name)) and library_id = an_library_id)
        order by attr_id asc;
        
    elsif as_is_system_attr = 'N' then
    
        open p_cur_attr for
        select  attr_id    ,
                attr_name    ,
                case data_type
                    when 'S' then 'String'
                    when 'N' then 'Number'
                    when 'I' then 'Integer'
                    when 'D' then 'Date'
                end as data_type,
                status,
                    case style
                    when 'TB' then 'Text Box'
                    when 'CB' then 'Check box'
                    when 'DL' then 'Dropdown List'
                    when 'CL' then 'Checkbox List'
                    when 'DT' then 'DateTime Picker'
                    when 'NB' then 'Number'
                    when 'RB' then 'Radio Button'
                    when 'HL' then 'Hyper Link'
                end as style,
                style as stylesml,
                description,
                default_val_flag,
                default_val,
                val_mand,
                inherit_mand,
                library_id,
                insert_by    ,
                insert_date    ,
                update_by    ,
                update_date
        from ld_attr_master 
        where library_id = an_library_id 
        order by attr_id asc;
    end if;

end p_get_library_attr_list1;
/


DROP PROCEDURE LDS_NEW.P_GET_LIBRARY_ATTR_LIST;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_library_attr_list(an_library_id in number, as_is_system_attr in varchar2, p_cur_attr out sys_refcursor)
as

begin
    
    if as_is_system_attr = 'Y' then
    
        open p_cur_attr for
        select  attr_id    ,
                attr_name    ,
                case data_type
                    when 'S' then 'String'
                    when 'N' then 'Number'
                    when 'I' then 'Integer'
                    when 'D' then 'Date'
                end as data_type,
                status,
                    case style
                    when 'TB' then 'Text Box'
                    when 'CB' then 'Check box'
                    when 'DL' then 'Dropdown List'
                    when 'CL' then 'Checkbox List'
                    when 'DT' then 'DateTime Picker'
                    when 'NB' then 'Number'
                    when 'RB' then 'Radio Button'
                    when 'HL' then 'Hyper Link'
                end as style,
                style as stylesml,
                description,
                default_val_flag,
                default_val,
                val_mand,
                inherit_mand,
                library_id,
                insert_by    ,
                insert_date    ,
                update_by    ,
                update_date
        from ld_attr_master a
        where library_id = 0 --and 1 = 2
        and not exists (select '' from ld_attr_master a1 where lower(trim(a1.attr_name)) = lower(trim(a.attr_name)) and library_id = an_library_id)
        order by attr_id asc;
        
    elsif as_is_system_attr = 'N' then
    
        open p_cur_attr for
        select  attr_id    ,
                attr_name    ,
                case data_type
                    when 'S' then 'String'
                    when 'N' then 'Number'
                    when 'I' then 'Integer'
                    when 'D' then 'Date'
                end as data_type,
                status,
                    case style
                    when 'TB' then 'Text Box'
                    when 'CB' then 'Check box'
                    when 'DL' then 'Dropdown List'
                    when 'CL' then 'Checkbox List'
                    when 'DT' then 'DateTime Picker'
                    when 'NB' then 'Number'
                    when 'RB' then 'Radio Button'
                    when 'HL' then 'Hyper Link'
                end as style,
                style as stylesml,
                description,
                default_val_flag,
                default_val,
                val_mand,
                inherit_mand,
                library_id,
                insert_by    ,
                insert_date    ,
                update_by    ,
                update_date
        from ld_attr_master 
        where library_id = an_library_id 
        order by attr_id asc;
    end if;

end p_get_library_attr_list;
/


DROP PROCEDURE LDS_NEW.P_GET_LIBRARY_ATTR_GROUP_LIST;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_library_attr_group_list(an_library_id in number, as_is_system_attr in varchar2, p_cur_group out sys_refcursor)
as

begin
    
    if as_is_system_attr = 'Y' then
    
        open p_cur_group for
            select  group_id    ,
                    group_name    
            from ld_attr_group_master a
            WHERE library_id = 0 and status = 'A'
            and not exists (select '' from ld_attr_group_master a1 where lower(trim(a1.group_name)) = lower(trim(a.group_name)) and library_id = an_library_id)
            order by group_name asc;
        
    elsif as_is_system_attr = 'N' then
    
         open p_cur_group for
            select  group_id    ,
                    group_name    
            from ld_attr_group_master a
            WHERE library_id = an_library_id and status = 'A'
            order by group_name;
    end if;

end p_get_library_attr_group_list;
/


DROP PROCEDURE LDS_NEW.P_GET_LIBRARY;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_library(an_library_id in number, p_cur_library out sys_refcursor)
as
begin
    open p_cur_library for
    select  library_id    ,
            library_name    ,
            parent_id    ,
            icon_image_name    ,
            description    ,
            nvl(owner, insert_by) owner    ,
            status    ,
            insert_by    ,
            insert_date    ,
            update_by    ,
            update_date
    from ld_library
    where library_id = decode(an_library_id, -999, library_id, an_library_id)
    and status = 'A';

end p_get_library;
/


DROP PROCEDURE LDS_NEW.P_GET_GROUP_ATTR;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_group_attr(an_library_id in number, an_group_id in number, as_group_flag in varchar2, p_cur_attr out sys_refcursor)
as
begin
    if as_group_flag = 'Y' then --
        open p_cur_attr for
        select  g.group_id,
                a.attr_id    ,
                a.attr_name    ,
                a.data_type    ,
                a.status,
                a.insert_by    ,
                a.insert_date    ,
                a.update_by    ,
                a.update_date
        from ld_attr_master a,
             ld_attr_group g
        where a.attr_id = g.attr_id
        and   g.group_id = an_group_id and a.library_id = an_library_id
        and   a.status = 'A' ;
    elsif as_group_flag = 'A' then --To return all attributes which are not selected for the group 
        open p_cur_attr for
        select  0 group_id,
                a.attr_id    ,
                a.attr_name    ,
                a.data_type    ,
                a.status,
                a.insert_by    ,
                a.insert_date    ,
                a.update_by    ,
                a.update_date
        from ld_attr_master a
        where a.library_id = an_library_id
        and not exists( select '' from ld_attr_group g
                                  where a.attr_id = g.attr_id
                                  and  g.group_id = an_group_id)
        and   a.status = 'A' 
        order by  a.attr_name ;
      end if;
end p_get_group_attr;
/


DROP PROCEDURE LDS_NEW.P_GET_FOLDER_OBJECT_DETAILS;

CREATE OR REPLACE PROCEDURE LDS_NEW.P_GET_FOLDER_OBJECT_DETAILS(an_object_id in number, p_cur_objects out sys_refcursor)
as
begin

--ROSHAN---
-----------
    open p_cur_objects for
    select  object_id    ,
            object_name    ,
            object_type    , --F (Folder), D (Document)
            file_path    ,
            current_version    ,
            file_type    ,
            library_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) icon_image_name,
            insert_by    ,
            insert_date    ,
            update_by    ,
            update_date
    from ld_object
    where object_id = an_object_id;

end P_GET_FOLDER_OBJECT_DETAILS;
/


DROP PROCEDURE LDS_NEW.P_GET_FILEPATH_BY_OBJECT_ID;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_filepath_by_object_id(an_object_id in number, p_cur_attr out sys_refcursor)
as
begin
    open p_cur_attr for
    select  object_id,
            file_path
    from ld_object
    where object_id = an_object_id;
end p_get_filepath_by_object_id;
/


DROP PROCEDURE LDS_NEW.P_GET_DISTINCT_DOCUMENT_TYPE;

CREATE OR REPLACE PROCEDURE LDS_NEW.P_GET_DISTINCT_DOCUMENT_TYPE(p_cur_access out sys_refcursor)
as
begin
    open p_cur_access for

     select distinct file_type
     from ld_object
     where file_type <> 'extension' ;-- for remove null value

END P_GET_DISTINCT_DOCUMENT_TYPE;
/


DROP PROCEDURE LDS_NEW.P_GET_DELETED_OBJECT_DETAILS;

CREATE OR REPLACE PROCEDURE LDS_NEW.P_GET_DELETED_OBJECT_DETAILS(as_status in varchar, p_cur_objects out sys_refcursor)
as
begin

    open p_cur_objects for
    select  object_id    ,
            object_name    ,
            object_type    , --F (Folder), D (Document)
            file_path    ,
            current_version    ,
            file_type    ,
          (case     when file_size <= 1024 then to_char(file_size) || ' Byte'
                    when file_size <= 1048576 then to_char(round(file_size/1024,2)) || ' KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || ' MB'
                    when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || ' GB'
                    else '0 KB'
             end) file_size,
            description,
            library_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) icon_image_name,
            nvl(owner, insert_by) owner,
            insert_by    ,
            insert_date    ,
            update_by    ,
            update_date
    from ld_object
    where status = as_status ;

end P_GET_DELETED_OBJECT_DETAILS;
/


DROP PROCEDURE LDS_NEW.P_GET_CONTENT_OBJECTS;

CREATE OR REPLACE PROCEDURE LDS_NEW.P_GET_CONTENT_OBJECTS(an_library_id in number,as_object_type in varchar,as_file_type in varchar, p_cur_objects out sys_refcursor)
as
s_sql   varchar2(4000);
begin

--ROSHAN---
-----------

    if as_file_type = 'Folder' and as_object_type is null then
        open p_cur_objects for
        select  object_id as ObjectId    ,
            object_name as ObjectName    ,
            object_type as ObjectType   , --F (Folder), D (Document)
            file_path   as FilePath  ,
            current_version as  CurrentVersion ,
--            file_type    ,
           (case   when file_size <= 1024 then to_char(file_size) || 'Byte'
                   when file_size <= 1048576 then to_char(round(file_size/1024,2)) || 'KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || 'MB'
                   when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || 'GB'
                   else null
            end) file_size,
--            description,
--            parent_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) ICONIMAGENAME
--            nvl(owner, create_by) owner,
--            create_by    ,
--            create_date    ,
--            update_by    ,
--            update_date
        from ld_object
        where library_id = an_library_id and object_type = 'F'
        and status = 'A';

    elsif  as_file_type = 'Document' and as_object_type is null then
        open p_cur_objects for
        select  object_id as ObjectId    ,
            object_name as ObjectName    ,
            object_type as ObjectType   , --F (Folder), D (Document)
            file_path   as FilePath  ,
            current_version as  CurrentVersion ,
--            file_type    ,
           (case   when file_size <= 1024 then to_char(file_size) || 'Byte'
                   when file_size <= 1048576 then to_char(round(file_size/1024,2)) || 'KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || 'MB'
                   when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || 'GB'
                   else null
            end) file_size,
--            description,
--            parent_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) ICONIMAGENAME
--            nvl(owner, create_by) owner,
--            create_by    ,
--            create_date    ,
--            update_by    ,
--            update_date
        from ld_object
        where library_id = an_library_id and object_type = 'D'
        and status = 'A';

    elsif as_file_type is not null and as_object_type is null then
        open p_cur_objects for
        select  object_id as ObjectId    ,
            object_name as ObjectName    ,
            object_type as ObjectType   , --F (Folder), D (Document)
            file_path   as FilePath  ,
            current_version as  CurrentVersion ,
--            file_type    ,
           (case   when file_size <= 1024 then to_char(file_size) || 'Byte'
                   when file_size <= 1048576 then to_char(round(file_size/1024,2)) || 'KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || 'MB'
                   when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || 'GB'
                   else null
            end) file_size,
--            description,
--            parent_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) ICONIMAGENAME
--            nvl(owner, create_by) owner,
--            create_by    ,
--            create_date    ,
--            update_by    ,
--            update_date
        from ld_object
        where library_id = an_library_id  and file_type = as_file_type
        and status = 'A';

    elsif as_object_type is not null and as_file_type is null then
        if as_object_type = 'Last Week' then
            open p_cur_objects for
            select  object_id as ObjectId    ,
            object_name as ObjectName    ,
            object_type as ObjectType   , --F (Folder), D (Document)
            file_path   as FilePath  ,
            current_version as  CurrentVersion ,
--            file_type    ,
           (case   when file_size <= 1024 then to_char(file_size) || 'Byte'
                   when file_size <= 1048576 then to_char(round(file_size/1024,2)) || 'KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || 'MB'
                   when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || 'GB'
                   else null
            end) file_size,
--            description,
--            parent_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) ICONIMAGENAME
--            nvl(owner, create_by) owner,
--            create_by    ,
--            create_date    ,
--            update_by    ,
--            update_date
        from ld_object
            where library_id = an_library_id  and trunc((sysdate - nvl(update_date, insert_date))/7) <= 1
            and status = 'A';

        elsif as_object_type = 'Two Weeks ago' then
            open p_cur_objects for
            select  object_id as ObjectId    ,
            object_name as ObjectName    ,
            object_type as ObjectType   , --F (Folder), D (Document)
            file_path   as FilePath  ,
            current_version as  CurrentVersion ,
--            file_type    ,
           (case   when file_size <= 1024 then to_char(file_size) || 'Byte'
                   when file_size <= 1048576 then to_char(round(file_size/1024,2)) || 'KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || 'MB'
                   when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || 'GB'
                   else null
            end) file_size,
--            description,
--            parent_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) ICONIMAGENAME
--            nvl(owner, create_by) owner,
--            create_by    ,
--            create_date    ,
--            update_by    ,
--            update_date
        from ld_object
            where library_id = an_library_id  and trunc((sysdate - nvl(update_date, insert_date))/14) <= 1 and (sysdate - nvl(update_date, insert_date)) >= 15
            and status = 'A';

        elsif as_object_type = 'Three Weeks ago' then
            open p_cur_objects for
            select  object_id as ObjectId    ,
            object_name as ObjectName    ,
            object_type as ObjectType   , --F (Folder), D (Document)
            file_path   as FilePath  ,
            current_version as  CurrentVersion ,
--            file_type    ,
           (case   when file_size <= 1024 then to_char(file_size) || 'Byte'
                   when file_size <= 1048576 then to_char(round(file_size/1024,2)) || 'KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || 'MB'
                   when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || 'GB'
                   else null
            end) file_size,
--            description,
--            parent_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) ICONIMAGENAME
--            nvl(owner, create_by) owner,
--            create_by    ,
--            create_date    ,
--            update_by    ,
--            update_date
        from ld_object
            where library_id = an_library_id  and trunc((sysdate - nvl(update_date, insert_date))/21) <= 1 and (sysdate - nvl(update_date, insert_date)) >= 22
            and status = 'A';

         elsif as_object_type = 'One Months ago' then
            open p_cur_objects for

            select  object_id as ObjectId    ,
            object_name as ObjectName    ,
            object_type as ObjectType   , --F (Folder), D (Document)
            file_path   as FilePath  ,
            current_version as  CurrentVersion ,
--            file_type    ,
           (case   when file_size <= 1024 then to_char(file_size) || 'Byte'
                   when file_size <= 1048576 then to_char(round(file_size/1024,2)) || 'KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || 'MB'
                   when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || 'GB'
                   else null
            end) file_size,
--            description,
--            parent_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) ICONIMAGENAME
--            nvl(owner, create_by) owner,
--            create_by    ,
--            create_date    ,
--            update_by    ,
--            update_date
        from ld_object
            where library_id = an_library_id  and trunc((sysdate - nvl(update_date, insert_date))/30) <= 1 and (sysdate - nvl(update_date, insert_date)) >= 31
            and status = 'A';

         elsif as_object_type = 'Two Months ago' then
            open p_cur_objects for
            select  object_id as ObjectId    ,
            object_name as ObjectName    ,
            object_type as ObjectType   , --F (Folder), D (Document)
            file_path   as FilePath  ,
            current_version as  CurrentVersion ,
--            file_type    ,
           (case   when file_size <= 1024 then to_char(file_size) || 'Byte'
                   when file_size <= 1048576 then to_char(round(file_size/1024,2)) || 'KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || 'MB'
                   when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || 'GB'
                   else null
            end) file_size,
--            description,
--            parent_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) ICONIMAGENAME
--            nvl(owner, create_by) owner,
--            create_by    ,
--            create_date    ,
--            update_by    ,
--            update_date
        from ld_object
            where library_id = an_library_id  and trunc((sysdate - nvl(update_date, insert_date))/60) <= 1 and (sysdate - nvl(update_date, insert_date)) >= 61
            and status = 'A';

         elsif as_object_type = 'Older' then
            open p_cur_objects for
            select  object_id as ObjectId    ,
            object_name as ObjectName    ,
            object_type as ObjectType   , --F (Folder), D (Document)
            file_path   as FilePath  ,
            current_version as  CurrentVersion ,
--            file_type    ,
           (case   when file_size <= 1024 then to_char(file_size) || 'Byte'
                   when file_size <= 1048576 then to_char(round(file_size/1024,2)) || 'KB'
                    when file_size > 1073741824 then to_char(round(file_size/1048576,2)) || 'MB'
                   when file_size > 1073741824 then to_char(round(file_size/1073741824,2)) || 'GB'
                   else null
            end) file_size,
--            description,
--            parent_id    ,
            decode(icon_image_name, null, decode(object_type, 'F', 'folder.png', file_type || '.png'), icon_image_name) ICONIMAGENAME
--            nvl(owner, create_by) owner,
--            create_by    ,
--            create_date    ,
--            update_by    ,
--            update_date
        from ld_object
            where library_id = an_library_id  and trunc((sysdate - nvl(update_date, insert_date))/3600) <= 1 and (sysdate - nvl(update_date, insert_date)) >= 61
            and status = 'A';
         end if;

    end if;

end P_GET_CONTENT_OBJECTS;
/


DROP PROCEDURE LDS_NEW.P_GET_CONTENT_FILTER;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_content_filter(an_library_id in number, as_section in varchar2, p_cur_filter out sys_refcursor)
as
begin
    if as_section = 'CONTENTTYPE' then

        open  p_cur_filter for
                select decode(object_type,'D','Document','F','Folder',object_type) as object_type, count(*) doc_count --ROSHAN
                from ld_object
            where library_id = an_library_id
            and status = 'A'
            group by object_type;

    elsif as_section = 'FILETYPE' then
        open  p_cur_filter for
            select decode(file_type,'','Folder',file_type) as file_type , count(*) doc_count
                from ld_object
            where library_id = an_library_id
            and status = 'A'
            group by file_type;
    elsif as_section = 'MODIFIEDDATE' then
        open  p_cur_filter for
        select  case
             when trunc((sysdate - nvl(update_date, insert_date))/7) <= 1 then 'Last Week'
             when trunc((sysdate - nvl(update_date, insert_date))/14) <= 1 then 'Two Weeks ago'
             when trunc((sysdate - nvl(update_date, insert_date))/21) <= 1 then 'Three Weeks ago'
             when trunc((sysdate - nvl(update_date, insert_date))/30) <= 1 then 'One Months ago'
             when trunc((sysdate - nvl(update_date, insert_date))/30) <= 1 then 'Two Months ago'
             else 'Older' end modified_date,
             count(*) doc_count
            from ld_object
        where library_id = an_library_id
        and status = 'A'
        group by case when trunc((sysdate - nvl(update_date, insert_date))/7) <= 1 then 'Last Week'
                     when trunc((sysdate - nvl(update_date, insert_date))/14) <= 1 then 'Two Weeks ago'
                     when trunc((sysdate - nvl(update_date, insert_date))/21) <= 1 then 'Three Weeks ago'
                     when trunc((sysdate - nvl(update_date, insert_date))/30) <= 1 then 'One Months ago'
                     when trunc((sysdate - nvl(update_date, insert_date))/30) <= 1 then 'Two Months ago'
                     else 'Older' end;
     end if;
 end  p_get_content_filter;
/


DROP PROCEDURE LDS_NEW.P_GET_ATTR_NOT_ASSIGNED;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_attr_not_assigned(as_attr_id in varchar, p_cur_attr out sys_refcursor)
as
s_sql varchar2(500);
s_attr_id varchar2(100);
begin
            if as_attr_id is not null then
                s_attr_id := as_attr_id;
            else
                s_attr_id := '-999';
            end if;
            s_sql := 'select  attr_id    ,
            attr_name    ,
              case attr_type
                    when ''S'' then ''String''
                    when ''N'' then ''Number''
                    when ''I'' then ''Integer''
                    when ''D'' then ''Date''
            end as attr_type
            from ld_attr_master
            where status = ''A'' and 1 = 2
            and attr_id not in ( '|| s_attr_id ||' )';

            open p_cur_attr for s_sql;

end p_get_attr_not_assigned;
/


DROP PROCEDURE LDS_NEW.P_GET_ATTR_LIST_BYID;

CREATE OR REPLACE PROCEDURE LDS_NEW.P_get_attr_List_byid(as_attr_id in varchar2, p_cur_attr out sys_refcursor)
as
s_search_text   varchar2(200);
begin
    open p_cur_attr for
    select  attr_id    ,
            attr_name    ,
            case data_type
                when 'S' then 'String'
                when 'N' then 'Number'
                when 'I' then 'Integer'
                when 'D' then 'Date'
            end as data_type,
            status,
                case Style
                when 'TB' then 'Text Box'
                when 'CB' then 'Check box'
                when 'DL' then 'Dropdown List'
                when 'CL' then 'Checkbox List'
                when 'DT' then 'DateTime Picker'
                when 'NB' then 'Number'
                when 'RB' then 'Radio Button'
                when 'HL' then 'Hyper Link'
            end as Style,
            Style AS StyleSml,
            description,
            default_val_flag,
            default_val,
            VAL_MAND,
            INHERIT_MAND,
            LIBRARY_ID,
            insert_by    ,
            insert_date    ,
            update_by    ,
            update_date
    from ld_attr_master
     WHERE attr_id = as_attr_id;

end P_get_attr_List_byid;
/


DROP PROCEDURE LDS_NEW.P_GET_ATTR_GROUP_NOT_ASSIGNED;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_attr_group_not_assigned(as_group_id in varchar, p_cur_attr out sys_refcursor)
as
s_sql varchar(500);
s_group_id varchar2(100);
begin
     if as_group_id is not null then
                s_group_id := as_group_id;
            else
                s_group_id := '-999';
     end if;
    s_sql:=' select group_id,
                 group_name
    from ld_attr_group_master
    where status = ''A'' 
    and group_id not in ('||as_group_id||')';

    open p_cur_attr for s_sql;

end p_get_attr_group_not_assigned;
/


DROP PROCEDURE LDS_NEW.P_GET_ATTR_GROUP_MASTER;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_attr_group_master(an_library_id in number, p_cur_group out sys_refcursor)
as
begin
    open p_cur_group for
    select  group_id    ,
            group_name    ,
            library_id,
            status    ,
            update_by    ,
            update_date
    from ld_attr_group_master
    WHERE library_id = an_library_id
    order by group_id asc;
end p_get_attr_group_master;
/


DROP PROCEDURE LDS_NEW.P_GET_ATTR_GROUP_LIST;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_attr_group_list(as_group_name in varchar2,p_cur_group out sys_refcursor)
as
begin
    open p_cur_group for
    select  g.group_id    ,
            g.group_name    ,
            g.status    ,
            decode(g.library_id, 0, 'System', l.library_name) library_name,
            g.update_by    ,
            g.update_date
    from ld_attr_group_master g
    left outer join ld_library l on g.library_id = l.library_id
    where g.group_name like as_group_name ||'%' and g.library_id = 0
    order by g.group_id asc;
end p_get_attr_group_list;
/


DROP PROCEDURE LDS_NEW.P_GET_ATTR_GROUP_BYID;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_attr_group_byId(an_group_id in number, p_cur_group out sys_refcursor)
as
begin
    open p_cur_group for
    select  group_id    ,
            group_name    ,
            library_id,
            status    ,
            update_by    ,
            update_date
    from ld_attr_group_master
    WHERE group_id = an_group_id
    order by group_id asc;
end p_get_attr_group_byId;
/


DROP PROCEDURE LDS_NEW.P_GET_ATTRIBUTE_STATUS;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_attribute_status(an_attr_id in number, as_success  out varchar2)
  as
  i_count integer;
  begin
      select count(*) into i_count from ld_attr_master where attr_id = an_attr_id;

        if i_count > 0 then
           as_success := 'PRESENT';
        else
           as_success := 'NOT PRESENT';
        end if;

END p_get_attribute_status;
/


DROP PROCEDURE LDS_NEW.P_GET_ATTRIBUTE_LIST_VAL;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_attribute_list_val(an_attr_id in number,p_cur_group out sys_refcursor)
  as
  --as_val          varchar2(200);
  begin
      open p_cur_group for
      select val 
    --  INTO as_val
      FROM LD_ATTR_LIST_VAL
       
     WHERE ATTR_ID=an_attr_id;
     
END p_get_attribute_list_val;
/


DROP PROCEDURE LDS_NEW.P_GET_ACCESS_ROLE;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_get_access_role(as_role_id varchar2,p_cur_access out sys_refcursor)
as
begin
    open p_cur_access for
    select
                role_id,
                role_name,
                description,
                insert_by,
                insert_date,
                update_by,
                update_date
        from ld_user_role_master
        where role_id =  decode(as_role_id, 'ALL', role_id, as_role_id);
end p_get_access_role;
/


DROP PROCEDURE LDS_NEW.P_DELETE_ROLE_MASTER;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_delete_role_master( an_role_id in number,p_msg out varchar )
as
p_count int;
begin

    select count(*) into p_count from ld_user_role where role_id = an_role_id;
    if p_count > 0 then
        p_msg := 'You cannot delete this Role';
        return;
    end if;

    delete from ld_user_role_master
            where role_id = an_role_id;

    p_msg := 'Role Deleted Successfully.';

    commit;
end p_delete_role_master;
/


DROP PROCEDURE LDS_NEW.P_DELETE_OBJECT_PERMANANTLY;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_delete_object_permanantly(an_object_id  in number,  p_msg out varchar )
as
i_count     integer;
begin
       delete from ld_object
       where object_id = an_object_id;
       delete from ld_object_attribute where object_id = an_object_id;
       delete from ld_object_attr_group where object_id = an_object_id;
       p_msg := 'Object deleted Successfully.';
       commit;

end p_delete_object_permanantly;
/


DROP PROCEDURE LDS_NEW.P_DELETE_OBJECT_ATTR_GROUP;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_delete_object_attr_group(an_object_id  in number,
                                                         an_group_id in number)
as
i_count     integer;
begin
       delete from ld_object_attr_group
            where object_id = an_object_id
            and   group_id = an_group_id;
       commit;

end p_delete_object_attr_group;
/


DROP PROCEDURE LDS_NEW.P_DELETE_OBJECT_ATTR;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_delete_object_attr(an_object_id  in number,
                                                an_version_number in number   ,
                                                an_attr_id in number,
                                                p_msg out varchar  )
as
begin
    delete from ld_object_attribute
            where object_id = an_object_id
            and   version_number = an_version_number
            and   attr_id = an_attr_id;

    p_msg :='Deleted successfully.';
    commit;
end p_delete_object_attr;
/


DROP PROCEDURE LDS_NEW.P_DELETE_OBJECT_ACCESS;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_delete_object_access( an_object_id in number,as_user_id varchar2, p_msg out varchar)
as
begin
    delete from zz_ld_object_access
            where object_id = an_object_id
            and user_id = as_user_id;

    p_msg := 'Object Access Deleted Successfully.';
    commit;
END p_delete_object_access;
/


DROP PROCEDURE LDS_NEW.P_DELETE_OBJECT;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_delete_object(an_object_id in number)
as
s_file_path     varchar2(300);
begin
    select file_path into s_file_path from ld_object where object_id = an_object_id;
    delete from ld_object where  file_path like s_file_path || '%';
    delete from ld_object where object_id = an_object_id;
    delete from ld_object_attribute where object_id = an_object_id;

end p_delete_object;
/


DROP PROCEDURE LDS_NEW.P_DELETE_LIBRARY;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_delete_library( an_library_id in number,p_msg out varchar )
as
p_count int;
begin

    select count(*) into p_count from LD_LIBRARY where PARENT_ID = an_library_id;
    if p_count > 0 then
        p_msg := 'You cannot delete this Library';
        return;
    end if;

    delete from LD_LIBRARY
            where LIBRARY_ID = an_library_id;
    p_msg := 'Library Deleted Successfully.';

    commit;
end p_delete_library;
/


DROP PROCEDURE LDS_NEW.P_DELETE_ATTR_LIST_VAL;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_delete_attr_list_val(an_Attribute_id in number)
as
begin

    delete from LD_ATTR_LIST_VAL where ATTR_ID = an_Attribute_id;

end p_delete_attr_list_val;
/


DROP PROCEDURE LDS_NEW.P_DELETE_ATTR_GROUP_MASTER;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_delete_attr_group_master(an_group_id in number, p_msg out varchar)
as
i_count int;
begin
  select count(*) into i_count from ld_object_attribute
    where attr_id in (select attr_id from ld_attr_group where group_id = an_group_id);

        if i_count > 0 then
            p_msg := 'You cannot delete Attribute Group.';
            return;
        end if;

    delete from ld_attr_group_master
            where group_id = an_group_id;

    delete from ld_attr_group
            where group_id = an_group_id;

    p_msg := 'Attribute Group Deleted Successfully.';
    commit;
END p_delete_attr_group_master;
/


DROP PROCEDURE LDS_NEW.P_DELETE_ATTRIBUTE_MASTER;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_delete_attribute_master( an_attr_id in number,p_msg out varchar )
as
p_count int;
begin

    select count(*) into p_count from ld_object_attribute where attr_id = an_attr_id;
    if p_count > 0 then
        p_msg := 'You cannot delete this Attribute';
        return;
    end if;

    delete from ld_attr_master
            where attr_id = an_attr_id;

    delete from ld_attr_group
            where attr_id = an_attr_id;

    p_msg := 'Attribute Deleted Successfully.';

    commit;
END p_delete_attribute_master;
/


DROP PROCEDURE LDS_NEW.P_COPY_OBJECT;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_copy_object(an_object_id  in number,
                                              as_file_path in varchar2,
                                              an_library_id in number,
                                              as_user in varchar2,
                                              an_new_object_id out number
                                              )
as
i_count     integer;
i_count_permission integer;
begin

        select ld_object_id.nextval into an_new_object_id from dual ;

        insert into ld_object
                (object_id    ,
                object_name    ,
                object_type    ,
                file_path    ,
                current_version    ,
                file_type    ,
                file_size,
                description,
                library_id    ,
                owner,
                icon_image_name,
                status,
                insert_by    ,
                insert_date    ,
                update_by    ,
                update_date
                )
        select   an_new_object_id    ,
                object_name    ,
                object_type    ,
                as_file_path    ,
                current_version    ,
                file_type    ,
                file_size,
                description,
                an_library_id    ,
                owner,
                as_user    ,
                sysdate   ,
                update_by    ,
                update_date    ,
                icon_image_name,
                status
                from  ld_object
                where  object_id = an_object_id;

         --To copy Parent attributes

         insert into ld_object_attr_group
                (object_id,
                group_id)
        select  an_new_object_id,
                group_id
          from  ld_object_attr_group
         where  object_id = an_object_id;

         --To copy Parent attributes
         insert into ld_object_attribute
                (object_id,
                version_number,
                attr_id,
                data_type,
                val_string,
                val_date,
                val_number,
                val_lob,
                val_mand,
                update_by,
                update_date
                )

        select  an_new_object_id,
                (select current_version  from  ld_object where  object_id = an_object_id) ,
                attr_id ,
                data_type,
                null,
                null,
                null,
                null ,
                null,
                as_user    ,
                sysdate

          from  ld_object_attribute
         where  object_id = an_object_id;

          --To Copy Parent Permission settings
          select count(*) into i_count_permission from zz_ld_object_access
          where object_id = an_library_id;

          if i_count_permission > 0  then

            insert into zz_ld_object_access
              (object_id,
               user_id,
               read_acc,
               add_acc,
               modify_acc,
               delete_acc,
               add_attr,
               edit_attr,
               delete_attr,
               edit_permission,
               is_user,
               insert_by,
               insert_date,
               update_by,
               update_date
                )
             select
               an_new_object_id,
               user_id,
               read_acc,
               add_acc,
               modify_acc,
               delete_acc,
               add_attr,
               edit_attr,
               delete_attr,
               edit_permission,
               is_user,
               as_user    ,
                sysdate   ,
              as_user    ,
                sysdate

             from zz_ld_object_access
             where object_id = an_library_id;
          end if;


end p_copy_object;
/


DROP PROCEDURE LDS_NEW.P_COPY_GROUP_MASTER;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_copy_group_master(an_group_id in number, an_new_library_id in varchar2, as_user in varchar2, p_msg  out varchar2)
as
    n_group_id   number;
begin
    
    select nvl(max(group_id), 0) + 1 into n_group_id from ld_attr_group_master;
    insert into ld_attr_group_master
            (group_id    ,
            library_id    ,
            group_name    ,
            status,
            update_by    ,
            update_date )
    (select n_group_id    ,
            an_new_library_id,
            group_name    ,
            status,
            as_user    ,
            sysdate  
         from ld_attr_group_master where group_id = an_group_id)  ;
            
   
              
      --Add Attribute to Attribute Master

        insert into ld_attr_master
                (attr_id    ,
                attr_name    ,
                data_type    ,
                status,
                style,
                description,
                default_val_flag,
                default_val,
                val_mand,
                inherit_mand,
                library_id,
                insert_by    ,
                insert_date  )
        select  attr_id.nextval    ,
                a.attr_name    ,
                a.data_type    ,
                a.status,
                a.style,
                a.description,
                a.default_val_flag,
                a.default_val,
                a.val_mand,
                a.inherit_mand,
                an_new_library_id,
                as_user    ,
                sysdate   
         from   ld_attr_master  a
         inner join ld_attr_group g on a.attr_id = g.attr_id and g.group_id = an_group_id
         where  a.status = 'A'
         and    not exists (select '' from ld_attr_master  a1 where a1.library_id = an_new_library_id and lower(a.attr_name) = lower(a1.attr_name));
         
         --Add attributes to the group
         
         insert into ld_attr_group
               select  n_group_id    ,
                a_new.attr_id,
                as_user,
                sysdate
         from   ld_attr_master  a
         inner join ld_attr_master  a_new on a_new.library_id = an_new_library_id and lower(a.attr_name) = lower(a_new.attr_name)
         inner join ld_attr_group g on a.attr_id = g.attr_id and g.group_id = an_group_id;

         
         
         p_msg := 'Attribute group has been added Successfully.';
                
end p_copy_group_master;
/


DROP PROCEDURE LDS_NEW.P_COPY_ATTR;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_copy_attr(an_attr_id in number, an_new_library_id in varchar2, as_user in varchar2, p_msg  out varchar2)
as
    n_attr_id   number;
begin
    
    select nvl(max(attr_id), 0) + 1 into n_attr_id from ld_attr_master;
    insert into ld_attr_master
            (attr_id    ,
            attr_name    ,
            data_type    ,
            status,
            style,
            description,
            default_val_flag,
            default_val,
            val_mand,
            inherit_mand,
            library_id,
            insert_by    ,
            insert_date    ,
            update_by    ,
            update_date )
    (select n_attr_id    ,
            attr_name    ,
            data_type    ,
            status,
            style,
            description,
            default_val_flag,
            default_val,
            val_mand,
            inherit_mand,
            an_new_library_id,
            as_user    ,
            sysdate    ,
            null    ,
            null 
         from ld_attr_master where attr_id = an_attr_id)  ;
            p_msg := 'Attribute Added Successfully.';
end p_copy_attr;
/


DROP PROCEDURE LDS_NEW.P_ADD_OBJECT_ATTR;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_add_object_attr(an_object_id  in number,
                                                an_version_number in number   ,
                                                an_attr_id in number   ,
                                                as_val_mand  in varchar2  ,
                                                as_user in varchar2)
as
i_count     integer;
begin
    select count(*) into i_count from ld_object_attribute
            where object_id = an_object_id
            and   version_number = an_version_number
            and   attr_id = an_attr_id;

    if i_count > 0 then
        update ld_object_attribute
            set data_type  = (select data_type from ld_attr_master where attr_id =  an_attr_id),
                val_mand =  as_val_mand ,
                update_by   = as_user ,
                update_date = sysdate
        where object_id =  an_object_id
        and   version_number = an_version_number
        and   attr_id = an_attr_id;

     else

        insert into ld_object_attribute
                (object_id    ,
                version_number    ,
                attr_id    ,
                data_type    ,
                val_string    ,
                val_date    ,
                val_number    ,
                val_lob    ,
                val_mand    ,
                update_by    ,
                update_date
                 )
        values (an_object_id    ,
                an_version_number    ,
                an_attr_id    ,
                (select data_type from ld_attr_master where attr_id =  an_attr_id)    ,
                null    ,
                null    ,
                null    ,
                null    ,
                as_val_mand    ,
                as_user    ,
                sysdate    )  ;
      end if;
      commit;
end p_add_object_attr;
/


DROP PROCEDURE LDS_NEW.P_ADD_ATTR_GROUP_TO_OBJECT;

CREATE OR REPLACE PROCEDURE LDS_NEW.p_add_attr_group_to_object(an_object_id  in number,
                                                         an_group_id in number,
                                                         an_version_number in number,
                                                         as_user    in varchar2)
as
i_count     integer;
begin
       select count(*) into i_count from ld_object_attr_group
            where object_id = an_object_id
            and   group_id = an_group_id;
       if i_count = 0 then
           insert into ld_object_attr_group
                    (object_id    ,
                     group_id  )
            values (an_object_id    ,
                    an_group_id  )  ;
            --Insert atrr
            insert into ld_object_attribute
                (object_id    ,
                version_number    ,
                attr_id    ,
                data_type    ,
                val_mand    ,
                style    ,
                update_by    ,
                update_date
                 )
            select an_object_id    ,
                   an_version_number    ,
                   a.attr_id    ,
                   a.data_type    ,
                   a.val_mand   ,
                   a.style    ,
                   as_user    ,
                   sysdate
             from ld_attr_master a, ld_attr_group g
             where a.attr_id = g.attr_id and g.group_id = an_group_id
             and a.attr_id not in (select oa.attr_id from ld_object_attribute oa
                        where  oa.object_id = an_object_id);

           commit;
       end if;
end p_add_attr_group_to_object;
/


