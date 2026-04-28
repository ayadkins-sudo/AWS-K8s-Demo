Abigail Adkins | AWS + Kubernetes DevOps Portfolio

This project is a production style containerized web application deployed on AWS using Kubernetes (K3s). It demonstrates real world DevOps practices including containerization, infrastructure provisioning, service exposure, and troubleshooting across the full stack.

Live Demo

https://abigail-devops.com

Architecture Overview

The application is deployed on AWS and orchestrated using Kubernetes:

Browser

  ↓

Route 53 (Domain)

  ↓

EC2 Instance (Ubuntu)

  ↓

K3s Kubernetes Cluster

  ↓

Traefik Ingress Controller

  ↓

Frontend Service (Nginx) / Backend Service (Flask API)

  ↓

Pods (Docker containers pulled from Amazon ECR)

Tech Stack

Cloud: AWS (EC2, ECR, Route 53)
Containerization: Docker (multi-arch builds using Buildx)
Orchestration: Kubernetes (K3s)
Ingress: Traefik
Backend: Flask + Gunicorn
Frontend: Nginx + Vanilla JavaScript
Deployment Workflow

Build Docker images (linux/amd64) using Docker Buildx
Push images to Amazon ECR
Apply Kubernetes manifests (Deployments, Services, Ingress)
Expose application via Traefik Ingress
Route traffic through Route 53 domain
Application Features

Frontend UI served via Nginx container
Backend API providing system and environment data
Live API check to verify connectivity between services
Health endpoint for service monitoring (/api/health)
Key Challenges & Solutions

Private ECR Authentication

Encountered ImagePullBackOff and 403 errors
Resolved by configuring Kubernetes imagePullSecrets for ECR access
Cross-Platform Image Builds

Faced architecture mismatch (ARM vs AMD64)
Fixed using Docker Buildx with linux/amd64 builds
Kubernetes Image Reference Errors

Resolved InvalidImageName issues by correcting ECR image paths
K3s Configuration Issues

Fixed kubeconfig permission issues to access the cluster properly
Infrastructure Details

Instance Type: t3.small
Operating System: Ubuntu 24.04
Kubernetes Distribution: K3s
Region: us-east-1
Project Structure

/frontend      → Static site (HTML, CSS, JS, Nginx)

/backend       → Flask API

/k8s           → Kubernetes manifests (Deployments, Services, Ingress)

/Dockerfile    → Container build definitions

 

Author

Abigail Adkins
Aspiring DevOps Engineer focused on cloud infrastructure, Kubernetes, and automation.