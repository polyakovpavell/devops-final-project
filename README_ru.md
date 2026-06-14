# End-to-End DevOps Pipeline: От инфраструктуры до K8s

[🇬🇧 Read in English](README.md)

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![GitLab CI](https://img.shields.io/badge/gitlab%20ci-%23181717.svg?style=for-the-badge&logo=gitlab&logoColor=white)

## 📌 О проекте
Этот репозиторий демонстрирует полный автоматизированный цикл развертывания веб-приложения. Проект охватывает создание облачной инфраструктуры, управление конфигурациями, контейнеризацию и полностью автоматизированный CI/CD пайплайн для доставки кода в кластер Kubernetes.

## 🏗 Архитектура и Стек технологий

- **Облачный провайдер:** Yandex Cloud (Compute Cloud, VPC)
- **Infrastructure as Code (IaC):** Terraform (Создание 2 ВМ: GitLab Runner и k3s Master Node)
- **Управление конфигурациями:** Ansible (Базовая настройка ОС, установка Docker и k3s)
- **Хранилище образов:** GitLab Container Registry
- **Оркестрация:** Kubernetes (легковесный дистрибутив k3s)
- **CI/CD:** GitLab CI/CD

## 🚀 Описание CI/CD Пайплайна

Пайплайн `.gitlab-ci.yml` состоит из двух основных стадий:
1. **Сборка (`build_image`):** Использует технологию Docker-in-Docker (DinD) для сборки образа приложения и отправки его в GitLab Container Registry.
2. **Деплой (`deploy_to_k8s`):** Запускает легковесный Alpine-контейнер с SSH-клиентом. Робот подключается к узлу K8s по SSH (используя Deploy Key), применяет манифесты (`deployment.yaml`, `service.yaml`) и инициирует `rollout restart` для обновления подов.

## 🛠 Troubleshooting (Решение проблем)

В процессе настройки пайплайна были решены следующие инженерные задачи:

* **Защита Terraform State:** Настроен строгий `.gitignore`, предотвращающий утечку файлов `terraform.tfstate` с облачными секретами и IP-адресами в публичный репозиторий.
* **Ошибка TLS в DinD:** При сборке образа возникала ошибка подключения к демону Docker (`tcp://docker:2375`). Проблема решена отключением проверки TLS-сертификатов (`DOCKER_TLS_CERTDIR: ""`) и переводом GitLab Runner в привилегированный режим (`privileged = true`).
* **Автоматизация SSH доступов:** Деплой блокировался запросом пароля от личного SSH-ключа. Решение: генерация выделенного беспарольного **Deploy Key** (`ed25519`) и безопасная передача его приватной части в пайплайн через Masked Variables в настройках GitLab.

## ⚙️ Быстрый  старт (Локальный запуск)

Для развертывания инфраструктуры в вашем облаке Yandex Cloud:

1. **Создание инфраструктуры:**
```bash
   cd terraform
   terraform init && terraform apply
```

2. **Настройка серверов:**
   Обновите файл `ansible/inventory.ini` новыми IP-адресами и выполните:
```bash
   ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

3. **Запуск пайплайна:**
   Отправьте код (git push) в GitLab. Убедитесь, что переменная `SSH_PRIVATE_KEY` корректно задана в настройках CI/CD вашего репозитория.
