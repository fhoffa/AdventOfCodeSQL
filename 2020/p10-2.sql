select pow(7,max(iff(session_length=5,c,0)))
    * pow(4,max(iff(session_length=4,c,0)))
    * pow(2,max(iff(session_length=3,c,0))) r
from (
    select count(*) c, session_length
    from (
        select session_id, count(*) session_length, min(v) minv
        from (
            select *, iff(vv=1,0,1) new_session, sum(new_session) over(order by v) session_id
            from (
                select v, v-lag(v) over(order by v) vv
                from (
                    select v 
                    from adapters1
                    union all select 0
                    union all select max(v)+3 from adapters1
                )
            )
        )
        group by session_id
    )
    group by session_length
)
;
