# CI/CD: Push Docker Image to Docker Hub via GitHub Actions
---
This repository demonstrates how to automatically build and push a Docker image to Docker Hub using GitHub Actions whenever code is pushed to the main branch.

---


## Technologies Used

- **Docker** – containerise the application.

- **GitHub Actions** – CI/CD automation.

- **Docker Hub** – remote container registry.

- **Git** – source code version control.
---

## Key Features

- Automated Docker builds – Every push to the main branch triggers a build.

- Multiple image tags – Images are tagged with main, latest, and the commit SHA for traceability.

- Secure Docker login – Credentials are stored in GitHub Secrets to protect sensitive information.

- CI/CD pipeline – Fully automated workflow with no manual intervention.

- Metadata labels – Each image stores repository and commit information for auditing.
  
---
  
 ## Workflow Overview

The workflow automates the following steps:

**1.** Checkout repository code.

**2.** Log in to Docker Hub securely using secrets.

**3.** Extract Docker image metadata (tags and labels).

**4.** Build the Docker image.

**5.** Push the image to Docker Hub with multiple tags:

- main (branch name)

- latest (always up-to-date)

- sha-<commit-hash> (unique per commit)

---

## Project Structure

```text
├── Dockerfile            # Dockerfile to build the image
├── .github
│   └── workflows
│       └── main.yml   # GitHub Actions workflow file
└── README.md
```

---
## Steps to Push Docker Image via GitHub Actions

## 1. Create Docker Hub Credentials

Log in to Docker Hub and generate an access token:
- Navigate to Account Settings → Security → New Access Token
- Save the token securely.

## 2. Store Secrets in GitHub

Add your Docker Hub credentials in GitHub repository secrets:

| Secret Name       | Value                    |
| ----------------- | ------------------------ |
| `DOCKER_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Your Docker Hub token    |

#### Settings → Secrets and variables → Actions → New repository secret

## 3. Add GitHub Actions Workflow

#### Create .github/workflows/main.yml with the following content:

```text
name: push image to docker hub

on:
  push:
   branches:
     - main

permissions:
  contents: read
  packages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Log into Docker Hub
      uses: docker/login-action@v3
      with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

    - name: Extract metadata (tags, labels) for Docker
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ secrets.DOCKER_USERNAME }}/cicd-challenge
        tags: |
          type=ref,event=branch
          type=raw,value=latest
          type=sha

    - name: Build and push Docker image
      id: push
      uses: docker/build-push-action@v6
      with:
          context: .
          file: ./Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```


## 4. Commit & Push
```text
git add .
git commit -m "Add GitHub Actions workflow for Docker push"
git push origin main
```
Once pushed, GitHub Actions will automatically:

**1.** Build your Docker image.

**2.** Tag it with main, latest, and the commit SHA.

**3.** Push it to Docker Hub.

## 5. Verify Docker Image
Check Docker Hub for your image:

```text
docker pull <your-username>/cicd-challenge:latest
docker pull <your-username>/cicd-challenge:sha-<commit-hash>
```
---
## Lessons learned

**1.** GitHub secrets are essential – never hard-code credentials.

**2.** Branch-based and commit-based tags improve traceability and reproducibility.

**3.** Automated metadata (labels) helps in auditing and tracking builds.

**4.** Testing images before push ensures broken builds are not deployed.

**5.** CI/CD pipelines save time and prevent human error for repetitive tasks like Docker image pushes.







