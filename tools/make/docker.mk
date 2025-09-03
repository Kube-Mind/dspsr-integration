define docker_build
	docker buildx build \
	--platform linux/amd64 \
	-f images/$(1)/Dockerfile \
	-t $(2) ./
endef

define docker_push
	docker push $(1)
endef

define docker_pull
	docker pull $(1)
endef
