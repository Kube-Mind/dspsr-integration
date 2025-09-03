# dspsr-integration

Integration repository intended as a test dspsr migration from SourceForge to GitHub

## CI workflow sequence

1. clone dspsr-integration recursively
2. build and publish oci images
2.1 psrchive builder
2.2 psrchive
2.3 dspsr builder
2.4 dspsr
3. run unit tests
3.1 psrchive unit tests
3.2 dspsr unit tests
3. run dspsr functional pipeline tests
3.1 synchronise input data
3.2 run functional pipeline tests
3.3 perform comparison against baseline dspsr output

## TODO

- [x] psrchive as submodule
- [x] dspsr as submodule
- [ ] dspsr unit tests
- [ ] dspsr pipeline tests
- [ ] renovate bot integration
- [ ] minio (S3) integration
