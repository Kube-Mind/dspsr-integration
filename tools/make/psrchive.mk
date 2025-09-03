.PHONY: oci-build-psrchive-builder oci-push-psrchive-builder oci-pull-psrchive-builder oci-login-psrchive-builder
OCI_IMAGE_PSRCHIVE_BUILDER=ocr.jcan.dev/library/psrchive-builder:latest
oci-build-psrchive-builder:
	@echo "Building OCI image: ${OCI_IMAGE_PSRCHIVE_BUILDER}"
	@$(call docker_build,psrchive-builder,$(OCI_IMAGE_PSRCHIVE_BUILDER))

.PHONY: oci-build-psrchive oci-push-psrchive oci-pull-psrchive oci-login-psrchive

OCI_IMAGE_PSRCHIVE=ocr.jcan.dev/library/psrchive:latest
oci-build-psrchive:
	@echo "Building OCI image: ${OCI_IMAGE_PSRCHIVE}"
	@$(call docker_build,psrchive,$(OCI_IMAGE_PSRCHIVE))
