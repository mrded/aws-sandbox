APP_DIR := app
ZIP_FILE := app.zip
TERRAFORM_DIR := terraform

AWS_REGION := us-east-1

.PHONY: all clean build zip deploy

all: deploy

clean:
	@echo "Cleaning up..."
	rm -rf $(APP_DIR)/dist $(ZIP_FILE)

build:
	@echo "Building the application..."
	cd $(APP_DIR) && npm install && npm run build

zip: build
	@echo "Zipping application files..."
	cd $(APP_DIR) && zip -r ../$(ZIP_FILE) dist package.json node_modules

deploy: zip
	@echo "Deploying application with Terraform..."
	cd $(TERRAFORM_DIR) && terraform init && terraform apply -auto-approve
