resource "google_data_loss_prevention_deidentify_template" "deidentify_template" {
    parent = "projects/${var.project_id}/locations/us-west1"
    description = "Identify Template for AVA project"
    display_name = "SVAV De-Identify Template"
    template_id =  "svav-identify-template"

    deidentify_config {
        info_type_transformations {
            transformations {
                info_types {
                    name = "PERSON_NAME"
                }

                info_types {
                    name = "PHONE_NUMBER"
                }

                info_types {
                    name = "US_DRIVERS_LICENSE_NUMBER"
                }

                info_types {
                    name = "US_SOCIAL_SECURITY_NUMBER"
                }

                info_types {
                    name = "NUMERIC_ZIP_CODE"
                }

                info_types {
                    name = "NUMERIC_OTP_CODE"
                }

                primitive_transformation {
                    replace_config {
                        new_value {
                            string_value = "[redacted]"
                        }
                    }
                }
            }
        }
    }
}
