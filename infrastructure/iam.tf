# Notflix に editor のロールを付与
resource "google_project_iam_member" "editor_notflix" {
  project = var.project_id
  role    = "roles/editor"
  member  = "user:${var.gcp_principal_notflix}"
}
