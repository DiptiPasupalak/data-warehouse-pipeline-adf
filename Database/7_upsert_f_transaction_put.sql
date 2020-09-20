SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[upsert_f_transaction_put] AS
  SET NOCOUNT ON;

  UPDATE f_transaction
  SET
    f_transaction.event_id = de.id
    , f_transaction.ticket_count = fui.ticket_count
    , f_transaction.ticket_amount = fui.total_amount
    , f_transaction.commission_amount = (des.commission_pct/fui.total_amount)*100
    , f_transaction.event_seller_id = des.id
    , f_transaction.updated_at = CURRENT_TIMESTAMP
    FROM file_upload_info fui
      inner join
         d_event de
         on upper(fui.event_name) = upper(de.event_name)
      inner join
         d_channel dc
         on upper(fui.channel) = upper(dc.channel_name)
      inner join
         d_event_seller des
         on de.id = des.event_id
         and des.reseller_id = substring(source_file_name
            ,dbo.INSTR(source_file_name, '_', 1, 2)+1
            ,dbo.INSTR(source_file_name, '.', 1, 1)-dbo.INSTR(source_file_name, '_', 1, 2)-1)
  WHERE
    f_transaction.transaction_id = fui.transaction_id;

  INSERT INTO f_transaction
  SELECT fui.transaction_id, de.id
        ,des.id, null, dc.id
        ,fui.ticket_count, fui.total_amount
        ,(des.commission_pct/fui.total_amount)*100
        ,CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    FROM file_upload_info fui
      inner join
         d_event de
         on upper(fui.event_name) = upper(de.event_name)
      inner join
         d_channel dc
         on upper(fui.channel) = upper(dc.channel_name)
      inner join
         d_event_seller des
         on de.id = des.event_id
         and des.reseller_id = substring(source_file_name
            ,dbo.INSTR(source_file_name, '_', 1, 2)+1
            ,dbo.INSTR(source_file_name, '.', 1, 1)-dbo.INSTR(source_file_name, '_', 1, 2)-1)
      left join
         f_transaction ft
         on ft.transaction_id = fui.transaction_id
    where ft.transaction_id is null;

  UPDATE STATISTICS f_transaction;
  truncate table file_upload_info;
GO