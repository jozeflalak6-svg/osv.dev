-- +goose Up
CREATE TABLE vulnerabilities (
  id TEXT PRIMARY KEY, -- 
  proto BYTEA NOT NULL
);
-- vuln_id does not reference vulnerabilities(id) because there is no index on (vuln_id)
-- (to save space/writes), which would cause a full table scan on vulnerability deletes.
-- Use vuln_commits to look up commits and delete by (commit_sha, vuln_id).
CREATE TABLE affected_commits (
  commit_sha BYTEA NOT NULL,
  vuln_id TEXT NOT NULL,
  PRIMARY KEY (commit_sha, vuln_id)
);
CREATE TABLE vuln_commits (
  vuln_id TEXT PRIMARY KEY REFERENCES vulnerabilities(id) ON DELETE CASCADE,
  commits BYTEA[]
);

CREATE TABLE affected_versions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vuln_id TEXT NOT NULL REFERENCES vulnerabilities(id) ON
    coarse_max TEXT COLLATE "C" NOT NULL,
    versions TEXT[],
    events JSONB
);

-- Primary index for typical queries (with ecosystem provided)
CREATE 

-- +goose Down
DROP TABLE affected_versions;
DROP TABLE vuln_commits;
DROP TABLE affected_commits;
DROP TABLE vulnerabilities;
