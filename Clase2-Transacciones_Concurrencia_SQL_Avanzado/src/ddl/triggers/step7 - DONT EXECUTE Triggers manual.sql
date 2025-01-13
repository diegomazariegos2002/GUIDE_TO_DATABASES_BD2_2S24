-- IMPORTANTE: ESTE ARCHIVO NO DEBE SER EJECUTADO
    -- SOLO ES UNA REFERENCIA PARA CREAR LOS TRIGGERS DE FORMA MANUAL
    -- MÁS ADELANTE SE CREARÁN LOS TRIGGERS DE FORMA AUTOMÁTICA (Step 3).


CREATE TRIGGER trg_auditoria_insert_estudiante -- Crea un trigger llamado 'trg_auditoria_insert_estudiante'.
AFTER INSERT ON estudiante -- Este trigger se ejecuta después de que ocurre un INSERT en la tabla 'estudiante'.
FOR EACH ROW EXECUTE FUNCTION auditoria_insert(); -- Por cada fila afectada por el INSERT, se ejecuta la función 'auditoria_insert'.

CREATE TRIGGER trg_auditoria_delete_estudiante -- Crea un trigger llamado 'trg_auditoria_delete_estudiante'.
AFTER DELETE ON estudiante -- Este trigger se ejecuta después de que ocurre un DELETE en la tabla 'estudiante'.
FOR EACH ROW EXECUTE FUNCTION auditoria_delete(); -- Por cada fila afectada por el DELETE, se ejecuta la función 'auditoria_delete'.

CREATE TRIGGER trg_auditoria_update_estudiante -- Crea un trigger llamado 'trg_auditoria_update_estudiante'.
AFTER UPDATE ON estudiante -- Este trigger se ejecuta después de que ocurre un UPDATE en la tabla 'estudiante'.
FOR EACH ROW EXECUTE FUNCTION auditoria_update(); -- Por cada fila afectada por el UPDATE, se ejecuta la función 'auditoria_update'.
