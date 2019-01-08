DROP FUNCTION LDS_NEW.LD_F_GET_ATTR_VAL;

CREATE OR REPLACE FUNCTION LDS_NEW.ld_f_get_attr_val(an_object_id   in number,
                                        an_version_number in number,
                                        an_attr_id in number)
    return varchar2
as
    s_val varchar2(300);
begin
    select decode(data_type, 'S', val_string,
                             'D', to_char(val_date),
                             'N', to_char(val_number))
           into s_val
        from ld_object_attribute
     where object_id = an_object_id
     and version_number = an_version_number
     and an_attr_id = an_attr_id;
     return s_val;
end ld_f_get_attr_val;
/


DROP FUNCTION LDS_NEW.LD_F_GET_ROLE_NAME_BY_ROLE_ID;

CREATE OR REPLACE FUNCTION LDS_NEW.ld_f_get_role_name_by_role_id(as_role_id  in varchar2)
    return varchar2
as
    s_val varchar2(300);
begin
    select role_name into s_val
        from ld_user_role_master
     where role_id = as_role_id;
     return s_val;
end ld_f_get_role_name_by_role_id;
/


DROP FUNCTION LDS_NEW.LD_F_GET_USER_NAME_BY_USER_ID;

CREATE OR REPLACE FUNCTION LDS_NEW.ld_f_get_user_name_by_user_id(as_user_id  in varchar2)
    return varchar2
as
    s_val varchar2(300);
begin
    select user_name into s_val
        from ld_user_master
     where user_id = as_user_id;
     return s_val;
end ld_f_get_user_name_by_user_id;
/


