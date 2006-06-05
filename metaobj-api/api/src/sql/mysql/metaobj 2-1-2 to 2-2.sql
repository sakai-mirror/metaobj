alter table osp_structured_artifact_def add column schema_hash varchar(255);
alter table osp_structured_artifact_def change id id varchar(36);
alter table osp_structured_artifact_def change schemaData schemaData longblob;
