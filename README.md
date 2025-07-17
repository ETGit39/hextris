# Hextris Kubernetes Deployment

This repository provides a fully automated and reproducible way to deploy the **Hextris** game on a local K8 cluster using **Terraform**, **Kind**, **Helm**, and **Docker**.

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Docker Image](#docker-image)
- [Repository Structure](#repository-structure)
- [Troubleshooting](#troubleshooting)

---

## Overview

This project automates the deployment of Hextris into a local Kubernetes cluster.

- A local Kubernetes cluster is created with Terraform using the [Kind](https://kind.sigs.k8s.io/) provider.
- The Hextris game is deployed on the cluster via Helm
- A custom Docker image serves the static Hextris game files via Nginx.
- A Makefile orchestrates the common commands to simplify the setup, deployment, and cleanup.

---

## Prerequisites

Make sure you have the following tools installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://terraform.io/downloads)
- [Helm](https://helm.sh/docs/intro/install/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)

You can use the included script to install missing tools:

```bash
chmod +x install_tools.sh && bash install_tools.sh
```

---

## Usage

**Start the cluster and deploy Hextris**

```bash
make up
```

This command will:
 - Check for the required tools
 - Create a Kind Kubernetes cluster with Terraform
 - Deploy Hextris using Helm
 - Display the URL to access the game

Open your browser and go to: http://localhost:8080

**Tear down the environment**

```bash
make down
```

This will uninstall the Helm release, destroy the Kind cluster, and clean up Terraform managed resources

**Other useful commands**

```bash
make reinstall #Tear down and bring everything back up fresh
make check-tools #Verify all required CLI tools are installed.
```

---

## Docker Image

We created a lightweight docker image to serve Hextris using NGINX

```bash
FROM nginx:1.25-alpine
COPY . /usr/share/nginx/html
EXPOSE 80
```

---

## Repository Structure

```bash
.
├── Makefile              # build and deployment automation
├── README.md
├── install_tools.sh      # Script to install required CLI tools
├── helm/                 # Helm chart for Hextris
│   └── hextris/
│       ├── Chart.yaml
│       ├── templates/
│       └── values.yaml
└── terraform/            # Terraform configs for Kind
    ├── main.tf
    ├── output.tf
    ├── providers.tf
    ├── variables.tf
    └── terraform.tfstate

```

---

## Troubleshooting

**Port conflicts:**

If http://localhost:8080 is unreachable, check if the NodePort 8080 is free or adjust it in helm/hextris/values.yaml