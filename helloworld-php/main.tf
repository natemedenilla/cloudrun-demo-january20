provider "google" {
  project = "tcg-cloudrundemo-1"
}

resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

resource "google_cloud_run_service" "tcg-php" {
  name     = "tcg-php"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/tcg-cloudrundemo-1/helloworld"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.run]
}

resource "google_cloud_run_service_iam_member" "allUsers" {
  service  = google_cloud_run_service.tcg-php.name
  location = google_cloud_run_service.tcg-php.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "url" {
  value = google_cloud_run_service.tcg-php.status[0].url
}