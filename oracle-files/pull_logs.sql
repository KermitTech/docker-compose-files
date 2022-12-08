ALTER SESSION SET container=cdb$root;

EXECUTE dbms_logmnr_d.build(options=> dbms_logmnr_d.store_in_redo_logs);
