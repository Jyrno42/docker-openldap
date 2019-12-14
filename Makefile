NAME = thorgate/osixia-openldap
VERSION = 1.3.0

.PHONY: build build-nocache test tag-latest push push-latest release git-tag-version

build:
	docker buildx build --platform linux/arm/v7,linux/amd64 -t $(NAME):$(VERSION) --push --rm image
	docker buildx build --platform linux/arm/v7,linux/amd64 -t $(NAME):latest --push --rm image

build-nocache:
	docker build -t $(NAME):$(VERSION) --no-cache --rm image

test:
	env NAME=$(NAME) VERSION=$(VERSION) bats test/test.bats

tag:
	docker tag $(NAME):$(VERSION) $(NAME):$(VERSION)

tag-latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

push:
	docker push $(NAME):$(VERSION)

push-latest:
	docker push $(NAME):latest

release: build tag-latest push push-latest

git-tag-version: release
	git tag -a v$(VERSION) -m "v$(VERSION)"
	git push origin v$(VERSION)
