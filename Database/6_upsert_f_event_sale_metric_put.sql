SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[upsert_f_event_sale_metric_put] AS
  SET NOCOUNT ON;

  IF (OBJECT_ID('sale_stg', 'V') IS NOT NULL)
  BEGIN
    DROP VIEW sale_stg;
  END;

  EXEC('
  CREATE VIEW sale_stg AS
    SELECT ft.event_id
      ,dd.id date_id
      ,ft.channel_id
      ,dc.region_id
      ,dc.id city_id
      ,dc.country_id
      ,des.organiser_id
      ,des.reseller_id
      ,sum(ft.ticket_count) ticket_count
      ,sum(ft.ticket_amount) ticket_amount
      ,sum(ft.commission_amount) commission_amount
  FROM f_transaction ft
    inner join 
       d_event de
       on ft.event_id = de.id
    inner join 
       d_city dc
       on de.city_id = dc.id
    inner join 
       d_event_seller des
       on ft.event_seller_id = des.id
    inner join 
       d_date dd
       on ft.updated_at >= getdate() - 2 
       and CONVERT(varchar,ft.updated_at,23)  = dd.date
  group by ft.event_id
      ,dd.id
      ,ft.channel_id
      ,dc.region_id
      ,dc.id
      ,dc.country_id
      ,des.organiser_id
      ,des.reseller_id
 ');

  UPDATE f_event_sale_metric
  SET
    f_event_sale_metric.commission_amount = ss.commission_amount
    ,f_event_sale_metric.ticket_count = ss.ticket_count
    ,f_event_sale_metric.ticket_amount = ss.ticket_amount
    FROM sale_stg ss
  WHERE
    f_event_sale_metric.event_id = ss.event_id
    and f_event_sale_metric.date_id = ss.date_id
    and f_event_sale_metric.channel_id = ss.channel_id
    and f_event_sale_metric.region_id = ss.region_id
    and f_event_sale_metric.city_id = ss.city_id
    and f_event_sale_metric.country_id = ss.country_id
    and f_event_sale_metric.organiser_id = ss.organiser_id
    and f_event_sale_metric.reseller_id = ss.reseller_id;

  INSERT INTO f_event_sale_metric
  select ss.*
    from sale_stg ss
      left join 
         f_event_sale_metric fesm
         on fesm.event_id = ss.event_id
        and fesm.date_id = ss.date_id
        and fesm.channel_id = ss.channel_id
        and fesm.region_id = ss.region_id
        and fesm.city_id = ss.city_id
        and fesm.country_id = ss.country_id
        and fesm.organiser_id = ss.organiser_id
        and fesm.reseller_id = ss.reseller_id
  where fesm.event_id is null;

  UPDATE STATISTICS f_event_sale_metric;
GO