# dspsr-integration

Integration repository intended as a test dspsr migration from SourceForge to GitHub

## CI status

- [![OCI PSRCHIVE builder image build](https://github.com/Kube-Mind/dspsr-integration/actions/workflows/psrchive-builder-oci-build.yaml/badge.svg?branch=renovate%2Foci-submodules)](https://github.com/Kube-Mind/dspsr-integration/actions/workflows/psrchive-builder-oci-build.yaml)
- [![OCI PSRCHIVE image build](https://github.com/Kube-Mind/dspsr-integration/actions/workflows/psrchive-oci-build.yaml/badge.svg)](https://github.com/Kube-Mind/dspsr-integration/actions/workflows/psrchive-oci-build.yaml)
- [![OCI DSPSR builder image build](https://github.com/Kube-Mind/dspsr-integration/actions/workflows/dspsr-builder-oci-image-build.yaml/badge.svg?branch=renovate%2Foci-submodules)](https://github.com/Kube-Mind/dspsr-integration/actions/workflows/dspsr-builder-oci-image-build.yaml)

## CI workflow sequence

1. clone dspsr-integration recursively
2. build and publish oci images
    - psrchive builder
    - psrchive
    - dspsr builder
    - dspsr
3. run unit tests
    - psrchive unit tests
    - dspsr unit tests
4. run dspsr functional pipeline tests
    - synchronise input data
    - run functional pipeline tests
    - perform comparison against baseline dspsr output

## TODO

- [x] psrchive as submodule
- [x] dspsr as submodule
- [ ] dspsr unit tests
- [ ] dspsr pipeline tests
- [x] renovate bot integration
- [ ] minio (S3) integration
