.PHONY: setup build deploy

setup:
	cd lambdas/foo-lambda && npm install

build:
	cd lambdas/foo-lambda && npm run build 
	zip -j lambdas/foo-lambda.zip lambdas/foo-lambda/dist/index.js

deploy: build
	cd terraform && terraform init && terraform apply -auto-approve
