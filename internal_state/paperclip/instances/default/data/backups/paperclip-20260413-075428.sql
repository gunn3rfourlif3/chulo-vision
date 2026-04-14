-- Paperclip database backup
-- Created: 2026-04-13T07:54:28.379Z

BEGIN;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
SET LOCAL session_replication_role = replica;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
SET LOCAL client_min_messages = warning;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Sequences
DROP SEQUENCE IF EXISTS "public"."heartbeat_run_events_id_seq" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE SEQUENCE "public"."heartbeat_run_events_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 NO CYCLE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.account
DROP TABLE IF EXISTS "public"."account" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."account" (
  "id" text NOT NULL,
  "account_id" text NOT NULL,
  "provider_id" text NOT NULL,
  "user_id" text NOT NULL,
  "access_token" text,
  "refresh_token" text,
  "id_token" text,
  "access_token_expires_at" timestamp with time zone,
  "refresh_token_expires_at" timestamp with time zone,
  "scope" text,
  "password" text,
  "created_at" timestamp with time zone NOT NULL,
  "updated_at" timestamp with time zone NOT NULL,
  CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.activity_log
DROP TABLE IF EXISTS "public"."activity_log" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."activity_log" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "actor_type" text DEFAULT 'system'::text NOT NULL,
  "actor_id" text NOT NULL,
  "action" text NOT NULL,
  "entity_type" text NOT NULL,
  "entity_id" text NOT NULL,
  "agent_id" uuid,
  "details" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "run_id" uuid,
  CONSTRAINT "activity_log_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agent_api_keys
DROP TABLE IF EXISTS "public"."agent_api_keys" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agent_api_keys" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "agent_id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "name" text NOT NULL,
  "key_hash" text NOT NULL,
  "last_used_at" timestamp with time zone,
  "revoked_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "agent_api_keys_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agent_config_revisions
DROP TABLE IF EXISTS "public"."agent_config_revisions" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agent_config_revisions" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "source" text DEFAULT 'patch'::text NOT NULL,
  "rolled_back_from_revision_id" uuid,
  "changed_keys" jsonb DEFAULT '[]'::jsonb NOT NULL,
  "before_config" jsonb NOT NULL,
  "after_config" jsonb NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "agent_config_revisions_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agent_runtime_state
DROP TABLE IF EXISTS "public"."agent_runtime_state" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agent_runtime_state" (
  "agent_id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "adapter_type" text NOT NULL,
  "session_id" text,
  "state_json" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "last_run_id" uuid,
  "last_run_status" text,
  "total_input_tokens" bigint DEFAULT 0 NOT NULL,
  "total_output_tokens" bigint DEFAULT 0 NOT NULL,
  "total_cached_input_tokens" bigint DEFAULT 0 NOT NULL,
  "total_cost_cents" bigint DEFAULT 0 NOT NULL,
  "last_error" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "agent_runtime_state_pkey" PRIMARY KEY ("agent_id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agent_task_sessions
DROP TABLE IF EXISTS "public"."agent_task_sessions" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agent_task_sessions" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "adapter_type" text NOT NULL,
  "task_key" text NOT NULL,
  "session_params_json" jsonb,
  "session_display_id" text,
  "last_run_id" uuid,
  "last_error" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "agent_task_sessions_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agent_wakeup_requests
DROP TABLE IF EXISTS "public"."agent_wakeup_requests" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agent_wakeup_requests" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "source" text NOT NULL,
  "trigger_detail" text,
  "reason" text,
  "payload" jsonb,
  "status" text DEFAULT 'queued'::text NOT NULL,
  "coalesced_count" integer DEFAULT 0 NOT NULL,
  "requested_by_actor_type" text,
  "requested_by_actor_id" text,
  "idempotency_key" text,
  "run_id" uuid,
  "requested_at" timestamp with time zone DEFAULT now() NOT NULL,
  "claimed_at" timestamp with time zone,
  "finished_at" timestamp with time zone,
  "error" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "agent_wakeup_requests_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.agents
DROP TABLE IF EXISTS "public"."agents" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."agents" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "name" text NOT NULL,
  "role" text DEFAULT 'general'::text NOT NULL,
  "title" text,
  "status" text DEFAULT 'idle'::text NOT NULL,
  "reports_to" uuid,
  "capabilities" text,
  "adapter_type" text DEFAULT 'process'::text NOT NULL,
  "adapter_config" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "budget_monthly_cents" integer DEFAULT 0 NOT NULL,
  "spent_monthly_cents" integer DEFAULT 0 NOT NULL,
  "last_heartbeat_at" timestamp with time zone,
  "metadata" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "runtime_config" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "permissions" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "icon" text,
  "pause_reason" text,
  "paused_at" timestamp with time zone,
  CONSTRAINT "agents_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.approval_comments
DROP TABLE IF EXISTS "public"."approval_comments" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."approval_comments" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "approval_id" uuid NOT NULL,
  "author_agent_id" uuid,
  "author_user_id" text,
  "body" text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "approval_comments_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.approvals
DROP TABLE IF EXISTS "public"."approvals" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."approvals" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "type" text NOT NULL,
  "requested_by_agent_id" uuid,
  "requested_by_user_id" text,
  "status" text DEFAULT 'pending'::text NOT NULL,
  "payload" jsonb NOT NULL,
  "decision_note" text,
  "decided_by_user_id" text,
  "decided_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "approvals_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.assets
DROP TABLE IF EXISTS "public"."assets" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."assets" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "provider" text NOT NULL,
  "object_key" text NOT NULL,
  "content_type" text NOT NULL,
  "byte_size" integer NOT NULL,
  "sha256" text NOT NULL,
  "original_filename" text,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "assets_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.board_api_keys
DROP TABLE IF EXISTS "public"."board_api_keys" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."board_api_keys" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "user_id" text NOT NULL,
  "name" text NOT NULL,
  "key_hash" text NOT NULL,
  "last_used_at" timestamp with time zone,
  "revoked_at" timestamp with time zone,
  "expires_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "board_api_keys_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.budget_incidents
DROP TABLE IF EXISTS "public"."budget_incidents" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."budget_incidents" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "policy_id" uuid NOT NULL,
  "scope_type" text NOT NULL,
  "scope_id" uuid NOT NULL,
  "metric" text NOT NULL,
  "window_kind" text NOT NULL,
  "window_start" timestamp with time zone NOT NULL,
  "window_end" timestamp with time zone NOT NULL,
  "threshold_type" text NOT NULL,
  "amount_limit" integer NOT NULL,
  "amount_observed" integer NOT NULL,
  "status" text DEFAULT 'open'::text NOT NULL,
  "approval_id" uuid,
  "resolved_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "budget_incidents_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.budget_policies
DROP TABLE IF EXISTS "public"."budget_policies" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."budget_policies" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "scope_type" text NOT NULL,
  "scope_id" uuid NOT NULL,
  "metric" text DEFAULT 'billed_cents'::text NOT NULL,
  "window_kind" text NOT NULL,
  "amount" integer DEFAULT 0 NOT NULL,
  "warn_percent" integer DEFAULT 80 NOT NULL,
  "hard_stop_enabled" boolean DEFAULT true NOT NULL,
  "notify_enabled" boolean DEFAULT true NOT NULL,
  "is_active" boolean DEFAULT true NOT NULL,
  "created_by_user_id" text,
  "updated_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "budget_policies_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.cli_auth_challenges
DROP TABLE IF EXISTS "public"."cli_auth_challenges" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."cli_auth_challenges" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "secret_hash" text NOT NULL,
  "command" text NOT NULL,
  "client_name" text,
  "requested_access" text DEFAULT 'board'::text NOT NULL,
  "requested_company_id" uuid,
  "pending_key_hash" text NOT NULL,
  "pending_key_name" text NOT NULL,
  "approved_by_user_id" text,
  "board_api_key_id" uuid,
  "approved_at" timestamp with time zone,
  "cancelled_at" timestamp with time zone,
  "expires_at" timestamp with time zone NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "cli_auth_challenges_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.companies
DROP TABLE IF EXISTS "public"."companies" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."companies" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "name" text NOT NULL,
  "description" text,
  "status" text DEFAULT 'active'::text NOT NULL,
  "budget_monthly_cents" integer DEFAULT 0 NOT NULL,
  "spent_monthly_cents" integer DEFAULT 0 NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "issue_prefix" text DEFAULT 'PAP'::text NOT NULL,
  "issue_counter" integer DEFAULT 0 NOT NULL,
  "require_board_approval_for_new_agents" boolean DEFAULT true NOT NULL,
  "brand_color" text,
  "pause_reason" text,
  "paused_at" timestamp with time zone,
  "feedback_data_sharing_enabled" boolean DEFAULT false NOT NULL,
  "feedback_data_sharing_consent_at" timestamp with time zone,
  "feedback_data_sharing_consent_by_user_id" text,
  "feedback_data_sharing_terms_version" text,
  CONSTRAINT "companies_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.company_logos
DROP TABLE IF EXISTS "public"."company_logos" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."company_logos" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "asset_id" uuid NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "company_logos_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.company_memberships
DROP TABLE IF EXISTS "public"."company_memberships" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."company_memberships" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "principal_type" text NOT NULL,
  "principal_id" text NOT NULL,
  "status" text DEFAULT 'active'::text NOT NULL,
  "membership_role" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "company_memberships_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.company_secret_versions
DROP TABLE IF EXISTS "public"."company_secret_versions" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."company_secret_versions" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "secret_id" uuid NOT NULL,
  "version" integer NOT NULL,
  "material" jsonb NOT NULL,
  "value_sha256" text NOT NULL,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "revoked_at" timestamp with time zone,
  CONSTRAINT "company_secret_versions_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.company_secrets
DROP TABLE IF EXISTS "public"."company_secrets" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."company_secrets" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "name" text NOT NULL,
  "provider" text DEFAULT 'local_encrypted'::text NOT NULL,
  "external_ref" text,
  "latest_version" integer DEFAULT 1 NOT NULL,
  "description" text,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "company_secrets_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.company_skills
DROP TABLE IF EXISTS "public"."company_skills" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."company_skills" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "key" text NOT NULL,
  "slug" text NOT NULL,
  "name" text NOT NULL,
  "description" text,
  "markdown" text NOT NULL,
  "source_type" text DEFAULT 'local_path'::text NOT NULL,
  "source_locator" text,
  "source_ref" text,
  "trust_level" text DEFAULT 'markdown_only'::text NOT NULL,
  "compatibility" text DEFAULT 'compatible'::text NOT NULL,
  "file_inventory" jsonb DEFAULT '[]'::jsonb NOT NULL,
  "metadata" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "company_skills_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.cost_events
DROP TABLE IF EXISTS "public"."cost_events" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."cost_events" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "issue_id" uuid,
  "project_id" uuid,
  "goal_id" uuid,
  "billing_code" text,
  "provider" text NOT NULL,
  "model" text NOT NULL,
  "input_tokens" integer DEFAULT 0 NOT NULL,
  "output_tokens" integer DEFAULT 0 NOT NULL,
  "cost_cents" integer NOT NULL,
  "occurred_at" timestamp with time zone NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "heartbeat_run_id" uuid,
  "biller" text DEFAULT 'unknown'::text NOT NULL,
  "billing_type" text DEFAULT 'unknown'::text NOT NULL,
  "cached_input_tokens" integer DEFAULT 0 NOT NULL,
  CONSTRAINT "cost_events_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.document_revisions
DROP TABLE IF EXISTS "public"."document_revisions" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."document_revisions" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "document_id" uuid NOT NULL,
  "revision_number" integer NOT NULL,
  "body" text NOT NULL,
  "change_summary" text,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "title" text,
  "format" text DEFAULT 'markdown'::text NOT NULL,
  "created_by_run_id" uuid,
  CONSTRAINT "document_revisions_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.documents
DROP TABLE IF EXISTS "public"."documents" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."documents" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "title" text,
  "format" text DEFAULT 'markdown'::text NOT NULL,
  "latest_body" text NOT NULL,
  "latest_revision_id" uuid,
  "latest_revision_number" integer DEFAULT 1 NOT NULL,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "updated_by_agent_id" uuid,
  "updated_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.execution_workspaces
DROP TABLE IF EXISTS "public"."execution_workspaces" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."execution_workspaces" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid NOT NULL,
  "project_workspace_id" uuid,
  "source_issue_id" uuid,
  "mode" text NOT NULL,
  "strategy_type" text NOT NULL,
  "name" text NOT NULL,
  "status" text DEFAULT 'active'::text NOT NULL,
  "cwd" text,
  "repo_url" text,
  "base_ref" text,
  "branch_name" text,
  "provider_type" text DEFAULT 'local_fs'::text NOT NULL,
  "provider_ref" text,
  "derived_from_execution_workspace_id" uuid,
  "last_used_at" timestamp with time zone DEFAULT now() NOT NULL,
  "opened_at" timestamp with time zone DEFAULT now() NOT NULL,
  "closed_at" timestamp with time zone,
  "cleanup_eligible_at" timestamp with time zone,
  "cleanup_reason" text,
  "metadata" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "execution_workspaces_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.feedback_exports
DROP TABLE IF EXISTS "public"."feedback_exports" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."feedback_exports" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "feedback_vote_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "project_id" uuid,
  "author_user_id" text NOT NULL,
  "target_type" text NOT NULL,
  "target_id" text NOT NULL,
  "vote" text NOT NULL,
  "status" text DEFAULT 'local_only'::text NOT NULL,
  "destination" text,
  "export_id" text,
  "consent_version" text,
  "schema_version" text DEFAULT 'paperclip-feedback-envelope-v2'::text NOT NULL,
  "bundle_version" text DEFAULT 'paperclip-feedback-bundle-v2'::text NOT NULL,
  "payload_version" text DEFAULT 'paperclip-feedback-v1'::text NOT NULL,
  "payload_digest" text,
  "payload_snapshot" jsonb,
  "target_summary" jsonb NOT NULL,
  "redaction_summary" jsonb,
  "attempt_count" integer DEFAULT 0 NOT NULL,
  "last_attempted_at" timestamp with time zone,
  "exported_at" timestamp with time zone,
  "failure_reason" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "feedback_exports_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.feedback_votes
DROP TABLE IF EXISTS "public"."feedback_votes" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."feedback_votes" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "target_type" text NOT NULL,
  "target_id" text NOT NULL,
  "author_user_id" text NOT NULL,
  "vote" text NOT NULL,
  "reason" text,
  "shared_with_labs" boolean DEFAULT false NOT NULL,
  "shared_at" timestamp with time zone,
  "consent_version" text,
  "redaction_summary" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "feedback_votes_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.finance_events
DROP TABLE IF EXISTS "public"."finance_events" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."finance_events" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid,
  "issue_id" uuid,
  "project_id" uuid,
  "goal_id" uuid,
  "heartbeat_run_id" uuid,
  "cost_event_id" uuid,
  "billing_code" text,
  "description" text,
  "event_kind" text NOT NULL,
  "direction" text DEFAULT 'debit'::text NOT NULL,
  "biller" text NOT NULL,
  "provider" text,
  "execution_adapter_type" text,
  "pricing_tier" text,
  "region" text,
  "model" text,
  "quantity" integer,
  "unit" text,
  "amount_cents" integer NOT NULL,
  "currency" text DEFAULT 'USD'::text NOT NULL,
  "estimated" boolean DEFAULT false NOT NULL,
  "external_invoice_id" text,
  "metadata_json" jsonb,
  "occurred_at" timestamp with time zone NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "finance_events_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.goals
DROP TABLE IF EXISTS "public"."goals" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."goals" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "title" text NOT NULL,
  "description" text,
  "level" text DEFAULT 'task'::text NOT NULL,
  "status" text DEFAULT 'planned'::text NOT NULL,
  "parent_id" uuid,
  "owner_agent_id" uuid,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "goals_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.heartbeat_run_events
DROP TABLE IF EXISTS "public"."heartbeat_run_events" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."heartbeat_run_events" (
  "id" bigint DEFAULT nextval('heartbeat_run_events_id_seq'::regclass) NOT NULL,
  "company_id" uuid NOT NULL,
  "run_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "seq" integer NOT NULL,
  "event_type" text NOT NULL,
  "stream" text,
  "level" text,
  "color" text,
  "message" text,
  "payload" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "heartbeat_run_events_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.heartbeat_runs
DROP TABLE IF EXISTS "public"."heartbeat_runs" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."heartbeat_runs" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "agent_id" uuid NOT NULL,
  "invocation_source" text DEFAULT 'on_demand'::text NOT NULL,
  "status" text DEFAULT 'queued'::text NOT NULL,
  "started_at" timestamp with time zone,
  "finished_at" timestamp with time zone,
  "error" text,
  "external_run_id" text,
  "context_snapshot" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "trigger_detail" text,
  "wakeup_request_id" uuid,
  "exit_code" integer,
  "signal" text,
  "usage_json" jsonb,
  "result_json" jsonb,
  "session_id_before" text,
  "session_id_after" text,
  "log_store" text,
  "log_ref" text,
  "log_bytes" bigint,
  "log_sha256" text,
  "log_compressed" boolean DEFAULT false NOT NULL,
  "stdout_excerpt" text,
  "stderr_excerpt" text,
  "error_code" text,
  "process_pid" integer,
  "process_started_at" timestamp with time zone,
  "retry_of_run_id" uuid,
  "process_loss_retry_count" integer DEFAULT 0 NOT NULL,
  CONSTRAINT "heartbeat_runs_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.instance_settings
DROP TABLE IF EXISTS "public"."instance_settings" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."instance_settings" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "singleton_key" text DEFAULT 'default'::text NOT NULL,
  "experimental" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "general" jsonb DEFAULT '{}'::jsonb NOT NULL,
  CONSTRAINT "instance_settings_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.instance_user_roles
DROP TABLE IF EXISTS "public"."instance_user_roles" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."instance_user_roles" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "user_id" text NOT NULL,
  "role" text DEFAULT 'instance_admin'::text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "instance_user_roles_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.invites
DROP TABLE IF EXISTS "public"."invites" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."invites" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid,
  "invite_type" text DEFAULT 'company_join'::text NOT NULL,
  "token_hash" text NOT NULL,
  "allowed_join_types" text DEFAULT 'both'::text NOT NULL,
  "defaults_payload" jsonb,
  "expires_at" timestamp with time zone NOT NULL,
  "invited_by_user_id" text,
  "revoked_at" timestamp with time zone,
  "accepted_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "invites_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_approvals
DROP TABLE IF EXISTS "public"."issue_approvals" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_approvals" (
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "approval_id" uuid NOT NULL,
  "linked_by_agent_id" uuid,
  "linked_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_approvals_pk" PRIMARY KEY ("issue_id", "approval_id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_attachments
DROP TABLE IF EXISTS "public"."issue_attachments" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_attachments" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "asset_id" uuid NOT NULL,
  "issue_comment_id" uuid,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_attachments_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_comments
DROP TABLE IF EXISTS "public"."issue_comments" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_comments" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "author_agent_id" uuid,
  "author_user_id" text,
  "body" text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "created_by_run_id" uuid,
  CONSTRAINT "issue_comments_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_documents
DROP TABLE IF EXISTS "public"."issue_documents" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_documents" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "document_id" uuid NOT NULL,
  "key" text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_documents_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_inbox_archives
DROP TABLE IF EXISTS "public"."issue_inbox_archives" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_inbox_archives" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "user_id" text NOT NULL,
  "archived_at" timestamp with time zone DEFAULT now() NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_inbox_archives_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_labels
DROP TABLE IF EXISTS "public"."issue_labels" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_labels" (
  "issue_id" uuid NOT NULL,
  "label_id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_labels_pk" PRIMARY KEY ("issue_id", "label_id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_read_states
DROP TABLE IF EXISTS "public"."issue_read_states" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_read_states" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "issue_id" uuid NOT NULL,
  "user_id" text NOT NULL,
  "last_read_at" timestamp with time zone DEFAULT now() NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_read_states_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issue_work_products
DROP TABLE IF EXISTS "public"."issue_work_products" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issue_work_products" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid,
  "issue_id" uuid NOT NULL,
  "execution_workspace_id" uuid,
  "runtime_service_id" uuid,
  "type" text NOT NULL,
  "provider" text NOT NULL,
  "external_id" text,
  "title" text NOT NULL,
  "url" text,
  "status" text NOT NULL,
  "review_state" text DEFAULT 'none'::text NOT NULL,
  "is_primary" boolean DEFAULT false NOT NULL,
  "health_status" text DEFAULT 'unknown'::text NOT NULL,
  "summary" text,
  "metadata" jsonb,
  "created_by_run_id" uuid,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "issue_work_products_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.issues
DROP TABLE IF EXISTS "public"."issues" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."issues" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid,
  "goal_id" uuid,
  "parent_id" uuid,
  "title" text NOT NULL,
  "description" text,
  "status" text DEFAULT 'backlog'::text NOT NULL,
  "priority" text DEFAULT 'medium'::text NOT NULL,
  "assignee_agent_id" uuid,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "request_depth" integer DEFAULT 0 NOT NULL,
  "billing_code" text,
  "started_at" timestamp with time zone,
  "completed_at" timestamp with time zone,
  "cancelled_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "issue_number" integer,
  "identifier" text,
  "hidden_at" timestamp with time zone,
  "checkout_run_id" uuid,
  "execution_run_id" uuid,
  "execution_agent_name_key" text,
  "execution_locked_at" timestamp with time zone,
  "assignee_user_id" text,
  "assignee_adapter_overrides" jsonb,
  "execution_workspace_settings" jsonb,
  "project_workspace_id" uuid,
  "execution_workspace_id" uuid,
  "execution_workspace_preference" text,
  "origin_kind" text DEFAULT 'manual'::text NOT NULL,
  "origin_id" text,
  "origin_run_id" text,
  CONSTRAINT "issues_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.join_requests
DROP TABLE IF EXISTS "public"."join_requests" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."join_requests" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "invite_id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "request_type" text NOT NULL,
  "status" text DEFAULT 'pending_approval'::text NOT NULL,
  "request_ip" text NOT NULL,
  "requesting_user_id" text,
  "request_email_snapshot" text,
  "agent_name" text,
  "adapter_type" text,
  "capabilities" text,
  "agent_defaults_payload" jsonb,
  "created_agent_id" uuid,
  "approved_by_user_id" text,
  "approved_at" timestamp with time zone,
  "rejected_by_user_id" text,
  "rejected_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "claim_secret_hash" text,
  "claim_secret_expires_at" timestamp with time zone,
  "claim_secret_consumed_at" timestamp with time zone,
  CONSTRAINT "join_requests_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.labels
DROP TABLE IF EXISTS "public"."labels" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."labels" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "name" text NOT NULL,
  "color" text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "labels_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_company_settings
DROP TABLE IF EXISTS "public"."plugin_company_settings" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_company_settings" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "plugin_id" uuid NOT NULL,
  "settings_json" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "last_error" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "enabled" boolean DEFAULT true NOT NULL,
  CONSTRAINT "plugin_company_settings_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_config
DROP TABLE IF EXISTS "public"."plugin_config" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_config" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "config_json" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "last_error" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_config_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_entities
DROP TABLE IF EXISTS "public"."plugin_entities" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_entities" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "entity_type" text NOT NULL,
  "scope_kind" text NOT NULL,
  "scope_id" text,
  "external_id" text,
  "title" text,
  "status" text,
  "data" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_entities_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_job_runs
DROP TABLE IF EXISTS "public"."plugin_job_runs" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_job_runs" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "job_id" uuid NOT NULL,
  "plugin_id" uuid NOT NULL,
  "trigger" text NOT NULL,
  "status" text DEFAULT 'pending'::text NOT NULL,
  "duration_ms" integer,
  "error" text,
  "logs" jsonb DEFAULT '[]'::jsonb NOT NULL,
  "started_at" timestamp with time zone,
  "finished_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_job_runs_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_jobs
DROP TABLE IF EXISTS "public"."plugin_jobs" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_jobs" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "job_key" text NOT NULL,
  "schedule" text NOT NULL,
  "status" text DEFAULT 'active'::text NOT NULL,
  "last_run_at" timestamp with time zone,
  "next_run_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_jobs_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_logs
DROP TABLE IF EXISTS "public"."plugin_logs" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_logs" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "level" text DEFAULT 'info'::text NOT NULL,
  "message" text NOT NULL,
  "meta" jsonb,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_logs_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_state
DROP TABLE IF EXISTS "public"."plugin_state" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_state" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "scope_kind" text NOT NULL,
  "scope_id" text,
  "namespace" text DEFAULT 'default'::text NOT NULL,
  "state_key" text NOT NULL,
  "value_json" jsonb NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_state_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugin_webhook_deliveries
DROP TABLE IF EXISTS "public"."plugin_webhook_deliveries" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugin_webhook_deliveries" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_id" uuid NOT NULL,
  "webhook_key" text NOT NULL,
  "external_id" text,
  "status" text DEFAULT 'pending'::text NOT NULL,
  "duration_ms" integer,
  "error" text,
  "payload" jsonb NOT NULL,
  "headers" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "started_at" timestamp with time zone,
  "finished_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugin_webhook_deliveries_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.plugins
DROP TABLE IF EXISTS "public"."plugins" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."plugins" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "plugin_key" text NOT NULL,
  "package_name" text NOT NULL,
  "package_path" text,
  "version" text NOT NULL,
  "api_version" integer DEFAULT 1 NOT NULL,
  "categories" jsonb DEFAULT '[]'::jsonb NOT NULL,
  "manifest_json" jsonb NOT NULL,
  "status" text DEFAULT 'installed'::text NOT NULL,
  "install_order" integer,
  "last_error" text,
  "installed_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "plugins_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.principal_permission_grants
DROP TABLE IF EXISTS "public"."principal_permission_grants" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."principal_permission_grants" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "principal_type" text NOT NULL,
  "principal_id" text NOT NULL,
  "permission_key" text NOT NULL,
  "scope" jsonb,
  "granted_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "principal_permission_grants_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.project_goals
DROP TABLE IF EXISTS "public"."project_goals" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."project_goals" (
  "project_id" uuid NOT NULL,
  "goal_id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "project_goals_project_id_goal_id_pk" PRIMARY KEY ("project_id", "goal_id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.project_workspaces
DROP TABLE IF EXISTS "public"."project_workspaces" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."project_workspaces" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid NOT NULL,
  "name" text NOT NULL,
  "cwd" text,
  "repo_url" text,
  "repo_ref" text,
  "metadata" jsonb,
  "is_primary" boolean DEFAULT false NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "source_type" text DEFAULT 'local_path'::text NOT NULL,
  "default_ref" text,
  "visibility" text DEFAULT 'default'::text NOT NULL,
  "setup_command" text,
  "cleanup_command" text,
  "remote_provider" text,
  "remote_workspace_ref" text,
  "shared_workspace_key" text,
  CONSTRAINT "project_workspaces_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.projects
DROP TABLE IF EXISTS "public"."projects" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."projects" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "goal_id" uuid,
  "name" text NOT NULL,
  "description" text,
  "status" text DEFAULT 'backlog'::text NOT NULL,
  "lead_agent_id" uuid,
  "target_date" date,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "color" text,
  "archived_at" timestamp with time zone,
  "execution_workspace_policy" jsonb,
  "pause_reason" text,
  "paused_at" timestamp with time zone,
  CONSTRAINT "projects_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.routine_runs
DROP TABLE IF EXISTS "public"."routine_runs" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."routine_runs" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "routine_id" uuid NOT NULL,
  "trigger_id" uuid,
  "source" text NOT NULL,
  "status" text DEFAULT 'received'::text NOT NULL,
  "triggered_at" timestamp with time zone DEFAULT now() NOT NULL,
  "idempotency_key" text,
  "trigger_payload" jsonb,
  "linked_issue_id" uuid,
  "coalesced_into_run_id" uuid,
  "failure_reason" text,
  "completed_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "routine_runs_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.routine_triggers
DROP TABLE IF EXISTS "public"."routine_triggers" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."routine_triggers" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "routine_id" uuid NOT NULL,
  "kind" text NOT NULL,
  "label" text,
  "enabled" boolean DEFAULT true NOT NULL,
  "cron_expression" text,
  "timezone" text,
  "next_run_at" timestamp with time zone,
  "last_fired_at" timestamp with time zone,
  "public_id" text,
  "secret_id" uuid,
  "signing_mode" text,
  "replay_window_sec" integer,
  "last_rotated_at" timestamp with time zone,
  "last_result" text,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "updated_by_agent_id" uuid,
  "updated_by_user_id" text,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "routine_triggers_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.routines
DROP TABLE IF EXISTS "public"."routines" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."routines" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid NOT NULL,
  "goal_id" uuid,
  "parent_issue_id" uuid,
  "title" text NOT NULL,
  "description" text,
  "assignee_agent_id" uuid NOT NULL,
  "priority" text DEFAULT 'medium'::text NOT NULL,
  "status" text DEFAULT 'active'::text NOT NULL,
  "concurrency_policy" text DEFAULT 'coalesce_if_active'::text NOT NULL,
  "catch_up_policy" text DEFAULT 'skip_missed'::text NOT NULL,
  "created_by_agent_id" uuid,
  "created_by_user_id" text,
  "updated_by_agent_id" uuid,
  "updated_by_user_id" text,
  "last_triggered_at" timestamp with time zone,
  "last_enqueued_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "variables" jsonb DEFAULT '[]'::jsonb NOT NULL,
  CONSTRAINT "routines_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.session
DROP TABLE IF EXISTS "public"."session" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."session" (
  "id" text NOT NULL,
  "expires_at" timestamp with time zone NOT NULL,
  "token" text NOT NULL,
  "created_at" timestamp with time zone NOT NULL,
  "updated_at" timestamp with time zone NOT NULL,
  "ip_address" text,
  "user_agent" text,
  "user_id" text NOT NULL,
  CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.user
DROP TABLE IF EXISTS "public"."user" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."user" (
  "id" text NOT NULL,
  "name" text NOT NULL,
  "email" text NOT NULL,
  "email_verified" boolean DEFAULT false NOT NULL,
  "image" text,
  "created_at" timestamp with time zone NOT NULL,
  "updated_at" timestamp with time zone NOT NULL,
  CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.verification
DROP TABLE IF EXISTS "public"."verification" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."verification" (
  "id" text NOT NULL,
  "identifier" text NOT NULL,
  "value" text NOT NULL,
  "expires_at" timestamp with time zone NOT NULL,
  "created_at" timestamp with time zone,
  "updated_at" timestamp with time zone,
  CONSTRAINT "verification_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.workspace_operations
DROP TABLE IF EXISTS "public"."workspace_operations" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."workspace_operations" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "company_id" uuid NOT NULL,
  "execution_workspace_id" uuid,
  "heartbeat_run_id" uuid,
  "phase" text NOT NULL,
  "command" text,
  "cwd" text,
  "status" text DEFAULT 'running'::text NOT NULL,
  "exit_code" integer,
  "log_store" text,
  "log_ref" text,
  "log_bytes" bigint,
  "log_sha256" text,
  "log_compressed" boolean DEFAULT false NOT NULL,
  "stdout_excerpt" text,
  "stderr_excerpt" text,
  "metadata" jsonb,
  "started_at" timestamp with time zone DEFAULT now() NOT NULL,
  "finished_at" timestamp with time zone,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT "workspace_operations_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Table: public.workspace_runtime_services
DROP TABLE IF EXISTS "public"."workspace_runtime_services" CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE TABLE "public"."workspace_runtime_services" (
  "id" uuid NOT NULL,
  "company_id" uuid NOT NULL,
  "project_id" uuid,
  "project_workspace_id" uuid,
  "issue_id" uuid,
  "scope_type" text NOT NULL,
  "scope_id" text,
  "service_name" text NOT NULL,
  "status" text NOT NULL,
  "lifecycle" text NOT NULL,
  "reuse_key" text,
  "command" text,
  "cwd" text,
  "port" integer,
  "url" text,
  "provider" text NOT NULL,
  "provider_ref" text,
  "owner_agent_id" uuid,
  "started_by_run_id" uuid,
  "last_used_at" timestamp with time zone DEFAULT now() NOT NULL,
  "started_at" timestamp with time zone DEFAULT now() NOT NULL,
  "stopped_at" timestamp with time zone,
  "stop_policy" jsonb,
  "health_status" text DEFAULT 'unknown'::text NOT NULL,
  "created_at" timestamp with time zone DEFAULT now() NOT NULL,
  "updated_at" timestamp with time zone DEFAULT now() NOT NULL,
  "execution_workspace_id" uuid,
  CONSTRAINT "workspace_runtime_services_pkey" PRIMARY KEY ("id")
);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Sequence ownership
ALTER SEQUENCE "public"."heartbeat_run_events_id_seq" OWNED BY "public"."heartbeat_run_events"."id";
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Foreign keys
ALTER TABLE "public"."account" ADD CONSTRAINT "account_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."activity_log" ADD CONSTRAINT "activity_log_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."activity_log" ADD CONSTRAINT "activity_log_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."activity_log" ADD CONSTRAINT "activity_log_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_api_keys" ADD CONSTRAINT "agent_api_keys_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_api_keys" ADD CONSTRAINT "agent_api_keys_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_config_revisions" ADD CONSTRAINT "agent_config_revisions_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_config_revisions" ADD CONSTRAINT "agent_config_revisions_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_config_revisions" ADD CONSTRAINT "agent_config_revisions_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_runtime_state" ADD CONSTRAINT "agent_runtime_state_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_runtime_state" ADD CONSTRAINT "agent_runtime_state_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_task_sessions" ADD CONSTRAINT "agent_task_sessions_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_task_sessions" ADD CONSTRAINT "agent_task_sessions_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_task_sessions" ADD CONSTRAINT "agent_task_sessions_last_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("last_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_wakeup_requests" ADD CONSTRAINT "agent_wakeup_requests_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agent_wakeup_requests" ADD CONSTRAINT "agent_wakeup_requests_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agents" ADD CONSTRAINT "agents_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."agents" ADD CONSTRAINT "agents_reports_to_agents_id_fk" FOREIGN KEY ("reports_to") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."approval_comments" ADD CONSTRAINT "approval_comments_approval_id_approvals_id_fk" FOREIGN KEY ("approval_id") REFERENCES "public"."approvals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."approval_comments" ADD CONSTRAINT "approval_comments_author_agent_id_agents_id_fk" FOREIGN KEY ("author_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."approval_comments" ADD CONSTRAINT "approval_comments_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."approvals" ADD CONSTRAINT "approvals_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."approvals" ADD CONSTRAINT "approvals_requested_by_agent_id_agents_id_fk" FOREIGN KEY ("requested_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."board_api_keys" ADD CONSTRAINT "board_api_keys_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."budget_incidents" ADD CONSTRAINT "budget_incidents_approval_id_approvals_id_fk" FOREIGN KEY ("approval_id") REFERENCES "public"."approvals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."budget_incidents" ADD CONSTRAINT "budget_incidents_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."budget_incidents" ADD CONSTRAINT "budget_incidents_policy_id_budget_policies_id_fk" FOREIGN KEY ("policy_id") REFERENCES "public"."budget_policies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."budget_policies" ADD CONSTRAINT "budget_policies_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cli_auth_challenges" ADD CONSTRAINT "cli_auth_challenges_approved_by_user_id_user_id_fk" FOREIGN KEY ("approved_by_user_id") REFERENCES "public"."user" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cli_auth_challenges" ADD CONSTRAINT "cli_auth_challenges_board_api_key_id_board_api_keys_id_fk" FOREIGN KEY ("board_api_key_id") REFERENCES "public"."board_api_keys" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cli_auth_challenges" ADD CONSTRAINT "cli_auth_challenges_requested_company_id_companies_id_fk" FOREIGN KEY ("requested_company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_logos" ADD CONSTRAINT "company_logos_asset_id_assets_id_fk" FOREIGN KEY ("asset_id") REFERENCES "public"."assets" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_logos" ADD CONSTRAINT "company_logos_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_memberships" ADD CONSTRAINT "company_memberships_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_secret_versions" ADD CONSTRAINT "company_secret_versions_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_secret_versions" ADD CONSTRAINT "company_secret_versions_secret_id_company_secrets_id_fk" FOREIGN KEY ("secret_id") REFERENCES "public"."company_secrets" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_secrets" ADD CONSTRAINT "company_secrets_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_secrets" ADD CONSTRAINT "company_secrets_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."company_skills" ADD CONSTRAINT "company_skills_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_heartbeat_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("heartbeat_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."cost_events" ADD CONSTRAINT "cost_events_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."document_revisions" ADD CONSTRAINT "document_revisions_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."document_revisions" ADD CONSTRAINT "document_revisions_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."document_revisions" ADD CONSTRAINT "document_revisions_created_by_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("created_by_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."document_revisions" ADD CONSTRAINT "document_revisions_document_id_documents_id_fk" FOREIGN KEY ("document_id") REFERENCES "public"."documents" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."documents" ADD CONSTRAINT "documents_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."documents" ADD CONSTRAINT "documents_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."documents" ADD CONSTRAINT "documents_updated_by_agent_id_agents_id_fk" FOREIGN KEY ("updated_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."execution_workspaces" ADD CONSTRAINT "execution_workspaces_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."execution_workspaces" ADD CONSTRAINT "execution_workspaces_derived_from_execution_workspace_id_execut" FOREIGN KEY ("derived_from_execution_workspace_id") REFERENCES "public"."execution_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."execution_workspaces" ADD CONSTRAINT "execution_workspaces_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."execution_workspaces" ADD CONSTRAINT "execution_workspaces_project_workspace_id_project_workspaces_id" FOREIGN KEY ("project_workspace_id") REFERENCES "public"."project_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."execution_workspaces" ADD CONSTRAINT "execution_workspaces_source_issue_id_issues_id_fk" FOREIGN KEY ("source_issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_exports" ADD CONSTRAINT "feedback_exports_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_exports" ADD CONSTRAINT "feedback_exports_feedback_vote_id_feedback_votes_id_fk" FOREIGN KEY ("feedback_vote_id") REFERENCES "public"."feedback_votes" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_exports" ADD CONSTRAINT "feedback_exports_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_exports" ADD CONSTRAINT "feedback_exports_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_votes" ADD CONSTRAINT "feedback_votes_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."feedback_votes" ADD CONSTRAINT "feedback_votes_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_cost_event_id_cost_events_id_fk" FOREIGN KEY ("cost_event_id") REFERENCES "public"."cost_events" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_heartbeat_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("heartbeat_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."finance_events" ADD CONSTRAINT "finance_events_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."goals" ADD CONSTRAINT "goals_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."goals" ADD CONSTRAINT "goals_owner_agent_id_agents_id_fk" FOREIGN KEY ("owner_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."goals" ADD CONSTRAINT "goals_parent_id_goals_id_fk" FOREIGN KEY ("parent_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_run_events" ADD CONSTRAINT "heartbeat_run_events_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_run_events" ADD CONSTRAINT "heartbeat_run_events_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_run_events" ADD CONSTRAINT "heartbeat_run_events_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_runs" ADD CONSTRAINT "heartbeat_runs_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_runs" ADD CONSTRAINT "heartbeat_runs_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_runs" ADD CONSTRAINT "heartbeat_runs_retry_of_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("retry_of_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."heartbeat_runs" ADD CONSTRAINT "heartbeat_runs_wakeup_request_id_agent_wakeup_requests_id_fk" FOREIGN KEY ("wakeup_request_id") REFERENCES "public"."agent_wakeup_requests" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."invites" ADD CONSTRAINT "invites_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_approvals" ADD CONSTRAINT "issue_approvals_approval_id_approvals_id_fk" FOREIGN KEY ("approval_id") REFERENCES "public"."approvals" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_approvals" ADD CONSTRAINT "issue_approvals_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_approvals" ADD CONSTRAINT "issue_approvals_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_approvals" ADD CONSTRAINT "issue_approvals_linked_by_agent_id_agents_id_fk" FOREIGN KEY ("linked_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_attachments" ADD CONSTRAINT "issue_attachments_asset_id_assets_id_fk" FOREIGN KEY ("asset_id") REFERENCES "public"."assets" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_attachments" ADD CONSTRAINT "issue_attachments_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_attachments" ADD CONSTRAINT "issue_attachments_issue_comment_id_issue_comments_id_fk" FOREIGN KEY ("issue_comment_id") REFERENCES "public"."issue_comments" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_attachments" ADD CONSTRAINT "issue_attachments_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_comments" ADD CONSTRAINT "issue_comments_author_agent_id_agents_id_fk" FOREIGN KEY ("author_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_comments" ADD CONSTRAINT "issue_comments_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_comments" ADD CONSTRAINT "issue_comments_created_by_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("created_by_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_comments" ADD CONSTRAINT "issue_comments_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_documents" ADD CONSTRAINT "issue_documents_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_documents" ADD CONSTRAINT "issue_documents_document_id_documents_id_fk" FOREIGN KEY ("document_id") REFERENCES "public"."documents" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_documents" ADD CONSTRAINT "issue_documents_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_inbox_archives" ADD CONSTRAINT "issue_inbox_archives_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_inbox_archives" ADD CONSTRAINT "issue_inbox_archives_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_labels" ADD CONSTRAINT "issue_labels_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_labels" ADD CONSTRAINT "issue_labels_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_labels" ADD CONSTRAINT "issue_labels_label_id_labels_id_fk" FOREIGN KEY ("label_id") REFERENCES "public"."labels" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_read_states" ADD CONSTRAINT "issue_read_states_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_read_states" ADD CONSTRAINT "issue_read_states_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_created_by_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("created_by_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_execution_workspace_id_execution_workspaces" FOREIGN KEY ("execution_workspace_id") REFERENCES "public"."execution_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issue_work_products" ADD CONSTRAINT "issue_work_products_runtime_service_id_workspace_runtime_servic" FOREIGN KEY ("runtime_service_id") REFERENCES "public"."workspace_runtime_services" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_assignee_agent_id_agents_id_fk" FOREIGN KEY ("assignee_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_checkout_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("checkout_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_execution_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("execution_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_execution_workspace_id_execution_workspaces_id_fk" FOREIGN KEY ("execution_workspace_id") REFERENCES "public"."execution_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_parent_id_issues_id_fk" FOREIGN KEY ("parent_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."issues" ADD CONSTRAINT "issues_project_workspace_id_project_workspaces_id_fk" FOREIGN KEY ("project_workspace_id") REFERENCES "public"."project_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."join_requests" ADD CONSTRAINT "join_requests_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."join_requests" ADD CONSTRAINT "join_requests_created_agent_id_agents_id_fk" FOREIGN KEY ("created_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."join_requests" ADD CONSTRAINT "join_requests_invite_id_invites_id_fk" FOREIGN KEY ("invite_id") REFERENCES "public"."invites" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."labels" ADD CONSTRAINT "labels_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_company_settings" ADD CONSTRAINT "plugin_company_settings_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_company_settings" ADD CONSTRAINT "plugin_company_settings_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_config" ADD CONSTRAINT "plugin_config_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_entities" ADD CONSTRAINT "plugin_entities_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_job_runs" ADD CONSTRAINT "plugin_job_runs_job_id_plugin_jobs_id_fk" FOREIGN KEY ("job_id") REFERENCES "public"."plugin_jobs" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_job_runs" ADD CONSTRAINT "plugin_job_runs_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_jobs" ADD CONSTRAINT "plugin_jobs_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_logs" ADD CONSTRAINT "plugin_logs_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_state" ADD CONSTRAINT "plugin_state_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."plugin_webhook_deliveries" ADD CONSTRAINT "plugin_webhook_deliveries_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."principal_permission_grants" ADD CONSTRAINT "principal_permission_grants_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."project_goals" ADD CONSTRAINT "project_goals_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."project_goals" ADD CONSTRAINT "project_goals_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."project_goals" ADD CONSTRAINT "project_goals_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."project_workspaces" ADD CONSTRAINT "project_workspaces_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."project_workspaces" ADD CONSTRAINT "project_workspaces_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."projects" ADD CONSTRAINT "projects_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."projects" ADD CONSTRAINT "projects_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."projects" ADD CONSTRAINT "projects_lead_agent_id_agents_id_fk" FOREIGN KEY ("lead_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_runs" ADD CONSTRAINT "routine_runs_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_runs" ADD CONSTRAINT "routine_runs_linked_issue_id_issues_id_fk" FOREIGN KEY ("linked_issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_runs" ADD CONSTRAINT "routine_runs_routine_id_routines_id_fk" FOREIGN KEY ("routine_id") REFERENCES "public"."routines" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_runs" ADD CONSTRAINT "routine_runs_trigger_id_routine_triggers_id_fk" FOREIGN KEY ("trigger_id") REFERENCES "public"."routine_triggers" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_triggers" ADD CONSTRAINT "routine_triggers_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_triggers" ADD CONSTRAINT "routine_triggers_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_triggers" ADD CONSTRAINT "routine_triggers_routine_id_routines_id_fk" FOREIGN KEY ("routine_id") REFERENCES "public"."routines" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_triggers" ADD CONSTRAINT "routine_triggers_secret_id_company_secrets_id_fk" FOREIGN KEY ("secret_id") REFERENCES "public"."company_secrets" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routine_triggers" ADD CONSTRAINT "routine_triggers_updated_by_agent_id_agents_id_fk" FOREIGN KEY ("updated_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_assignee_agent_id_agents_id_fk" FOREIGN KEY ("assignee_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_created_by_agent_id_agents_id_fk" FOREIGN KEY ("created_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_goal_id_goals_id_fk" FOREIGN KEY ("goal_id") REFERENCES "public"."goals" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_parent_issue_id_issues_id_fk" FOREIGN KEY ("parent_issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."routines" ADD CONSTRAINT "routines_updated_by_agent_id_agents_id_fk" FOREIGN KEY ("updated_by_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."session" ADD CONSTRAINT "session_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user" ("id") ON UPDATE NO ACTION ON DELETE CASCADE;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_operations" ADD CONSTRAINT "workspace_operations_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_operations" ADD CONSTRAINT "workspace_operations_execution_workspace_id_execution_workspace" FOREIGN KEY ("execution_workspace_id") REFERENCES "public"."execution_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_operations" ADD CONSTRAINT "workspace_operations_heartbeat_run_id_heartbeat_runs_id_fk" FOREIGN KEY ("heartbeat_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_execution_workspace_id_execution_wor" FOREIGN KEY ("execution_workspace_id") REFERENCES "public"."execution_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_issue_id_issues_id_fk" FOREIGN KEY ("issue_id") REFERENCES "public"."issues" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_owner_agent_id_agents_id_fk" FOREIGN KEY ("owner_agent_id") REFERENCES "public"."agents" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_project_workspace_id_project_workspa" FOREIGN KEY ("project_workspace_id") REFERENCES "public"."project_workspaces" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
ALTER TABLE "public"."workspace_runtime_services" ADD CONSTRAINT "workspace_runtime_services_started_by_run_id_heartbeat_runs_id_" FOREIGN KEY ("started_by_run_id") REFERENCES "public"."heartbeat_runs" ("id") ON UPDATE NO ACTION ON DELETE SET NULL;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Unique constraints
ALTER TABLE "public"."plugin_state" ADD CONSTRAINT "plugin_state_unique_entry_idx" UNIQUE ("plugin_id", "scope_kind", "scope_id", "namespace", "state_key");
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Indexes
CREATE INDEX activity_log_company_created_idx ON public.activity_log USING btree (company_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX activity_log_entity_type_id_idx ON public.activity_log USING btree (entity_type, entity_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX activity_log_run_id_idx ON public.activity_log USING btree (run_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_api_keys_company_agent_idx ON public.agent_api_keys USING btree (company_id, agent_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_api_keys_key_hash_idx ON public.agent_api_keys USING btree (key_hash);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_config_revisions_agent_created_idx ON public.agent_config_revisions USING btree (agent_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_config_revisions_company_agent_created_idx ON public.agent_config_revisions USING btree (company_id, agent_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_runtime_state_company_agent_idx ON public.agent_runtime_state USING btree (company_id, agent_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_runtime_state_company_updated_idx ON public.agent_runtime_state USING btree (company_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX agent_task_sessions_company_agent_adapter_task_uniq ON public.agent_task_sessions USING btree (company_id, agent_id, adapter_type, task_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_task_sessions_company_agent_updated_idx ON public.agent_task_sessions USING btree (company_id, agent_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_task_sessions_company_task_updated_idx ON public.agent_task_sessions USING btree (company_id, task_key, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_wakeup_requests_agent_requested_idx ON public.agent_wakeup_requests USING btree (agent_id, requested_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_wakeup_requests_company_agent_status_idx ON public.agent_wakeup_requests USING btree (company_id, agent_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agent_wakeup_requests_company_requested_idx ON public.agent_wakeup_requests USING btree (company_id, requested_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agents_company_reports_to_idx ON public.agents USING btree (company_id, reports_to);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX agents_company_status_idx ON public.agents USING btree (company_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX approval_comments_approval_created_idx ON public.approval_comments USING btree (approval_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX approval_comments_approval_idx ON public.approval_comments USING btree (approval_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX approval_comments_company_idx ON public.approval_comments USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX approvals_company_status_type_idx ON public.approvals USING btree (company_id, status, type);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX assets_company_created_idx ON public.assets USING btree (company_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX assets_company_object_key_uq ON public.assets USING btree (company_id, object_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX assets_company_provider_idx ON public.assets USING btree (company_id, provider);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX board_api_keys_key_hash_idx ON public.board_api_keys USING btree (key_hash);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX board_api_keys_user_idx ON public.board_api_keys USING btree (user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX budget_incidents_company_scope_idx ON public.budget_incidents USING btree (company_id, scope_type, scope_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX budget_incidents_company_status_idx ON public.budget_incidents USING btree (company_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX budget_incidents_policy_window_threshold_idx ON public.budget_incidents USING btree (policy_id, window_start, threshold_type) WHERE (status <> 'dismissed'::text);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX budget_policies_company_scope_active_idx ON public.budget_policies USING btree (company_id, scope_type, scope_id, is_active);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX budget_policies_company_scope_metric_unique_idx ON public.budget_policies USING btree (company_id, scope_type, scope_id, metric, window_kind);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX budget_policies_company_window_idx ON public.budget_policies USING btree (company_id, window_kind, metric);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cli_auth_challenges_approved_by_idx ON public.cli_auth_challenges USING btree (approved_by_user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cli_auth_challenges_requested_company_idx ON public.cli_auth_challenges USING btree (requested_company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cli_auth_challenges_secret_hash_idx ON public.cli_auth_challenges USING btree (secret_hash);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX companies_issue_prefix_idx ON public.companies USING btree (issue_prefix);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_logos_asset_uq ON public.company_logos USING btree (asset_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_logos_company_uq ON public.company_logos USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_memberships_company_principal_unique_idx ON public.company_memberships USING btree (company_id, principal_type, principal_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_memberships_company_status_idx ON public.company_memberships USING btree (company_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_memberships_principal_status_idx ON public.company_memberships USING btree (principal_type, principal_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_secret_versions_secret_idx ON public.company_secret_versions USING btree (secret_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_secret_versions_secret_version_uq ON public.company_secret_versions USING btree (secret_id, version);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_secret_versions_value_sha256_idx ON public.company_secret_versions USING btree (value_sha256);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_secrets_company_idx ON public.company_secrets USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_secrets_company_name_uq ON public.company_secrets USING btree (company_id, name);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_secrets_company_provider_idx ON public.company_secrets USING btree (company_id, provider);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX company_skills_company_key_idx ON public.company_skills USING btree (company_id, key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX company_skills_company_name_idx ON public.company_skills USING btree (company_id, name);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cost_events_company_agent_occurred_idx ON public.cost_events USING btree (company_id, agent_id, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cost_events_company_biller_occurred_idx ON public.cost_events USING btree (company_id, biller, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cost_events_company_heartbeat_run_idx ON public.cost_events USING btree (company_id, heartbeat_run_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cost_events_company_occurred_idx ON public.cost_events USING btree (company_id, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX cost_events_company_provider_occurred_idx ON public.cost_events USING btree (company_id, provider, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX document_revisions_company_document_created_idx ON public.document_revisions USING btree (company_id, document_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX document_revisions_document_revision_uq ON public.document_revisions USING btree (document_id, revision_number);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX documents_company_created_idx ON public.documents USING btree (company_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX documents_company_updated_idx ON public.documents USING btree (company_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX execution_workspaces_company_branch_idx ON public.execution_workspaces USING btree (company_id, branch_name);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX execution_workspaces_company_last_used_idx ON public.execution_workspaces USING btree (company_id, last_used_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX execution_workspaces_company_project_status_idx ON public.execution_workspaces USING btree (company_id, project_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX execution_workspaces_company_project_workspace_status_idx ON public.execution_workspaces USING btree (company_id, project_workspace_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX execution_workspaces_company_source_issue_idx ON public.execution_workspaces USING btree (company_id, source_issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_exports_company_author_idx ON public.feedback_exports USING btree (company_id, author_user_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_exports_company_created_idx ON public.feedback_exports USING btree (company_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_exports_company_issue_idx ON public.feedback_exports USING btree (company_id, issue_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_exports_company_project_idx ON public.feedback_exports USING btree (company_id, project_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_exports_company_status_idx ON public.feedback_exports USING btree (company_id, status, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX feedback_exports_feedback_vote_idx ON public.feedback_exports USING btree (feedback_vote_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_votes_author_idx ON public.feedback_votes USING btree (author_user_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_votes_company_issue_idx ON public.feedback_votes USING btree (company_id, issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX feedback_votes_company_target_author_idx ON public.feedback_votes USING btree (company_id, target_type, target_id, author_user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX feedback_votes_issue_target_idx ON public.feedback_votes USING btree (issue_id, target_type, target_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_biller_occurred_idx ON public.finance_events USING btree (company_id, biller, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_cost_event_idx ON public.finance_events USING btree (company_id, cost_event_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_direction_occurred_idx ON public.finance_events USING btree (company_id, direction, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_heartbeat_run_idx ON public.finance_events USING btree (company_id, heartbeat_run_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_kind_occurred_idx ON public.finance_events USING btree (company_id, event_kind, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX finance_events_company_occurred_idx ON public.finance_events USING btree (company_id, occurred_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX goals_company_idx ON public.goals USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX heartbeat_run_events_company_created_idx ON public.heartbeat_run_events USING btree (company_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX heartbeat_run_events_company_run_idx ON public.heartbeat_run_events USING btree (company_id, run_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX heartbeat_run_events_run_seq_idx ON public.heartbeat_run_events USING btree (run_id, seq);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX heartbeat_runs_company_agent_started_idx ON public.heartbeat_runs USING btree (company_id, agent_id, started_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX instance_settings_singleton_key_idx ON public.instance_settings USING btree (singleton_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX instance_user_roles_role_idx ON public.instance_user_roles USING btree (role);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX instance_user_roles_user_role_unique_idx ON public.instance_user_roles USING btree (user_id, role);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX invites_company_invite_state_idx ON public.invites USING btree (company_id, invite_type, revoked_at, expires_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX invites_token_hash_unique_idx ON public.invites USING btree (token_hash);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_approvals_approval_idx ON public.issue_approvals USING btree (approval_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_approvals_company_idx ON public.issue_approvals USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_approvals_issue_idx ON public.issue_approvals USING btree (issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issue_attachments_asset_uq ON public.issue_attachments USING btree (asset_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_attachments_company_issue_idx ON public.issue_attachments USING btree (company_id, issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_attachments_issue_comment_idx ON public.issue_attachments USING btree (issue_comment_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_comments_company_author_issue_created_at_idx ON public.issue_comments USING btree (company_id, author_user_id, issue_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_comments_company_idx ON public.issue_comments USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_comments_company_issue_created_at_idx ON public.issue_comments USING btree (company_id, issue_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_comments_issue_idx ON public.issue_comments USING btree (issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issue_documents_company_issue_key_uq ON public.issue_documents USING btree (company_id, issue_id, key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_documents_company_issue_updated_idx ON public.issue_documents USING btree (company_id, issue_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issue_documents_document_uq ON public.issue_documents USING btree (document_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_inbox_archives_company_issue_idx ON public.issue_inbox_archives USING btree (company_id, issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issue_inbox_archives_company_issue_user_idx ON public.issue_inbox_archives USING btree (company_id, issue_id, user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_inbox_archives_company_user_idx ON public.issue_inbox_archives USING btree (company_id, user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_labels_company_idx ON public.issue_labels USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_labels_issue_idx ON public.issue_labels USING btree (issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_labels_label_idx ON public.issue_labels USING btree (label_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_read_states_company_issue_idx ON public.issue_read_states USING btree (company_id, issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issue_read_states_company_issue_user_idx ON public.issue_read_states USING btree (company_id, issue_id, user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_read_states_company_user_idx ON public.issue_read_states USING btree (company_id, user_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_work_products_company_execution_workspace_type_idx ON public.issue_work_products USING btree (company_id, execution_workspace_id, type);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_work_products_company_issue_type_idx ON public.issue_work_products USING btree (company_id, issue_id, type);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_work_products_company_provider_external_id_idx ON public.issue_work_products USING btree (company_id, provider, external_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issue_work_products_company_updated_idx ON public.issue_work_products USING btree (company_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_assignee_status_idx ON public.issues USING btree (company_id, assignee_agent_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_assignee_user_status_idx ON public.issues USING btree (company_id, assignee_user_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_execution_workspace_idx ON public.issues USING btree (company_id, execution_workspace_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_origin_idx ON public.issues USING btree (company_id, origin_kind, origin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_parent_idx ON public.issues USING btree (company_id, parent_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_project_idx ON public.issues USING btree (company_id, project_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_project_workspace_idx ON public.issues USING btree (company_id, project_workspace_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX issues_company_status_idx ON public.issues USING btree (company_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issues_identifier_idx ON public.issues USING btree (identifier);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX issues_open_routine_execution_uq ON public.issues USING btree (company_id, origin_kind, origin_id) WHERE ((origin_kind = 'routine_execution'::text) AND (origin_id IS NOT NULL) AND (hidden_at IS NULL) AND (execution_run_id IS NOT NULL) AND (status = ANY (ARRAY['backlog'::text, 'todo'::text, 'in_progress'::text, 'in_review'::text, 'blocked'::text])));
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX join_requests_company_status_type_created_idx ON public.join_requests USING btree (company_id, status, request_type, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX join_requests_invite_unique_idx ON public.join_requests USING btree (invite_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX labels_company_idx ON public.labels USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX labels_company_name_idx ON public.labels USING btree (company_id, name);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_company_settings_company_idx ON public.plugin_company_settings USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX plugin_company_settings_company_plugin_uq ON public.plugin_company_settings USING btree (company_id, plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_company_settings_plugin_idx ON public.plugin_company_settings USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX plugin_config_plugin_id_idx ON public.plugin_config USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX plugin_entities_external_idx ON public.plugin_entities USING btree (plugin_id, entity_type, external_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_entities_plugin_idx ON public.plugin_entities USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_entities_scope_idx ON public.plugin_entities USING btree (scope_kind, scope_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_entities_type_idx ON public.plugin_entities USING btree (entity_type);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_job_runs_job_idx ON public.plugin_job_runs USING btree (job_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_job_runs_plugin_idx ON public.plugin_job_runs USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_job_runs_status_idx ON public.plugin_job_runs USING btree (status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_jobs_next_run_idx ON public.plugin_jobs USING btree (next_run_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_jobs_plugin_idx ON public.plugin_jobs USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX plugin_jobs_unique_idx ON public.plugin_jobs USING btree (plugin_id, job_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_logs_level_idx ON public.plugin_logs USING btree (level);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_logs_plugin_time_idx ON public.plugin_logs USING btree (plugin_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_state_plugin_scope_idx ON public.plugin_state USING btree (plugin_id, scope_kind);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_webhook_deliveries_key_idx ON public.plugin_webhook_deliveries USING btree (webhook_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_webhook_deliveries_plugin_idx ON public.plugin_webhook_deliveries USING btree (plugin_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugin_webhook_deliveries_status_idx ON public.plugin_webhook_deliveries USING btree (status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX plugins_plugin_key_idx ON public.plugins USING btree (plugin_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX plugins_status_idx ON public.plugins USING btree (status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX principal_permission_grants_company_permission_idx ON public.principal_permission_grants USING btree (company_id, permission_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX principal_permission_grants_unique_idx ON public.principal_permission_grants USING btree (company_id, principal_type, principal_id, permission_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_goals_company_idx ON public.project_goals USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_goals_goal_idx ON public.project_goals USING btree (goal_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_goals_project_idx ON public.project_goals USING btree (project_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_workspaces_company_project_idx ON public.project_workspaces USING btree (company_id, project_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_workspaces_company_shared_key_idx ON public.project_workspaces USING btree (company_id, shared_workspace_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_workspaces_project_primary_idx ON public.project_workspaces USING btree (project_id, is_primary);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX project_workspaces_project_remote_ref_idx ON public.project_workspaces USING btree (project_id, remote_provider, remote_workspace_ref);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX project_workspaces_project_source_type_idx ON public.project_workspaces USING btree (project_id, source_type);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX projects_company_idx ON public.projects USING btree (company_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_runs_company_routine_idx ON public.routine_runs USING btree (company_id, routine_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_runs_linked_issue_idx ON public.routine_runs USING btree (linked_issue_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_runs_trigger_idempotency_idx ON public.routine_runs USING btree (trigger_id, idempotency_key);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_runs_trigger_idx ON public.routine_runs USING btree (trigger_id, created_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_triggers_company_kind_idx ON public.routine_triggers USING btree (company_id, kind);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_triggers_company_routine_idx ON public.routine_triggers USING btree (company_id, routine_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_triggers_next_run_idx ON public.routine_triggers USING btree (next_run_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routine_triggers_public_id_idx ON public.routine_triggers USING btree (public_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE UNIQUE INDEX routine_triggers_public_id_uq ON public.routine_triggers USING btree (public_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routines_company_assignee_idx ON public.routines USING btree (company_id, assignee_agent_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routines_company_project_idx ON public.routines USING btree (company_id, project_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX routines_company_status_idx ON public.routines USING btree (company_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_operations_company_run_started_idx ON public.workspace_operations USING btree (company_id, heartbeat_run_id, started_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_operations_company_workspace_started_idx ON public.workspace_operations USING btree (company_id, execution_workspace_id, started_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_runtime_services_company_execution_workspace_status_i ON public.workspace_runtime_services USING btree (company_id, execution_workspace_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_runtime_services_company_project_status_idx ON public.workspace_runtime_services USING btree (company_id, project_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_runtime_services_company_updated_idx ON public.workspace_runtime_services USING btree (company_id, updated_at);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_runtime_services_company_workspace_status_idx ON public.workspace_runtime_services USING btree (company_id, project_workspace_id, status);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
CREATE INDEX workspace_runtime_services_run_idx ON public.workspace_runtime_services USING btree (started_by_run_id);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.account (1 rows)
INSERT INTO "public"."account" ("id", "account_id", "provider_id", "user_id", "access_token", "refresh_token", "id_token", "access_token_expires_at", "refresh_token_expires_at", "scope", "password", "created_at", "updated_at") VALUES ($paperclip$pDQkD9j668ZwFEmweEUpAm57Bg5nL5lu$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$credential$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$bf42c73a67d5caea5d899e6913ee915b:cbca4b87c9315e01c5ad3af9a0f7367ff01766d9eeb831874b658edc5ca5239222e0f981b473927673cb970b24b41c501eeba3b47ed4fce13cc92722faa6425c$paperclip$, $paperclip$2026-04-11T20:58:49.288Z$paperclip$, $paperclip$2026-04-11T20:58:49.288Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.activity_log (81 rows)
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$267586af-2a76-401d-8471-64ba4ed34fda$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$company.created$paperclip$, $paperclip$company$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, NULL, $paperclip${"name":"Zaaka"}$paperclip$, $paperclip$2026-04-11T21:01:00.336Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$71afb0ea-6a03-4e5f-bd8a-9d16f287d10c$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.created$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"name":"Chulo(CEO)","role":"ceo","desiredSkills":null}$paperclip$, $paperclip$2026-04-11T21:01:48.980Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$cc570096-a481-4373-8e20-c85bb06cd503$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$project.created$paperclip$, $paperclip$project$paperclip$, $paperclip$15e44c3d-527b-4d86-90f8-04d926928a3a$paperclip$, NULL, $paperclip${"name":"Onboarding","workspaceId":null}$paperclip$, $paperclip$2026-04-11T21:01:51.692Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$639b5627-dab5-4e5d-9d7a-8284a4bfd581$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$issue.created$paperclip$, $paperclip$issue$paperclip$, $paperclip$1fb189f4-9819-4177-94e2-9f08c0e37091$paperclip$, NULL, $paperclip${"title":"Hire your first engineer and create a hiring plan","identifier":"ZAA-1"}$paperclip$, $paperclip$2026-04-11T21:01:51.931Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$a0bb05d4-942e-4439-b897-eb25a59b9f75$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$1fb189f4-9819-4177-94e2-9f08c0e37091$paperclip$, NULL, $paperclip${"userId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","lastReadAt":"2026-04-11T21:01:53.439Z"}$paperclip$, $paperclip$2026-04-11T21:01:53.442Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$218e41e8-dabb-4789-9b52-d56dd65c5bf1$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$budget.policy_upserted$paperclip$, $paperclip$budget_policy$paperclip$, $paperclip$a24ef3e5-a469-4249-823f-82ea272c7b09$paperclip$, NULL, $paperclip${"amount":15000,"scopeId":"2b72e8ff-73f4-40fa-a123-960faf668d7c","scopeType":"agent","windowKind":"calendar_month_utc"}$paperclip$, $paperclip$2026-04-11T21:02:27.371Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$134b188e-a57a-4430-a176-49320d20a294$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.runtime_session_reset$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"taskKey":null}$paperclip$, $paperclip$2026-04-12T07:09:30.180Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$e6ff1849-1778-432e-9891-3b472ab84c75$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$7e34f986-b2a4-4efb-a55b-4ee19d90fdae$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:14:21.006Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$162d8920-d203-4057-8541-ded5c6db0e02$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$167227db-1c47-475e-b79f-38497f2ca7e4$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:19:22.379Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$5651ff4b-ab20-4fe8-9649-f80e40568c24$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$0df2efa0-14d9-4463-a543-49696a9c5b67$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:20:45.750Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$31bc363d-8191-4527-8e42-767e3ea9a47d$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$b4396483-417d-4db6-9768-dd0f6250d1f0$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:22:58.222Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$0a189fa5-4438-45a0-9235-2642017ed84a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$f8633c11-19aa-41ac-835a-8241c6eabbd8$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:24:01.025Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$582a1532-299e-4b43-bd4d-bb66b5056cea$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$6adbc3ee-6369-4799-be0d-e3ce862fd4e0$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:24:09.743Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$2fc414d3-2639-41d1-b712-926384e4cef7$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$e78eb643-0eff-488f-997c-3430fc2a15ca$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:26:52.665Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$3c4f802f-6e7a-486e-9eba-83f0d4022dfa$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$f2c16036-7175-40c1-9402-2b7f15f96f7b$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:28:16.282Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$f6b479bb-961e-441b-92a4-3a6867ee4644$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$2875d489-aae7-472f-924f-797280f06b6e$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:28:29.411Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$e2a7c2c0-493a-460f-a449-0610a6da9137$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$11a73508-baac-4c65-aaa7-682f22662eb7$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:29:29.133Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$9ec7bb75-d731-48a9-86a2-38d91afc3225$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$8240f42d-fbca-4fa2-9fa4-6d4927bfd289$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:32:17.745Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$47a47aa6-d0e0-4267-a810-01684beafa11$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$a7ae4206-a3ec-4053-8835-007a22f6ffbc$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:34:05.273Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$e3bde8d6-2c01-4561-9115-bfc0bee24355$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$c2cb04d3-a8be-4c70-8878-3514dd9d43a2$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:35:10.145Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$0b23c918-9850-4725-aff7-6ee7cd647579$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$c7df6b60-74b8-438f-a758-556454680861$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:35:19.812Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$871f92dc-b857-4cbc-83a8-15cf696f4c99$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$project.created$paperclip$, $paperclip$project$paperclip$, $paperclip$6242380a-94c5-4fdf-b9a3-ae9fb6e8c920$paperclip$, NULL, $paperclip${"name":"EternalGuard","workspaceId":null}$paperclip$, $paperclip$2026-04-12T07:40:50.446Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$1df6ddc1-838e-43be-89c6-72208c570f7b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$da80c1c0-e9e4-42eb-8722-6d97fb0c3dbf$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:42:28.901Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$b2fbd004-0a4a-4936-a848-79338b3bc2b8$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$issue.created$paperclip$, $paperclip$issue$paperclip$, $paperclip$203f56e9-315c-4946-a0c0-8e0f40b89a58$paperclip$, NULL, $paperclip${"title":"Hire Full Stack Dev agent","identifier":"ZAA-2"}$paperclip$, $paperclip$2026-04-12T07:43:51.513Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$bd0f2a13-04cd-448a-9f00-4e85e9bb9c40$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$203f56e9-315c-4946-a0c0-8e0f40b89a58$paperclip$, NULL, $paperclip${"userId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","lastReadAt":"2026-04-12T07:46:28.143Z"}$paperclip$, $paperclip$2026-04-12T07:46:28.160Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$198754af-c264-4c91-b402-da1df3bd2f89$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$1fb189f4-9819-4177-94e2-9f08c0e37091$paperclip$, NULL, $paperclip${"userId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","lastReadAt":"2026-04-12T07:46:53.548Z"}$paperclip$, $paperclip$2026-04-12T07:46:53.550Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$9c2ff46e-5b91-4e54-9e2a-2fd44436bbe3$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$issue.updated$paperclip$, $paperclip$issue$paperclip$, $paperclip$1fb189f4-9819-4177-94e2-9f08c0e37091$paperclip$, NULL, $paperclip${"hiddenAt":"2026-04-12T07:47:15.627Z","_previous":{"hiddenAt":null},"identifier":"ZAA-1"}$paperclip$, $paperclip$2026-04-12T07:47:15.189Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$242dd966-c411-4b17-8d87-e64bff1458f9$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$issue.read_marked$paperclip$, $paperclip$issue$paperclip$, $paperclip$203f56e9-315c-4946-a0c0-8e0f40b89a58$paperclip$, NULL, $paperclip${"userId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","lastReadAt":"2026-04-12T07:47:20.582Z"}$paperclip$, $paperclip$2026-04-12T07:47:20.585Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$445d1302-6687-4fb2-b23b-d34e2ecd05d6$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.paused$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, NULL, $paperclip$2026-04-12T07:48:07.813Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$52c9b505-caa2-4505-b00e-8eff9d59192c$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.resumed$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, NULL, $paperclip$2026-04-12T07:48:09.480Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$b4fb91c5-6b39-4ada-af1a-092e66eb29bc$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$6f924eeb-25ca-4f77-bed1-2d6f4ff06744$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:48:14.210Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$bda2384e-48ba-4dc8-8d5f-1127c83a84c8$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$issue.inbox_archived$paperclip$, $paperclip$issue$paperclip$, $paperclip$203f56e9-315c-4946-a0c0-8e0f40b89a58$paperclip$, NULL, $paperclip${"userId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","archivedAt":"2026-04-12T07:49:58.993Z"}$paperclip$, $paperclip$2026-04-12T07:49:58.998Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$8e255cdb-2007-4b54-89c8-88e38ff6d6f7$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$a6fa23be-eb87-426a-b8f0-23186ca42094$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:51:08.117Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$100d8d5b-fd4a-4037-b6ae-002dc1bfbfd5$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$9c59ceb9-e27f-40e2-a80c-afd017e1f4cc$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T07:53:42.186Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$ef8b3c87-8dd5-47d3-85ef-57222b0df41b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig","adapterType"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","search","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:25:14.982Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$7799eaeb-1a95-4680-8107-65de783c6e47$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","extraArgs","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","search","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:32:32.405Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$9c4d3705-9cc9-4278-97e1-7e6dc96be936$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","extraArgs","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","search","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:34:37.091Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$67b389bc-fd62-4779-81ab-aef38c9c2864$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","extraArgs","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","search","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:35:47.932Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$56bdb7ba-cb5d-49e0-a23c-9abe7ec82e28$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","extraArgs","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","search","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:36:00.796Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$407f3afa-dca5-4776-a9a3-10e995ab1bc0$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","extraArgs","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","search","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:36:27.338Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$3b3773ec-d4c8-4b67-ac9c-46ac349c8092$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig","adapterType"],"changedAdapterConfigKeys":["effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:36:58.589Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$18d8b07a-eeb8-4b37-8152-24903c8f3515$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig","adapterType"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:37:11.397Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$abd034f0-d681-4d82-9c56-dfa6af802907$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:38:55.713Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$039f4931-eb6d-4595-ae68-e7f95303aa96$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:39:20.044Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$7be1ce7b-6fca-4939-a3a9-de42714ca576$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","extraArgs","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:51:44.622Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$9bda516a-9c87-4eda-91b1-7db824dc981d$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","extraArgs","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T09:54:17.043Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$dc9b3d77-b2e8-43d0-9b74-edc770f95623$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","extraArgs","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T10:56:17.639Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$dc8cd144-5d93-4ba6-aef0-0457a573c58d$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","extraArgs","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T11:02:10.635Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$d415fc99-8690-4fd9-8b57-e1f1735ec096$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig","adapterType"],"changedAdapterConfigKeys":["effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T11:02:26.650Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$d1b818d6-220b-4398-af62-0a683436f3bf$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig","adapterType"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T11:02:34.708Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$0c219277-aa96-4338-a746-6cf63248514e$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig","adapterType"],"changedAdapterConfigKeys":["effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T11:02:42.617Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$51f03e59-1715-4bb7-81e2-a8257349a534$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig","adapterType"],"changedAdapterConfigKeys":["dangerouslyBypassApprovalsAndSandbox","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T11:02:53.946Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$6a6c25cd-91ab-4b0e-873e-8adbb71ef86a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig","adapterType"],"changedAdapterConfigKeys":["effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T11:57:14.019Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$7c5cdd58-a0db-477b-8c2f-6c7a19dc23d1$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:00:27.176Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$933342ea-8155-40f2-bc9b-312fbe7f4642$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:04:09.764Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$e1604591-4366-4929-9873-54e859b4d9aa$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:04:50.448Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$8aa7399b-82d6-4efe-9629-97f6845cc432$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:05:36.796Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$e23082ef-659d-4812-99a9-49c09f9462e9$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:14:48.793Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$45fa4757-04e4-452f-b4d8-88d9cbf2dd05$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$7045eef0-61bd-4fb1-a8ed-edd95c8c0558$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:16:45.145Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$2f2b8969-0341-41e1-a669-65bdd2251b89$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:20:18.984Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$72ceedc5-dcfa-4e7a-b02a-b3c1ccd78973$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$cb2e7ba3-166f-41da-9106-641b349880d8$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:20:24.303Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$861e850a-0727-443f-8245-73f7a18b78dc$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:21:54.421Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$02ee824e-dd68-4407-aced-782a9fbf08a2$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$84a851eb-efb4-4ccc-9eb8-9f443a64e1ab$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:22:45.878Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4bbf1398-1afa-4b55-9ac1-9662059f25bc$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:23:39.771Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$fe11a47a-a9ad-4ed2-a851-365be11b06a4$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:24:34.553Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$204aedfe-8d38-49f2-8dab-52bc545870dd$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$d672bebe-2543-4597-a268-913c27bc0e0f$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:24:53.729Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$901588e3-22bf-49ba-a278-625410bf8bea$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:27:33.248Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$efccf044-ddc7-460c-8bf4-d3c9abce352b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$2285a812-43c5-49f5-ae18-e2b21a01e1fe$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:37:51.459Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$090b34d7-04fb-4903-9299-27a2eefbeb31$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:28:24.215Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$977173ae-2d48-4d50-82a9-b34634d7e5c2$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$5eaf2c55-0e04-49ca-86a8-f977730bb3c6$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:32:21.608Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$2032fcd5-27f7-4cc7-af2c-89d8b99f4c92$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:28:32.304Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$8a14e566-44a8-40b3-adae-41244be0066c$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$d29ce65f-0a4d-4d99-906a-db1f25750e29$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:37:24.815Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$140860b2-a95f-4d95-86ba-927353f4a459$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:28:44.075Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$5757ae9a-172f-484e-bbd7-9251a6dcbca7$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$348a1162-d807-4318-93e6-6a45082a3033$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:31:18.044Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$d25217e2-ec31-45f9-ae98-2878abd8930b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$e107e9d4-7e38-4cb8-b19e-80803dcf37af$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:33:25.069Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$fa7fa042-5fda-4ec5-a8dc-a4ff27fc050b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$902baa9c-94a0-427f-ad0e-92086c16f3db$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:38:02.720Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$00ac5fa3-08d8-48cc-afbd-cfc86e17aa67$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$09d318dc-189d-4b08-a19c-c9249f461dc8$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:42:29.887Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$da408adc-9f11-40ce-9702-1e275047ccc0$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:42:50.311Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$b7b3cb51-5f34-4f63-bacd-a8236c050ed5$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$3734032c-bf64-414b-8678-39a701c5a6ea$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:42:55.260Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$4c11d226-9b39-4b01-92c3-5701f088ac33$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$agent.updated$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip${"changedTopLevelKeys":["adapterConfig"],"changedAdapterConfigKeys":["command","effort","env","graceSec","instructionsBundleMode","instructionsEntryFile","instructionsFilePath","instructionsRootPath","mode","model","modelReasoningEffort","timeoutSec","variant"]}$paperclip$, $paperclip$2026-04-12T12:45:55.845Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."activity_log" ("id", "company_id", "actor_type", "actor_id", "action", "entity_type", "entity_id", "agent_id", "details", "created_at", "run_id") VALUES ($paperclip$d0cf15fd-e407-4cf0-a039-2cbfa174ba65$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$heartbeat.invoked$paperclip$, $paperclip$heartbeat_run$paperclip$, $paperclip$9aceaafc-1f19-411e-986e-7ab3e763ad4a$paperclip$, NULL, $paperclip${"agentId":"2b72e8ff-73f4-40fa-a123-960faf668d7c"}$paperclip$, $paperclip$2026-04-12T12:46:16.088Z$paperclip$, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.agent_config_revisions (26 rows)
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$bbb92ad1-9288-4309-9422-860d7596d6b9$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"model":"gpt-5.3-codex","search":false,"graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","search":false,"variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T09:25:14.980Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$9a6fe55e-a5b9-41d6-bc6d-a712e85a0255$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","search":false,"variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","search":false,"variant":"","graceSec":15,"extraArgs":["--offline"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T09:32:32.404Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$17815fe1-e6a7-4948-8814-4fc1d3392e01$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","search":false,"variant":"","graceSec":15,"extraArgs":["--offline"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","search":false,"variant":"","graceSec":15,"extraArgs":["--offline"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T09:34:37.089Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$bb7b3f94-9243-4dc7-9411-79f476bcadc5$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","search":false,"variant":"","graceSec":15,"extraArgs":["--offline"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","search":false,"variant":"","graceSec":15,"extraArgs":["--offline"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":false},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T09:36:27.336Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$92b10ce3-a7e1-4047-9a45-082147a12d8f$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterType","adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","search":false,"variant":"","graceSec":15,"extraArgs":["--offline"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":false},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"claude_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T09:36:58.587Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$a9bd308b-0faf-43ce-b9c0-356d74498e4a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterType","adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"gemini_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"auto","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T11:02:42.615Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$ee6df3b2-5a36-462a-8aad-ff1e9fd85ae4$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterType","adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"claude_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T09:37:11.394Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$0192adb7-fc78-4003-8af3-35712a66a12b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T09:38:55.711Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$8a6e919a-a39a-4410-8c7f-2822fb5678e1$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"CODEX_PROTOCOL":{"type":"plain","value":"rest"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T09:39:20.043Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$722c1de4-8ef3-4d1d-a8d8-243196e31d1c$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"CODEX_PROTOCOL":{"type":"plain","value":"rest"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"CODEX_PROTOCOL":{"type":"plain","value":"rest"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"extraArgs":["--config /root/.codex/config.toml"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T09:51:44.620Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$aa704e82-b48a-4bca-ad95-7314537bb9c7$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"CODEX_PROTOCOL":{"type":"plain","value":"rest"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"extraArgs":["--config /root/.codex/config.toml"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"CODEX_PROTOCOL":{"type":"plain","value":"rest"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434"},"CODEX_SKIP_PATH_UPDATE":{"type":"plain","value":"true"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"extraArgs":["--config /root/.codex/config.toml"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T09:54:17.041Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$6b3cf94c-28c8-4951-9f4a-c6ceb32a145a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"CODEX_OFFLINE":{"type":"plain","value":"true"},"CODEX_PROTOCOL":{"type":"plain","value":"rest"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:11434"},"CODEX_SKIP_PATH_UPDATE":{"type":"plain","value":"true"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"extraArgs":["--config /root/.codex/config.toml"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"extraArgs":["--config /root/.codex/config.toml"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T10:56:17.636Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$9a800d1d-82c9-4ae3-a5cd-a0ed9a3ff441$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterType","adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"extraArgs":["--config /root/.codex/config.toml"],"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"claude_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T11:02:26.648Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$f2980850-924e-4cd5-95b8-a7ed1e698db3$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterType","adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"claude_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T11:02:34.706Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$8f05e473-ab99-4b50-94b9-7d8d208d0892$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterType","adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"gemini_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"auto","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T11:02:53.944Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$76329d25-a9dd-4acc-9687-14059f4c9abc$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterType","adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"codex_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-5.3-codex","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed","dangerouslyBypassApprovalsAndSandbox":true},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T11:57:14.017Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$8efc0f2d-4da3-4d10-a0fe-0672eba00fe3$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"","effort":"","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"/usr/local/bin/hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T12:00:27.175Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$b6d4acc5-45d6-407d-ac8d-0540ddda1c02$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"/usr/local/bin/hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"},"HERMES_CONFIG_PATH":{"type":"plain","value":"/opt/hermes/config.yaml"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"/usr/local/bin/hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T12:04:09.762Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$433ee553-95b3-4236-9821-fd78b5d50df8$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"},"HERMES_CONFIG_PATH":{"type":"plain","value":"/opt/hermes/config.yaml"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"/usr/local/bin/hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"/usr/local/bin/hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T12:04:50.446Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$cb385d14-ab9b-4e07-a804-ca7acf7e312d$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"/usr/local/bin/hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"},"HERMES_CONFIG_PATH":{"type":"plain","value":"/opt/hermes/config.yaml"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"/usr/local/bin/hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T12:05:36.794Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$722b62a3-5533-40e7-8b95-18fe09cc4619$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"},"HERMES_CONFIG_PATH":{"type":"plain","value":"/opt/hermes/config.yaml"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"/usr/local/bin/hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"},"HERMES_CONFIG_PATH":{"type":"plain","value":"/opt/hermes/config.yaml"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T12:14:48.791Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$267b589d-38aa-4367-be0c-cc63cbf8a894$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"},"HERMES_CONFIG_PATH":{"type":"plain","value":"/opt/hermes/config.yaml"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"},"HERMES_CONFIG_PATH":{"type":"plain","value":"/opt/hermes/config.yaml"},"HERMES_PROJECT_ROOT":{"type":"plain","value":"/opt/hermes"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T12:20:18.982Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$e4bba756-9ef4-4e06-b9f7-79b615015556$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"},"HERMES_CONFIG_PATH":{"type":"plain","value":"/opt/hermes/config.yaml"},"HERMES_PROJECT_ROOT":{"type":"plain","value":"/opt/hermes"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"HOME":{"type":"plain","value":"/tmp"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"},"HERMES_CONFIG_PATH":{"type":"plain","value":"/opt/hermes/config.yaml"},"HERMES_PROJECT_ROOT":{"type":"plain","value":"/opt/hermes"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T12:21:54.420Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$1df032e1-01b7-4a92-b2ac-e584c3282f9d$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"HOME":{"type":"plain","value":"/tmp"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"},"HERMES_CONFIG_PATH":{"type":"plain","value":"/opt/hermes/config.yaml"},"HERMES_PROJECT_ROOT":{"type":"plain","value":"/opt/hermes"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"HOME":{"type":"plain","value":"/tmp"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T12:23:39.769Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$78f678d5-581e-4922-b961-be7c3693ad8b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"HOME":{"type":"plain","value":"/tmp"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"HOME":{"type":"plain","value":"/tmp/hermes_home"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T12:24:34.551Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_config_revisions" ("id", "company_id", "agent_id", "created_by_agent_id", "created_by_user_id", "source", "rolled_back_from_revision_id", "changed_keys", "before_config", "after_config", "created_at") VALUES ($paperclip$539cb4b8-72ca-436c-abb3-a6d6ddeb7f57$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$patch$paperclip$, NULL, $paperclip$["adapterConfig"]$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"HOME":{"type":"plain","value":"/tmp/hermes_home"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-3.5-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip${"name":"Chulo(CEO)","role":"ceo","title":null,"metadata":null,"reportsTo":null,"adapterType":"hermes_local","capabilities":null,"adapterConfig":{"env":{"HOME":{"type":"plain","value":"/tmp/hermes_home"},"OPENAI_API_KEY":{"type":"plain","value":"***REDACTED***"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-4-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"},"runtimeConfig":{"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}},"budgetMonthlyCents":15000}$paperclip$, $paperclip$2026-04-12T12:45:55.843Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.agent_runtime_state (1 rows)
INSERT INTO "public"."agent_runtime_state" ("agent_id", "company_id", "adapter_type", "session_id", "state_json", "last_run_id", "last_run_status", "total_input_tokens", "total_output_tokens", "total_cached_input_tokens", "total_cost_cents", "last_error", "created_at", "updated_at") VALUES ($paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$hermes_local$paperclip$, NULL, $paperclip${}$paperclip$, $paperclip$3a1cb5d4-d4cf-464c-af04-041370ac8eec$paperclip$, $paperclip$failed$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, $paperclip$0$paperclip$, NULL, $paperclip$2026-04-11T21:01:51.956Z$paperclip$, $paperclip$2026-04-13T06:55:03.905Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.agent_task_sessions (1 rows)
INSERT INTO "public"."agent_task_sessions" ("id", "company_id", "agent_id", "adapter_type", "task_key", "session_params_json", "session_display_id", "last_run_id", "last_error", "created_at", "updated_at") VALUES ($paperclip$f8bfe277-7245-4564-bd32-2eeaa231642d$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$codex_local$paperclip$, $paperclip$__heartbeat__$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","sessionId":"019d80e5-972f-79d3-ba57-960a9a1bd8c4"}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$c3dcf50a-5978-42d7-856a-e69699f1aaf6$paperclip$, $paperclip$unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b4c2df54da6-FRA, request id: req_5a6ada486dfc4bdf9c8de35edde4a3b4$paperclip$, $paperclip$2026-04-12T08:54:13.969Z$paperclip$, $paperclip$2026-04-12T11:55:48.712Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.agent_wakeup_requests (65 rows)
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$500a7c43-7e18-4171-b1eb-8d4926baac95$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$assignment$paperclip$, $paperclip$system$paperclip$, $paperclip$issue_assigned$paperclip$, $paperclip${"issueId":"1fb189f4-9819-4177-94e2-9f08c0e37091","mutation":"create"}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$ae7bde7c-7cfa-47fa-ba42-770f6f131fa7$paperclip$, $paperclip$2026-04-11T21:01:51.939Z$paperclip$, $paperclip$2026-04-11T21:01:51.951Z$paperclip$, $paperclip$2026-04-11T21:01:52.068Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-11T21:01:51.939Z$paperclip$, $paperclip$2026-04-11T21:01:52.068Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$59d8e3b2-888d-4cb7-a429-2fa04ab2b9c2$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$f9e10ce7-16e6-4b0b-943d-5fbe8cb98d93$paperclip$, $paperclip$2026-04-12T05:02:12.056Z$paperclip$, $paperclip$2026-04-12T05:02:12.064Z$paperclip$, $paperclip$2026-04-12T05:02:12.096Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T05:02:12.056Z$paperclip$, $paperclip$2026-04-12T05:02:12.096Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$227ae65e-bcc5-4701-b45c-581f0eb6f569$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$068cbe93-6ca9-4ac6-bc7e-f6842acf2bb5$paperclip$, $paperclip$2026-04-11T22:02:10.578Z$paperclip$, $paperclip$2026-04-11T22:02:10.588Z$paperclip$, $paperclip$2026-04-11T22:02:10.625Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-11T22:02:10.578Z$paperclip$, $paperclip$2026-04-11T22:02:10.625Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$f57cc3db-2a35-4d5d-9d68-d7fdb500707e$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$b5e60724-3d95-4a41-8657-f0bdf08c080b$paperclip$, $paperclip$2026-04-11T23:02:10.753Z$paperclip$, $paperclip$2026-04-11T23:02:10.760Z$paperclip$, $paperclip$2026-04-11T23:02:10.831Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-11T23:02:10.753Z$paperclip$, $paperclip$2026-04-11T23:02:10.831Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$68436e1d-6a77-4d81-bb20-b6e3ed9292a9$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$2942e9bc-c9a1-46db-b6db-b86b555f52f3$paperclip$, $paperclip$2026-04-12T00:02:10.944Z$paperclip$, $paperclip$2026-04-12T00:02:10.954Z$paperclip$, $paperclip$2026-04-12T00:02:10.989Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T00:02:10.944Z$paperclip$, $paperclip$2026-04-12T00:02:10.989Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$732c2044-c257-4cc2-97e9-aecfaceaefc6$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$75d830b8-bb81-4284-8f7e-09d0350f326f$paperclip$, $paperclip$2026-04-12T01:02:11.195Z$paperclip$, $paperclip$2026-04-12T01:02:11.207Z$paperclip$, $paperclip$2026-04-12T01:02:11.233Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T01:02:11.195Z$paperclip$, $paperclip$2026-04-12T01:02:11.233Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$66a22eed-6530-4a30-a133-493d298edbd4$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$ded7f8c5-eb3e-4e33-b85f-bc466d906692$paperclip$, $paperclip$2026-04-12T06:02:12.309Z$paperclip$, $paperclip$2026-04-12T06:02:12.316Z$paperclip$, $paperclip$2026-04-12T06:02:12.341Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T06:02:12.309Z$paperclip$, $paperclip$2026-04-12T06:02:12.341Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$c7c28a7d-a946-4848-a5ba-bf0240e4ffff$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$7b89525a-c54d-449f-be7a-4e606a7d1140$paperclip$, $paperclip$2026-04-12T02:02:11.385Z$paperclip$, $paperclip$2026-04-12T02:02:11.393Z$paperclip$, $paperclip$2026-04-12T02:02:11.421Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T02:02:11.385Z$paperclip$, $paperclip$2026-04-12T02:02:11.421Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$ad56dc45-dfe8-4a21-8945-a189297a4e45$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$134f4a81-1ceb-42bb-867e-24aeeac50717$paperclip$, $paperclip$2026-04-12T03:02:11.619Z$paperclip$, $paperclip$2026-04-12T03:02:11.628Z$paperclip$, $paperclip$2026-04-12T03:02:11.659Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T03:02:11.619Z$paperclip$, $paperclip$2026-04-12T03:02:11.659Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$798a3c04-8805-4974-a3d1-f9f947beb0d9$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$b4396483-417d-4db6-9768-dd0f6250d1f0$paperclip$, $paperclip$2026-04-12T07:22:58.203Z$paperclip$, $paperclip$2026-04-12T07:22:58.217Z$paperclip$, $paperclip$2026-04-12T07:22:58.270Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T07:22:58.203Z$paperclip$, $paperclip$2026-04-12T07:22:58.270Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$2fdca7a9-f515-4f5a-88aa-735e6bfb5069$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$adc9ca5c-fc89-4508-a007-21feae9701e6$paperclip$, $paperclip$2026-04-12T04:02:11.857Z$paperclip$, $paperclip$2026-04-12T04:02:11.899Z$paperclip$, $paperclip$2026-04-12T04:02:11.936Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T04:02:11.857Z$paperclip$, $paperclip$2026-04-12T04:02:11.936Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$2691fbce-c1ca-4768-9941-56f91864a724$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$650b51e5-1746-4030-b05b-df7d3e6e2006$paperclip$, $paperclip$2026-04-12T07:02:12.549Z$paperclip$, $paperclip$2026-04-12T07:02:12.558Z$paperclip$, $paperclip$2026-04-12T07:02:12.649Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T07:02:12.549Z$paperclip$, $paperclip$2026-04-12T07:02:12.649Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$2e309aa8-2538-48c2-94a5-c2b3f521cd6a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$7e34f986-b2a4-4efb-a55b-4ee19d90fdae$paperclip$, $paperclip$2026-04-12T07:14:20.994Z$paperclip$, $paperclip$2026-04-12T07:14:21.003Z$paperclip$, $paperclip$2026-04-12T07:14:21.043Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T07:14:20.994Z$paperclip$, $paperclip$2026-04-12T07:14:21.043Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$22c835a4-ad4c-485c-9108-edbfe19c9259$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$167227db-1c47-475e-b79f-38497f2ca7e4$paperclip$, $paperclip$2026-04-12T07:19:22.363Z$paperclip$, $paperclip$2026-04-12T07:19:22.374Z$paperclip$, $paperclip$2026-04-12T07:19:22.418Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T07:19:22.363Z$paperclip$, $paperclip$2026-04-12T07:19:22.418Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$f03100d6-78f9-4f0c-8d41-0468b6d4eabe$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$f8633c11-19aa-41ac-835a-8241c6eabbd8$paperclip$, $paperclip$2026-04-12T07:24:01.006Z$paperclip$, $paperclip$2026-04-12T07:24:01.019Z$paperclip$, $paperclip$2026-04-12T07:24:01.119Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T07:24:01.006Z$paperclip$, $paperclip$2026-04-12T07:24:01.119Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$14ea63c0-56e3-4f6a-9fa2-f7cfd2dd3d83$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$0df2efa0-14d9-4463-a543-49696a9c5b67$paperclip$, $paperclip$2026-04-12T07:20:45.728Z$paperclip$, $paperclip$2026-04-12T07:20:45.745Z$paperclip$, $paperclip$2026-04-12T07:20:45.799Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T07:20:45.728Z$paperclip$, $paperclip$2026-04-12T07:20:45.799Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$1cecae83-2802-4a78-9c6f-9e71095df4e0$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$f2c16036-7175-40c1-9402-2b7f15f96f7b$paperclip$, $paperclip$2026-04-12T07:28:16.265Z$paperclip$, $paperclip$2026-04-12T07:28:16.277Z$paperclip$, $paperclip$2026-04-12T07:28:16.422Z$paperclip$, $paperclip$Error loading config.toml: invalid type: map, expected a string$paperclip$, $paperclip$2026-04-12T07:28:16.265Z$paperclip$, $paperclip$2026-04-12T07:28:16.422Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$fc8544c7-97f8-458c-93d6-be1f3d7ec202$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$6adbc3ee-6369-4799-be0d-e3ce862fd4e0$paperclip$, $paperclip$2026-04-12T07:24:09.728Z$paperclip$, $paperclip$2026-04-12T07:24:09.740Z$paperclip$, $paperclip$2026-04-12T07:24:09.771Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, $paperclip$2026-04-12T07:24:09.728Z$paperclip$, $paperclip$2026-04-12T07:24:09.771Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$2e015a5a-e1d4-4809-8717-0e27d9feff4e$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$e78eb643-0eff-488f-997c-3430fc2a15ca$paperclip$, $paperclip$2026-04-12T07:26:52.648Z$paperclip$, $paperclip$2026-04-12T07:26:52.659Z$paperclip$, $paperclip$2026-04-12T07:26:52.770Z$paperclip$, $paperclip$Error loading config.toml: invalid type: map, expected a string$paperclip$, $paperclip$2026-04-12T07:26:52.648Z$paperclip$, $paperclip$2026-04-12T07:26:52.770Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$60aa59c8-e953-4aeb-9b32-4f028e4d409b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$2875d489-aae7-472f-924f-797280f06b6e$paperclip$, $paperclip$2026-04-12T07:28:29.400Z$paperclip$, $paperclip$2026-04-12T07:28:29.408Z$paperclip$, $paperclip$2026-04-12T07:28:29.485Z$paperclip$, $paperclip$Error loading config.toml: invalid type: map, expected a string$paperclip$, $paperclip$2026-04-12T07:28:29.400Z$paperclip$, $paperclip$2026-04-12T07:28:29.485Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$f46e118f-06f1-4ed3-9173-7f380a928449$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$8240f42d-fbca-4fa2-9fa4-6d4927bfd289$paperclip$, $paperclip$2026-04-12T07:32:17.726Z$paperclip$, $paperclip$2026-04-12T07:32:17.739Z$paperclip$, $paperclip$2026-04-12T07:32:48.832Z$paperclip$, $paperclip$stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)$paperclip$, $paperclip$2026-04-12T07:32:17.726Z$paperclip$, $paperclip$2026-04-12T07:32:48.832Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$7262af42-2cfc-418a-9753-7a1eabd42c26$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$11a73508-baac-4c65-aaa7-682f22662eb7$paperclip$, $paperclip$2026-04-12T07:29:29.111Z$paperclip$, $paperclip$2026-04-12T07:29:29.126Z$paperclip$, $paperclip$2026-04-12T07:29:45.505Z$paperclip$, $paperclip$unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0859238ed3410-FRA, request id: req_9491ef35dbc546e9a426f4a194b8b140$paperclip$, $paperclip$2026-04-12T07:29:29.111Z$paperclip$, $paperclip$2026-04-12T07:29:45.505Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$454b61a5-131d-46be-8bfd-ab504f1cf1bd$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$c2cb04d3-a8be-4c70-8878-3514dd9d43a2$paperclip$, $paperclip$2026-04-12T07:35:10.125Z$paperclip$, $paperclip$2026-04-12T07:35:10.139Z$paperclip$, $paperclip$2026-04-12T07:35:10.305Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$2026-04-12T07:35:10.125Z$paperclip$, $paperclip$2026-04-12T07:35:10.305Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$c0a65fd3-d8b9-409b-a61b-2a93f46de82b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$a7ae4206-a3ec-4053-8835-007a22f6ffbc$paperclip$, $paperclip$2026-04-12T07:34:05.250Z$paperclip$, $paperclip$2026-04-12T07:34:05.268Z$paperclip$, $paperclip$2026-04-12T07:34:05.451Z$paperclip$, $paperclip$2026-04-12T07:34:05.418767Z ERROR codex_rollout::list: state db returned stale rollout path for thread 019d8098-78cb-7960-8c41-c2c2cdb3b812: /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/sessions/2026/04/12/rollout-2026-04-12T07-29-29-019d8098-78cb-7960-8c41-c2c2cdb3b812.jsonl$paperclip$, $paperclip$2026-04-12T07:34:05.250Z$paperclip$, $paperclip$2026-04-12T07:34:05.451Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$0ebe9bdc-e1aa-41e9-8668-c8a5518dd0a9$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$c7df6b60-74b8-438f-a758-556454680861$paperclip$, $paperclip$2026-04-12T07:35:19.800Z$paperclip$, $paperclip$2026-04-12T07:35:19.809Z$paperclip$, $paperclip$2026-04-12T07:35:19.948Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$2026-04-12T07:35:19.800Z$paperclip$, $paperclip$2026-04-12T07:35:19.948Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$3bcb7917-66f0-4b1d-b5d4-54cf48465ce9$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$da80c1c0-e9e4-42eb-8722-6d97fb0c3dbf$paperclip$, $paperclip$2026-04-12T07:42:28.874Z$paperclip$, $paperclip$2026-04-12T07:42:28.891Z$paperclip$, $paperclip$2026-04-12T07:42:29.064Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$2026-04-12T07:42:28.874Z$paperclip$, $paperclip$2026-04-12T07:42:29.064Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$a090f6e9-e60a-40a7-a586-fc2c6fe2ebff$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$9c59ceb9-e27f-40e2-a80c-afd017e1f4cc$paperclip$, $paperclip$2026-04-12T07:53:42.169Z$paperclip$, $paperclip$2026-04-12T07:53:42.180Z$paperclip$, $paperclip$2026-04-12T07:53:42.344Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$2026-04-12T07:53:42.169Z$paperclip$, $paperclip$2026-04-12T07:53:42.344Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$a39402aa-9123-4981-9d4f-167ce5868982$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$6f924eeb-25ca-4f77-bed1-2d6f4ff06744$paperclip$, $paperclip$2026-04-12T07:48:14.198Z$paperclip$, $paperclip$2026-04-12T07:48:14.207Z$paperclip$, $paperclip$2026-04-12T07:48:14.348Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$2026-04-12T07:48:14.198Z$paperclip$, $paperclip$2026-04-12T07:48:14.348Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$8fc1c05c-abc1-49f6-bbc8-097575317579$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$coalesced$paperclip$, 1, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$b475626d-ac07-4ccf-a587-647186180b93$paperclip$, $paperclip$2026-04-12T08:54:13.182Z$paperclip$, NULL, $paperclip$2026-04-12T08:54:13.182Z$paperclip$, NULL, $paperclip$2026-04-12T08:54:13.182Z$paperclip$, $paperclip$2026-04-12T08:54:13.182Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$74851d51-e911-42c5-9592-831d860c1bdf$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$a6fa23be-eb87-426a-b8f0-23186ca42094$paperclip$, $paperclip$2026-04-12T07:51:08.104Z$paperclip$, $paperclip$2026-04-12T07:51:08.113Z$paperclip$, $paperclip$2026-04-12T07:51:08.255Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$2026-04-12T07:51:08.104Z$paperclip$, $paperclip$2026-04-12T07:51:08.255Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$11aafbd8-8773-40a5-a286-1b3fb5fd6cdb$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$b475626d-ac07-4ccf-a587-647186180b93$paperclip$, $paperclip$2026-04-12T08:53:43.180Z$paperclip$, $paperclip$2026-04-12T08:53:43.192Z$paperclip$, $paperclip$2026-04-12T08:54:13.961Z$paperclip$, $paperclip$stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)$paperclip$, $paperclip$2026-04-12T08:53:43.180Z$paperclip$, $paperclip$2026-04-12T08:54:13.961Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$8762f266-cbc1-4be4-ad11-7ef5e4f7ff04$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$4d3b607f-4cea-415d-9e23-21dd3cee54b1$paperclip$, $paperclip$2026-04-12T09:54:58.332Z$paperclip$, $paperclip$2026-04-12T09:54:58.353Z$paperclip$, $paperclip$2026-04-12T09:54:58.468Z$paperclip$, $paperclip$error: unexpected argument '--config /root/.codex/config.toml' found$paperclip$, $paperclip$2026-04-12T09:54:58.332Z$paperclip$, $paperclip$2026-04-12T09:54:58.468Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$47cd1f5b-f697-4cf2-a02d-ec07b6cbf01e$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$275d85c6-6730-452a-9355-5ac06295c5af$paperclip$, $paperclip$2026-04-12T10:54:58.568Z$paperclip$, $paperclip$2026-04-12T10:54:58.578Z$paperclip$, $paperclip$2026-04-12T10:54:58.728Z$paperclip$, $paperclip$error: unexpected argument '--config /root/.codex/config.toml' found$paperclip$, $paperclip$2026-04-12T10:54:58.568Z$paperclip$, $paperclip$2026-04-12T10:54:58.728Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$8885aee4-04d9-47b4-a605-26f6450b0a71$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$c3dcf50a-5978-42d7-856a-e69699f1aaf6$paperclip$, $paperclip$2026-04-12T11:55:28.731Z$paperclip$, $paperclip$2026-04-12T11:55:28.742Z$paperclip$, $paperclip$2026-04-12T11:55:48.705Z$paperclip$, $paperclip$unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b4c2df54da6-FRA, request id: req_5a6ada486dfc4bdf9c8de35edde4a3b4$paperclip$, $paperclip$2026-04-12T11:55:28.731Z$paperclip$, $paperclip$2026-04-12T11:55:48.705Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$74e81f66-d712-4621-89fb-25ffae6ee0ce$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$7045eef0-61bd-4fb1-a8ed-edd95c8c0558$paperclip$, $paperclip$2026-04-12T12:16:45.132Z$paperclip$, $paperclip$2026-04-12T12:16:45.141Z$paperclip$, $paperclip$2026-04-12T12:16:45.333Z$paperclip$, $paperclip$Traceback (most recent call last):
PermissionError: [Errno 13] Permission denied: '/root/.hermes/.env'$paperclip$, $paperclip$2026-04-12T12:16:45.132Z$paperclip$, $paperclip$2026-04-12T12:16:45.333Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$1c4104b7-a0b2-4e33-a892-cd80f16bcb23$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$cb2e7ba3-166f-41da-9106-641b349880d8$paperclip$, $paperclip$2026-04-12T12:20:24.293Z$paperclip$, $paperclip$2026-04-12T12:20:24.300Z$paperclip$, $paperclip$2026-04-12T12:20:24.486Z$paperclip$, $paperclip$Traceback (most recent call last):
PermissionError: [Errno 13] Permission denied: '/root/.hermes/.env'$paperclip$, $paperclip$2026-04-12T12:20:24.293Z$paperclip$, $paperclip$2026-04-12T12:20:24.486Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$d71e9117-ce41-473e-bec0-646be7a0f636$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$84a851eb-efb4-4ccc-9eb8-9f443a64e1ab$paperclip$, $paperclip$2026-04-12T12:22:45.870Z$paperclip$, $paperclip$2026-04-12T12:22:45.876Z$paperclip$, $paperclip$2026-04-12T12:22:46.169Z$paperclip$, $paperclip$Traceback (most recent call last):
FileNotFoundError: [Errno 2] No such file or directory: '[object Object]/.hermes'
During handling of the above exception, another exception occurred:
Traceback (most recent call last):
PermissionError: [Errno 13] Permission denied: '[object Object]'$paperclip$, $paperclip$2026-04-12T12:22:45.870Z$paperclip$, $paperclip$2026-04-12T12:22:46.169Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$da9eb920-f726-4102-a9a7-b89e759f2771$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$d672bebe-2543-4597-a268-913c27bc0e0f$paperclip$, $paperclip$2026-04-12T12:24:53.719Z$paperclip$, $paperclip$2026-04-12T12:24:53.726Z$paperclip$, $paperclip$2026-04-12T12:24:54.082Z$paperclip$, $paperclip$Traceback (most recent call last):
FileNotFoundError: [Errno 2] No such file or directory: '[object Object]/.hermes'
During handling of the above exception, another exception occurred:
Traceback (most recent call last):
PermissionError: [Errno 13] Permission denied: '[object Object]'$paperclip$, $paperclip$2026-04-12T12:24:53.719Z$paperclip$, $paperclip$2026-04-12T12:24:54.082Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$16333b33-5989-4d48-bb17-5f8c5570c46a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$d29ce65f-0a4d-4d99-906a-db1f25750e29$paperclip$, $paperclip$2026-04-12T12:37:24.775Z$paperclip$, $paperclip$2026-04-12T12:37:24.809Z$paperclip$, $paperclip$2026-04-12T12:37:26.195Z$paperclip$, NULL, $paperclip$2026-04-12T12:37:24.775Z$paperclip$, $paperclip$2026-04-12T12:37:26.195Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$3670d155-c7f4-461e-a44f-a84772deeaa4$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$348a1162-d807-4318-93e6-6a45082a3033$paperclip$, $paperclip$2026-04-12T12:31:18.035Z$paperclip$, $paperclip$2026-04-12T12:31:18.041Z$paperclip$, $paperclip$2026-04-12T12:31:18.567Z$paperclip$, $paperclip$Traceback (most recent call last):
ModuleNotFoundError: No module named 'prompt_toolkit'$paperclip$, $paperclip$2026-04-12T12:31:18.035Z$paperclip$, $paperclip$2026-04-12T12:31:18.567Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$cda46d5d-42b6-4e1e-9c75-6ba9639751e3$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$5eaf2c55-0e04-49ca-86a8-f977730bb3c6$paperclip$, $paperclip$2026-04-12T12:32:21.598Z$paperclip$, $paperclip$2026-04-12T12:32:21.605Z$paperclip$, $paperclip$2026-04-12T12:32:22.500Z$paperclip$, $paperclip$Traceback (most recent call last):
ModuleNotFoundError: No module named 'fire'$paperclip$, $paperclip$2026-04-12T12:32:21.598Z$paperclip$, $paperclip$2026-04-12T12:32:22.500Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$e846adfc-bd98-460f-bfd3-d6237909ac1b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$e107e9d4-7e38-4cb8-b19e-80803dcf37af$paperclip$, $paperclip$2026-04-12T12:33:25.055Z$paperclip$, $paperclip$2026-04-12T12:33:25.065Z$paperclip$, $paperclip$2026-04-12T12:33:26.702Z$paperclip$, NULL, $paperclip$2026-04-12T12:33:25.055Z$paperclip$, $paperclip$2026-04-12T12:33:26.702Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$1b1fd7b7-88c8-4e95-80ab-ff453f3ccc7e$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$09d318dc-189d-4b08-a19c-c9249f461dc8$paperclip$, $paperclip$2026-04-12T12:42:29.874Z$paperclip$, $paperclip$2026-04-12T12:42:29.883Z$paperclip$, $paperclip$2026-04-12T12:42:31.288Z$paperclip$, NULL, $paperclip$2026-04-12T12:42:29.874Z$paperclip$, $paperclip$2026-04-12T12:42:31.288Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$620d8e44-f84e-44cf-a13c-b8f39af45f72$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$2285a812-43c5-49f5-ae18-e2b21a01e1fe$paperclip$, $paperclip$2026-04-12T12:37:51.449Z$paperclip$, $paperclip$2026-04-12T12:37:51.456Z$paperclip$, $paperclip$2026-04-12T12:37:52.679Z$paperclip$, NULL, $paperclip$2026-04-12T12:37:51.449Z$paperclip$, $paperclip$2026-04-12T12:37:52.679Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$6ae71218-d4c7-475f-8aa2-66d73302562a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$902baa9c-94a0-427f-ad0e-92086c16f3db$paperclip$, $paperclip$2026-04-12T12:38:02.710Z$paperclip$, $paperclip$2026-04-12T12:38:02.718Z$paperclip$, $paperclip$2026-04-12T12:38:03.997Z$paperclip$, NULL, $paperclip$2026-04-12T12:38:02.710Z$paperclip$, $paperclip$2026-04-12T12:38:03.997Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$a41ed901-ffad-4791-bd5e-eebfd1cefc14$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, NULL, NULL, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$3734032c-bf64-414b-8678-39a701c5a6ea$paperclip$, $paperclip$2026-04-12T12:42:55.249Z$paperclip$, $paperclip$2026-04-12T12:42:55.257Z$paperclip$, $paperclip$2026-04-12T12:42:56.564Z$paperclip$, NULL, $paperclip$2026-04-12T12:42:55.249Z$paperclip$, $paperclip$2026-04-12T12:42:56.564Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$1b3164f4-b78b-4297-a84c-38625ec517dc$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$2f0ee8c1-06b3-4fb0-a89d-5e5debeb68fc$paperclip$, $paperclip$2026-04-12T13:46:29.087Z$paperclip$, $paperclip$2026-04-12T13:46:29.096Z$paperclip$, $paperclip$2026-04-12T13:46:30.102Z$paperclip$, NULL, $paperclip$2026-04-12T13:46:29.087Z$paperclip$, $paperclip$2026-04-12T13:46:30.102Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$38b3d300-57c6-4b23-9ba9-6eb2a0ead874$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$manual$paperclip$, $paperclip$retry_failed_run$paperclip$, $paperclip${}$paperclip$, $paperclip$failed$paperclip$, 0, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, NULL, $paperclip$9aceaafc-1f19-411e-986e-7ab3e763ad4a$paperclip$, $paperclip$2026-04-12T12:46:16.076Z$paperclip$, $paperclip$2026-04-12T12:46:16.085Z$paperclip$, $paperclip$2026-04-12T12:46:17.033Z$paperclip$, NULL, $paperclip$2026-04-12T12:46:16.076Z$paperclip$, $paperclip$2026-04-12T12:46:17.033Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$0f863bac-bd1b-4a0d-bff6-108ec1f7acfa$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$356523d9-0d5c-4477-9599-f15afe51b87c$paperclip$, $paperclip$2026-04-12T14:46:59.336Z$paperclip$, $paperclip$2026-04-12T14:46:59.344Z$paperclip$, $paperclip$2026-04-12T14:47:00.313Z$paperclip$, NULL, $paperclip$2026-04-12T14:46:59.336Z$paperclip$, $paperclip$2026-04-12T14:47:00.313Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$460e612e-6b4d-45cf-93f7-d85303fc1440$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$e612b9c3-da58-47de-bbf4-af432867447b$paperclip$, $paperclip$2026-04-12T15:47:29.538Z$paperclip$, $paperclip$2026-04-12T15:47:29.551Z$paperclip$, $paperclip$2026-04-12T15:47:30.533Z$paperclip$, NULL, $paperclip$2026-04-12T15:47:29.538Z$paperclip$, $paperclip$2026-04-12T15:47:30.533Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$89f24a3e-c44e-4122-b254-b92aa5141ab8$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$9018e79b-ffb5-4ebb-afb9-e0d4bbb65e68$paperclip$, $paperclip$2026-04-12T16:47:59.736Z$paperclip$, $paperclip$2026-04-12T16:47:59.746Z$paperclip$, $paperclip$2026-04-12T16:48:00.740Z$paperclip$, NULL, $paperclip$2026-04-12T16:47:59.736Z$paperclip$, $paperclip$2026-04-12T16:48:00.740Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$cb8109c6-20c7-4708-a50c-356644a53632$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$3afd74a2-c61f-4daa-ac96-2e5970b563b7$paperclip$, $paperclip$2026-04-12T17:48:29.994Z$paperclip$, $paperclip$2026-04-12T17:48:30.003Z$paperclip$, $paperclip$2026-04-12T17:48:30.935Z$paperclip$, NULL, $paperclip$2026-04-12T17:48:29.994Z$paperclip$, $paperclip$2026-04-12T17:48:30.935Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$1611290d-b1aa-4f94-a77b-b9712c2cfafa$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$5952dba4-e175-4a3a-9491-b83af1f122ee$paperclip$, $paperclip$2026-04-12T18:49:00.160Z$paperclip$, $paperclip$2026-04-12T18:49:00.169Z$paperclip$, $paperclip$2026-04-12T18:49:01.200Z$paperclip$, NULL, $paperclip$2026-04-12T18:49:00.160Z$paperclip$, $paperclip$2026-04-12T18:49:01.200Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$8364fba6-b246-47d4-b66d-c5509e2b600d$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$34d696c1-ac0b-412a-a33e-2b553f6a450c$paperclip$, $paperclip$2026-04-12T19:49:30.419Z$paperclip$, $paperclip$2026-04-12T19:49:30.428Z$paperclip$, $paperclip$2026-04-12T19:49:31.295Z$paperclip$, NULL, $paperclip$2026-04-12T19:49:30.419Z$paperclip$, $paperclip$2026-04-12T19:49:31.295Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$8264ae51-dcf2-4fe0-a0c3-6dac8cdc7a5f$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$9af64ba0-04d9-49d1-aedc-4cad4a5879d7$paperclip$, $paperclip$2026-04-12T20:50:00.635Z$paperclip$, $paperclip$2026-04-12T20:50:00.644Z$paperclip$, $paperclip$2026-04-12T20:50:01.638Z$paperclip$, NULL, $paperclip$2026-04-12T20:50:00.635Z$paperclip$, $paperclip$2026-04-12T20:50:01.638Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$6fe1e60d-5f40-424d-9629-02529dce613c$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$726086fe-1afa-47b8-ba5e-1f65c07a67aa$paperclip$, $paperclip$2026-04-12T21:50:30.846Z$paperclip$, $paperclip$2026-04-12T21:50:30.864Z$paperclip$, $paperclip$2026-04-12T21:50:31.856Z$paperclip$, NULL, $paperclip$2026-04-12T21:50:30.846Z$paperclip$, $paperclip$2026-04-12T21:50:31.856Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$be34ec2a-093a-4094-8b75-99e6de7e746e$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$f3329d57-0740-4891-bb10-97925b9a73f5$paperclip$, $paperclip$2026-04-13T05:54:32.755Z$paperclip$, $paperclip$2026-04-13T05:54:32.767Z$paperclip$, $paperclip$2026-04-13T05:54:33.743Z$paperclip$, NULL, $paperclip$2026-04-13T05:54:32.755Z$paperclip$, $paperclip$2026-04-13T05:54:33.743Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$5fe31496-6a14-4d92-be60-f90770308c34$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$70dadcce-01a7-4d69-a61f-cfd1d4caa169$paperclip$, $paperclip$2026-04-12T22:51:01.092Z$paperclip$, $paperclip$2026-04-12T22:51:01.100Z$paperclip$, $paperclip$2026-04-12T22:51:02.013Z$paperclip$, NULL, $paperclip$2026-04-12T22:51:01.092Z$paperclip$, $paperclip$2026-04-12T22:51:02.013Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$94448f6b-6c08-4b9e-beaf-69910658fdb1$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$c7caaed8-aa92-4ce9-a785-0b5fbc98c9b2$paperclip$, $paperclip$2026-04-12T23:51:31.267Z$paperclip$, $paperclip$2026-04-12T23:51:31.276Z$paperclip$, $paperclip$2026-04-12T23:51:32.141Z$paperclip$, NULL, $paperclip$2026-04-12T23:51:31.267Z$paperclip$, $paperclip$2026-04-12T23:51:32.141Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$cd3a28f3-3408-495f-93c8-9e464a0c3993$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$742d5909-f91e-4fe0-9ddd-7fb079a4bb4b$paperclip$, $paperclip$2026-04-13T00:52:01.540Z$paperclip$, $paperclip$2026-04-13T00:52:01.549Z$paperclip$, $paperclip$2026-04-13T00:52:02.392Z$paperclip$, NULL, $paperclip$2026-04-13T00:52:01.540Z$paperclip$, $paperclip$2026-04-13T00:52:02.392Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$66edf434-fba0-4c26-adae-9dd5554d1a2a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$b738d214-285a-442a-8fdc-c987f03074fd$paperclip$, $paperclip$2026-04-13T01:52:31.752Z$paperclip$, $paperclip$2026-04-13T01:52:31.761Z$paperclip$, $paperclip$2026-04-13T01:52:32.640Z$paperclip$, NULL, $paperclip$2026-04-13T01:52:31.752Z$paperclip$, $paperclip$2026-04-13T01:52:32.640Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$ef9352a6-5cca-48c7-a4cb-7de5ac97a86a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$3a1cb5d4-d4cf-464c-af04-041370ac8eec$paperclip$, $paperclip$2026-04-13T06:55:02.949Z$paperclip$, $paperclip$2026-04-13T06:55:02.958Z$paperclip$, $paperclip$2026-04-13T06:55:03.899Z$paperclip$, NULL, $paperclip$2026-04-13T06:55:02.949Z$paperclip$, $paperclip$2026-04-13T06:55:03.899Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$070f82c3-41ee-40f9-8488-5e8b799f057b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$4f28e098-01e9-4a9f-acda-990ac4878ecd$paperclip$, $paperclip$2026-04-13T02:53:02.006Z$paperclip$, $paperclip$2026-04-13T02:53:02.016Z$paperclip$, $paperclip$2026-04-13T02:53:02.910Z$paperclip$, NULL, $paperclip$2026-04-13T02:53:02.006Z$paperclip$, $paperclip$2026-04-13T02:53:02.910Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$a0167811-c8f8-45fe-b859-db5219c68caf$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$cde7245e-b4c9-4c3e-960d-7bd4fb5f2f09$paperclip$, $paperclip$2026-04-13T03:53:32.253Z$paperclip$, $paperclip$2026-04-13T03:53:32.262Z$paperclip$, $paperclip$2026-04-13T03:53:33.166Z$paperclip$, NULL, $paperclip$2026-04-13T03:53:32.253Z$paperclip$, $paperclip$2026-04-13T03:53:33.166Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."agent_wakeup_requests" ("id", "company_id", "agent_id", "source", "trigger_detail", "reason", "payload", "status", "coalesced_count", "requested_by_actor_type", "requested_by_actor_id", "idempotency_key", "run_id", "requested_at", "claimed_at", "finished_at", "error", "created_at", "updated_at") VALUES ($paperclip$607ce0f2-c7ca-4e16-9b8e-1e3f36b5f38f$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$system$paperclip$, $paperclip$heartbeat_timer$paperclip$, NULL, $paperclip$failed$paperclip$, 0, $paperclip$system$paperclip$, $paperclip$heartbeat_scheduler$paperclip$, NULL, $paperclip$efb9acc4-d3a2-41a2-8912-682eb9597b9a$paperclip$, $paperclip$2026-04-13T04:54:02.465Z$paperclip$, $paperclip$2026-04-13T04:54:02.484Z$paperclip$, $paperclip$2026-04-13T04:54:03.353Z$paperclip$, NULL, $paperclip$2026-04-13T04:54:02.465Z$paperclip$, $paperclip$2026-04-13T04:54:03.353Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.agents (1 rows)
INSERT INTO "public"."agents" ("id", "company_id", "name", "role", "title", "status", "reports_to", "capabilities", "adapter_type", "adapter_config", "budget_monthly_cents", "spent_monthly_cents", "last_heartbeat_at", "metadata", "created_at", "updated_at", "runtime_config", "permissions", "icon", "pause_reason", "paused_at") VALUES ($paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$Chulo(CEO)$paperclip$, $paperclip$ceo$paperclip$, NULL, $paperclip$error$paperclip$, NULL, NULL, $paperclip$hermes_local$paperclip$, $paperclip${"env":{"HOME":{"type":"plain","value":"/tmp/hermes_home"},"OPENAI_API_KEY":{"type":"plain","value":"ollama"},"OPENAI_API_BASE":{"type":"plain","value":"http://127.0.0.1:4000/v1"}},"mode":"","model":"gpt-4-turbo","effort":"","command":"hermes","variant":"","graceSec":15,"timeoutSec":0,"instructionsFilePath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","instructionsRootPath":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions","modelReasoningEffort":"","instructionsEntryFile":"AGENTS.md","instructionsBundleMode":"managed"}$paperclip$, 15000, 0, $paperclip$2026-04-13T06:55:03.909Z$paperclip$, NULL, $paperclip$2026-04-11T21:01:48.968Z$paperclip$, $paperclip$2026-04-13T06:55:03.909Z$paperclip$, $paperclip${"heartbeat":{"enabled":true,"cooldownSec":10,"intervalSec":3600,"wakeOnDemand":true,"maxConcurrentRuns":1}}$paperclip$, $paperclip${"canCreateAgents":true}$paperclip$, NULL, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.budget_policies (1 rows)
INSERT INTO "public"."budget_policies" ("id", "company_id", "scope_type", "scope_id", "metric", "window_kind", "amount", "warn_percent", "hard_stop_enabled", "notify_enabled", "is_active", "created_by_user_id", "updated_by_user_id", "created_at", "updated_at") VALUES ($paperclip$a24ef3e5-a469-4249-823f-82ea272c7b09$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$billed_cents$paperclip$, $paperclip$calendar_month_utc$paperclip$, 15000, 80, true, true, true, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$2026-04-11T21:02:27.363Z$paperclip$, $paperclip$2026-04-11T21:02:27.363Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.companies (1 rows)
INSERT INTO "public"."companies" ("id", "name", "description", "status", "budget_monthly_cents", "spent_monthly_cents", "created_at", "updated_at", "issue_prefix", "issue_counter", "require_board_approval_for_new_agents", "brand_color", "pause_reason", "paused_at", "feedback_data_sharing_enabled", "feedback_data_sharing_consent_at", "feedback_data_sharing_consent_by_user_id", "feedback_data_sharing_terms_version") VALUES ($paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$Zaaka$paperclip$, NULL, $paperclip$active$paperclip$, 0, 0, $paperclip$2026-04-11T21:01:00.324Z$paperclip$, $paperclip$2026-04-11T21:01:00.324Z$paperclip$, $paperclip$ZAA$paperclip$, 2, true, NULL, NULL, NULL, false, NULL, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.company_memberships (2 rows)
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$f3ce10e2-e0f1-4114-ae60-109ebfc9ed1c$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$user$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$active$paperclip$, $paperclip$owner$paperclip$, $paperclip$2026-04-11T21:01:00.330Z$paperclip$, $paperclip$2026-04-11T21:01:00.330Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_memberships" ("id", "company_id", "principal_type", "principal_id", "status", "membership_role", "created_at", "updated_at") VALUES ($paperclip$f98d7d56-b0db-457b-96ab-82a10961ee5a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$active$paperclip$, $paperclip$member$paperclip$, $paperclip$2026-04-11T21:01:48.983Z$paperclip$, $paperclip$2026-04-11T21:01:48.983Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.company_skills (4 rows)
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$8b9441fc-b0f9-4aae-ad9e-84849db87046$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$paperclipai/paperclip/paperclip$paperclip$, $paperclip$paperclip$paperclip$, $paperclip$paperclip$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: paperclip
description: >
  Interact with the Paperclip control plane API to manage tasks, coordinate with
  other agents, and follow company governance. Use when you need to check
  assignments, update task status, delegate work, post comments, set up or manage
  routines (recurring scheduled tasks), or call any Paperclip API endpoint. Do NOT
  use for the actual domain work itself (writing code, research, etc.) — only for
  Paperclip coordination.
---

# Paperclip Skill

You run in **heartbeats** — short execution windows triggered by Paperclip. Each heartbeat, you wake up, check your work, do something useful, and exit. You do not run continuously.

## Authentication

Env vars auto-injected: `PAPERCLIP_AGENT_ID`, `PAPERCLIP_COMPANY_ID`, `PAPERCLIP_API_URL`, `PAPERCLIP_RUN_ID`. Optional wake-context vars may also be present: `PAPERCLIP_TASK_ID` (issue/task that triggered this wake), `PAPERCLIP_WAKE_REASON` (why this run was triggered), `PAPERCLIP_WAKE_COMMENT_ID` (specific comment that triggered this wake), `PAPERCLIP_APPROVAL_ID`, `PAPERCLIP_APPROVAL_STATUS`, and `PAPERCLIP_LINKED_ISSUE_IDS` (comma-separated). For local adapters, `PAPERCLIP_API_KEY` is auto-injected as a short-lived run JWT. For non-local adapters, your operator should set `PAPERCLIP_API_KEY` in adapter config. All requests use `Authorization: Bearer $PAPERCLIP_API_KEY`. All endpoints under `/api`, all JSON. Never hard-code the API URL.

Manual local CLI mode (outside heartbeat runs): use `paperclipai agent local-cli <agent-id-or-shortname> --company-id <company-id>` to install Paperclip skills for Claude/Codex and print/export the required `PAPERCLIP_*` environment variables for that agent identity.

**Run audit trail:** You MUST include `-H 'X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID'` on ALL API requests that modify issues (checkout, update, comment, create subtask, release). This links your actions to the current heartbeat run for traceability.

## The Heartbeat Procedure

Follow these steps every time you wake up:

**Step 1 — Identity.** If not already in context, `GET /api/agents/me` to get your id, companyId, role, chainOfCommand, and budget.

**Step 2 — Approval follow-up (when triggered).** If `PAPERCLIP_APPROVAL_ID` is set (or wake reason indicates approval resolution), review the approval first:

- `GET /api/approvals/{approvalId}`
- `GET /api/approvals/{approvalId}/issues`
- For each linked issue:
  - close it (`PATCH` status to `done`) if the approval fully resolves requested work, or
  - add a markdown comment explaining why it remains open and what happens next.
    Always include links to the approval and issue in that comment.

**Step 3 — Get assignments.** Prefer `GET /api/agents/me/inbox-lite` for the normal heartbeat inbox. It returns the compact assignment list you need for prioritization. Fall back to `GET /api/companies/{companyId}/issues?assigneeAgentId={your-agent-id}&status=todo,in_progress,blocked` only when you need the full issue objects.

**Step 4 — Pick work (with mention exception).** Work on `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it.
**Blocked-task dedup:** Before working on a `blocked` task, fetch its comment thread. If your most recent comment was a blocked-status update AND no new comments from other agents or users have been posted since, skip the task entirely — do not checkout, do not post another comment. Exit the heartbeat (or move to the next task) instead. Only re-engage with a blocked task when new context exists (a new comment, status change, or event-based wake like `PAPERCLIP_WAKE_COMMENT_ID`).
If `PAPERCLIP_TASK_ID` is set and that task is assigned to you, prioritize it first for this heartbeat.
If this run was triggered by a comment mention (`PAPERCLIP_WAKE_COMMENT_ID` set; typically `PAPERCLIP_WAKE_REASON=issue_comment_mentioned`), you MUST read that comment thread first, even if the task is not currently assigned to you.
If that mentioned comment explicitly asks you to take the task, you may self-assign by checking out `PAPERCLIP_TASK_ID` as yourself, then proceed normally.
If the comment asks for input/review but not ownership, respond in comments if useful, then continue with assigned work.
If the comment does not direct you to take ownership, do not self-assign.
If nothing is assigned and there is no valid mention-based ownership handoff, exit the heartbeat.

**Step 5 — Checkout.** You MUST checkout before doing any work. Include the run ID header:

```
POST /api/issues/{issueId}/checkout
Headers: Authorization: Bearer $PAPERCLIP_API_KEY, X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID
{ "agentId": "{your-agent-id}", "expectedStatuses": ["todo", "backlog", "blocked"] }
```

If already checked out by you, returns normally. If owned by another agent: `409 Conflict` — stop, pick a different task. **Never retry a 409.**

**Step 6 — Understand context.** Prefer `GET /api/issues/{issueId}/heartbeat-context` first. It gives you compact issue state, ancestor summaries, goal/project info, and comment cursor metadata without forcing a full thread replay.

Use comments incrementally:

- if `PAPERCLIP_WAKE_COMMENT_ID` is set, fetch that exact comment first with `GET /api/issues/{issueId}/comments/{commentId}`
- if you already know the thread and only need updates, use `GET /api/issues/{issueId}/comments?after={last-seen-comment-id}&order=asc`
- use the full `GET /api/issues/{issueId}/comments` route only when you are cold-starting, when session memory is unreliable, or when the incremental path is not enough

Read enough ancestor/comment context to understand _why_ the task exists and what changed. Do not reflexively reload the whole thread on every heartbeat.

**Step 7 — Do the work.** Use your tools and capabilities.

**Step 8 — Update status and communicate.** Always include the run ID header.
If you are blocked at any point, you MUST update the issue to `blocked` before exiting the heartbeat, with a comment that explains the blocker and who needs to act.

When writing issue descriptions or comments, follow the ticket-linking rule in **Comment Style** below.

```json
PATCH /api/issues/{issueId}
Headers: X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID
{ "status": "done", "comment": "What was done and why." }

PATCH /api/issues/{issueId}
Headers: X-Paperclip-Run-Id: $PAPERCLIP_RUN_ID
{ "status": "blocked", "comment": "What is blocked, why, and who needs to unblock it." }
```

Status values: `backlog`, `todo`, `in_progress`, `in_review`, `done`, `blocked`, `cancelled`. Priority values: `critical`, `high`, `medium`, `low`. Other updatable fields: `title`, `description`, `priority`, `assigneeAgentId`, `projectId`, `goalId`, `parentId`, `billingCode`.

**Step 9 — Delegate if needed.** Create subtasks with `POST /api/companies/{companyId}/issues`. Always set `parentId` and `goalId`. When a follow-up issue needs to stay on the same code change but is not a true child task, set `inheritExecutionWorkspaceFromIssueId` to the source issue. Set `billingCode` for cross-team work.

## Project Setup Workflow (CEO/Manager Common Path)

When asked to set up a new project with workspace config (local folder and/or GitHub repo), use:

1. `POST /api/companies/{companyId}/projects` with project fields.
2. Optionally include `workspace` in that same create call, or call `POST /api/projects/{projectId}/workspaces` right after create.

Workspace rules:

- Provide at least one of `cwd` (local folder) or `repoUrl` (remote repo).
- For repo-only setup, omit `cwd` and provide `repoUrl`.
- Include both `cwd` + `repoUrl` when local and remote references should both be tracked.

## OpenClaw Invite Workflow (CEO)

Use this when asked to invite a new OpenClaw employee.

1. Generate a fresh OpenClaw invite prompt:

```
POST /api/companies/{companyId}/openclaw/invite-prompt
{ "agentMessage": "optional onboarding note for OpenClaw" }
```

Access control:

- Board users with invite permission can call it.
- Agent callers: only the company CEO agent can call it.

2. Build the copy-ready OpenClaw prompt for the board:

- Use `onboardingTextUrl` from the response.
- Ask the board to paste that prompt into OpenClaw.
- If the issue includes an OpenClaw URL (for example `ws://127.0.0.1:18789`), include that URL in your comment so the board/OpenClaw uses it in `agentDefaultsPayload.url`.

3. Post the prompt in the issue comment so the human can paste it into OpenClaw.

4. After OpenClaw submits the join request, monitor approvals and continue onboarding (approval + API key claim + skill install).

## Company Skills Workflow

Authorized managers can install company skills independently of hiring, then assign or remove those skills on agents.

- Install and inspect company skills with the company skills API.
- Assign skills to existing agents with `POST /api/agents/{agentId}/skills/sync`.
- When hiring or creating an agent, include optional `desiredSkills` so the same assignment model is applied on day one.

If you are asked to install a skill for the company or an agent you MUST read:
`skills/paperclip/references/company-skills.md`

## Routines

Routines are recurring tasks. Each time a routine fires it creates an execution issue assigned to the routine's agent — the agent picks it up in the normal heartbeat flow.

- Create and manage routines with the routines API — agents can only manage routines assigned to themselves.
- Add triggers per routine: `schedule` (cron), `webhook`, or `api` (manual).
- Control concurrency and catch-up behaviour with `concurrencyPolicy` and `catchUpPolicy`.

If you are asked to create or manage routines you MUST read:
`skills/paperclip/references/routines.md`

## Critical Rules

- **Always checkout** before working. Never PATCH to `in_progress` manually.
- **Never retry a 409.** The task belongs to someone else.
- **Never look for unassigned work.**
- **Self-assign only for explicit @-mention handoff.** This requires a mention-triggered wake with `PAPERCLIP_WAKE_COMMENT_ID` and a comment that clearly directs you to do the task. Use checkout (never direct assignee patch). Otherwise, no assignments = exit.
- **Honor "send it back to me" requests from board users.** If a board/user asks for review handoff (e.g. "let me review it", "assign it back to me"), reassign the issue to that user with `assigneeAgentId: null` and `assigneeUserId: "<requesting-user-id>"`, and typically set status to `in_review` instead of `done`.
  Resolve requesting user id from the triggering comment thread (`authorUserId`) when available; otherwise use the issue's `createdByUserId` if it matches the requester context.
- **Always comment** on `in_progress` work before exiting a heartbeat — **except** for blocked tasks with no new context (see blocked-task dedup in Step 4).
- **Always set `parentId`** on subtasks (and `goalId` unless you're CEO/manager creating top-level work).
- **Preserve workspace continuity for follow-ups.** Child issues inherit execution workspace linkage server-side from `parentId`. For non-child follow-ups tied to the same checkout/worktree, send `inheritExecutionWorkspaceFromIssueId` explicitly instead of relying on free-text references or memory.
- **Never cancel cross-team tasks.** Reassign to your manager with a comment.
- **Always update blocked issues explicitly.** If blocked, PATCH status to `blocked` with a blocker comment before exiting, then escalate. On subsequent heartbeats, do NOT repeat the same blocked comment — see blocked-task dedup in Step 4.
- **@-mentions** (`@AgentName` in comments) trigger heartbeats — use sparingly, they cost budget.
- **Budget**: auto-paused at 100%. Above 80%, focus on critical tasks only.
- **Escalate** via `chainOfCommand` when stuck. Reassign to manager or create a task for them.
- **Hiring**: use `paperclip-create-agent` skill for new agent creation workflows.
- **Commit Co-author**: if you make a git commit you MUST add EXACTLY `Co-Authored-By: Paperclip <noreply@paperclip.ing>` to the end of each commit message. Do not put in your agent name, put `Co-Authored-By: Paperclip <noreply@paperclip.ing>`

## Comment Style (Required)

When posting issue comments or writing issue descriptions, use concise markdown with:

- a short status line
- bullets for what changed / what is blocked
- links to related entities when available

**Ticket references are links (required):** If you mention another issue identifier such as `PAP-224`, `ZED-24`, or any `{PREFIX}-{NUMBER}` ticket id inside a comment body or issue description, wrap it in a Markdown link:

- `[PAP-224](/PAP/issues/PAP-224)`
- `[ZED-24](/ZED/issues/ZED-24)`

Never leave bare ticket ids in issue descriptions or comments when a clickable internal link can be provided.

**Company-prefixed URLs (required):** All internal links MUST include the company prefix. Derive the prefix from any issue identifier you have (e.g., `PAP-315` → prefix is `PAP`). Use this prefix in all UI links:

- Issues: `/<prefix>/issues/<issue-identifier>` (e.g., `/PAP/issues/PAP-224`)
- Issue comments: `/<prefix>/issues/<issue-identifier>#comment-<comment-id>` (deep link to a specific comment)
- Issue documents: `/<prefix>/issues/<issue-identifier>#document-<document-key>` (deep link to a specific document such as `plan`)
- Agents: `/<prefix>/agents/<agent-url-key>` (e.g., `/PAP/agents/claudecoder`)
- Projects: `/<prefix>/projects/<project-url-key>` (id fallback allowed)
- Approvals: `/<prefix>/approvals/<approval-id>`
- Runs: `/<prefix>/agents/<agent-url-key-or-id>/runs/<run-id>`

Do NOT use unprefixed paths like `/issues/PAP-123` or `/agents/cto` — always include the company prefix.

Example:

```md
## Update

Submitted CTO hire request and linked it for board review.

- Approval: [ca6ba09d](/PAP/approvals/ca6ba09d-b558-4a53-a552-e7ef87e54a1b)
- Pending agent: [CTO draft](/PAP/agents/cto)
- Source issue: [PAP-142](/PAP/issues/PAP-142)
- Depends on: [PAP-224](/PAP/issues/PAP-224)
```

## Planning (Required when planning requested)

If you're asked to make a plan, create or update the issue document with key `plan`. Do not append plans into the issue description anymore. If you're asked for plan revisions, update that same `plan` document. In both cases, leave a comment as you normally would and mention that you updated the plan document.

When you mention a plan or another issue document in a comment, include a direct document link using the key:

- Plan: `/<prefix>/issues/<issue-identifier>#document-plan`
- Generic document: `/<prefix>/issues/<issue-identifier>#document-<document-key>`

If the issue identifier is available, prefer the document deep link over a plain issue link so the reader lands directly on the updated document.

If you're asked to make a plan, _do not mark the issue as done_. Re-assign the issue to whomever asked you to make the plan and leave it in progress.

Recommended API flow:

```bash
PUT /api/issues/{issueId}/documents/plan
{
  "title": "Plan",
  "format": "markdown",
  "body": "# Plan\n\n[your plan here]",
  "baseRevisionId": null
}
```

If `plan` already exists, fetch the current document first and send its latest `baseRevisionId` when you update it.

## Setting Agent Instructions Path

Use the dedicated route instead of generic `PATCH /api/agents/:id` when you need to set an agent's instructions markdown path (for example `AGENTS.md`).

```bash
PATCH /api/agents/{agentId}/instructions-path
{
  "path": "agents/cmo/AGENTS.md"
}
```

Rules:

- Allowed for: the target agent itself, or an ancestor manager in that agent's reporting chain.
- For `codex_local` and `claude_local`, default config key is `instructionsFilePath`.
- Relative paths are resolved against the target agent's `adapterConfig.cwd`; absolute paths are accepted as-is.
- To clear the path, send `{ "path": null }`.
- For adapters with a different key, provide it explicitly:

```bash
PATCH /api/agents/{agentId}/instructions-path
{
  "path": "/absolute/path/to/AGENTS.md",
  "adapterConfigKey": "yourAdapterSpecificPathField"
}
```

## Key Endpoints (Quick Reference)

| Action                                    | Endpoint                                                                                   |
| ----------------------------------------- | ------------------------------------------------------------------------------------------ |
| My identity                               | `GET /api/agents/me`                                                                       |
| My compact inbox                          | `GET /api/agents/me/inbox-lite`                                                            |
| Report a user's Mine inbox view           | `GET /api/agents/me/inbox/mine?userId=:userId`                                             |
| My assignments                            | `GET /api/companies/:companyId/issues?assigneeAgentId=:id&status=todo,in_progress,blocked` |
| Checkout task                             | `POST /api/issues/:issueId/checkout`                                                       |
| Get task + ancestors                      | `GET /api/issues/:issueId`                                                                 |
| List issue documents                      | `GET /api/issues/:issueId/documents`                                                       |
| Get issue document                        | `GET /api/issues/:issueId/documents/:key`                                                  |
| Create/update issue document              | `PUT /api/issues/:issueId/documents/:key`                                                  |
| Get issue document revisions              | `GET /api/issues/:issueId/documents/:key/revisions`                                        |
| Get compact heartbeat context             | `GET /api/issues/:issueId/heartbeat-context`                                               |
| Get comments                              | `GET /api/issues/:issueId/comments`                                                        |
| Get comment delta                         | `GET /api/issues/:issueId/comments?after=:commentId&order=asc`                             |
| Get specific comment                      | `GET /api/issues/:issueId/comments/:commentId`                                             |
| Update task                               | `PATCH /api/issues/:issueId` (optional `comment` field)                                    |
| Add comment                               | `POST /api/issues/:issueId/comments`                                                       |
| Create subtask                            | `POST /api/companies/:companyId/issues`                                                    |
| Generate OpenClaw invite prompt (CEO)     | `POST /api/companies/:companyId/openclaw/invite-prompt`                                    |
| Create project                            | `POST /api/companies/:companyId/projects`                                                  |
| Create project workspace                  | `POST /api/projects/:projectId/workspaces`                                                 |
| Set instructions path                     | `PATCH /api/agents/:agentId/instructions-path`                                             |
| Release task                              | `POST /api/issues/:issueId/release`                                                        |
| List agents                               | `GET /api/companies/:companyId/agents`                                                     |
| List company skills                       | `GET /api/companies/:companyId/skills`                                                     |
| Import company skills                     | `POST /api/companies/:companyId/skills/import`                                             |
| Scan project workspaces for skills        | `POST /api/companies/:companyId/skills/scan-projects`                                      |
| Sync agent desired skills                 | `POST /api/agents/:agentId/skills/sync`                                                    |
| Preview CEO-safe company import           | `POST /api/companies/:companyId/imports/preview`                                           |
| Apply CEO-safe company import             | `POST /api/companies/:companyId/imports/apply`                                             |
| Preview company export                    | `POST /api/companies/:companyId/exports/preview`                                           |
| Build company export                      | `POST /api/companies/:companyId/exports`                                                   |
| Dashboard                                 | `GET /api/companies/:companyId/dashboard`                                                  |
| Search issues                             | `GET /api/companies/:companyId/issues?q=search+term`                                       |
| Upload attachment (multipart, field=file) | `POST /api/companies/:companyId/issues/:issueId/attachments`                               |
| List issue attachments                    | `GET /api/issues/:issueId/attachments`                                                     |
| Get attachment content                    | `GET /api/attachments/:attachmentId/content`                                               |
| Delete attachment                         | `DELETE /api/attachments/:attachmentId`                                                    |
| List routines                             | `GET /api/companies/:companyId/routines`                                                   |
| Get routine                               | `GET /api/routines/:routineId`                                                             |
| Create routine                            | `POST /api/companies/:companyId/routines`                                                  |
| Update routine                            | `PATCH /api/routines/:routineId`                                                           |
| Add trigger                               | `POST /api/routines/:routineId/triggers`                                                   |
| Update trigger                            | `PATCH /api/routine-triggers/:triggerId`                                                   |
| Delete trigger                            | `DELETE /api/routine-triggers/:triggerId`                                                  |
| Rotate webhook secret                     | `POST /api/routine-triggers/:triggerId/rotate-secret`                                      |
| Manual run                                | `POST /api/routines/:routineId/run`                                                        |
| Fire webhook (external)                   | `POST /api/routine-triggers/public/:publicId/fire`                                         |
| List runs                                 | `GET /api/routines/:routineId/runs`                                                        |

## Company Import / Export

Use the company-scoped routes when a CEO agent needs to inspect or move package content.

- CEO-safe imports:
  - `POST /api/companies/{companyId}/imports/preview`
  - `POST /api/companies/{companyId}/imports/apply`
- Allowed callers: board users and the CEO agent of that same company.
- Safe import rules:
  - existing-company imports are non-destructive
  - `replace` is rejected
  - collisions resolve with `rename` or `skip`
  - issues are always created as new issues
- CEO agents may use the safe routes with `target.mode = "new_company"` to create a new company directly. Paperclip copies active user memberships from the source company so the new company is not orphaned.

For export, preview first and keep tasks explicit:

- `POST /api/companies/{companyId}/exports/preview`
- `POST /api/companies/{companyId}/exports`
- Export preview defaults to `issues: false`
- Add `issues` or `projectIssues` only when you intentionally need task files
- Use `selectedFiles` to narrow the final package to specific agents, skills, projects, or tasks after you inspect the preview inventory

## Searching Issues

Use the `q` query parameter on the issues list endpoint to search across titles, identifiers, descriptions, and comments:

```
GET /api/companies/{companyId}/issues?q=dockerfile
```

Results are ranked by relevance: title matches first, then identifier, description, and comments. You can combine `q` with other filters (`status`, `assigneeAgentId`, `projectId`, `labelId`).

## Self-Test Playbook (App-Level)

Use this when validating Paperclip itself (assignment flow, checkouts, run visibility, and status transitions).

1. Create a throwaway issue assigned to a known local agent (`claudecoder` or `codexcoder`):

```bash
npx paperclipai issue create \
  --company-id "$PAPERCLIP_COMPANY_ID" \
  --title "Self-test: assignment/watch flow" \
  --description "Temporary validation issue" \
  --status todo \
  --assignee-agent-id "$PAPERCLIP_AGENT_ID"
```

2. Trigger and watch a heartbeat for that assignee:

```bash
npx paperclipai heartbeat run --agent-id "$PAPERCLIP_AGENT_ID"
```

3. Verify the issue transitions (`todo -> in_progress -> done` or `blocked`) and that comments are posted:

```bash
npx paperclipai issue get <issue-id-or-identifier>
```

4. Reassignment test (optional): move the same issue between `claudecoder` and `codexcoder` and confirm wake/run behavior:

```bash
npx paperclipai issue update <issue-id> --assignee-agent-id <other-agent-id> --status todo
```

5. Cleanup: mark temporary issues done/cancelled with a clear note.

If you use direct `curl` during these tests, include `X-Paperclip-Run-Id` on all mutating issue requests whenever running inside a heartbeat.

## Full Reference

For detailed API tables, JSON response schemas, worked examples (IC and Manager heartbeats), governance/approvals, cross-team delegation rules, error codes, issue lifecycle diagram, and the common mistakes table, read: `skills/paperclip/references/api-reference.md`
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/usr/local/share/pnpm/global/5/.pnpm/@paperclipai+server@2026.403.0_@noble+hashes@2.0.1_kysely@0.28.16_pg@8.20.0_postgres@3.4.9/node_modules/@paperclipai/server/skills/paperclip$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"reference","path":"references/api-reference.md"},{"kind":"reference","path":"references/company-skills.md"},{"kind":"reference","path":"references/routines.md"},{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/paperclip","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-11T21:01:51.970Z$paperclip$, $paperclip$2026-04-13T06:55:02.969Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$4cd85826-dabb-4ca2-911a-507e2011fe7f$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$paperclipai/paperclip/paperclip-create-agent$paperclip$, $paperclip$paperclip-create-agent$paperclip$, $paperclip$paperclip-create-agent$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: paperclip-create-agent
description: >
  Create new agents in Paperclip with governance-aware hiring. Use when you need
  to inspect adapter configuration options, compare existing agent configs,
  draft a new agent prompt/config, and submit a hire request.
---

# Paperclip Create Agent Skill

Use this skill when you are asked to hire/create an agent.

## Preconditions

You need either:

- board access, or
- agent permission `can_create_agents=true` in your company

If you do not have this permission, escalate to your CEO or board.

## Workflow

1. Confirm identity and company context.

```sh
curl -sS "$PAPERCLIP_API_URL/api/agents/me" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

2. Discover available adapter configuration docs for this Paperclip instance.

```sh
curl -sS "$PAPERCLIP_API_URL/llms/agent-configuration.txt" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

3. Read adapter-specific docs (example: `claude_local`).

```sh
curl -sS "$PAPERCLIP_API_URL/llms/agent-configuration/claude_local.txt" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

4. Compare existing agent configurations in your company.

```sh
curl -sS "$PAPERCLIP_API_URL/api/companies/$PAPERCLIP_COMPANY_ID/agent-configurations" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

5. Discover allowed agent icons and pick one that matches the role.

```sh
curl -sS "$PAPERCLIP_API_URL/llms/agent-icons.txt" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

6. Draft the new hire config:
- role/title/name
- icon (required in practice; use one from `/llms/agent-icons.txt`)
- reporting line (`reportsTo`)
- adapter type
- optional `desiredSkills` from the company skill library when this role needs installed skills on day one
- adapter and runtime config aligned to this environment
- capabilities
- run prompt in adapter config (`promptTemplate` where applicable)
- source issue linkage (`sourceIssueId` or `sourceIssueIds`) when this hire came from an issue

7. Submit hire request.

```sh
curl -sS -X POST "$PAPERCLIP_API_URL/api/companies/$PAPERCLIP_COMPANY_ID/agent-hires" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "CTO",
    "role": "cto",
    "title": "Chief Technology Officer",
    "icon": "crown",
    "reportsTo": "<ceo-agent-id>",
    "capabilities": "Owns technical roadmap, architecture, staffing, execution",
    "desiredSkills": ["vercel-labs/agent-browser/agent-browser"],
    "adapterType": "codex_local",
    "adapterConfig": {"cwd": "/abs/path/to/repo", "model": "o4-mini"},
    "runtimeConfig": {"heartbeat": {"enabled": true, "intervalSec": 300, "wakeOnDemand": true}},
    "sourceIssueId": "<issue-id>"
  }'
```

8. Handle governance state:
- if response has `approval`, hire is `pending_approval`
- monitor and discuss on approval thread
- when the board approves, you will be woken with `PAPERCLIP_APPROVAL_ID`; read linked issues and close/comment follow-up

```sh
curl -sS "$PAPERCLIP_API_URL/api/approvals/<approval-id>" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"

curl -sS -X POST "$PAPERCLIP_API_URL/api/approvals/<approval-id>/comments" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"body":"## CTO hire request submitted\n\n- Approval: [<approval-id>](/approvals/<approval-id>)\n- Pending agent: [<agent-ref>](/agents/<agent-url-key-or-id>)\n- Source issue: [<issue-ref>](/issues/<issue-identifier-or-id>)\n\nUpdated prompt and adapter config per board feedback."}'
```

If the approval already exists and needs manual linking to the issue:

```sh
curl -sS -X POST "$PAPERCLIP_API_URL/api/issues/<issue-id>/approvals" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"approvalId":"<approval-id>"}'
```

After approval is granted, run this follow-up loop:

```sh
curl -sS "$PAPERCLIP_API_URL/api/approvals/$PAPERCLIP_APPROVAL_ID" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"

curl -sS "$PAPERCLIP_API_URL/api/approvals/$PAPERCLIP_APPROVAL_ID/issues" \
  -H "Authorization: Bearer $PAPERCLIP_API_KEY"
```

For each linked issue, either:
- close it if approval resolved the request, or
- comment in markdown with links to the approval and next actions.

## Quality Bar

Before sending a hire request:

- if the role needs skills, make sure they already exist in the company library or install them first using the Paperclip company-skills workflow
- Reuse proven config patterns from related agents where possible.
- Set a concrete `icon` from `/llms/agent-icons.txt` so the new hire is identifiable in org and task views.
- Avoid secrets in plain text unless required by adapter behavior.
- Ensure reporting line is correct and in-company.
- Ensure prompt is role-specific and operationally scoped.
- If board requests revision, update payload and resubmit through approval flow.

For endpoint payload shapes and full examples, read:
`skills/paperclip-create-agent/references/api-reference.md`
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/usr/local/share/pnpm/global/5/.pnpm/@paperclipai+server@2026.403.0_@noble+hashes@2.0.1_kysely@0.28.16_pg@8.20.0_postgres@3.4.9/node_modules/@paperclipai/server/skills/paperclip-create-agent$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"reference","path":"references/api-reference.md"},{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/paperclip-create-agent","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-11T21:01:51.974Z$paperclip$, $paperclip$2026-04-13T06:55:02.972Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$f3aebe61-10c1-4a77-8a64-2a1d091d6c27$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$paperclipai/paperclip/paperclip-create-plugin$paperclip$, $paperclip$paperclip-create-plugin$paperclip$, $paperclip$paperclip-create-plugin$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: paperclip-create-plugin
description: >
  Create new Paperclip plugins with the current alpha SDK/runtime. Use when
  scaffolding a plugin package, adding a new example plugin, or updating plugin
  authoring docs. Covers the supported worker/UI surface, route conventions,
  scaffold flow, and verification steps.
---

# Create a Paperclip Plugin

Use this skill when the task is to create, scaffold, or document a Paperclip plugin.

## 1. Ground rules

Read these first when needed:

1. `doc/plugins/PLUGIN_AUTHORING_GUIDE.md`
2. `packages/plugins/sdk/README.md`
3. `doc/plugins/PLUGIN_SPEC.md` only for future-looking context

Current runtime assumptions:

- plugin workers are trusted code
- plugin UI is trusted same-origin host code
- worker APIs are capability-gated
- plugin UI is not sandboxed by manifest capabilities
- no host-provided shared plugin UI component kit yet
- `ctx.assets` is not supported in the current runtime

## 2. Preferred workflow

Use the scaffold package instead of hand-writing the boilerplate:

```bash
pnpm --filter @paperclipai/create-paperclip-plugin build
node packages/plugins/create-paperclip-plugin/dist/index.js <npm-package-name> --output <target-dir>
```

For a plugin that lives outside the Paperclip repo, pass `--sdk-path` and let the scaffold snapshot the local SDK/shared packages into `.paperclip-sdk/`:

```bash
pnpm --filter @paperclipai/create-paperclip-plugin build
node packages/plugins/create-paperclip-plugin/dist/index.js @acme/plugin-name \
  --output /absolute/path/to/plugin-repos \
  --sdk-path /absolute/path/to/paperclip/packages/plugins/sdk
```

Recommended target inside this repo:

- `packages/plugins/examples/` for example plugins
- another `packages/plugins/<name>/` folder if it is becoming a real package

## 3. After scaffolding

Check and adjust:

- `src/manifest.ts`
- `src/worker.ts`
- `src/ui/index.tsx`
- `tests/plugin.spec.ts`
- `package.json`

Make sure the plugin:

- declares only supported capabilities
- does not use `ctx.assets`
- does not import host UI component stubs
- keeps UI self-contained
- uses `routePath` only on `page` slots
- is installed into Paperclip from an absolute local path during development

## 4. If the plugin should appear in the app

For bundled example/discoverable behavior, update the relevant host wiring:

- bundled example list in `server/src/routes/plugins.ts`
- any docs that list in-repo examples

Only do this if the user wants the plugin surfaced as a bundled example.

## 5. Verification

Always run:

```bash
pnpm --filter <plugin-package> typecheck
pnpm --filter <plugin-package> test
pnpm --filter <plugin-package> build
```

If you changed SDK/host/plugin runtime code too, also run broader repo checks as appropriate.

## 6. Documentation expectations

When authoring or updating plugin docs:

- distinguish current implementation from future spec ideas
- be explicit about the trusted-code model
- do not promise host UI components or asset APIs
- prefer npm-package deployment guidance over repo-local workflows for production
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/usr/local/share/pnpm/global/5/.pnpm/@paperclipai+server@2026.403.0_@noble+hashes@2.0.1_kysely@0.28.16_pg@8.20.0_postgres@3.4.9/node_modules/@paperclipai/server/skills/paperclip-create-plugin$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/paperclip-create-plugin","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-11T21:01:51.976Z$paperclip$, $paperclip$2026-04-13T06:55:02.974Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."company_skills" ("id", "company_id", "key", "slug", "name", "description", "markdown", "source_type", "source_locator", "source_ref", "trust_level", "compatibility", "file_inventory", "metadata", "created_at", "updated_at") VALUES ($paperclip$1b596aaa-9fc6-4562-8b59-9ab684c89417$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$paperclipai/paperclip/para-memory-files$paperclip$, $paperclip$para-memory-files$paperclip$, $paperclip$para-memory-files$paperclip$, $paperclip$>$paperclip$, $paperclip$---
name: para-memory-files
description: >
  File-based memory system using Tiago Forte's PARA method. Use this skill whenever
  you need to store, retrieve, update, or organize knowledge across sessions. Covers
  three memory layers: (1) Knowledge graph in PARA folders with atomic YAML facts,
  (2) Daily notes as raw timeline, (3) Tacit knowledge about user patterns. Also
  handles planning files, memory decay, weekly synthesis, and recall via qmd.
  Trigger on any memory operation: saving facts, writing daily notes, creating
  entities, running weekly synthesis, recalling past context, or managing plans.
---

# PARA Memory Files

Persistent, file-based memory organized by Tiago Forte's PARA method. Three layers: a knowledge graph, daily notes, and tacit knowledge. All paths are relative to `$AGENT_HOME`.

## Three Memory Layers

### Layer 1: Knowledge Graph (`$AGENT_HOME/life/` -- PARA)

Entity-based storage. Each entity gets a folder with two tiers:

1. `summary.md` -- quick context, load first.
2. `items.yaml` -- atomic facts, load on demand.

```text
$AGENT_HOME/life/
  projects/          # Active work with clear goals/deadlines
    <name>/
      summary.md
      items.yaml
  areas/             # Ongoing responsibilities, no end date
    people/<name>/
    companies/<name>/
  resources/         # Reference material, topics of interest
    <topic>/
  archives/          # Inactive items from the other three
  index.md
```

**PARA rules:**

- **Projects** -- active work with a goal or deadline. Move to archives when complete.
- **Areas** -- ongoing (people, companies, responsibilities). No end date.
- **Resources** -- reference material, topics of interest.
- **Archives** -- inactive items from any category.

**Fact rules:**

- Save durable facts immediately to `items.yaml`.
- Weekly: rewrite `summary.md` from active facts.
- Never delete facts. Supersede instead (`status: superseded`, add `superseded_by`).
- When an entity goes inactive, move its folder to `$AGENT_HOME/life/archives/`.

**When to create an entity:**

- Mentioned 3+ times, OR
- Direct relationship to the user (family, coworker, partner, client), OR
- Significant project or company in the user's life.
- Otherwise, note it in daily notes.

For the atomic fact YAML schema and memory decay rules, see [references/schemas.md](references/schemas.md).

### Layer 2: Daily Notes (`$AGENT_HOME/memory/YYYY-MM-DD.md`)

Raw timeline of events -- the "when" layer.

- Write continuously during conversations.
- Extract durable facts to Layer 1 during heartbeats.

### Layer 3: Tacit Knowledge (`$AGENT_HOME/MEMORY.md`)

How the user operates -- patterns, preferences, lessons learned.

- Not facts about the world; facts about the user.
- Update whenever you learn new operating patterns.

## Write It Down -- No Mental Notes

Memory does not survive session restarts. Files do.

- Want to remember something -> WRITE IT TO A FILE.
- "Remember this" -> update `$AGENT_HOME/memory/YYYY-MM-DD.md` or the relevant entity file.
- Learn a lesson -> update AGENTS.md, TOOLS.md, or the relevant skill file.
- Make a mistake -> document it so future-you does not repeat it.
- On-disk text files are always better than holding it in temporary context.

## Memory Recall -- Use qmd

Use `qmd` rather than grepping files:

```bash
qmd query "what happened at Christmas"   # Semantic search with reranking
qmd search "specific phrase"              # BM25 keyword search
qmd vsearch "conceptual question"         # Pure vector similarity
```

Index your personal folder: `qmd index $AGENT_HOME`

Vectors + BM25 + reranking finds things even when the wording differs.

## Planning

Keep plans in timestamped files in `plans/` at the project root (outside personal memory so other agents can access them). Use `qmd` to search plans. Plans go stale -- if a newer plan exists, do not confuse yourself with an older version. If you notice staleness, update the file to note what it is supersededBy.
$paperclip$, $paperclip$local_path$paperclip$, $paperclip$/usr/local/share/pnpm/global/5/.pnpm/@paperclipai+server@2026.403.0_@noble+hashes@2.0.1_kysely@0.28.16_pg@8.20.0_postgres@3.4.9/node_modules/@paperclipai/server/skills/para-memory-files$paperclip$, NULL, $paperclip$markdown_only$paperclip$, $paperclip$compatible$paperclip$, $paperclip$[{"kind":"reference","path":"references/schemas.md"},{"kind":"skill","path":"SKILL.md"}]$paperclip$, $paperclip${"skillKey":"paperclipai/paperclip/para-memory-files","sourceKind":"paperclip_bundled"}$paperclip$, $paperclip$2026-04-11T21:01:51.978Z$paperclip$, $paperclip$2026-04-13T06:55:02.976Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.execution_workspaces (1 rows)
INSERT INTO "public"."execution_workspaces" ("id", "company_id", "project_id", "project_workspace_id", "source_issue_id", "mode", "strategy_type", "name", "status", "cwd", "repo_url", "base_ref", "branch_name", "provider_type", "provider_ref", "derived_from_execution_workspace_id", "last_used_at", "opened_at", "closed_at", "cleanup_eligible_at", "cleanup_reason", "metadata", "created_at", "updated_at") VALUES ($paperclip$0b447ff2-5710-44b7-b372-d9a5891bf5be$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$15e44c3d-527b-4d86-90f8-04d926928a3a$paperclip$, NULL, $paperclip$1fb189f4-9819-4177-94e2-9f08c0e37091$paperclip$, $paperclip$shared_workspace$paperclip$, $paperclip$project_primary$paperclip$, $paperclip$ZAA-1$paperclip$, $paperclip$active$paperclip$, $paperclip$/root/.paperclip/instances/default/projects/613da0c8-8f6a-41f5-9a81-f6272721e383/15e44c3d-527b-4d86-90f8-04d926928a3a/_default$paperclip$, NULL, NULL, NULL, $paperclip$local_fs$paperclip$, NULL, NULL, $paperclip$2026-04-11T21:01:51.981Z$paperclip$, $paperclip$2026-04-11T21:01:51.981Z$paperclip$, NULL, NULL, NULL, $paperclip${"source":"project_primary","createdByRuntime":false}$paperclip$, $paperclip$2026-04-11T21:01:51.982Z$paperclip$, $paperclip$2026-04-11T21:01:51.982Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.heartbeat_run_events (144 rows)
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$1$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$ae7bde7c-7cfa-47fa-ba42-770f6f131fa7$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-11T21:01:52.051Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$2$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$ae7bde7c-7cfa-47fa-ba42-770f6f131fa7$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-11T21:01:52.070Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$3$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$068cbe93-6ca9-4ac6-bc7e-f6842acf2bb5$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-11T22:02:10.614Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$4$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$068cbe93-6ca9-4ac6-bc7e-f6842acf2bb5$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-11T22:02:10.627Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$5$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$b5e60724-3d95-4a41-8657-f0bdf08c080b$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-11T23:02:10.792Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$6$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$b5e60724-3d95-4a41-8657-f0bdf08c080b$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-11T23:02:10.832Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$7$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2942e9bc-c9a1-46db-b6db-b86b555f52f3$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T00:02:10.978Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$8$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2942e9bc-c9a1-46db-b6db-b86b555f52f3$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T00:02:10.991Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$9$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$75d830b8-bb81-4284-8f7e-09d0350f326f$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T01:02:11.227Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$10$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$75d830b8-bb81-4284-8f7e-09d0350f326f$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T01:02:11.234Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$11$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$7b89525a-c54d-449f-be7a-4e606a7d1140$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T02:02:11.415Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$12$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$7b89525a-c54d-449f-be7a-4e606a7d1140$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T02:02:11.422Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$13$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$134f4a81-1ceb-42bb-867e-24aeeac50717$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T03:02:11.649Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$14$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$134f4a81-1ceb-42bb-867e-24aeeac50717$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T03:02:11.660Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$15$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$adc9ca5c-fc89-4508-a007-21feae9701e6$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T04:02:11.930Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$16$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$adc9ca5c-fc89-4508-a007-21feae9701e6$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T04:02:11.937Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$17$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$f9e10ce7-16e6-4b0b-943d-5fbe8cb98d93$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T05:02:12.089Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$18$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$f9e10ce7-16e6-4b0b-943d-5fbe8cb98d93$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T05:02:12.098Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$19$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$ded7f8c5-eb3e-4e33-b85f-bc466d906692$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T06:02:12.334Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$20$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$ded7f8c5-eb3e-4e33-b85f-bc466d906692$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T06:02:12.342Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$21$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$650b51e5-1746-4030-b05b-df7d3e6e2006$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:02:12.641Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$22$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$650b51e5-1746-4030-b05b-df7d3e6e2006$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T07:02:12.650Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$23$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$7e34f986-b2a4-4efb-a55b-4ee19d90fdae$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:14:21.034Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$24$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$7e34f986-b2a4-4efb-a55b-4ee19d90fdae$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T07:14:21.045Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$25$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$167227db-1c47-475e-b79f-38497f2ca7e4$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:19:22.408Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$26$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$167227db-1c47-475e-b79f-38497f2ca7e4$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T07:19:22.425Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$27$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$0df2efa0-14d9-4463-a543-49696a9c5b67$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:20:45.782Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$28$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$0df2efa0-14d9-4463-a543-49696a9c5b67$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T07:20:45.804Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$29$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$b4396483-417d-4db6-9768-dd0f6250d1f0$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:22:58.256Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$30$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$b4396483-417d-4db6-9768-dd0f6250d1f0$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T07:22:58.275Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$31$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$f8633c11-19aa-41ac-835a-8241c6eabbd8$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:24:01.059Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$32$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$f8633c11-19aa-41ac-835a-8241c6eabbd8$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T07:24:01.127Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$33$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$6adbc3ee-6369-4799-be0d-e3ce862fd4e0$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:24:09.763Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$34$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$6adbc3ee-6369-4799-be0d-e3ce862fd4e0$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$error$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip$2026-04-12T07:24:09.772Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$35$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$e78eb643-0eff-488f-997c-3430fc2a15ca$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:26:52.698Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$36$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$e78eb643-0eff-488f-997c-3430fc2a15ca$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"e78eb643-0eff-488f-997c-3430fc2a15ca","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"retry_failed_run","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are the CEO. Your job is to lead the company, not to do individual contributor work. You own strategy, prioritization, and cross-functional coordination.\n\nYour home directory is $AGENT_HOME. Everything personal to you -- life, memory, knowledge -- lives there. Other agents may have their own folders and you may update them when necessary.\n\nCompany-wide artifacts (plans, shared docs) live in the project root, outside your personal directory.\n\n## Delegation (critical)\n\nYou MUST delegate work rather than doing it yourself. When a task is assigned to you:\n\n1. **Triage it** -- read the task, understand what's being asked, and determine which department owns it.\n2. **Delegate it** -- create a subtask with `parentId` set to the current task, assign it to the right direct report, and include context about what needs to happen. Use these routing rules:\n   - **Code, bugs, features, infra, devtools, technical tasks** → CTO\n   - **Marketing, content, social media, growth, devrel** → CMO\n   - **UX, design, user research, design-system** → UXDesigner\n   - **Cross-functional or unclear** → break into separate subtasks for each department, or assign to the CTO if it's primarily technical with a design component\n   - If the right report doesn't exist yet, use the `paperclip-create-agent` skill to hire one before delegating.\n3. **Do NOT write code, implement features, or fix bugs yourself.** Your reports exist for this. Even if a task seems small or quick, delegate it.\n4. **Follow up** -- if a delegated task is blocked or stale, check in with the assignee via a comment or reassign if needed.\n\n## What you DO personally\n\n- Set priorities and make product decisions\n- Resolve cross-team conflicts or ambiguity\n- Communicate with the board (human users)\n- Approve or reject proposals from your reports\n- Hire new agents when the team needs capacity\n- Unblock your direct reports when they escalate to you\n\n## Keeping work moving\n\n- Don't let tasks sit idle. If you delegate something, check that it's progressing.\n- If a report is blocked, help unblock them -- escalate to the board if needed.\n- If the board asks you to do something and you're unsure who should own it, default to the CTO for technical work.\n- You must always update your task with a comment explaining what you did (e.g., who you delegated to and why).\n\n## Memory and Planning\n\nYou MUST use the `para-memory-files` skill for all memory operations: storing facts, writing daily notes, creating entities, running weekly synthesis, recalling past context, and managing plans. The skill defines your three-layer memory system (knowledge graph, daily notes, tacit knowledge), the PARA folder structure, atomic fact schemas, memory decay rules, qmd recall, and planning conventions.\n\nInvoke it whenever you need to remember, retrieve, or organize anything.\n\n## Safety Considerations\n\n- Never exfiltrate secrets or private data.\n- Do not perform any destructive commands unless explicitly requested by the board.\n\n## References\n\nThese files are essential. Read them.\n\n- `$AGENT_HOME/HEARTBEAT.md` -- execution and extraction checklist. Run every heartbeat.\n- `$AGENT_HOME/SOUL.md` -- who you are and how you should act.\n- `$AGENT_HOME/TOOLS.md` -- tools you have access to\n\n\nThe above agent instructions were loaded from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md. Resolve any relative file references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/.\n\nYou are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","-"],"commandNotes":["Loaded agent instructions from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","Prepended instructions + path directive to stdin prompt (relative references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/).","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":3721,"instructionsChars":3627,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:26:52.716Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$37$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$e78eb643-0eff-488f-997c-3430fc2a15ca$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:26:52.773Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$38$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$f2c16036-7175-40c1-9402-2b7f15f96f7b$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:28:16.310Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$39$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$f2c16036-7175-40c1-9402-2b7f15f96f7b$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"f2c16036-7175-40c1-9402-2b7f15f96f7b","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"retry_failed_run","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are the CEO. Your job is to lead the company, not to do individual contributor work. You own strategy, prioritization, and cross-functional coordination.\n\nYour home directory is $AGENT_HOME. Everything personal to you -- life, memory, knowledge -- lives there. Other agents may have their own folders and you may update them when necessary.\n\nCompany-wide artifacts (plans, shared docs) live in the project root, outside your personal directory.\n\n## Delegation (critical)\n\nYou MUST delegate work rather than doing it yourself. When a task is assigned to you:\n\n1. **Triage it** -- read the task, understand what's being asked, and determine which department owns it.\n2. **Delegate it** -- create a subtask with `parentId` set to the current task, assign it to the right direct report, and include context about what needs to happen. Use these routing rules:\n   - **Code, bugs, features, infra, devtools, technical tasks** → CTO\n   - **Marketing, content, social media, growth, devrel** → CMO\n   - **UX, design, user research, design-system** → UXDesigner\n   - **Cross-functional or unclear** → break into separate subtasks for each department, or assign to the CTO if it's primarily technical with a design component\n   - If the right report doesn't exist yet, use the `paperclip-create-agent` skill to hire one before delegating.\n3. **Do NOT write code, implement features, or fix bugs yourself.** Your reports exist for this. Even if a task seems small or quick, delegate it.\n4. **Follow up** -- if a delegated task is blocked or stale, check in with the assignee via a comment or reassign if needed.\n\n## What you DO personally\n\n- Set priorities and make product decisions\n- Resolve cross-team conflicts or ambiguity\n- Communicate with the board (human users)\n- Approve or reject proposals from your reports\n- Hire new agents when the team needs capacity\n- Unblock your direct reports when they escalate to you\n\n## Keeping work moving\n\n- Don't let tasks sit idle. If you delegate something, check that it's progressing.\n- If a report is blocked, help unblock them -- escalate to the board if needed.\n- If the board asks you to do something and you're unsure who should own it, default to the CTO for technical work.\n- You must always update your task with a comment explaining what you did (e.g., who you delegated to and why).\n\n## Memory and Planning\n\nYou MUST use the `para-memory-files` skill for all memory operations: storing facts, writing daily notes, creating entities, running weekly synthesis, recalling past context, and managing plans. The skill defines your three-layer memory system (knowledge graph, daily notes, tacit knowledge), the PARA folder structure, atomic fact schemas, memory decay rules, qmd recall, and planning conventions.\n\nInvoke it whenever you need to remember, retrieve, or organize anything.\n\n## Safety Considerations\n\n- Never exfiltrate secrets or private data.\n- Do not perform any destructive commands unless explicitly requested by the board.\n\n## References\n\nThese files are essential. Read them.\n\n- `$AGENT_HOME/HEARTBEAT.md` -- execution and extraction checklist. Run every heartbeat.\n- `$AGENT_HOME/SOUL.md` -- who you are and how you should act.\n- `$AGENT_HOME/TOOLS.md` -- tools you have access to\n\n\nThe above agent instructions were loaded from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md. Resolve any relative file references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/.\n\nYou are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","-"],"commandNotes":["Loaded agent instructions from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","Prepended instructions + path directive to stdin prompt (relative references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/).","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":3721,"instructionsChars":3627,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:28:16.366Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$40$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$f2c16036-7175-40c1-9402-2b7f15f96f7b$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:28:16.426Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$41$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2875d489-aae7-472f-924f-797280f06b6e$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:28:29.430Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$42$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2875d489-aae7-472f-924f-797280f06b6e$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"2875d489-aae7-472f-924f-797280f06b6e","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"retry_failed_run","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are the CEO. Your job is to lead the company, not to do individual contributor work. You own strategy, prioritization, and cross-functional coordination.\n\nYour home directory is $AGENT_HOME. Everything personal to you -- life, memory, knowledge -- lives there. Other agents may have their own folders and you may update them when necessary.\n\nCompany-wide artifacts (plans, shared docs) live in the project root, outside your personal directory.\n\n## Delegation (critical)\n\nYou MUST delegate work rather than doing it yourself. When a task is assigned to you:\n\n1. **Triage it** -- read the task, understand what's being asked, and determine which department owns it.\n2. **Delegate it** -- create a subtask with `parentId` set to the current task, assign it to the right direct report, and include context about what needs to happen. Use these routing rules:\n   - **Code, bugs, features, infra, devtools, technical tasks** → CTO\n   - **Marketing, content, social media, growth, devrel** → CMO\n   - **UX, design, user research, design-system** → UXDesigner\n   - **Cross-functional or unclear** → break into separate subtasks for each department, or assign to the CTO if it's primarily technical with a design component\n   - If the right report doesn't exist yet, use the `paperclip-create-agent` skill to hire one before delegating.\n3. **Do NOT write code, implement features, or fix bugs yourself.** Your reports exist for this. Even if a task seems small or quick, delegate it.\n4. **Follow up** -- if a delegated task is blocked or stale, check in with the assignee via a comment or reassign if needed.\n\n## What you DO personally\n\n- Set priorities and make product decisions\n- Resolve cross-team conflicts or ambiguity\n- Communicate with the board (human users)\n- Approve or reject proposals from your reports\n- Hire new agents when the team needs capacity\n- Unblock your direct reports when they escalate to you\n\n## Keeping work moving\n\n- Don't let tasks sit idle. If you delegate something, check that it's progressing.\n- If a report is blocked, help unblock them -- escalate to the board if needed.\n- If the board asks you to do something and you're unsure who should own it, default to the CTO for technical work.\n- You must always update your task with a comment explaining what you did (e.g., who you delegated to and why).\n\n## Memory and Planning\n\nYou MUST use the `para-memory-files` skill for all memory operations: storing facts, writing daily notes, creating entities, running weekly synthesis, recalling past context, and managing plans. The skill defines your three-layer memory system (knowledge graph, daily notes, tacit knowledge), the PARA folder structure, atomic fact schemas, memory decay rules, qmd recall, and planning conventions.\n\nInvoke it whenever you need to remember, retrieve, or organize anything.\n\n## Safety Considerations\n\n- Never exfiltrate secrets or private data.\n- Do not perform any destructive commands unless explicitly requested by the board.\n\n## References\n\nThese files are essential. Read them.\n\n- `$AGENT_HOME/HEARTBEAT.md` -- execution and extraction checklist. Run every heartbeat.\n- `$AGENT_HOME/SOUL.md` -- who you are and how you should act.\n- `$AGENT_HOME/TOOLS.md` -- tools you have access to\n\n\nThe above agent instructions were loaded from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md. Resolve any relative file references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/.\n\nYou are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","-"],"commandNotes":["Loaded agent instructions from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","Prepended instructions + path directive to stdin prompt (relative references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/).","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":3721,"instructionsChars":3627,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:28:29.436Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$43$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2875d489-aae7-472f-924f-797280f06b6e$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:28:29.487Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$44$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$11a73508-baac-4c65-aaa7-682f22662eb7$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:29:29.174Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$45$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$11a73508-baac-4c65-aaa7-682f22662eb7$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"11a73508-baac-4c65-aaa7-682f22662eb7","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"retry_failed_run","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are the CEO. Your job is to lead the company, not to do individual contributor work. You own strategy, prioritization, and cross-functional coordination.\n\nYour home directory is $AGENT_HOME. Everything personal to you -- life, memory, knowledge -- lives there. Other agents may have their own folders and you may update them when necessary.\n\nCompany-wide artifacts (plans, shared docs) live in the project root, outside your personal directory.\n\n## Delegation (critical)\n\nYou MUST delegate work rather than doing it yourself. When a task is assigned to you:\n\n1. **Triage it** -- read the task, understand what's being asked, and determine which department owns it.\n2. **Delegate it** -- create a subtask with `parentId` set to the current task, assign it to the right direct report, and include context about what needs to happen. Use these routing rules:\n   - **Code, bugs, features, infra, devtools, technical tasks** → CTO\n   - **Marketing, content, social media, growth, devrel** → CMO\n   - **UX, design, user research, design-system** → UXDesigner\n   - **Cross-functional or unclear** → break into separate subtasks for each department, or assign to the CTO if it's primarily technical with a design component\n   - If the right report doesn't exist yet, use the `paperclip-create-agent` skill to hire one before delegating.\n3. **Do NOT write code, implement features, or fix bugs yourself.** Your reports exist for this. Even if a task seems small or quick, delegate it.\n4. **Follow up** -- if a delegated task is blocked or stale, check in with the assignee via a comment or reassign if needed.\n\n## What you DO personally\n\n- Set priorities and make product decisions\n- Resolve cross-team conflicts or ambiguity\n- Communicate with the board (human users)\n- Approve or reject proposals from your reports\n- Hire new agents when the team needs capacity\n- Unblock your direct reports when they escalate to you\n\n## Keeping work moving\n\n- Don't let tasks sit idle. If you delegate something, check that it's progressing.\n- If a report is blocked, help unblock them -- escalate to the board if needed.\n- If the board asks you to do something and you're unsure who should own it, default to the CTO for technical work.\n- You must always update your task with a comment explaining what you did (e.g., who you delegated to and why).\n\n## Memory and Planning\n\nYou MUST use the `para-memory-files` skill for all memory operations: storing facts, writing daily notes, creating entities, running weekly synthesis, recalling past context, and managing plans. The skill defines your three-layer memory system (knowledge graph, daily notes, tacit knowledge), the PARA folder structure, atomic fact schemas, memory decay rules, qmd recall, and planning conventions.\n\nInvoke it whenever you need to remember, retrieve, or organize anything.\n\n## Safety Considerations\n\n- Never exfiltrate secrets or private data.\n- Do not perform any destructive commands unless explicitly requested by the board.\n\n## References\n\nThese files are essential. Read them.\n\n- `$AGENT_HOME/HEARTBEAT.md` -- execution and extraction checklist. Run every heartbeat.\n- `$AGENT_HOME/SOUL.md` -- who you are and how you should act.\n- `$AGENT_HOME/TOOLS.md` -- tools you have access to\n\n\nThe above agent instructions were loaded from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md. Resolve any relative file references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/.\n\nYou are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","-"],"commandNotes":["Loaded agent instructions from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","Prepended instructions + path directive to stdin prompt (relative references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/).","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":3721,"instructionsChars":3627,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:29:29.191Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$46$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$11a73508-baac-4c65-aaa7-682f22662eb7$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:29:45.508Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$47$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$8240f42d-fbca-4fa2-9fa4-6d4927bfd289$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:32:17.820Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$48$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$8240f42d-fbca-4fa2-9fa4-6d4927bfd289$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"8240f42d-fbca-4fa2-9fa4-6d4927bfd289","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"retry_failed_run","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are the CEO. Your job is to lead the company, not to do individual contributor work. You own strategy, prioritization, and cross-functional coordination.\n\nYour home directory is $AGENT_HOME. Everything personal to you -- life, memory, knowledge -- lives there. Other agents may have their own folders and you may update them when necessary.\n\nCompany-wide artifacts (plans, shared docs) live in the project root, outside your personal directory.\n\n## Delegation (critical)\n\nYou MUST delegate work rather than doing it yourself. When a task is assigned to you:\n\n1. **Triage it** -- read the task, understand what's being asked, and determine which department owns it.\n2. **Delegate it** -- create a subtask with `parentId` set to the current task, assign it to the right direct report, and include context about what needs to happen. Use these routing rules:\n   - **Code, bugs, features, infra, devtools, technical tasks** → CTO\n   - **Marketing, content, social media, growth, devrel** → CMO\n   - **UX, design, user research, design-system** → UXDesigner\n   - **Cross-functional or unclear** → break into separate subtasks for each department, or assign to the CTO if it's primarily technical with a design component\n   - If the right report doesn't exist yet, use the `paperclip-create-agent` skill to hire one before delegating.\n3. **Do NOT write code, implement features, or fix bugs yourself.** Your reports exist for this. Even if a task seems small or quick, delegate it.\n4. **Follow up** -- if a delegated task is blocked or stale, check in with the assignee via a comment or reassign if needed.\n\n## What you DO personally\n\n- Set priorities and make product decisions\n- Resolve cross-team conflicts or ambiguity\n- Communicate with the board (human users)\n- Approve or reject proposals from your reports\n- Hire new agents when the team needs capacity\n- Unblock your direct reports when they escalate to you\n\n## Keeping work moving\n\n- Don't let tasks sit idle. If you delegate something, check that it's progressing.\n- If a report is blocked, help unblock them -- escalate to the board if needed.\n- If the board asks you to do something and you're unsure who should own it, default to the CTO for technical work.\n- You must always update your task with a comment explaining what you did (e.g., who you delegated to and why).\n\n## Memory and Planning\n\nYou MUST use the `para-memory-files` skill for all memory operations: storing facts, writing daily notes, creating entities, running weekly synthesis, recalling past context, and managing plans. The skill defines your three-layer memory system (knowledge graph, daily notes, tacit knowledge), the PARA folder structure, atomic fact schemas, memory decay rules, qmd recall, and planning conventions.\n\nInvoke it whenever you need to remember, retrieve, or organize anything.\n\n## Safety Considerations\n\n- Never exfiltrate secrets or private data.\n- Do not perform any destructive commands unless explicitly requested by the board.\n\n## References\n\nThese files are essential. Read them.\n\n- `$AGENT_HOME/HEARTBEAT.md` -- execution and extraction checklist. Run every heartbeat.\n- `$AGENT_HOME/SOUL.md` -- who you are and how you should act.\n- `$AGENT_HOME/TOOLS.md` -- tools you have access to\n\n\nThe above agent instructions were loaded from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md. Resolve any relative file references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/.\n\nYou are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","resume","019d8098-78cb-7960-8c41-c2c2cdb3b812","-"],"commandNotes":["Loaded agent instructions from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","Prepended instructions + path directive to stdin prompt (relative references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/).","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":3721,"instructionsChars":3627,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:32:17.831Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$49$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$8240f42d-fbca-4fa2-9fa4-6d4927bfd289$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:32:48.834Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$50$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$a7ae4206-a3ec-4053-8835-007a22f6ffbc$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:34:05.308Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$51$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$a7ae4206-a3ec-4053-8835-007a22f6ffbc$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"a7ae4206-a3ec-4053-8835-007a22f6ffbc","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"retry_failed_run","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are the CEO. Your job is to lead the company, not to do individual contributor work. You own strategy, prioritization, and cross-functional coordination.\n\nYour home directory is $AGENT_HOME. Everything personal to you -- life, memory, knowledge -- lives there. Other agents may have their own folders and you may update them when necessary.\n\nCompany-wide artifacts (plans, shared docs) live in the project root, outside your personal directory.\n\n## Delegation (critical)\n\nYou MUST delegate work rather than doing it yourself. When a task is assigned to you:\n\n1. **Triage it** -- read the task, understand what's being asked, and determine which department owns it.\n2. **Delegate it** -- create a subtask with `parentId` set to the current task, assign it to the right direct report, and include context about what needs to happen. Use these routing rules:\n   - **Code, bugs, features, infra, devtools, technical tasks** → CTO\n   - **Marketing, content, social media, growth, devrel** → CMO\n   - **UX, design, user research, design-system** → UXDesigner\n   - **Cross-functional or unclear** → break into separate subtasks for each department, or assign to the CTO if it's primarily technical with a design component\n   - If the right report doesn't exist yet, use the `paperclip-create-agent` skill to hire one before delegating.\n3. **Do NOT write code, implement features, or fix bugs yourself.** Your reports exist for this. Even if a task seems small or quick, delegate it.\n4. **Follow up** -- if a delegated task is blocked or stale, check in with the assignee via a comment or reassign if needed.\n\n## What you DO personally\n\n- Set priorities and make product decisions\n- Resolve cross-team conflicts or ambiguity\n- Communicate with the board (human users)\n- Approve or reject proposals from your reports\n- Hire new agents when the team needs capacity\n- Unblock your direct reports when they escalate to you\n\n## Keeping work moving\n\n- Don't let tasks sit idle. If you delegate something, check that it's progressing.\n- If a report is blocked, help unblock them -- escalate to the board if needed.\n- If the board asks you to do something and you're unsure who should own it, default to the CTO for technical work.\n- You must always update your task with a comment explaining what you did (e.g., who you delegated to and why).\n\n## Memory and Planning\n\nYou MUST use the `para-memory-files` skill for all memory operations: storing facts, writing daily notes, creating entities, running weekly synthesis, recalling past context, and managing plans. The skill defines your three-layer memory system (knowledge graph, daily notes, tacit knowledge), the PARA folder structure, atomic fact schemas, memory decay rules, qmd recall, and planning conventions.\n\nInvoke it whenever you need to remember, retrieve, or organize anything.\n\n## Safety Considerations\n\n- Never exfiltrate secrets or private data.\n- Do not perform any destructive commands unless explicitly requested by the board.\n\n## References\n\nThese files are essential. Read them.\n\n- `$AGENT_HOME/HEARTBEAT.md` -- execution and extraction checklist. Run every heartbeat.\n- `$AGENT_HOME/SOUL.md` -- who you are and how you should act.\n- `$AGENT_HOME/TOOLS.md` -- tools you have access to\n\n\nThe above agent instructions were loaded from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md. Resolve any relative file references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/.\n\nYou are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","resume","019d8098-78cb-7960-8c41-c2c2cdb3b812","-"],"commandNotes":["Loaded agent instructions from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md","Prepended instructions + path directive to stdin prompt (relative references from /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/).","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":3721,"instructionsChars":3627,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:34:05.318Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$52$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$a7ae4206-a3ec-4053-8835-007a22f6ffbc$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:34:05.453Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$53$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c2cb04d3-a8be-4c70-8878-3514dd9d43a2$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:35:10.177Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$54$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c2cb04d3-a8be-4c70-8878-3514dd9d43a2$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"c2cb04d3-a8be-4c70-8878-3514dd9d43a2","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","resume","019d8098-78cb-7960-8c41-c2c2cdb3b812","-"],"commandNotes":["Configured instructionsFilePath /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md, but file could not be read; continuing without injected instructions.","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":94,"instructionsChars":0,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:35:10.191Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$55$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c2cb04d3-a8be-4c70-8878-3514dd9d43a2$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:35:10.310Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$56$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c7df6b60-74b8-438f-a758-556454680861$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:35:19.838Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$57$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c7df6b60-74b8-438f-a758-556454680861$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"c7df6b60-74b8-438f-a758-556454680861","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"retry_failed_run","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","resume","019d8098-78cb-7960-8c41-c2c2cdb3b812","-"],"commandNotes":["Configured instructionsFilePath /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md, but file could not be read; continuing without injected instructions.","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":94,"instructionsChars":0,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:35:19.847Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$58$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c7df6b60-74b8-438f-a758-556454680861$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:35:19.951Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$59$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$da80c1c0-e9e4-42eb-8722-6d97fb0c3dbf$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:42:28.936Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$60$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$da80c1c0-e9e4-42eb-8722-6d97fb0c3dbf$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"da80c1c0-e9e4-42eb-8722-6d97fb0c3dbf","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","resume","019d8098-78cb-7960-8c41-c2c2cdb3b812","-"],"commandNotes":["Configured instructionsFilePath /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md, but file could not be read; continuing without injected instructions.","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":94,"instructionsChars":0,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:42:28.951Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$61$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$da80c1c0-e9e4-42eb-8722-6d97fb0c3dbf$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:42:29.066Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$62$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$6f924eeb-25ca-4f77-bed1-2d6f4ff06744$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:48:14.229Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$63$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$6f924eeb-25ca-4f77-bed1-2d6f4ff06744$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"6f924eeb-25ca-4f77-bed1-2d6f4ff06744","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","resume","019d8098-78cb-7960-8c41-c2c2cdb3b812","-"],"commandNotes":["Configured instructionsFilePath /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md, but file could not be read; continuing without injected instructions.","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":94,"instructionsChars":0,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:48:14.237Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$64$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$6f924eeb-25ca-4f77-bed1-2d6f4ff06744$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:48:14.351Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$65$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$a6fa23be-eb87-426a-b8f0-23186ca42094$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:51:08.141Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$108$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$9aceaafc-1f19-411e-986e-7ab3e763ad4a$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:46:17.049Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$66$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$a6fa23be-eb87-426a-b8f0-23186ca42094$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"a6fa23be-eb87-426a-b8f0-23186ca42094","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"retry_failed_run","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","resume","019d8098-78cb-7960-8c41-c2c2cdb3b812","-"],"commandNotes":["Configured instructionsFilePath /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md, but file could not be read; continuing without injected instructions.","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":94,"instructionsChars":0,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:51:08.151Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$67$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$a6fa23be-eb87-426a-b8f0-23186ca42094$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:51:08.261Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$68$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$9c59ceb9-e27f-40e2-a80c-afd017e1f4cc$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T07:53:42.217Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$69$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$9c59ceb9-e27f-40e2-a80c-afd017e1f4cc$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"9c59ceb9-e27f-40e2-a80c-afd017e1f4cc","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"retry_failed_run","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","resume","019d8098-78cb-7960-8c41-c2c2cdb3b812","-"],"commandNotes":["Configured instructionsFilePath /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md, but file could not be read; continuing without injected instructions.","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":94,"instructionsChars":0,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T07:53:42.233Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$70$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$9c59ceb9-e27f-40e2-a80c-afd017e1f4cc$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T07:53:42.348Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$71$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$b475626d-ac07-4ccf-a587-647186180b93$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T08:53:43.226Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$72$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$b475626d-ac07-4ccf-a587-647186180b93$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","PAPERCLIP_RUN_ID":"b475626d-ac07-4ccf-a587-647186180b93","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"heartbeat_timer","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"agent_home","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"now":"2026-04-12T08:53:43.170Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","-"],"commandNotes":["Configured instructionsFilePath /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md, but file could not be read; continuing without injected instructions.","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":94,"instructionsChars":0,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T08:53:43.241Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$73$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$b475626d-ac07-4ccf-a587-647186180b93$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T08:54:13.963Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$74$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$4d3b607f-4cea-415d-9e23-21dd3cee54b1$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T09:54:58.397Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$75$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$4d3b607f-4cea-415d-9e23-21dd3cee54b1$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","CODEX_OFFLINE":"true","CODEX_PROTOCOL":"rest","OPENAI_API_KEY":"***REDACTED***","OPENAI_API_BASE":"http://127.0.0.1:11434","PAPERCLIP_RUN_ID":"4d3b607f-4cea-415d-9e23-21dd3cee54b1","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"heartbeat_timer","CODEX_SKIP_PATH_UPDATE":"true","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"task_session","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"now":"2026-04-12T09:54:58.317Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"task_session","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","--config /root/.codex/config.toml","resume","019d80e5-972f-79d3-ba57-960a9a1bd8c4","-"],"commandNotes":["Configured instructionsFilePath /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md, but file could not be read; continuing without injected instructions.","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":94,"instructionsChars":0,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T09:54:58.408Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$76$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$4d3b607f-4cea-415d-9e23-21dd3cee54b1$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":2}$paperclip$, $paperclip$2026-04-12T09:54:58.471Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$77$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$275d85c6-6730-452a-9355-5ac06295c5af$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T10:54:58.602Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$78$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$275d85c6-6730-452a-9355-5ac06295c5af$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","CODEX_OFFLINE":"true","CODEX_PROTOCOL":"rest","OPENAI_API_KEY":"***REDACTED***","OPENAI_API_BASE":"http://127.0.0.1:11434","PAPERCLIP_RUN_ID":"275d85c6-6730-452a-9355-5ac06295c5af","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"heartbeat_timer","CODEX_SKIP_PATH_UPDATE":"true","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"task_session","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"now":"2026-04-12T10:54:58.560Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"task_session","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","--config /root/.codex/config.toml","resume","019d80e5-972f-79d3-ba57-960a9a1bd8c4","-"],"commandNotes":["Configured instructionsFilePath /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md, but file could not be read; continuing without injected instructions.","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":94,"instructionsChars":0,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T10:54:58.615Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$79$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$275d85c6-6730-452a-9355-5ac06295c5af$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":2}$paperclip$, $paperclip$2026-04-12T10:54:58.731Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$80$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c3dcf50a-5978-42d7-856a-e69699f1aaf6$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T11:55:28.768Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$81$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c3dcf50a-5978-42d7-856a-e69699f1aaf6$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$adapter.invoke$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$adapter invocation$paperclip$, $paperclip${"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","env":{"HOME":"/root","AGENT_HOME":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","CODEX_HOME":"/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home","OPENAI_API_KEY":"***REDACTED***","OPENAI_API_BASE":"http://127.0.0.1:4000/v1","PAPERCLIP_RUN_ID":"c3dcf50a-5978-42d7-856a-e69699f1aaf6","PAPERCLIP_API_KEY":"***REDACTED***","PAPERCLIP_API_URL":"http://46.225.0.132:22303","PAPERCLIP_AGENT_ID":"2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_COMPANY_ID":"613da0c8-8f6a-41f5-9a81-f6272721e383","PAPERCLIP_WAKE_REASON":"heartbeat_timer","PAPERCLIP_WORKSPACE_CWD":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","PAPERCLIP_RESOLVED_COMMAND":"/usr/bin/codex","PAPERCLIP_WORKSPACE_SOURCE":"task_session","PAPERCLIP_WORKSPACE_STRATEGY":"project_primary"},"prompt":"You are agent 2b72e8ff-73f4-40fa-a123-960faf668d7c (Chulo(CEO)). Continue your Paperclip work.","command":"/usr/bin/codex","context":{"now":"2026-04-12T11:55:28.721Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"task_session","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]},"adapterType":"codex_local","commandArgs":["exec","--json","--dangerously-bypass-approvals-and-sandbox","--model","gpt-5.3-codex","resume","019d80e5-972f-79d3-ba57-960a9a1bd8c4","-"],"commandNotes":["Configured instructionsFilePath /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md, but file could not be read; continuing without injected instructions.","Codex exec automatically applies repo-scoped AGENTS.md instructions from the current workspace; Paperclip does not currently suppress that discovery."],"promptMetrics":{"promptChars":94,"instructionsChars":0,"sessionHandoffChars":0,"bootstrapPromptChars":0,"heartbeatPromptChars":94}}$paperclip$, $paperclip$2026-04-12T11:55:28.778Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$82$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c3dcf50a-5978-42d7-856a-e69699f1aaf6$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 3, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T11:55:48.707Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$83$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$7045eef0-61bd-4fb1-a8ed-edd95c8c0558$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:16:45.164Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$84$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$7045eef0-61bd-4fb1-a8ed-edd95c8c0558$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:16:45.336Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$85$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$cb2e7ba3-166f-41da-9106-641b349880d8$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:20:24.319Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$86$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$cb2e7ba3-166f-41da-9106-641b349880d8$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:20:24.489Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$87$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$84a851eb-efb4-4ccc-9eb8-9f443a64e1ab$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:22:45.894Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$88$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$84a851eb-efb4-4ccc-9eb8-9f443a64e1ab$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:22:46.170Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$89$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$d672bebe-2543-4597-a268-913c27bc0e0f$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:24:53.751Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$90$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$d672bebe-2543-4597-a268-913c27bc0e0f$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:24:54.086Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$91$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$348a1162-d807-4318-93e6-6a45082a3033$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:31:18.110Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$92$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$348a1162-d807-4318-93e6-6a45082a3033$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:31:18.570Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$93$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$5eaf2c55-0e04-49ca-86a8-f977730bb3c6$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:32:21.623Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$94$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$5eaf2c55-0e04-49ca-86a8-f977730bb3c6$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:32:22.503Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$95$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$e107e9d4-7e38-4cb8-b19e-80803dcf37af$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:33:25.099Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$96$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$e107e9d4-7e38-4cb8-b19e-80803dcf37af$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:33:26.705Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$97$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$d29ce65f-0a4d-4d99-906a-db1f25750e29$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:37:24.868Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$98$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$d29ce65f-0a4d-4d99-906a-db1f25750e29$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:37:26.198Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$99$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2285a812-43c5-49f5-ae18-e2b21a01e1fe$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:37:51.476Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$100$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2285a812-43c5-49f5-ae18-e2b21a01e1fe$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:37:52.683Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$101$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$902baa9c-94a0-427f-ad0e-92086c16f3db$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:38:02.735Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$102$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$902baa9c-94a0-427f-ad0e-92086c16f3db$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:38:04.000Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$103$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$09d318dc-189d-4b08-a19c-c9249f461dc8$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:42:29.912Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$104$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$09d318dc-189d-4b08-a19c-c9249f461dc8$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:42:31.290Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$105$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$3734032c-bf64-414b-8678-39a701c5a6ea$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:42:55.276Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$106$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$3734032c-bf64-414b-8678-39a701c5a6ea$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T12:42:56.566Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$107$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$9aceaafc-1f19-411e-986e-7ab3e763ad4a$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T12:46:16.149Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$109$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2f0ee8c1-06b3-4fb0-a89d-5e5debeb68fc$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T13:46:29.116Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$110$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2f0ee8c1-06b3-4fb0-a89d-5e5debeb68fc$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T13:46:30.104Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$111$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$356523d9-0d5c-4477-9599-f15afe51b87c$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T14:46:59.371Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$112$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$356523d9-0d5c-4477-9599-f15afe51b87c$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T14:47:00.316Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$113$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$e612b9c3-da58-47de-bbf4-af432867447b$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T15:47:29.582Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$114$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$e612b9c3-da58-47de-bbf4-af432867447b$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T15:47:30.537Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$115$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$9018e79b-ffb5-4ebb-afb9-e0d4bbb65e68$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T16:47:59.767Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$116$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$9018e79b-ffb5-4ebb-afb9-e0d4bbb65e68$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T16:48:00.744Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$117$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$3afd74a2-c61f-4daa-ac96-2e5970b563b7$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T17:48:30.026Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$118$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$3afd74a2-c61f-4daa-ac96-2e5970b563b7$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T17:48:30.937Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$119$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$5952dba4-e175-4a3a-9491-b83af1f122ee$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T18:49:00.191Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$120$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$5952dba4-e175-4a3a-9491-b83af1f122ee$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T18:49:01.203Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$121$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$34d696c1-ac0b-412a-a33e-2b553f6a450c$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T19:49:30.448Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$122$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$34d696c1-ac0b-412a-a33e-2b553f6a450c$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T19:49:31.309Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$123$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$9af64ba0-04d9-49d1-aedc-4cad4a5879d7$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T20:50:00.667Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$124$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$9af64ba0-04d9-49d1-aedc-4cad4a5879d7$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T20:50:01.640Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$125$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$726086fe-1afa-47b8-ba5e-1f65c07a67aa$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T21:50:30.908Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$126$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$726086fe-1afa-47b8-ba5e-1f65c07a67aa$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T21:50:31.862Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$127$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$70dadcce-01a7-4d69-a61f-cfd1d4caa169$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T22:51:01.124Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$128$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$70dadcce-01a7-4d69-a61f-cfd1d4caa169$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T22:51:02.015Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$129$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c7caaed8-aa92-4ce9-a785-0b5fbc98c9b2$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-12T23:51:31.350Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$130$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$c7caaed8-aa92-4ce9-a785-0b5fbc98c9b2$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-12T23:51:32.143Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$131$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$742d5909-f91e-4fe0-9ddd-7fb079a4bb4b$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-13T00:52:01.570Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$132$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$742d5909-f91e-4fe0-9ddd-7fb079a4bb4b$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-13T00:52:02.394Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$133$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$b738d214-285a-442a-8fdc-c987f03074fd$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-13T01:52:31.783Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$134$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$b738d214-285a-442a-8fdc-c987f03074fd$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-13T01:52:32.642Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$135$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$4f28e098-01e9-4a9f-acda-990ac4878ecd$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-13T02:53:02.087Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$136$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$4f28e098-01e9-4a9f-acda-990ac4878ecd$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-13T02:53:02.912Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$137$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$cde7245e-b4c9-4c3e-960d-7bd4fb5f2f09$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-13T03:53:32.285Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$138$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$cde7245e-b4c9-4c3e-960d-7bd4fb5f2f09$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-13T03:53:33.168Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$139$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$efb9acc4-d3a2-41a2-8912-682eb9597b9a$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-13T04:54:02.510Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$140$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$efb9acc4-d3a2-41a2-8912-682eb9597b9a$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-13T04:54:03.354Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$141$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$f3329d57-0740-4891-bb10-97925b9a73f5$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-13T05:54:32.797Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$142$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$f3329d57-0740-4891-bb10-97925b9a73f5$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-13T05:54:33.747Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$143$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$3a1cb5d4-d4cf-464c-af04-041370ac8eec$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 1, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$info$paperclip$, NULL, $paperclip$run started$paperclip$, NULL, $paperclip$2026-04-13T06:55:02.983Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_run_events" ("id", "company_id", "run_id", "agent_id", "seq", "event_type", "stream", "level", "color", "message", "payload", "created_at") VALUES ($paperclip$144$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$3a1cb5d4-d4cf-464c-af04-041370ac8eec$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, 2, $paperclip$lifecycle$paperclip$, $paperclip$system$paperclip$, $paperclip$error$paperclip$, NULL, $paperclip$run failed$paperclip$, $paperclip${"status":"failed","exitCode":1}$paperclip$, $paperclip$2026-04-13T06:55:03.902Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.heartbeat_runs (64 rows)
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$068cbe93-6ca9-4ac6-bc7e-f6842acf2bb5$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-11T22:02:10.588Z$paperclip$, $paperclip$2026-04-11T22:02:10.621Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"now":"2026-04-11T22:02:10.536Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-11T22:02:10.580Z$paperclip$, $paperclip$2026-04-11T22:02:10.621Z$paperclip$, $paperclip$system$paperclip$, $paperclip$227ae65e-bcc5-4701-b45c-581f0eb6f569$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/068cbe93-6ca9-4ac6-bc7e-f6842acf2bb5.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$9c7fbea3f34a533b0fe0a2e31d46a9b6083dbe823014a477b520e055cce360ef$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$ae7bde7c-7cfa-47fa-ba42-770f6f131fa7$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$assignment$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-11T21:01:51.951Z$paperclip$, $paperclip$2026-04-11T21:01:52.066Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"source":"issue.create","taskId":"1fb189f4-9819-4177-94e2-9f08c0e37091","issueId":"1fb189f4-9819-4177-94e2-9f08c0e37091","taskKey":"1fb189f4-9819-4177-94e2-9f08c0e37091","projectId":"15e44c3d-527b-4d86-90f8-04d926928a3a","wakeReason":"issue_assigned","wakeSource":"assignment","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/projects/613da0c8-8f6a-41f5-9a81-f6272721e383/15e44c3d-527b-4d86-90f8-04d926928a3a/_default","mode":"shared_workspace","source":"project_primary","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":"15e44c3d-527b-4d86-90f8-04d926928a3a","branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[],"executionWorkspaceId":"0b447ff2-5710-44b7-b372-d9a5891bf5be"}$paperclip$, $paperclip$2026-04-11T21:01:51.939Z$paperclip$, $paperclip$2026-04-11T21:01:52.066Z$paperclip$, $paperclip$system$paperclip$, $paperclip$500a7c43-7e18-4171-b1eb-8d4926baac95$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/ae7bde7c-7cfa-47fa-ba42-770f6f131fa7.ndjson$paperclip$, $paperclip$1334$paperclip$, $paperclip$46df2002b81ee743269f8b04548fef4c4a60d09d54331e86fe213afc222cadc8$paperclip$, false, $paperclip$[paperclip] Skipping saved session resume for task "1fb189f4-9819-4177-94e2-9f08c0e37091" because wake reason is issue_assigned.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Injected Codex skill "paperclip" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "paperclip-create-agent" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "paperclip-create-plugin" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "para-memory-files" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$b5e60724-3d95-4a41-8657-f0bdf08c080b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-11T23:02:10.760Z$paperclip$, $paperclip$2026-04-11T23:02:10.830Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"now":"2026-04-11T23:02:10.740Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-11T23:02:10.755Z$paperclip$, $paperclip$2026-04-11T23:02:10.830Z$paperclip$, $paperclip$system$paperclip$, $paperclip$f57cc3db-2a35-4d5d-9d68-d7fdb500707e$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/b5e60724-3d95-4a41-8657-f0bdf08c080b.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$6a06170cf0c49fd480b689d16a878dceb836a7c28fb16ea2a812a4184e5c8fc8$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$f9e10ce7-16e6-4b0b-943d-5fbe8cb98d93$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T05:02:12.064Z$paperclip$, $paperclip$2026-04-12T05:02:12.095Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"now":"2026-04-12T05:02:12.047Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T05:02:12.057Z$paperclip$, $paperclip$2026-04-12T05:02:12.095Z$paperclip$, $paperclip$system$paperclip$, $paperclip$59d8e3b2-888d-4cb7-a429-2fa04ab2b9c2$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/f9e10ce7-16e6-4b0b-943d-5fbe8cb98d93.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$7e3c92cf0c704947a276c5a4b1f8e069a3b78b30a61c9fa8f7fb6f7bff49ae60$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$2942e9bc-c9a1-46db-b6db-b86b555f52f3$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T00:02:10.954Z$paperclip$, $paperclip$2026-04-12T00:02:10.988Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"now":"2026-04-12T00:02:10.935Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T00:02:10.946Z$paperclip$, $paperclip$2026-04-12T00:02:10.988Z$paperclip$, $paperclip$system$paperclip$, $paperclip$68436e1d-6a77-4d81-bb20-b6e3ed9292a9$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/2942e9bc-c9a1-46db-b6db-b86b555f52f3.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$ca35361afd4502901ea928108303eebb17a7357fc0d6a0ea63fc52bf1e594c22$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$7b89525a-c54d-449f-be7a-4e606a7d1140$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T02:02:11.393Z$paperclip$, $paperclip$2026-04-12T02:02:11.420Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"now":"2026-04-12T02:02:11.375Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T02:02:11.387Z$paperclip$, $paperclip$2026-04-12T02:02:11.420Z$paperclip$, $paperclip$system$paperclip$, $paperclip$c7c28a7d-a946-4848-a5ba-bf0240e4ffff$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/7b89525a-c54d-449f-be7a-4e606a7d1140.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$ca25aee35eae8f7c24c9c47c41c7d07969a7979cd674ab564be8dab7dd6fff5b$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$75d830b8-bb81-4284-8f7e-09d0350f326f$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T01:02:11.207Z$paperclip$, $paperclip$2026-04-12T01:02:11.232Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"now":"2026-04-12T01:02:11.182Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T01:02:11.197Z$paperclip$, $paperclip$2026-04-12T01:02:11.232Z$paperclip$, $paperclip$system$paperclip$, $paperclip$732c2044-c257-4cc2-97e9-aecfaceaefc6$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/75d830b8-bb81-4284-8f7e-09d0350f326f.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$3d55c7a71416f21d9ff4e18be999efe8df0fb7b845824efe737d4c02a2ed26f9$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$134f4a81-1ceb-42bb-867e-24aeeac50717$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T03:02:11.628Z$paperclip$, $paperclip$2026-04-12T03:02:11.658Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"now":"2026-04-12T03:02:11.612Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T03:02:11.620Z$paperclip$, $paperclip$2026-04-12T03:02:11.658Z$paperclip$, $paperclip$system$paperclip$, $paperclip$ad56dc45-dfe8-4a21-8945-a189297a4e45$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/134f4a81-1ceb-42bb-867e-24aeeac50717.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$825f00f37e38f1b81e500542f9e235e6bf06bfa9f77c1b7062ecf7258dfa918f$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$adc9ca5c-fc89-4508-a007-21feae9701e6$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T04:02:11.899Z$paperclip$, $paperclip$2026-04-12T04:02:11.935Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"now":"2026-04-12T04:02:11.851Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T04:02:11.859Z$paperclip$, $paperclip$2026-04-12T04:02:11.935Z$paperclip$, $paperclip$system$paperclip$, $paperclip$2fdca7a9-f515-4f5a-88aa-735e6bfb5069$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/adc9ca5c-fc89-4508-a007-21feae9701e6.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$12a2db23327994d08773fbc414b350d8e84ad94e92e7204c9de8cc915f7c694f$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$ded7f8c5-eb3e-4e33-b85f-bc466d906692$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T06:02:12.316Z$paperclip$, $paperclip$2026-04-12T06:02:12.340Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"now":"2026-04-12T06:02:12.303Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T06:02:12.311Z$paperclip$, $paperclip$2026-04-12T06:02:12.340Z$paperclip$, $paperclip$system$paperclip$, $paperclip$66a22eed-6530-4a30-a133-493d298edbd4$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/ded7f8c5-eb3e-4e33-b85f-bc466d906692.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$62ade2442fd7e87186fdbbb2831c345666f6dd2d95fc5c0a0867b6ae84cdf8f1$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$5eaf2c55-0e04-49ca-86a8-f977730bb3c6$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:32:21.605Z$paperclip$, $paperclip$2026-04-12T12:32:22.498Z$paperclip$, $paperclip$Traceback (most recent call last):
ModuleNotFoundError: No module named 'fire'$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:32:21.599Z$paperclip$, $paperclip$2026-04-12T12:32:22.498Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$cda46d5d-42b6-4e1e-9c75-6ba9639751e3$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/5eaf2c55-0e04-49ca-86a8-f977730bb3c6.ndjson$paperclip$, $paperclip$1273$paperclip$, $paperclip$0093d7531aaef3fa6ae196b85c4449cb1b3f7413ae537a937fc49e24cf08fe4b$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$Traceback (most recent call last):
  File "/usr/bin/hermes.real", line 11, in <module>
    main()
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 5923, in main
    args.func(args)
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 758, in cmd_chat
    from cli import main as cli_main
  File "/opt/hermes/hermes-agent/cli.py", line 573, in <module>
    import fire
ModuleNotFoundError: No module named 'fire'
$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$7e34f986-b2a4-4efb-a55b-4ee19d90fdae$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:14:21.003Z$paperclip$, $paperclip$2026-04-12T07:14:21.042Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:14:20.996Z$paperclip$, $paperclip$2026-04-12T07:14:21.042Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$2e309aa8-2538-48c2-94a5-c2b3f521cd6a$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/7e34f986-b2a4-4efb-a55b-4ee19d90fdae.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$cbab4566cefe5f6f372eef847ed38ad5096667769b8949964adde326768888c9$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$e612b9c3-da58-47de-bbf4-af432867447b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T15:47:29.551Z$paperclip$, $paperclip$2026-04-12T15:47:30.530Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T15:47:29.530Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T15:47:29.541Z$paperclip$, $paperclip$2026-04-12T15:47:30.530Z$paperclip$, $paperclip$system$paperclip$, $paperclip$460e612e-6b4d-45cf-93f7-d85303fc1440$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/e612b9c3-da58-47de-bbf4-af432867447b.ndjson$paperclip$, $paperclip$701$paperclip$, $paperclip$59b8f87e54c310fcc07993a835b58a1d9dfc46f18e0a46b37b1e0028cc74d0f3$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$650b51e5-1746-4030-b05b-df7d3e6e2006$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:02:12.558Z$paperclip$, $paperclip$2026-04-12T07:02:12.648Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"now":"2026-04-12T07:02:12.541Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:02:12.550Z$paperclip$, $paperclip$2026-04-12T07:02:12.648Z$paperclip$, $paperclip$system$paperclip$, $paperclip$2691fbce-c1ca-4768-9941-56f91864a724$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/650b51e5-1746-4030-b05b-df7d3e6e2006.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$d3770f74e029d23eb43f0cd3c9fca9c5bcb30621d6efb894c92680f6c7c5751b$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$167227db-1c47-475e-b79f-38497f2ca7e4$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:19:22.374Z$paperclip$, $paperclip$2026-04-12T07:19:22.417Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:19:22.366Z$paperclip$, $paperclip$2026-04-12T07:19:22.417Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$22c835a4-ad4c-485c-9108-edbfe19c9259$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/167227db-1c47-475e-b79f-38497f2ca7e4.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$5b1e2d58dc396c1cf998e9aa0465a441827d382e9614bed3967405c00fc8bed3$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$0df2efa0-14d9-4463-a543-49696a9c5b67$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:20:45.745Z$paperclip$, $paperclip$2026-04-12T07:20:45.797Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:20:45.731Z$paperclip$, $paperclip$2026-04-12T07:20:45.797Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$14ea63c0-56e3-4f6a-9fa2-f7cfd2dd3d83$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/0df2efa0-14d9-4463-a543-49696a9c5b67.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$4353da2005f152c4dc2122fba08b94ccca00c29d2a0873d9cdf9ad71871751c4$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$e107e9d4-7e38-4cb8-b19e-80803dcf37af$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:33:25.065Z$paperclip$, $paperclip$2026-04-12T12:33:26.701Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:33:25.057Z$paperclip$, $paperclip$2026-04-12T12:33:26.701Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$e846adfc-bd98-460f-bfd3-d6237909ac1b$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385\ntokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a\nmodel with at least 64K context, or set model.context_length in config.yaml to\noverride.","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/e107e9d4-7e38-4cb8-b19e-80803dcf37af.ndjson$paperclip$, $paperclip$1025$paperclip$, $paperclip$5629512f9c00a5c1289743cb46556d4c18ca36629b67f46dd762e9f85d63b226$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385 
tokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a 
model with at least 64K context, or set model.context_length in config.yaml to 
override.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$726086fe-1afa-47b8-ba5e-1f65c07a67aa$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T21:50:30.864Z$paperclip$, $paperclip$2026-04-12T21:50:31.853Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T21:50:30.831Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T21:50:30.852Z$paperclip$, $paperclip$2026-04-12T21:50:31.853Z$paperclip$, $paperclip$system$paperclip$, $paperclip$6fe1e60d-5f40-424d-9629-02529dce613c$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/726086fe-1afa-47b8-ba5e-1f65c07a67aa.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$98392bf6c333e24fdcbfeae42c992814c1f8788b6f820622ef9b062e3f91718e$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$b738d214-285a-442a-8fdc-c987f03074fd$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-13T01:52:31.761Z$paperclip$, $paperclip$2026-04-13T01:52:32.637Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-13T01:52:31.745Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-13T01:52:31.755Z$paperclip$, $paperclip$2026-04-13T01:52:32.637Z$paperclip$, $paperclip$system$paperclip$, $paperclip$66edf434-fba0-4c26-adae-9dd5554d1a2a$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/b738d214-285a-442a-8fdc-c987f03074fd.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$4de5c7467c32e5c1e3ae453676d2fb550b3a0e0f88b51e50ef64c2b2dbd1ca6b$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$b4396483-417d-4db6-9768-dd0f6250d1f0$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:22:58.217Z$paperclip$, $paperclip$2026-04-12T07:22:58.269Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:22:58.206Z$paperclip$, $paperclip$2026-04-12T07:22:58.269Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$798a3c04-8805-4974-a3d1-f9f947beb0d9$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/b4396483-417d-4db6-9768-dd0f6250d1f0.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$4b45b70d0b3fef7f87ee548f95f4b14cfca9874abf3f6364e479541e55e5320f$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$6adbc3ee-6369-4799-be0d-e3ce862fd4e0$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:24:09.740Z$paperclip$, $paperclip$2026-04-12T07:24:09.770Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:24:09.730Z$paperclip$, $paperclip$2026-04-12T07:24:09.770Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$fc8544c7-97f8-458c-93d6-be1f3d7ec202$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/6adbc3ee-6369-4799-be0d-e3ce862fd4e0.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$ba177a975d46d240261f06154556d2698640a995bbcb04b598d800871d11702c$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$f8633c11-19aa-41ac-835a-8241c6eabbd8$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:24:01.019Z$paperclip$, $paperclip$2026-04-12T07:24:01.113Z$paperclip$, $paperclip$Command not found in PATH: "codex"$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:24:01.008Z$paperclip$, $paperclip$2026-04-12T07:24:01.113Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$f03100d6-78f9-4f0c-8d41-0468b6d4eabe$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/f8633c11-19aa-41ac-835a-8241c6eabbd8.ndjson$paperclip$, $paperclip$495$paperclip$, $paperclip$6c3aebbb7bc7155611bc39c45ab9dbdeb3cce0a2eea62f3f6e7ad829ef26d17e$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$e78eb643-0eff-488f-997c-3430fc2a15ca$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:26:52.659Z$paperclip$, $paperclip$2026-04-12T07:26:52.768Z$paperclip$, $paperclip$Error loading config.toml: invalid type: map, expected a string$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:26:52.650Z$paperclip$, $paperclip$2026-04-12T07:26:52.768Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$2e015a5a-e1d4-4809-8717-0e27d9feff4e$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":true,"outputTokens":0,"sessionReused":false,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"Error loading config.toml: invalid type: map, expected a string\nin `model`\n\n","stdout":""}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/e78eb643-0eff-488f-997c-3430fc2a15ca.ndjson$paperclip$, $paperclip$637$paperclip$, $paperclip$65bdecde008321776288286118b03e7e290ee8e36e4f1bf8029a62a4149f0901$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$Error loading config.toml: invalid type: map, expected a string
in `model`

$paperclip$, $paperclip$adapter_failed$paperclip$, 177675, $paperclip$2026-04-12T07:26:52.724Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$9018e79b-ffb5-4ebb-afb9-e0d4bbb65e68$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T16:47:59.746Z$paperclip$, $paperclip$2026-04-12T16:48:00.737Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T16:47:59.728Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T16:47:59.738Z$paperclip$, $paperclip$2026-04-12T16:48:00.737Z$paperclip$, $paperclip$system$paperclip$, $paperclip$89f24a3e-c44e-4122-b254-b92aa5141ab8$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/9018e79b-ffb5-4ebb-afb9-e0d4bbb65e68.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$6bfadbb9cd8694da551932ae8ddd9a477833c27be9d844336ee5b7b74689fe4b$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$f2c16036-7175-40c1-9402-2b7f15f96f7b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:28:16.277Z$paperclip$, $paperclip$2026-04-12T07:28:16.418Z$paperclip$, $paperclip$Error loading config.toml: invalid type: map, expected a string$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:28:16.267Z$paperclip$, $paperclip$2026-04-12T07:28:16.418Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$1cecae83-2802-4a78-9c6f-9e71095df4e0$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":true,"outputTokens":0,"sessionReused":false,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"Error loading config.toml: invalid type: map, expected a string\nin `model`\n\n","stdout":""}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/f2c16036-7175-40c1-9402-2b7f15f96f7b.ndjson$paperclip$, $paperclip$700$paperclip$, $paperclip$dba6b194509f5060d0fce3d1fc9a1c122ae1659a0d320f340c68c8812d9bfd3c$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$Error loading config.toml: invalid type: map, expected a string
in `model`

$paperclip$, $paperclip$adapter_failed$paperclip$, 177765, $paperclip$2026-04-12T07:28:16.376Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$d29ce65f-0a4d-4d99-906a-db1f25750e29$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:37:24.809Z$paperclip$, $paperclip$2026-04-12T12:37:26.193Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:37:24.780Z$paperclip$, $paperclip$2026-04-12T12:37:26.193Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$16333b33-5989-4d48-bb17-5f8c5570c46a$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385\ntokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a\nmodel with at least 64K context, or set model.context_length in config.yaml to\noverride.","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/d29ce65f-0a4d-4d99-906a-db1f25750e29.ndjson$paperclip$, $paperclip$1025$paperclip$, $paperclip$fe459746213a0bba56a00cd8eb364e31c05ef8cc6d2962cce047eec788926722$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385 
tokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a 
model with at least 64K context, or set model.context_length in config.yaml to 
override.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$2875d489-aae7-472f-924f-797280f06b6e$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:28:29.408Z$paperclip$, $paperclip$2026-04-12T07:28:29.483Z$paperclip$, $paperclip$Error loading config.toml: invalid type: map, expected a string$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:28:29.402Z$paperclip$, $paperclip$2026-04-12T07:28:29.483Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$60aa59c8-e953-4aeb-9b32-4f028e4d409b$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":true,"outputTokens":0,"sessionReused":false,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"Error loading config.toml: invalid type: map, expected a string\nin `model`\n\n","stdout":""}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/2875d489-aae7-472f-924f-797280f06b6e.ndjson$paperclip$, $paperclip$700$paperclip$, $paperclip$e85979694ecb6de28ab691be7b19e645c4da796faba1b030a603ce04ad344f36$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$Error loading config.toml: invalid type: map, expected a string
in `model`

$paperclip$, $paperclip$adapter_failed$paperclip$, 177782, $paperclip$2026-04-12T07:28:29.441Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$11a73508-baac-4c65-aaa7-682f22662eb7$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:29:29.126Z$paperclip$, $paperclip$2026-04-12T07:29:45.501Z$paperclip$, $paperclip$unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0859238ed3410-FRA, request id: req_9491ef35dbc546e9a426f4a194b8b140$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:29:29.114Z$paperclip$, $paperclip$2026-04-12T07:29:45.502Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$7262af42-2cfc-418a-9753-7a1eabd42c26$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":true,"outputTokens":0,"sessionReused":false,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"persistedSessionId":"019d8098-78cb-7960-8c41-c2c2cdb3b812","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"2026-04-12T07:29:29.848137Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T07:29:30.344883Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T07:29:31.040265Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T07:29:31.851469Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T07:29:33.190944Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T07:29:35.335593Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T07:29:38.687198Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n","stdout":"{\"type\":\"thread.started\",\"thread_id\":\"019d8098-78cb-7960-8c41-c2c2cdb3b812\"}\n{\"type\":\"turn.started\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 2/5 (We're currently experiencing high demand, which may cause temporary errors.)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 3/5 (We're currently experiencing high demand, which may cause temporary errors.)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 4/5 (We're currently experiencing high demand, which may cause temporary errors.)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 5/5 (We're currently experiencing high demand, which may cause temporary errors.)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 1/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb08569097bd3a5-FRA, request id: req_177a5fff3ad94ea888f8295e663ac5da)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 2/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0856b4827d26c-FRA, request id: req_18de600a813f479387afd641b9665801)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 3/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0856efe85d381-FRA, request id: req_7962ef16c6e446b8be1ab9bfd1a2062f)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 4/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb085749e3dd299-FRA, request id: req_b27d88c504644a6e844cf7df6bd09c17)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 5/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0857eb9c09bf7-FRA, request id: req_052e8921806e41b2b58ce7bc73cbc956)\"}\n{\"type\":\"error\",\"message\":\"unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0859238ed3410-FRA, request id: req_9491ef35dbc546e9a426f4a194b8b140\"}\n{\"type\":\"turn.failed\",\"error\":{\"message\":\"unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0859238ed3410-FRA, request id: req_9491ef35dbc546e9a426f4a194b8b140\"}}\n"}$paperclip$, NULL, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/11a73508-baac-4c65-aaa7-682f22662eb7.ndjson$paperclip$, $paperclip$6465$paperclip$, $paperclip$699e36d2cbe113898d20277fb167a4850b9a55993d62e874738c702d85ab4811$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Injected Codex skill "paperclip" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "paperclip-create-agent" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "paperclip-create-plugin" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "para-memory-files" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
{"type":"thread.started","thread_id":"019d8098-78cb-7960-8c41-c2c2cdb3b812"}
{"type":"turn.started"}
{"type":"error","message":"Reconnecting... 2/5 (We're currently experiencing high demand, which may cause temporary errors.)"}
{"type":"error","message":"Reconnecting... 3/5 (We're currently experiencing high demand, which may cause temporary errors.)"}
{"type":"error","message":"Reconnecting... 4/5 (We're currently experiencing high demand, which may cause temporary errors.)"}
{"type":"error","message":"Reconnecting... 5/5 (We're currently experiencing high demand, which may cause temporary errors.)"}
{"type":"error","message":"Reconnecting... 1/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb08569097bd3a5-FRA, request id: req_177a5fff3ad94ea888f8295e663ac5da)"}
{"type":"error","message":"Reconnecting... 2/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0856b4827d26c-FRA, request id: req_18de600a813f479387afd641b9665801)"}
{"type":"error","message":"Reconnecting... 3/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0856efe85d381-FRA, request id: req_7962ef16c6e446b8be1ab9bfd1a2062f)"}
{"type":"error","message":"Reconnecting... 4/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb085749e3dd299-FRA, request id: req_b27d88c504644a6e844cf7df6bd09c17)"}
{"type":"error","message":"Reconnecting... 5/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0857eb9c09bf7-FRA, request id: req_052e8921806e41b2b58ce7bc73cbc956)"}
{"type":"error","message":"unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0859238ed3410-FRA, request id: req_9491ef35dbc546e9a426f4a194b8b140"}
{"type":"turn.failed","error":{"message":"unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb0859238ed3410-FRA, request id: req_9491ef35dbc546e9a426f4a194b8b140"}}
$paperclip$, $paperclip$2026-04-12T07:29:29.848137Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T07:29:30.344883Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T07:29:31.040265Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T07:29:31.851469Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T07:29:33.190944Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T07:29:35.335593Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T07:29:38.687198Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
$paperclip$, $paperclip$adapter_failed$paperclip$, 177864, $paperclip$2026-04-12T07:29:29.197Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$8240f42d-fbca-4fa2-9fa4-6d4927bfd289$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:32:17.739Z$paperclip$, $paperclip$2026-04-12T07:32:48.830Z$paperclip$, $paperclip$stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:32:17.728Z$paperclip$, $paperclip$2026-04-12T07:32:48.830Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$f46e118f-06f1-4ed3-9173-7f380a928449$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"persistedSessionId":"019d8098-78cb-7960-8c41-c2c2cdb3b812","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"2026-04-12T07:32:17.987924Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T07:32:18.008755Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T07:32:18.193329Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T07:32:18.619243Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T07:32:19.370357Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T07:32:20.966250Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T07:32:24.198818Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n","stdout":"{\"type\":\"thread.started\",\"thread_id\":\"019d8098-78cb-7960-8c41-c2c2cdb3b812\"}\n{\"type\":\"turn.started\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 2/5 (stream disconnected before completion: Connection refused (os error 111))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 3/5 (stream disconnected before completion: Connection refused (os error 111))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 4/5 (stream disconnected before completion: Connection refused (os error 111))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 5/5 (stream disconnected before completion: Connection refused (os error 111))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 1/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 2/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 3/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 4/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 5/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))\"}\n{\"type\":\"error\",\"message\":\"stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)\"}\n{\"type\":\"turn.failed\",\"error\":{\"message\":\"stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)\"}}\n"}$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/8240f42d-fbca-4fa2-9fa4-6d4927bfd289.ndjson$paperclip$, $paperclip$4896$paperclip$, $paperclip$41e3f64694037a71a2eb052c4990b2f2ca9100efec1bc2047be70e855f9b2341$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
{"type":"thread.started","thread_id":"019d8098-78cb-7960-8c41-c2c2cdb3b812"}
{"type":"turn.started"}
{"type":"error","message":"Reconnecting... 2/5 (stream disconnected before completion: Connection refused (os error 111))"}
{"type":"error","message":"Reconnecting... 3/5 (stream disconnected before completion: Connection refused (os error 111))"}
{"type":"error","message":"Reconnecting... 4/5 (stream disconnected before completion: Connection refused (os error 111))"}
{"type":"error","message":"Reconnecting... 5/5 (stream disconnected before completion: Connection refused (os error 111))"}
{"type":"error","message":"Reconnecting... 1/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))"}
{"type":"error","message":"Reconnecting... 2/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))"}
{"type":"error","message":"Reconnecting... 3/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))"}
{"type":"error","message":"Reconnecting... 4/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))"}
{"type":"error","message":"Reconnecting... 5/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))"}
{"type":"error","message":"stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)"}
{"type":"turn.failed","error":{"message":"stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)"}}
$paperclip$, $paperclip$2026-04-12T07:32:17.987924Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T07:32:18.008755Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T07:32:18.193329Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T07:32:18.619243Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T07:32:19.370357Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T07:32:20.966250Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T07:32:24.198818Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
$paperclip$, $paperclip$adapter_failed$paperclip$, 178291, $paperclip$2026-04-12T07:32:17.837Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$2285a812-43c5-49f5-ae18-e2b21a01e1fe$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:37:51.456Z$paperclip$, $paperclip$2026-04-12T12:37:52.676Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:37:51.450Z$paperclip$, $paperclip$2026-04-12T12:37:52.676Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$620d8e44-f84e-44cf-a13c-b8f39af45f72$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385\ntokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a\nmodel with at least 64K context, or set model.context_length in config.yaml to\noverride.","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/2285a812-43c5-49f5-ae18-e2b21a01e1fe.ndjson$paperclip$, $paperclip$1025$paperclip$, $paperclip$1ad8780df46691c1d1231c3f3f028058bfb9c6c8fa51a0971d772368083fcabe$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385 
tokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a 
model with at least 64K context, or set model.context_length in config.yaml to 
override.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$3afd74a2-c61f-4daa-ac96-2e5970b563b7$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T17:48:30.003Z$paperclip$, $paperclip$2026-04-12T17:48:30.934Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T17:48:29.987Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T17:48:29.996Z$paperclip$, $paperclip$2026-04-12T17:48:30.934Z$paperclip$, $paperclip$system$paperclip$, $paperclip$cb8109c6-20c7-4708-a50c-356644a53632$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/3afd74a2-c61f-4daa-ac96-2e5970b563b7.ndjson$paperclip$, $paperclip$701$paperclip$, $paperclip$069e506ad7c410f63fc0cf708e14b3aef6c611d717ae3345c3f26db8e914b5f6$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$a7ae4206-a3ec-4053-8835-007a22f6ffbc$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:34:05.268Z$paperclip$, $paperclip$2026-04-12T07:34:05.448Z$paperclip$, $paperclip$2026-04-12T07:34:05.418767Z ERROR codex_rollout::list: state db returned stale rollout path for thread 019d8098-78cb-7960-8c41-c2c2cdb3b812: /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/sessions/2026/04/12/rollout-2026-04-12T07-29-29-019d8098-78cb-7960-8c41-c2c2cdb3b812.jsonl$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:34:05.253Z$paperclip$, $paperclip$2026-04-12T07:34:05.449Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$c0a65fd3-d8b9-409b-a61b-2a93f46de82b$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"persistedSessionId":"019d8098-78cb-7960-8c41-c2c2cdb3b812","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"2026-04-12T07:34:05.418767Z ERROR codex_rollout::list: state db returned stale rollout path for thread 019d8098-78cb-7960-8c41-c2c2cdb3b812: /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/sessions/2026/04/12/rollout-2026-04-12T07-29-29-019d8098-78cb-7960-8c41-c2c2cdb3b812.jsonl\nError: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812\n","stdout":""}$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/a7ae4206-a3ec-4053-8835-007a22f6ffbc.ndjson$paperclip$, $paperclip$1060$paperclip$, $paperclip$7cbe3df530709c931d9487484ba96422c657bd6e9330b2c74d432e5e2ce32dbf$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
$paperclip$, $paperclip$2026-04-12T07:34:05.418767Z ERROR codex_rollout::list: state db returned stale rollout path for thread 019d8098-78cb-7960-8c41-c2c2cdb3b812: /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/sessions/2026/04/12/rollout-2026-04-12T07-29-29-019d8098-78cb-7960-8c41-c2c2cdb3b812.jsonl
Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812
$paperclip$, $paperclip$adapter_failed$paperclip$, 178677, $paperclip$2026-04-12T07:34:05.323Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$902baa9c-94a0-427f-ad0e-92086c16f3db$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:38:02.718Z$paperclip$, $paperclip$2026-04-12T12:38:03.995Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:38:02.711Z$paperclip$, $paperclip$2026-04-12T12:38:03.995Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$6ae71218-d4c7-475f-8aa2-66d73302562a$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385\ntokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a\nmodel with at least 64K context, or set model.context_length in config.yaml to\noverride.","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/902baa9c-94a0-427f-ad0e-92086c16f3db.ndjson$paperclip$, $paperclip$1025$paperclip$, $paperclip$e81a662656f3e1a30e5191ac94eb2c7bf37c9d392e9e738a4de654c271552f49$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385 
tokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a 
model with at least 64K context, or set model.context_length in config.yaml to 
override.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$70dadcce-01a7-4d69-a61f-cfd1d4caa169$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T22:51:01.100Z$paperclip$, $paperclip$2026-04-12T22:51:02.010Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T22:51:01.084Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T22:51:01.094Z$paperclip$, $paperclip$2026-04-12T22:51:02.010Z$paperclip$, $paperclip$system$paperclip$, $paperclip$5fe31496-6a14-4d92-be60-f90770308c34$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/70dadcce-01a7-4d69-a61f-cfd1d4caa169.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$e524d1814dc08654c67c0a9dd4edc57b5e24dbb19116b3597d59430ccc3b6b3f$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$c2cb04d3-a8be-4c70-8878-3514dd9d43a2$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:35:10.139Z$paperclip$, $paperclip$2026-04-12T07:35:10.298Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:35:10.128Z$paperclip$, $paperclip$2026-04-12T07:35:10.299Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$454b61a5-131d-46be-8bfd-ab504f1cf1bd$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"persistedSessionId":"019d8098-78cb-7960-8c41-c2c2cdb3b812","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812\n","stdout":""}$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/c2cb04d3-a8be-4c70-8878-3514dd9d43a2.ndjson$paperclip$, $paperclip$2102$paperclip$, $paperclip$45a0004b42cea03f3fbf08777c1a372f47a9ef4e27c15734a66d7440010ec362$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Injected Codex skill "paperclip" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "paperclip-create-agent" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "paperclip-create-plugin" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "para-memory-files" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Warning: could not read agent instructions file "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md": ENOENT: no such file or directory, open '/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md'
$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812
$paperclip$, $paperclip$adapter_failed$paperclip$, 178826, $paperclip$2026-04-12T07:35:10.197Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$c7df6b60-74b8-438f-a758-556454680861$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:35:19.809Z$paperclip$, $paperclip$2026-04-12T07:35:19.946Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:35:19.802Z$paperclip$, $paperclip$2026-04-12T07:35:19.947Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$0ebe9bdc-e1aa-41e9-8668-c8a5518dd0a9$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"persistedSessionId":"019d8098-78cb-7960-8c41-c2c2cdb3b812","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812\n","stdout":""}$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/c7df6b60-74b8-438f-a758-556454680861.ndjson$paperclip$, $paperclip$1140$paperclip$, $paperclip$f944b6d717759e85b67b00f33f147a9c360cb1e84f6d031b1c200b0b6b86832c$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Warning: could not read agent instructions file "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md": ENOENT: no such file or directory, open '/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md'
$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812
$paperclip$, $paperclip$adapter_failed$paperclip$, 178898, $paperclip$2026-04-12T07:35:19.851Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$09d318dc-189d-4b08-a19c-c9249f461dc8$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:42:29.883Z$paperclip$, $paperclip$2026-04-12T12:42:31.286Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:42:29.875Z$paperclip$, $paperclip$2026-04-12T12:42:31.286Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$1b1fd7b7-88c8-4e95-80ab-ff453f3ccc7e$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385\ntokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a\nmodel with at least 64K context, or set model.context_length in config.yaml to\noverride.","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/09d318dc-189d-4b08-a19c-c9249f461dc8.ndjson$paperclip$, $paperclip$1025$paperclip$, $paperclip$d6fb262d86266bc1515dda190052c7a51a60c66b1f0cd0990cbf8bfc78e6257d$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385 
tokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a 
model with at least 64K context, or set model.context_length in config.yaml to 
override.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$6f924eeb-25ca-4f77-bed1-2d6f4ff06744$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:48:14.207Z$paperclip$, $paperclip$2026-04-12T07:48:14.346Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:48:14.200Z$paperclip$, $paperclip$2026-04-12T07:48:14.346Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$a39402aa-9123-4981-9d4f-167ce5868982$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"persistedSessionId":"019d8098-78cb-7960-8c41-c2c2cdb3b812","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812\n","stdout":""}$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/6f924eeb-25ca-4f77-bed1-2d6f4ff06744.ndjson$paperclip$, $paperclip$1140$paperclip$, $paperclip$acbaa3354dc7bbc9c24e94d18388880d62f0ba70e5270dbb70b9d2138d210f03$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Warning: could not read agent instructions file "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md": ENOENT: no such file or directory, open '/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md'
$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812
$paperclip$, $paperclip$adapter_failed$paperclip$, 179505, $paperclip$2026-04-12T07:48:14.243Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$da80c1c0-e9e4-42eb-8722-6d97fb0c3dbf$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:42:28.891Z$paperclip$, $paperclip$2026-04-12T07:42:29.062Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:42:28.877Z$paperclip$, $paperclip$2026-04-12T07:42:29.062Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$3bcb7917-66f0-4b1d-b5d4-54cf48465ce9$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"persistedSessionId":"019d8098-78cb-7960-8c41-c2c2cdb3b812","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812\n","stdout":""}$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/da80c1c0-e9e4-42eb-8722-6d97fb0c3dbf.ndjson$paperclip$, $paperclip$1140$paperclip$, $paperclip$43c5a777cf9171965ac366eab43d2a4e5bd4ca8385ab657e49d9dfbc116d81f5$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Warning: could not read agent instructions file "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md": ENOENT: no such file or directory, open '/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md'
$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812
$paperclip$, $paperclip$adapter_failed$paperclip$, 179323, $paperclip$2026-04-12T07:42:28.957Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$a6fa23be-eb87-426a-b8f0-23186ca42094$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:51:08.113Z$paperclip$, $paperclip$2026-04-12T07:51:08.252Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:51:08.106Z$paperclip$, $paperclip$2026-04-12T07:51:08.252Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$74851d51-e911-42c5-9592-831d860c1bdf$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"persistedSessionId":"019d8098-78cb-7960-8c41-c2c2cdb3b812","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812\n","stdout":""}$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/a6fa23be-eb87-426a-b8f0-23186ca42094.ndjson$paperclip$, $paperclip$2039$paperclip$, $paperclip$3ef3a6a2e9572b9f478b2c00c78628e93e63f7f3cf6b395381af0c8536e857c2$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Injected Codex skill "paperclip" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "paperclip-create-agent" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "paperclip-create-plugin" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Injected Codex skill "para-memory-files" into /root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home/skills
[paperclip] Warning: could not read agent instructions file "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md": ENOENT: no such file or directory, open '/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md'
$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812
$paperclip$, $paperclip$adapter_failed$paperclip$, 179683, $paperclip$2026-04-12T07:51:08.157Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$3734032c-bf64-414b-8678-39a701c5a6ea$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:42:55.257Z$paperclip$, $paperclip$2026-04-12T12:42:56.562Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:42:55.251Z$paperclip$, $paperclip$2026-04-12T12:42:56.562Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$a41ed901-ffad-4791-bd5e-eebfd1cefc14$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385\ntokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a\nmodel with at least 64K context, or set model.context_length in config.yaml to\noverride.","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/3734032c-bf64-414b-8678-39a701c5a6ea.ndjson$paperclip$, $paperclip$1025$paperclip$, $paperclip$16b7974d0f2ab0ee36a86e3bb1cbce7d79e21031cfd22ff7bebc1b0db358e745$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
Failed to initialize agent: Model gpt-3.5-turbo has a context window of 16,385 
tokens, which is below the minimum 64,000 required by Hermes Agent.  Choose a 
model with at least 64K context, or set model.context_length in config.yaml to 
override.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$5952dba4-e175-4a3a-9491-b83af1f122ee$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T18:49:00.169Z$paperclip$, $paperclip$2026-04-12T18:49:01.198Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T18:49:00.153Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T18:49:00.162Z$paperclip$, $paperclip$2026-04-12T18:49:01.198Z$paperclip$, $paperclip$system$paperclip$, $paperclip$1611290d-b1aa-4f94-a77b-b9712c2cfafa$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/5952dba4-e175-4a3a-9491-b83af1f122ee.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$d90b85c35ef17774c12d1e0f19bed4b76b5a499db397e937e6fc17286a743f76$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$9c59ceb9-e27f-40e2-a80c-afd017e1f4cc$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T07:53:42.180Z$paperclip$, $paperclip$2026-04-12T07:53:42.342Z$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T07:53:42.171Z$paperclip$, $paperclip$2026-04-12T07:53:42.342Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$a090f6e9-e60a-40a7-a586-fc2c6fe2ebff$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"persistedSessionId":"019d8098-78cb-7960-8c41-c2c2cdb3b812","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812\n","stdout":""}$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$019d8098-78cb-7960-8c41-c2c2cdb3b812$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/9c59ceb9-e27f-40e2-a80c-afd017e1f4cc.ndjson$paperclip$, $paperclip$1140$paperclip$, $paperclip$cf87258ec0360a8278cde3003faa710744728139699ba15d18213d108ea89467$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Warning: could not read agent instructions file "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md": ENOENT: no such file or directory, open '/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md'
$paperclip$, $paperclip$Error: thread/resume: thread/resume failed: no rollout found for thread id 019d8098-78cb-7960-8c41-c2c2cdb3b812
$paperclip$, $paperclip$adapter_failed$paperclip$, 179900, $paperclip$2026-04-12T07:53:42.240Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$b475626d-ac07-4ccf-a587-647186180b93$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T08:53:43.192Z$paperclip$, $paperclip$2026-04-12T08:54:13.957Z$paperclip$, $paperclip$stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)$paperclip$, NULL, $paperclip${"now":"2026-04-12T08:54:13.172Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T08:53:43.183Z$paperclip$, $paperclip$2026-04-12T08:54:13.957Z$paperclip$, $paperclip$system$paperclip$, $paperclip$11aafbd8-8773-40a5-a286-1b3fb5fd6cdb$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"chatgpt","provider":"openai","billingType":"subscription_included","inputTokens":0,"freshSession":true,"outputTokens":0,"sessionReused":false,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":false,"persistedSessionId":"019d80e5-972f-79d3-ba57-960a9a1bd8c4","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"2026-04-12T08:53:43.390383Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T08:53:43.401158Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T08:53:43.616998Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T08:53:44.046396Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T08:53:44.780118Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T08:53:46.365713Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n2026-04-12T08:53:49.729087Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses\n","stdout":"{\"type\":\"thread.started\",\"thread_id\":\"019d80e5-972f-79d3-ba57-960a9a1bd8c4\"}\n{\"type\":\"turn.started\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 2/5 (stream disconnected before completion: Connection refused (os error 111))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 3/5 (stream disconnected before completion: Connection refused (os error 111))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 4/5 (stream disconnected before completion: Connection refused (os error 111))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 5/5 (stream disconnected before completion: Connection refused (os error 111))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 1/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 2/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 3/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 4/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 5/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))\"}\n{\"type\":\"error\",\"message\":\"stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)\"}\n{\"type\":\"turn.failed\",\"error\":{\"message\":\"stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)\"}}\n"}$paperclip$, NULL, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/b475626d-ac07-4ccf-a587-647186180b93.ndjson$paperclip$, $paperclip$5365$paperclip$, $paperclip$2b8d41015fa00699ab9a6db4ac0de8fe534c36f24bd11426827cc0254343c97d$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Warning: could not read agent instructions file "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md": ENOENT: no such file or directory, open '/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md'
{"type":"thread.started","thread_id":"019d80e5-972f-79d3-ba57-960a9a1bd8c4"}
{"type":"turn.started"}
{"type":"error","message":"Reconnecting... 2/5 (stream disconnected before completion: Connection refused (os error 111))"}
{"type":"error","message":"Reconnecting... 3/5 (stream disconnected before completion: Connection refused (os error 111))"}
{"type":"error","message":"Reconnecting... 4/5 (stream disconnected before completion: Connection refused (os error 111))"}
{"type":"error","message":"Reconnecting... 5/5 (stream disconnected before completion: Connection refused (os error 111))"}
{"type":"error","message":"Reconnecting... 1/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))"}
{"type":"error","message":"Reconnecting... 2/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))"}
{"type":"error","message":"Reconnecting... 3/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))"}
{"type":"error","message":"Reconnecting... 4/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))"}
{"type":"error","message":"Reconnecting... 5/5 (stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses))"}
{"type":"error","message":"stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)"}
{"type":"turn.failed","error":{"message":"stream disconnected before completion: error sending request for url (https://api.openai.com/v1/responses)"}}
$paperclip$, $paperclip$2026-04-12T08:53:43.390383Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T08:53:43.401158Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T08:53:43.616998Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T08:53:44.046396Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T08:53:44.780118Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T08:53:46.365713Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
2026-04-12T08:53:49.729087Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: IO error: Connection refused (os error 111), url: wss://api.openai.com/v1/responses
$paperclip$, $paperclip$adapter_failed$paperclip$, 181335, $paperclip$2026-04-12T08:53:43.247Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$9aceaafc-1f19-411e-986e-7ab3e763ad4a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:46:16.085Z$paperclip$, $paperclip$2026-04-12T12:46:17.023Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeReason":"retry_failed_run","wakeSource":"on_demand","triggeredBy":"board","forceFreshSession":false,"wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:46:16.078Z$paperclip$, $paperclip$2026-04-12T12:46:17.023Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$38b3d300-57c6-4b23-9ba9-6eb2a0ead874$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/9aceaafc-1f19-411e-986e-7ab3e763ad4a.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$196279847fd4717cad7443255a8869c42cc6f9b246574b347bb3c05c37f1a315$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$34d696c1-ac0b-412a-a33e-2b553f6a450c$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T19:49:30.428Z$paperclip$, $paperclip$2026-04-12T19:49:31.279Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T19:49:30.412Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T19:49:30.421Z$paperclip$, $paperclip$2026-04-12T19:49:31.279Z$paperclip$, $paperclip$system$paperclip$, $paperclip$8364fba6-b246-47d4-b66d-c5509e2b600d$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/34d696c1-ac0b-412a-a33e-2b553f6a450c.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$9a7f6e4688b34c0f47da48d04393f027892a3d808daf2bdf88532b7dbaa19921$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$4d3b607f-4cea-415d-9e23-21dd3cee54b1$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T09:54:58.353Z$paperclip$, $paperclip$2026-04-12T09:54:58.465Z$paperclip$, $paperclip$error: unexpected argument '--config /root/.codex/config.toml' found$paperclip$, NULL, $paperclip${"now":"2026-04-12T09:54:58.317Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"task_session","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T09:54:58.335Z$paperclip$, $paperclip$2026-04-12T09:54:58.465Z$paperclip$, $paperclip$system$paperclip$, $paperclip$8762f266-cbc1-4be4-ad11-7ef5e4f7ff04$paperclip$, 2, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"openai","provider":"openai","billingType":"metered_api","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":true,"persistedSessionId":"019d80e5-972f-79d3-ba57-960a9a1bd8c4","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"error: unexpected argument '--config /root/.codex/config.toml' found\n\n  tip: a similar argument exists: '--config'\n\nUsage: codex exec [OPTIONS] [PROMPT]\n       codex exec [OPTIONS] <COMMAND> [ARGS]\n\nFor more information, try '--help'.\n","stdout":""}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/4d3b607f-4cea-415d-9e23-21dd3cee54b1.ndjson$paperclip$, $paperclip$1015$paperclip$, $paperclip$7067a129139a3983347e6c972597f5f704541f3478625d4c58c08dc6f315cb07$paperclip$, false, $paperclip$[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Warning: could not read agent instructions file "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md": ENOENT: no such file or directory, open '/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md'
$paperclip$, $paperclip$error: unexpected argument '--config /root/.codex/config.toml' found

  tip: a similar argument exists: '--config'

Usage: codex exec [OPTIONS] [PROMPT]
       codex exec [OPTIONS] <COMMAND> [ARGS]

For more information, try '--help'.
$paperclip$, $paperclip$adapter_failed$paperclip$, 184036, $paperclip$2026-04-12T09:54:58.413Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$275d85c6-6730-452a-9355-5ac06295c5af$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T10:54:58.578Z$paperclip$, $paperclip$2026-04-12T10:54:58.725Z$paperclip$, $paperclip$error: unexpected argument '--config /root/.codex/config.toml' found$paperclip$, NULL, $paperclip${"now":"2026-04-12T10:54:58.560Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"task_session","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T10:54:58.571Z$paperclip$, $paperclip$2026-04-12T10:54:58.725Z$paperclip$, $paperclip$system$paperclip$, $paperclip$47cd1f5b-f697-4cf2-a02d-ec07b6cbf01e$paperclip$, 2, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"openai","provider":"openai","billingType":"metered_api","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":true,"persistedSessionId":"019d80e5-972f-79d3-ba57-960a9a1bd8c4","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"error: unexpected argument '--config /root/.codex/config.toml' found\n\n  tip: a similar argument exists: '--config'\n\nUsage: codex exec [OPTIONS] [PROMPT]\n       codex exec [OPTIONS] <COMMAND> [ARGS]\n\nFor more information, try '--help'.\n","stdout":""}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/275d85c6-6730-452a-9355-5ac06295c5af.ndjson$paperclip$, $paperclip$1015$paperclip$, $paperclip$bff05a6b1433cc0099e847bbe339eb63654a15d5861bf8b86587029b352afc0b$paperclip$, false, $paperclip$[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Warning: could not read agent instructions file "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md": ENOENT: no such file or directory, open '/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md'
$paperclip$, $paperclip$error: unexpected argument '--config /root/.codex/config.toml' found

  tip: a similar argument exists: '--config'

Usage: codex exec [OPTIONS] [PROMPT]
       codex exec [OPTIONS] <COMMAND> [ARGS]

For more information, try '--help'.
$paperclip$, $paperclip$adapter_failed$paperclip$, 188982, $paperclip$2026-04-12T10:54:58.622Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$c3dcf50a-5978-42d7-856a-e69699f1aaf6$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T11:55:28.742Z$paperclip$, $paperclip$2026-04-12T11:55:48.703Z$paperclip$, $paperclip$unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b4c2df54da6-FRA, request id: req_5a6ada486dfc4bdf9c8de35edde4a3b4$paperclip$, NULL, $paperclip${"now":"2026-04-12T11:55:28.721Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"task_session","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T11:55:28.735Z$paperclip$, $paperclip$2026-04-12T11:55:48.703Z$paperclip$, $paperclip$system$paperclip$, $paperclip$8885aee4-04d9-47b4-a605-26f6450b0a71$paperclip$, 1, NULL, $paperclip${"model":"gpt-5.3-codex","biller":"openai","provider":"openai","billingType":"metered_api","inputTokens":0,"freshSession":false,"outputTokens":0,"sessionReused":true,"rawInputTokens":0,"sessionRotated":false,"rawOutputTokens":0,"cachedInputTokens":0,"taskSessionReused":true,"persistedSessionId":"019d80e5-972f-79d3-ba57-960a9a1bd8c4","rawCachedInputTokens":0,"sessionRotationReason":null}$paperclip$, $paperclip${"stderr":"2026-04-12T11:55:29.518307Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T11:55:31.350183Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T11:55:32.019744Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T11:55:32.879948Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T11:55:34.181489Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T11:55:36.118628Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n2026-04-12T11:55:39.918499Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses\n","stdout":"{\"type\":\"thread.started\",\"thread_id\":\"019d80e5-972f-79d3-ba57-960a9a1bd8c4\"}\n{\"type\":\"turn.started\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 2/5 (We're currently experiencing high demand, which may cause temporary errors.)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 3/5 (We're currently experiencing high demand, which may cause temporary errors.)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 4/5 (We're currently experiencing high demand, which may cause temporary errors.)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 5/5 (We're currently experiencing high demand, which may cause temporary errors.)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 1/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b16bdd89752-FRA, request id: req_4fc6e63f77004ca9b75eb47e31798fb4)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 2/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b192b5f9b71-FRA, request id: req_40374eb6b18a4f34b475443c4f0defa0)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 3/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b1cda82c95d-FRA, request id: req_f019e9c6516c9b988afbc34b4e79bd39)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 4/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b235d18974a-FRA, request id: req_bf0d27bce4b542bf820e3d365d429cc2)\"}\n{\"type\":\"error\",\"message\":\"Reconnecting... 5/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b2ee90be85e-FRA, request id: req_b88cc650d620452690580544001daf3f)\"}\n{\"type\":\"error\",\"message\":\"unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b4c2df54da6-FRA, request id: req_5a6ada486dfc4bdf9c8de35edde4a3b4\"}\n{\"type\":\"turn.failed\",\"error\":{\"message\":\"unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b4c2df54da6-FRA, request id: req_5a6ada486dfc4bdf9c8de35edde4a3b4\"}}\n"}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/c3dcf50a-5978-42d7-856a-e69699f1aaf6.ndjson$paperclip$, $paperclip$5780$paperclip$, $paperclip$3bae7b8367f3743e85124466e10bf307bb29c9f73881c273aa84e81b499a19fb$paperclip$, false, $paperclip$[paperclip] Using Paperclip-managed Codex home "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/codex-home" (seeded from "/root/.codex").
[paperclip] Warning: could not read agent instructions file "/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md": ENOENT: no such file or directory, open '/root/.paperclip/instances/default/companies/613da0c8-8f6a-41f5-9a81-f6272721e383/agents/2b72e8ff-73f4-40fa-a123-960faf668d7c/instructions/AGENTS.md'
{"type":"thread.started","thread_id":"019d80e5-972f-79d3-ba57-960a9a1bd8c4"}
{"type":"turn.started"}
{"type":"error","message":"Reconnecting... 2/5 (We're currently experiencing high demand, which may cause temporary errors.)"}
{"type":"error","message":"Reconnecting... 3/5 (We're currently experiencing high demand, which may cause temporary errors.)"}
{"type":"error","message":"Reconnecting... 4/5 (We're currently experiencing high demand, which may cause temporary errors.)"}
{"type":"error","message":"Reconnecting... 5/5 (We're currently experiencing high demand, which may cause temporary errors.)"}
{"type":"error","message":"Reconnecting... 1/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b16bdd89752-FRA, request id: req_4fc6e63f77004ca9b75eb47e31798fb4)"}
{"type":"error","message":"Reconnecting... 2/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b192b5f9b71-FRA, request id: req_40374eb6b18a4f34b475443c4f0defa0)"}
{"type":"error","message":"Reconnecting... 3/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b1cda82c95d-FRA, request id: req_f019e9c6516c9b988afbc34b4e79bd39)"}
{"type":"error","message":"Reconnecting... 4/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b235d18974a-FRA, request id: req_bf0d27bce4b542bf820e3d365d429cc2)"}
{"type":"error","message":"Reconnecting... 5/5 (unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b2ee90be85e-FRA, request id: req_b88cc650d620452690580544001daf3f)"}
{"type":"error","message":"unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b4c2df54da6-FRA, request id: req_5a6ada486dfc4bdf9c8de35edde4a3b4"}
{"type":"turn.failed","error":{"message":"unexpected status 401 Unauthorized: Missing bearer or basic authentication in header, url: https://api.openai.com/v1/responses, cf-ray: 9eb20b4c2df54da6-FRA, request id: req_5a6ada486dfc4bdf9c8de35edde4a3b4"}}
$paperclip$, $paperclip$2026-04-12T11:55:29.518307Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T11:55:31.350183Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T11:55:32.019744Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T11:55:32.879948Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T11:55:34.181489Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T11:55:36.118628Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
2026-04-12T11:55:39.918499Z ERROR codex_api::endpoint::responses_websocket: failed to connect to websocket: HTTP error: 500 Internal Server Error, url: wss://api.openai.com/v1/responses
$paperclip$, $paperclip$adapter_failed$paperclip$, 196482, $paperclip$2026-04-12T11:55:28.784Z$paperclip$, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$7045eef0-61bd-4fb1-a8ed-edd95c8c0558$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:16:45.141Z$paperclip$, $paperclip$2026-04-12T12:16:45.332Z$paperclip$, $paperclip$Traceback (most recent call last):
PermissionError: [Errno 13] Permission denied: '/root/.hermes/.env'$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:16:45.134Z$paperclip$, $paperclip$2026-04-12T12:16:45.332Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$74e81f66-d712-4621-89fb-25ffae6ee0ce$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/7045eef0-61bd-4fb1-a8ed-edd95c8c0558.ndjson$paperclip$, $paperclip$1408$paperclip$, $paperclip$8e2605bf6395ec09532d277c805eebc0d58f138fb6d9a704af90c9202a6bb086$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$Traceback (most recent call last):
  File "/usr/bin/hermes", line 10, in <module>
    from hermes_cli.main import main
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 144, in <module>
    load_hermes_dotenv(project_env=PROJECT_ROOT / '.env')
  File "/opt/hermes/hermes-agent/hermes_cli/env_loader.py", line 37, in load_hermes_dotenv
    if user_env.exists():
       ^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/pathlib.py", line 862, in exists
    self.stat(follow_symlinks=follow_symlinks)
  File "/usr/lib/python3.12/pathlib.py", line 842, in stat
    return os.stat(self, follow_symlinks=follow_symlinks)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
PermissionError: [Errno 13] Permission denied: '/root/.hermes/.env'
$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$84a851eb-efb4-4ccc-9eb8-9f443a64e1ab$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:22:45.876Z$paperclip$, $paperclip$2026-04-12T12:22:46.167Z$paperclip$, $paperclip$Traceback (most recent call last):
FileNotFoundError: [Errno 2] No such file or directory: '[object Object]/.hermes'
During handling of the above exception, another exception occurred:
Traceback (most recent call last):
PermissionError: [Errno 13] Permission denied: '[object Object]'$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:22:45.871Z$paperclip$, $paperclip$2026-04-12T12:22:46.167Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$d71e9117-ce41-473e-bec0-646be7a0f636$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/84a851eb-efb4-4ccc-9eb8-9f443a64e1ab.ndjson$paperclip$, $paperclip$2390$paperclip$, $paperclip$8724474547cf845e80b5ca8faf6e1f320d29b14a5c0a3a0112468717951b391f$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$Traceback (most recent call last):
  File "/usr/lib/python3.12/pathlib.py", line 1313, in mkdir
    os.mkdir(self, mode)
FileNotFoundError: [Errno 2] No such file or directory: '[object Object]/.hermes'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/usr/bin/hermes", line 11, in <module>
    main()
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 5923, in main
    args.func(args)
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 709, in cmd_chat
    if not _has_any_provider_configured():
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 205, in _has_any_provider_configured
    cfg = load_config()
          ^^^^^^^^^^^^^
  File "/opt/hermes/hermes-agent/hermes_cli/config.py", line 2252, in load_config
    ensure_hermes_home()
  File "/opt/hermes/hermes-agent/hermes_cli/config.py", line 298, in ensure_hermes_home
    home.mkdir(parents=True, exist_ok=True)
  File "/usr/lib/python3.12/pathlib.py", line 1317, in mkdir
    self.parent.mkdir(parents=True, exist_ok=True)
  File "/usr/lib/python3.12/pathlib.py", line 1313, in mkdir
    os.mkdir(self, mode)
PermissionError: [Errno 13] Permission denied: '[object Object]'
$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$cb2e7ba3-166f-41da-9106-641b349880d8$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:20:24.300Z$paperclip$, $paperclip$2026-04-12T12:20:24.484Z$paperclip$, $paperclip$Traceback (most recent call last):
PermissionError: [Errno 13] Permission denied: '/root/.hermes/.env'$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:20:24.294Z$paperclip$, $paperclip$2026-04-12T12:20:24.484Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$1c4104b7-a0b2-4e33-a892-cd80f16bcb23$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/cb2e7ba3-166f-41da-9106-641b349880d8.ndjson$paperclip$, $paperclip$1408$paperclip$, $paperclip$8af5789391520560cdcd32e163e3b7e8e880b2153ee62174c8a799226bfb1b9e$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$Traceback (most recent call last):
  File "/usr/bin/hermes", line 10, in <module>
    from hermes_cli.main import main
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 144, in <module>
    load_hermes_dotenv(project_env=PROJECT_ROOT / '.env')
  File "/opt/hermes/hermes-agent/hermes_cli/env_loader.py", line 37, in load_hermes_dotenv
    if user_env.exists():
       ^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/pathlib.py", line 862, in exists
    self.stat(follow_symlinks=follow_symlinks)
  File "/usr/lib/python3.12/pathlib.py", line 842, in stat
    return os.stat(self, follow_symlinks=follow_symlinks)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
PermissionError: [Errno 13] Permission denied: '/root/.hermes/.env'
$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$d672bebe-2543-4597-a268-913c27bc0e0f$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:24:53.726Z$paperclip$, $paperclip$2026-04-12T12:24:54.080Z$paperclip$, $paperclip$Traceback (most recent call last):
FileNotFoundError: [Errno 2] No such file or directory: '[object Object]/.hermes'
During handling of the above exception, another exception occurred:
Traceback (most recent call last):
PermissionError: [Errno 13] Permission denied: '[object Object]'$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:24:53.720Z$paperclip$, $paperclip$2026-04-12T12:24:54.080Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$da9eb920-f726-4102-a9a7-b89e759f2771$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/d672bebe-2543-4597-a268-913c27bc0e0f.ndjson$paperclip$, $paperclip$2327$paperclip$, $paperclip$fbe5ca05c245c7e9cea500b192c010f16ac6e4457b40ffd33e789cf86af0dada$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$Traceback (most recent call last):
  File "/usr/lib/python3.12/pathlib.py", line 1313, in mkdir
    os.mkdir(self, mode)
FileNotFoundError: [Errno 2] No such file or directory: '[object Object]/.hermes'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/usr/bin/hermes", line 11, in <module>
    main()
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 5923, in main
    args.func(args)
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 709, in cmd_chat
    if not _has_any_provider_configured():
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 205, in _has_any_provider_configured
    cfg = load_config()
          ^^^^^^^^^^^^^
  File "/opt/hermes/hermes-agent/hermes_cli/config.py", line 2252, in load_config
    ensure_hermes_home()
  File "/opt/hermes/hermes-agent/hermes_cli/config.py", line 298, in ensure_hermes_home
    home.mkdir(parents=True, exist_ok=True)
  File "/usr/lib/python3.12/pathlib.py", line 1317, in mkdir
    self.parent.mkdir(parents=True, exist_ok=True)
  File "/usr/lib/python3.12/pathlib.py", line 1313, in mkdir
    os.mkdir(self, mode)
PermissionError: [Errno 13] Permission denied: '[object Object]'
$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$c7caaed8-aa92-4ce9-a785-0b5fbc98c9b2$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T23:51:31.276Z$paperclip$, $paperclip$2026-04-12T23:51:32.140Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T23:51:31.260Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T23:51:31.269Z$paperclip$, $paperclip$2026-04-12T23:51:32.140Z$paperclip$, $paperclip$system$paperclip$, $paperclip$94448f6b-6c08-4b9e-beaf-69910658fdb1$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/c7caaed8-aa92-4ce9-a785-0b5fbc98c9b2.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$0b7ddbcc89d85fb9bbaa16e25fd04f4e16678f7cb4dd0e1b3d19131327558a3f$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$2f0ee8c1-06b3-4fb0-a89d-5e5debeb68fc$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T13:46:29.096Z$paperclip$, $paperclip$2026-04-12T13:46:30.100Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T13:46:29.079Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T13:46:29.090Z$paperclip$, $paperclip$2026-04-12T13:46:30.100Z$paperclip$, $paperclip$system$paperclip$, $paperclip$1b3164f4-b78b-4297-a84c-38625ec517dc$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/2f0ee8c1-06b3-4fb0-a89d-5e5debeb68fc.ndjson$paperclip$, $paperclip$701$paperclip$, $paperclip$80c42235c9fd25000b3dfd8f20243f5864c7b458fa206f51547669a9c4e6edcb$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$348a1162-d807-4318-93e6-6a45082a3033$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$on_demand$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T12:31:18.041Z$paperclip$, $paperclip$2026-04-12T12:31:18.564Z$paperclip$, $paperclip$Traceback (most recent call last):
ModuleNotFoundError: No module named 'prompt_toolkit'$paperclip$, NULL, $paperclip${"actorId":"1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL","wakeSource":"on_demand","triggeredBy":"board","wakeTriggerDetail":"manual","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T12:31:18.036Z$paperclip$, $paperclip$2026-04-12T12:31:18.564Z$paperclip$, $paperclip$manual$paperclip$, $paperclip$3670d155-c7f4-461e-a44f-a84772deeaa4$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"","cost_usd":null,"session_id":null}$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$019d80e5-972f-79d3-ba57-960a9a1bd8c4$paperclip$, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/348a1162-d807-4318-93e6-6a45082a3033.ndjson$paperclip$, $paperclip$1191$paperclip$, $paperclip$717c20532fcada1e12d746ec86466396b0cb6410e9a9faccb1c57fdfda2cb222$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-3.5-turbo, provider=auto [auto], timeout=300s)
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$Traceback (most recent call last):
  File "/usr/bin/hermes.real", line 11, in <module>
    main()
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 5923, in main
    args.func(args)
  File "/opt/hermes/hermes-agent/hermes_cli/main.py", line 758, in cmd_chat
    from cli import main as cli_main
  File "/opt/hermes/hermes-agent/cli.py", line 39, in <module>
    from prompt_toolkit.history import FileHistory
ModuleNotFoundError: No module named 'prompt_toolkit'
$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$356523d9-0d5c-4477-9599-f15afe51b87c$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T14:46:59.344Z$paperclip$, $paperclip$2026-04-12T14:47:00.311Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T14:46:59.330Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T14:46:59.338Z$paperclip$, $paperclip$2026-04-12T14:47:00.311Z$paperclip$, $paperclip$system$paperclip$, $paperclip$0f863bac-bd1b-4a0d-bff6-108ec1f7acfa$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/356523d9-0d5c-4477-9599-f15afe51b87c.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$393d84315f13a4cca0b14315cb61aea24c753cd7a61a04acf7e214dd1495f107$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$9af64ba0-04d9-49d1-aedc-4cad4a5879d7$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-12T20:50:00.644Z$paperclip$, $paperclip$2026-04-12T20:50:01.637Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-12T20:50:00.627Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-12T20:50:00.637Z$paperclip$, $paperclip$2026-04-12T20:50:01.637Z$paperclip$, $paperclip$system$paperclip$, $paperclip$8264ae51-dcf2-4fe0-a0c3-6dac8cdc7a5f$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/9af64ba0-04d9-49d1-aedc-4cad4a5879d7.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$997d7f00f49cfc61c8fc7181bd7471d04eb06cfc9b0d78b6392dc8f2c9d72fc9$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$742d5909-f91e-4fe0-9ddd-7fb079a4bb4b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-13T00:52:01.549Z$paperclip$, $paperclip$2026-04-13T00:52:02.391Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-13T00:52:01.534Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-13T00:52:01.541Z$paperclip$, $paperclip$2026-04-13T00:52:02.391Z$paperclip$, $paperclip$system$paperclip$, $paperclip$cd3a28f3-3408-495f-93c8-9e464a0c3993$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/742d5909-f91e-4fe0-9ddd-7fb079a4bb4b.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$9163b53d1478a04a594e3e4badc4a3042cc4e2009887cd2ffc7e2c5385d808cb$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$4f28e098-01e9-4a9f-acda-990ac4878ecd$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-13T02:53:02.016Z$paperclip$, $paperclip$2026-04-13T02:53:02.907Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-13T02:53:01.997Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-13T02:53:02.009Z$paperclip$, $paperclip$2026-04-13T02:53:02.907Z$paperclip$, $paperclip$system$paperclip$, $paperclip$070f82c3-41ee-40f9-8488-5e8b799f057b$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/4f28e098-01e9-4a9f-acda-990ac4878ecd.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$c2c259fc8c23e0d91f11c931585f06e0205447879f37d12f350fbb5a8afed5b9$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$cde7245e-b4c9-4c3e-960d-7bd4fb5f2f09$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-13T03:53:32.262Z$paperclip$, $paperclip$2026-04-13T03:53:33.165Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-13T03:53:32.245Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-13T03:53:32.255Z$paperclip$, $paperclip$2026-04-13T03:53:33.165Z$paperclip$, $paperclip$system$paperclip$, $paperclip$a0167811-c8f8-45fe-b859-db5219c68caf$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/cde7245e-b4c9-4c3e-960d-7bd4fb5f2f09.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$4200e6bd022e757a26930af88db05eeaa281a301d5766fa320cb7d9edbcf1c50$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$efb9acc4-d3a2-41a2-8912-682eb9597b9a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-13T04:54:02.484Z$paperclip$, $paperclip$2026-04-13T04:54:03.351Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-13T04:54:02.457Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-13T04:54:02.467Z$paperclip$, $paperclip$2026-04-13T04:54:03.351Z$paperclip$, $paperclip$system$paperclip$, $paperclip$607ce0f2-c7ca-4e16-9b8e-1e3f36b5f38f$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/efb9acc4-d3a2-41a2-8912-682eb9597b9a.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$9f04e32dba22f702a49ae5b01828cf29ef0cfbcb9f3862e961225c385e0b72ad$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$f3329d57-0740-4891-bb10-97925b9a73f5$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-13T05:54:32.767Z$paperclip$, $paperclip$2026-04-13T05:54:33.741Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-13T05:54:32.746Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-13T05:54:32.758Z$paperclip$, $paperclip$2026-04-13T05:54:33.741Z$paperclip$, $paperclip$system$paperclip$, $paperclip$be34ec2a-093a-4094-8b75-99e6de7e746e$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/f3329d57-0740-4891-bb10-97925b9a73f5.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$2b66fef71218dfcfb4d194248cadd4216033a25bc76dd7747589d127b468d867$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."heartbeat_runs" ("id", "company_id", "agent_id", "invocation_source", "status", "started_at", "finished_at", "error", "external_run_id", "context_snapshot", "created_at", "updated_at", "trigger_detail", "wakeup_request_id", "exit_code", "signal", "usage_json", "result_json", "session_id_before", "session_id_after", "log_store", "log_ref", "log_bytes", "log_sha256", "log_compressed", "stdout_excerpt", "stderr_excerpt", "error_code", "process_pid", "process_started_at", "retry_of_run_id", "process_loss_retry_count") VALUES ($paperclip$3a1cb5d4-d4cf-464c-af04-041370ac8eec$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$timer$paperclip$, $paperclip$failed$paperclip$, $paperclip$2026-04-13T06:55:02.958Z$paperclip$, $paperclip$2026-04-13T06:55:03.897Z$paperclip$, $paperclip$Adapter failed$paperclip$, NULL, $paperclip${"now":"2026-04-13T06:55:02.943Z","reason":"interval_elapsed","source":"scheduler","wakeReason":"heartbeat_timer","wakeSource":"timer","wakeTriggerDetail":"system","paperclipWorkspace":{"cwd":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","mode":"shared_workspace","source":"agent_home","repoRef":null,"repoUrl":null,"strategy":"project_primary","agentHome":"/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c","projectId":null,"branchName":null,"workspaceId":null,"worktreePath":null},"paperclipWorkspaces":[]}$paperclip$, $paperclip$2026-04-13T06:55:02.950Z$paperclip$, $paperclip$2026-04-13T06:55:03.897Z$paperclip$, $paperclip$system$paperclip$, $paperclip$ef9352a6-5cca-48c7-a4cb-7de5ac97a86a$paperclip$, 1, NULL, NULL, $paperclip${"usage":null,"result":"No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes\nmodel` to re-authenticate.","cost_usd":null,"session_id":null}$paperclip$, NULL, NULL, $paperclip$local_file$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383/2b72e8ff-73f4-40fa-a123-960faf668d7c/3a1cb5d4-d4cf-464c-af04-041370ac8eec.ndjson$paperclip$, $paperclip$764$paperclip$, $paperclip$e2f4f226fc03f8f09c692af6cf29dd893c939e89e2aeb56ff17ddfb3dbc20223$paperclip$, false, $paperclip$[paperclip] No project or prior session workspace was available. Using fallback workspace "/root/.paperclip/instances/default/workspaces/2b72e8ff-73f4-40fa-a123-960faf668d7c" for this run.
[hermes] Starting Hermes Agent (model=gpt-4-turbo, provider=openai-codex [modelInference], timeout=300s)
No Codex credentials stored. Run `hermes auth` to authenticate. Run `hermes 
model` to re-authenticate.
[hermes] Exit code: 1, timed out: false
$paperclip$, $paperclip$$paperclip$, $paperclip$adapter_failed$paperclip$, NULL, NULL, NULL, 0);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.instance_settings (1 rows)
INSERT INTO "public"."instance_settings" ("id", "singleton_key", "experimental", "created_at", "updated_at", "general") VALUES ($paperclip$e95efbc4-d54c-48df-9353-11ed68f073bd$paperclip$, $paperclip$default$paperclip$, $paperclip${}$paperclip$, $paperclip$2026-04-11T21:01:00.332Z$paperclip$, $paperclip$2026-04-11T21:01:00.332Z$paperclip$, $paperclip${}$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.instance_user_roles (2 rows)
INSERT INTO "public"."instance_user_roles" ("id", "user_id", "role", "created_at", "updated_at") VALUES ($paperclip$cd8c7434-b49d-4c74-b3a6-267f2292f71c$paperclip$, $paperclip$local-board$paperclip$, $paperclip$instance_admin$paperclip$, $paperclip$2026-04-11T20:31:53.918Z$paperclip$, $paperclip$2026-04-11T20:31:53.918Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."instance_user_roles" ("id", "user_id", "role", "created_at", "updated_at") VALUES ($paperclip$a5511579-3bab-4dfd-8a6b-328125153986$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$instance_admin$paperclip$, $paperclip$2026-04-11T21:00:52.482Z$paperclip$, $paperclip$2026-04-11T21:00:52.482Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.invites (2 rows)
INSERT INTO "public"."invites" ("id", "company_id", "invite_type", "token_hash", "allowed_join_types", "defaults_payload", "expires_at", "invited_by_user_id", "revoked_at", "accepted_at", "created_at", "updated_at") VALUES ($paperclip$91de2e32-06ca-4365-81f0-24684aba3a50$paperclip$, NULL, $paperclip$bootstrap_ceo$paperclip$, $paperclip$db5099daaa8383cfdf48c15250df3d7a4545e6af2bd6351b0c02d6c6b25ba99b$paperclip$, $paperclip$human$paperclip$, NULL, $paperclip$2026-04-14T21:00:40.635Z$paperclip$, $paperclip$system$paperclip$, NULL, $paperclip$2026-04-11T21:00:52.483Z$paperclip$, $paperclip$2026-04-11T21:00:40.636Z$paperclip$, $paperclip$2026-04-11T21:00:52.483Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."invites" ("id", "company_id", "invite_type", "token_hash", "allowed_join_types", "defaults_payload", "expires_at", "invited_by_user_id", "revoked_at", "accepted_at", "created_at", "updated_at") VALUES ($paperclip$bd2b23e0-e414-4c46-a371-9d05ade7dc86$paperclip$, NULL, $paperclip$bootstrap_ceo$paperclip$, $paperclip$94dda19ed0567fb1731d8d432a7f2c1879f673fa7e23ded6bb69e207d7161160$paperclip$, $paperclip$human$paperclip$, NULL, $paperclip$2026-04-15T07:13:14.756Z$paperclip$, $paperclip$system$paperclip$, NULL, NULL, $paperclip$2026-04-12T07:13:14.757Z$paperclip$, $paperclip$2026-04-12T07:13:14.757Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.issue_inbox_archives (1 rows)
INSERT INTO "public"."issue_inbox_archives" ("id", "company_id", "issue_id", "user_id", "archived_at", "created_at", "updated_at") VALUES ($paperclip$730fd29f-9643-4df7-b33c-278168d1d627$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$203f56e9-315c-4946-a0c0-8e0f40b89a58$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$2026-04-12T07:49:58.993Z$paperclip$, $paperclip$2026-04-12T07:49:58.995Z$paperclip$, $paperclip$2026-04-12T07:49:58.993Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.issue_read_states (2 rows)
INSERT INTO "public"."issue_read_states" ("id", "company_id", "issue_id", "user_id", "last_read_at", "created_at", "updated_at") VALUES ($paperclip$4b1d0cee-2295-4ef1-92eb-28dbe39a4d34$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$1fb189f4-9819-4177-94e2-9f08c0e37091$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$2026-04-12T07:46:53.548Z$paperclip$, $paperclip$2026-04-11T21:01:53.440Z$paperclip$, $paperclip$2026-04-12T07:46:53.548Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issue_read_states" ("id", "company_id", "issue_id", "user_id", "last_read_at", "created_at", "updated_at") VALUES ($paperclip$f5dfa309-6dbc-4e31-b1da-215cc3b534a0$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$203f56e9-315c-4946-a0c0-8e0f40b89a58$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$2026-04-12T07:47:20.582Z$paperclip$, $paperclip$2026-04-12T07:46:28.150Z$paperclip$, $paperclip$2026-04-12T07:47:20.582Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.issues (2 rows)
INSERT INTO "public"."issues" ("id", "company_id", "project_id", "goal_id", "parent_id", "title", "description", "status", "priority", "assignee_agent_id", "created_by_agent_id", "created_by_user_id", "request_depth", "billing_code", "started_at", "completed_at", "cancelled_at", "created_at", "updated_at", "issue_number", "identifier", "hidden_at", "checkout_run_id", "execution_run_id", "execution_agent_name_key", "execution_locked_at", "assignee_user_id", "assignee_adapter_overrides", "execution_workspace_settings", "project_workspace_id", "execution_workspace_id", "execution_workspace_preference", "origin_kind", "origin_id", "origin_run_id") VALUES ($paperclip$203f56e9-315c-4946-a0c0-8e0f40b89a58$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$6242380a-94c5-4fdf-b9a3-ae9fb6e8c920$paperclip$, NULL, NULL, $paperclip$Hire Full Stack Dev agent$paperclip$, $paperclip$Hire Full Stack Dev Agent to develop premium web interface for the EternalGuard hybrid model.$paperclip$, $paperclip$todo$paperclip$, $paperclip$medium$paperclip$, NULL, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, 0, NULL, NULL, NULL, NULL, $paperclip$2026-04-12T07:43:51.501Z$paperclip$, $paperclip$2026-04-12T07:43:51.501Z$paperclip$, 2, $paperclip$ZAA-2$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$manual$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."issues" ("id", "company_id", "project_id", "goal_id", "parent_id", "title", "description", "status", "priority", "assignee_agent_id", "created_by_agent_id", "created_by_user_id", "request_depth", "billing_code", "started_at", "completed_at", "cancelled_at", "created_at", "updated_at", "issue_number", "identifier", "hidden_at", "checkout_run_id", "execution_run_id", "execution_agent_name_key", "execution_locked_at", "assignee_user_id", "assignee_adapter_overrides", "execution_workspace_settings", "project_workspace_id", "execution_workspace_id", "execution_workspace_preference", "origin_kind", "origin_id", "origin_run_id") VALUES ($paperclip$1fb189f4-9819-4177-94e2-9f08c0e37091$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$15e44c3d-527b-4d86-90f8-04d926928a3a$paperclip$, NULL, NULL, $paperclip$Hire your first engineer and create a hiring plan$paperclip$, $paperclip$You are the CEO. You set the direction for the company.

- hire a founding engineer
- write a hiring plan
- break the roadmap into concrete tasks and start delegating work$paperclip$, $paperclip$todo$paperclip$, $paperclip$medium$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, 0, NULL, NULL, NULL, NULL, $paperclip$2026-04-11T21:01:51.921Z$paperclip$, $paperclip$2026-04-12T07:47:15.184Z$paperclip$, 1, $paperclip$ZAA-1$paperclip$, $paperclip$2026-04-12T07:47:15.627Z$paperclip$, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $paperclip$manual$paperclip$, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.principal_permission_grants (1 rows)
INSERT INTO "public"."principal_permission_grants" ("id", "company_id", "principal_type", "principal_id", "permission_key", "scope", "granted_by_user_id", "created_at", "updated_at") VALUES ($paperclip$2fd02ccd-bc8e-4250-bfa0-da921ca8e45b$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, $paperclip$agent$paperclip$, $paperclip$2b72e8ff-73f4-40fa-a123-960faf668d7c$paperclip$, $paperclip$tasks:assign$paperclip$, NULL, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$2026-04-11T21:01:48.985Z$paperclip$, $paperclip$2026-04-11T21:01:48.985Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.projects (2 rows)
INSERT INTO "public"."projects" ("id", "company_id", "goal_id", "name", "description", "status", "lead_agent_id", "target_date", "created_at", "updated_at", "color", "archived_at", "execution_workspace_policy", "pause_reason", "paused_at") VALUES ($paperclip$15e44c3d-527b-4d86-90f8-04d926928a3a$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, NULL, $paperclip$Onboarding$paperclip$, NULL, $paperclip$in_progress$paperclip$, NULL, NULL, $paperclip$2026-04-11T21:01:51.687Z$paperclip$, $paperclip$2026-04-11T21:01:51.687Z$paperclip$, $paperclip$#6366f1$paperclip$, NULL, NULL, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."projects" ("id", "company_id", "goal_id", "name", "description", "status", "lead_agent_id", "target_date", "created_at", "updated_at", "color", "archived_at", "execution_workspace_policy", "pause_reason", "paused_at") VALUES ($paperclip$6242380a-94c5-4fdf-b9a3-ae9fb6e8c920$paperclip$, $paperclip$613da0c8-8f6a-41f5-9a81-f6272721e383$paperclip$, NULL, $paperclip$EternalGuard$paperclip$, $paperclip$Funeral Cover assistant$paperclip$, $paperclip$planned$paperclip$, NULL, NULL, $paperclip$2026-04-12T07:40:50.441Z$paperclip$, $paperclip$2026-04-12T07:40:50.441Z$paperclip$, $paperclip$#14b8a6$paperclip$, NULL, NULL, NULL, NULL);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.session (3 rows)
INSERT INTO "public"."session" ("id", "expires_at", "token", "created_at", "updated_at", "ip_address", "user_agent", "user_id") VALUES ($paperclip$xQs65cSeaCAxYOtMDZyIRibzWyft9L6K$paperclip$, $paperclip$2026-04-19T07:49:42.723Z$paperclip$, $paperclip$xx6LncNq48IwZ3iGywg5v3M39mdNqDlY$paperclip$, $paperclip$2026-04-12T07:49:42.723Z$paperclip$, $paperclip$2026-04-12T07:49:42.723Z$paperclip$, $paperclip$$paperclip$, $paperclip$Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."session" ("id", "expires_at", "token", "created_at", "updated_at", "ip_address", "user_agent", "user_id") VALUES ($paperclip$rt5i27Y8fJqemfruXAX477Gdv54doKSi$paperclip$, $paperclip$2026-04-19T12:28:10.445Z$paperclip$, $paperclip$tjHZehATuc7fU3cdPTJFWc3E0XHSwVNk$paperclip$, $paperclip$2026-04-12T12:28:10.445Z$paperclip$, $paperclip$2026-04-12T12:28:10.445Z$paperclip$, $paperclip$$paperclip$, $paperclip$Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."session" ("id", "expires_at", "token", "created_at", "updated_at", "ip_address", "user_agent", "user_id") VALUES ($paperclip$cM4gIcEN22hZNjBBsRapQyPxpMZt9dWp$paperclip$, $paperclip$2026-04-19T21:17:18.098Z$paperclip$, $paperclip$ayGIHwSwMqgPjQEThhQyrSYzB3pDARe2$paperclip$, $paperclip$2026-04-11T20:58:49.291Z$paperclip$, $paperclip$2026-04-12T21:17:18.098Z$paperclip$, $paperclip$$paperclip$, $paperclip$Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36$paperclip$, $paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Data for: public.user (2 rows)
INSERT INTO "public"."user" ("id", "name", "email", "email_verified", "image", "created_at", "updated_at") VALUES ($paperclip$local-board$paperclip$, $paperclip$Board$paperclip$, $paperclip$local@paperclip.local$paperclip$, true, NULL, $paperclip$2026-04-11T20:31:53.901Z$paperclip$, $paperclip$2026-04-11T20:31:53.901Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
INSERT INTO "public"."user" ("id", "name", "email", "email_verified", "image", "created_at", "updated_at") VALUES ($paperclip$1axWGxOQtf53Q6xQJdLmnZ5s2EjZaezL$paperclip$, $paperclip$Vernon Venter$paperclip$, $paperclip$vernon@zaaka.io$paperclip$, false, NULL, $paperclip$2026-04-11T20:58:49.284Z$paperclip$, $paperclip$2026-04-11T20:58:49.284Z$paperclip$);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

-- Sequence values
SELECT setval('"public"."heartbeat_run_events_id_seq"', 144, true);
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900

COMMIT;
-- paperclip statement breakpoint 69f6f3f1-42fd-46a6-bf17-d1d85f8f3900
