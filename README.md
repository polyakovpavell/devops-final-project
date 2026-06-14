# End-to-End DevOps Pipeline: Infrastructure to K8s

[🇷🇺 Читать на русском](README_ru.md)

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![GitLab CI](https://img.shields.io/badge/gitlab%20ci-%23181717.svg?style=for-the-badge&logo=gitlab&logoColor=white)

## 📌 Overview
This repository demonstrates a complete, automated lifecycle of a web application deployment. It covers infrastructure provisioning, configuration management, containerization, and a fully automated CI/CD pipeline delivering the workload to a Kubernetes cluster. 

## 🏗 Architecture & Tech Stack

- **Cloud Provider:** Yandex Cloud (Compute Cloud, VPC)
- **Infrastructure as Code (IaC):** Terraform (Provisioning 2 VMs: GitLab Runner & k3s Master Node)
- **Configuration Management:** Ansible (Environment bootstrapping, Docker & k3s installation)
- **Container Registry:** GitLab Container Registry
- **Orchestration:** Kubernetes (k3s lightweight distribution)
- **CI/CD:** GitLab CI/CD

## 🚀 CI/CD Pipeline Flow

The `.gitlab-ci.yml` pipeline consists of two primary stages:
1. **Build (`build_image`):** Uses Docker-in-Docker (DinD) to build the application image and pushes it to the GitLab Container Registry.
2. **Deploy (`deploy_to_k8s`):** Uses a lightweight Alpine container equipped with an SSH client. It authenticates to the target K8s node via a passwordless Deploy Key, applies the latest manifests (`deployment.yaml`, `service.yaml`), and triggers a rolling restart to pull the `latest` image tag.

## 🛠 Troubleshooting & Applied Solutions

During the implementation of this pipeline, several real-world engineering challenges were resolved:

* **Securing Terraform State:** Configured a strict `.gitignore` to prevent the leakage of `terraform.tfstate` files containing sensitive cloud credentials and IP addresses.
* **DinD TLS Verification Failure:** Encountered `Cannot connect to the Docker daemon at tcp://docker:2375` during the CI build stage. Resolved by explicitly disabling TLS verification (`DOCKER_TLS_CERTDIR: ""`) and running the GitLab Runner in `privileged = true` mode.
* **Automated K8s Authentication:** Standard SSH keys with passphrases blocked automated deployment jobs. Solved by generating a dedicated, passwordless `ed25519` **Deploy Key** and securely injecting its private counterpart into the pipeline via GitLab CI/CD Masked Variables.

## ⚙️ Quick Start (Local Reproduction)

To deploy this infrastructure in your own Yandex Cloud environment:

1. **Provision Infrastructure:**
   ```bash
   cd terraform
   terraform init && terraform apply
