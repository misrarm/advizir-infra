resource "google_data_loss_prevention_inspect_template" "inspect_template" {
    parent = "projects/${var.project_id}/locations/us"
    description = "Inspection template for AVA project"
    display_name = "SVAV inspect template"
    template_id = "svav-inspect-template"

    inspect_config {
        info_types {
            name = "EMAIL_ADDRESS"
        }

        info_types {
            name = "STREET_ADDRESS"
        }

        info_types {
            name = "US_DRIVERS_LICENSE_NUMBER"
        }

        info_types {
            name = "PERSON_NAME"
        }

        info_types {
            name = "PHONE_NUMBER"
        }

        info_types {
            name = "US_SOCIAL_SECURITY_NUMBER"
        }

        info_types {
            name = "PASSWORD"
        }

        info_types {
            name = "CREDIT_CARD_NUMBER"
        }

        custom_info_types {
            info_type {
                name = "NUMERIC_OTP_CODE"
            }

            likelihood = "POSSIBLE"

            regex {
                pattern = "\\b\\d{6}\\b"
            }
        }

        custom_info_types {
            info_type {
                name = "NUMERIC_ZIP_CODE"
            }

            likelihood = "UNLIKELY"

            regex {
                pattern = "\\b\\d{5}\\b"
            }
        }
    }
}
