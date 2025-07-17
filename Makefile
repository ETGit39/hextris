# Variables
IMAGE_NAME := elizatom00/hextris
IMAGE_TAG := v1
FULL_IMAGE_NAME := $(IMAGE_NAME):$(IMAGE_TAG)
TF_DIR=terraform
HELM_DIR=helm
RELEASE_NAME=hextris
NODE_PORT=8080

# Tools required
REQUIRED_TOOLS := terraform helm docker kind

.PHONY: check-tools up down reinstall helm kind info

check-tools:
	@echo "Checking required tools..."
	@for tool in $(REQUIRED_TOOLS); do \
		if ! command -v $$tool >/dev/null 2>&1; then \
			echo "Missing required tool: $$tool"; \
			MISSING=true; \
		fi; \
	done; \
	if [ "$$MISSING" = "true" ]; then \
		echo ""; \
		echo "Please install the missing tools before proceeding."; \
		echo "You can run the installer script like this:"; \
		echo "chmod +x install_tools.sh && bash install_tools.sh"; \
		exit 1; \
	else \
		echo "All required tools are installed ✅"; \
	fi

up: check-tools kind helm info

kind:
	@echo "🚀 Creating Kubernetes cluster with Terraform..."
	cd $(TF_DIR) && terraform init
	cd $(TF_DIR) && terraform apply -auto-approve

helm:
	@echo "📦 Installing Hextris via Helm..."
	cd $(HELM_DIR) && helm install $(RELEASE_NAME) hextris

info:
	@echo ""
	@echo "🌐 Access Hextris at: http://localhost:$(NODE_PORT)"
	@echo ""

reinstall: down up

down: helm-delete terraform-destroy kind-delete

terraform-destroy:
	@echo "Destroying Terraform state..."
	cd $(TF_DIR) && terraform init && terraform destroy -auto-approve

helm-delete:
	@echo "Uninstalling Helm release..."
	-helm uninstall $(RELEASE_NAME) || true

kind-delete:
	@echo "Deleting Kind cluster..."
	kind delete cluster --name hextris-cluster || true