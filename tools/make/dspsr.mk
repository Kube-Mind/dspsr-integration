.PHONY: oci-build-dspsr-builder oci-push-dspsr-builder oci-pull-dspsr-builder oci-login-dspsr-builder

OCI_IMAGE_DSPSR=ocr.jcan.dev/library/dspsr-builder:latest
oci-build-dspsr-builder:
	@echo "Building OCI image: ${OCI_IMAGE_DSPSR}"
	@$(call docker_build,dspsr-builder,$(OCI_IMAGE_DSPSR))