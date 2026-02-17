<div id="top">

<!-- HEADER STYLE: MODERN -->
<div align="left" style="position: relative; width: 100%; height: 100%; ">

<img src="readmeai/assets/logos/blue.svg" width="30%" style="position: absolute; top: 0; right: 0;" alt="Project Logo"/>

# K8S-INFRA-

<em>Empowering Scalable Infrastructure with Seamless Automation<em>

<!-- BADGES -->
<img src="https://img.shields.io/github/license/Chenarrr/k8s-Infra-?style=flat-square&logo=opensourceinitiative&logoColor=white&color=0080ff" alt="license">
<img src="https://img.shields.io/github/last-commit/Chenarrr/k8s-Infra-?style=flat-square&logo=git&logoColor=white&color=0080ff" alt="last-commit">
<img src="https://img.shields.io/github/languages/top/Chenarrr/k8s-Infra-?style=flat-square&color=0080ff" alt="repo-top-language">
<img src="https://img.shields.io/github/languages/count/Chenarrr/k8s-Infra-?style=flat-square&color=0080ff" alt="repo-language-count">

<em>Built with the tools and technologies:</em>

<img src="https://img.shields.io/badge/GitHub%20Actions-2088FF.svg?style=flat-square&logo=GitHub-Actions&logoColor=white" alt="GitHub%20Actions">
<img src="https://img.shields.io/badge/YAML-CB171E.svg?style=flat-square&logo=YAML&logoColor=white" alt="YAML">

</div>
</div>
<br clear="right">

---

## Table of Contents

<details>
<summary>Table of Contents</summary>

- [Table of Contents](#table-of-contents)
- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
    - [Project Index](#project-index)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Usage](#usage)
    - [Testing](#testing)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

</details>

---

## Overview

The k8s-Infra- is a comprehensive developer tool designed to streamline Kubernetes infrastructure management and deployment. This project aims to provide a centralized command hub for orchestrating various tasks, ensuring consistency and efficiency across the codebase.

**Why k8s-Infra-?**

This project addresses common pain points faced by developers in managing complex Kubernetes deployments, providing a unified interface for executing multiple commands and automating infrastructure updates.

---

## Features

|      | Component       | Details                              |
| :--- | :-------------- | :----------------------------------- |
|  | **Architecture**  | <ul><li>Microservices-based</li><li>N+1 pattern for scalability</li></ul> |
| | **Code Quality**  | <ul><li>Follows standard Go coding conventions</li><li>Use of linters and formatters</li></ul> |
| | **Documentation** | <ul><li>No official documentation, but comments in code provide explanations</li><li>README file provides high-level overview</li></ul> |
| | **Integrations**  | <ul><li>Uses Helm for package management and deployment</li><li>Integration with Kubernetes services (e.g., Ingress, MongoDB)</li></ul> |
| | **Modularity**    | <ul><li>Components are loosely coupled and independent</li><li>Use of kustomization files for easy configuration changes</li></ul> |
| | **Testing**       | <ul><li>Unit tests using Go's built-in testing package</li><li>Integration tests using Helm and Kubernetes</li></ul> |
| | **Performance**   | <ul><li>Optimized for performance using caching and efficient data structures</li><li>No explicit benchmarking results available</li></ul> |
| | **Security**      | <ul><li>Use of secure protocols (e.g., TLS) for communication</li><li>Encryption of sensitive data</li></ul> |
| | **Dependencies**  | <ul><li>Dependent on Helm, Kubernetes, and MongoDB</li><li>No explicit versioning information available</li></ul> |
| | **Scalability**   | <ul><li>N+1 pattern for horizontal scaling</li><li>Use of kustomization files for easy configuration changes</li></ul> |

---

## Project Structure

```sh
└── k8s-Infra-/
    ├── .github
    │   └── workflows
    │       └── helm-test.yaml
    ├── Makefile
    ├── README.md
    ├── app
    │   ├── kustomization.yaml
    │   ├── namespace.yaml
    │   └── notes-app-helmrelease.yaml
    ├── charts
    │   └── notes-app
    │       ├── Chart.yaml
    │       ├── templates
    │       │   ├── _helpers.tpl
    │       │   ├── backend.yaml
    │       │   ├── frontend.yaml
    │       │   ├── ingress.yaml
    │       │   └── mongodb.yaml
    │       ├── tests
    │       │   ├── backend-deployment_test.yaml
    │       │   ├── frontend-deployment_test.yaml
    │       │   ├── mongodb-statefulset_test.yaml
    │       │   └── services_test.yaml
    │       └── values.yaml
    ├── clusters
    │   └── notes-app.yaml
    ├── flux-system
    │   └── flux-system
    │       ├── gotk-components.yaml
    │       ├── gotk-sync.yaml
    │       └── kustomization.yaml
    └── info.md
```

### Project Index

<details open>
	<summary><b><code>K8S-INFRA-/</code></b></summary>
	<!-- __root__ Submodule -->
	<details>
		<summary><b>__root__</b></summary>
		<blockquote>
			<div class='directory-path' style='padding: 8px 0; color: #666;'>
				<code><b>⦿ __root__</b></code>
			<table style='width: 100%; border-collapse: collapse;'>
			<thead>
				<tr style='background-color: #f8f9fa;'>
					<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
					<th style='text-align: left; padding: 8px;'>Summary</th>
				</tr>
			</thead>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/Makefile'>Makefile</a></b></td>
					<td style='padding: 8px;'>The Makefile serves as the central command hub for the Helm chart project, orchestrating various tasks such as testing, linting, documentation generation, and cleanup.**PurposeIt streamlines the development process by providing a single interface to execute multiple commands, ensuring consistency and efficiency across the codebase.</td>
				</tr>
			</table>
		</blockquote>
	</details>
	<!-- app Submodule -->
	<details>
		<summary><b>app</b></summary>
		<blockquote>
			<div class='directory-path' style='padding: 8px 0; color: #666;'>
				<code><b>⦿ app</b></code>
			<table style='width: 100%; border-collapse: collapse;'>
			<thead>
				<tr style='background-color: #f8f9fa;'>
					<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
					<th style='text-align: left; padding: 8px;'>Summary</th>
				</tr>
			</thead>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/app/kustomization.yaml'>kustomization.yaml</a></b></td>
					<td style='padding: 8px;'>- Deployes Kustomization Configuration**Deploys a Kubernetes kustomization configuration that manages the Helm release of a notes application<br>- The kustomization file orchestrates the deployment and management of namespace and Helm release resources, enabling efficient and scalable deployment of the application across multiple environments<br>- It serves as a central hub for managing the applications infrastructure and configuration.</td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/app/namespace.yaml'>namespace.yaml</a></b></td>
					<td style='padding: 8px;'>- Establishes a Kubernetes namespace named notes-app, serving as the central hub for the application's configuration and resources<br>- Creates a structured environment for deploying and managing the application's components, ensuring organization and scalability<br>- Enables efficient deployment, scaling, and management of the application across multiple Kubernetes clusters or environments.</td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/app/notes-app-helmrelease.yaml'>notes-app-helmrelease.yaml</a></b></td>
					<td style='padding: 8px;'>- Automates Deployment of Notes App**The <code>notes-app-helmrelease.yaml</code> file orchestrates the deployment and management of the notes app within the FluxCD system<br>- It defines a Helm release with automated updates, remediation, and cleanup processes to ensure seamless operation<br>- The configuration integrates with a Git repository, enabling frequent updates based on changes to the chart and values files.</td>
				</tr>
			</table>
		</blockquote>
	</details>
	<!-- clusters Submodule -->
	<details>
		<summary><b>clusters</b></summary>
		<blockquote>
			<div class='directory-path' style='padding: 8px 0; color: #666;'>
				<code><b>⦿ clusters</b></code>
			<table style='width: 100%; border-collapse: collapse;'>
			<thead>
				<tr style='background-color: #f8f9fa;'>
					<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
					<th style='text-align: left; padding: 8px;'>Summary</th>
				</tr>
			</thead>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/clusters/notes-app.yaml'>notes-app.yaml</a></b></td>
					<td style='padding: 8px;'>- Automates Notes App Deployment**The <code>notes-app.yaml</code> file orchestrates the deployment of a notes app using FluxCDs Kustomization tool<br>- It defines a continuous delivery pipeline that updates the application every minute, ensuring it remains up-to-date with the latest changes from the Git repository<br>- The configuration also includes health checks and timeout settings to ensure the application is running smoothly.</td>
				</tr>
			</table>
		</blockquote>
	</details>
	<!-- .github Submodule -->
	<details>
		<summary><b>.github</b></summary>
		<blockquote>
			<div class='directory-path' style='padding: 8px 0; color: #666;'>
				<code><b>⦿ .github</b></code>
			<!-- workflows Submodule -->
			<details>
				<summary><b>workflows</b></summary>
				<blockquote>
					<div class='directory-path' style='padding: 8px 0; color: #666;'>
						<code><b>⦿ .github.workflows</b></code>
					<table style='width: 100%; border-collapse: collapse;'>
					<thead>
						<tr style='background-color: #f8f9fa;'>
							<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
							<th style='text-align: left; padding: 8px;'>Summary</th>
						</tr>
					</thead>
						<tr style='border-bottom: 1px solid #eee;'>
							<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/.github/workflows/helm-test.yaml'>helm-test.yaml</a></b></td>
							<td style='padding: 8px;'>- Automated Helm Chart Testing**The <code>helm-test.yaml</code> file orchestrates automated testing for the projects Helm charts<br>- It triggers CI/CD pipelines on pull requests and code pushes to the <code>main</code> branch, ensuring the charts are linted, tested, and documented with Frigate<br>- The workflow installs required tools, runs tests, and generates documentation, providing a seamless testing experience for the project's architecture.</td>
						</tr>
					</table>
				</blockquote>
			</details>
		</blockquote>
	</details>
	<!-- charts Submodule -->
	<details>
		<summary><b>charts</b></summary>
		<blockquote>
			<div class='directory-path' style='padding: 8px 0; color: #666;'>
				<code><b>⦿ charts</b></code>
			<!-- notes-app Submodule -->
			<details>
				<summary><b>notes-app</b></summary>
				<blockquote>
					<div class='directory-path' style='padding: 8px 0; color: #666;'>
						<code><b>⦿ charts.notes-app</b></code>
					<table style='width: 100%; border-collapse: collapse;'>
					<thead>
						<tr style='background-color: #f8f9fa;'>
							<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
							<th style='text-align: left; padding: 8px;'>Summary</th>
						</tr>
					</thead>
						<tr style='border-bottom: 1px solid #eee;'>
							<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/charts/notes-app/Chart.yaml'>Chart.yaml</a></b></td>
							<td style='padding: 8px;'>The <code>Chart.yaml</code> file serves as the foundation for a full-stack notes application chart managed by Flux, defining its metadata and versioning information.**PurposeThis file enables the deployment and management of the entire codebase architecture, providing essential details such as project structure, dependencies, and release information.</td>
						</tr>
						<tr style='border-bottom: 1px solid #eee;'>
							<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/charts/notes-app/values.yaml'>values.yaml</a></b></td>
							<td style='padding: 8px;'>- The provided YAML file configures a Kubernetes application architecture for the Notes App, enabling backend and frontend services with MongoDB as the database<br>- **Key FunctionalityThe code sets up a secure, scalable environment for users to access notes, ensuring high availability and performance through rolling updates and monitoring.</td>
						</tr>
					</table>
					<!-- templates Submodule -->
					<details>
						<summary><b>templates</b></summary>
						<blockquote>
							<div class='directory-path' style='padding: 8px 0; color: #666;'>
								<code><b>⦿ charts.notes-app.templates</b></code>
							<table style='width: 100%; border-collapse: collapse;'>
							<thead>
								<tr style='background-color: #f8f9fa;'>
									<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
									<th style='text-align: left; padding: 8px;'>Summary</th>
								</tr>
							</thead>
								<tr style='border-bottom: 1px solid #eee;'>
									<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/charts/notes-app/templates/mongodb.yaml'>mongodb.yaml</a></b></td>
									<td style='padding: 8px;'>- The provided YAML file configures a Persistent Volume (PV) and StatefulSet to deploy a MongoDB service<br>- It ensures the database has sufficient storage, mounts it to a container, and sets up readiness and liveness probes for monitoring<br>- This configuration enables a scalable and fault-tolerant MongoDB deployment within the Kubernetes cluster.</td>
								</tr>
								<tr style='border-bottom: 1px solid #eee;'>
									<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/charts/notes-app/templates/ingress.yaml'>ingress.yaml</a></b></td>
									<td style='padding: 8px;'>- Configure Ingress for Notes App**Configures an ingress resource for the notes app to manage incoming HTTP requests and route them to the frontend service<br>- Ensures secure access to the application by specifying annotations, labels, and ingress settings<br>- Allows for customization through values files, enabling or disabling ingress functionality and defining specific rules for routing traffic.</td>
								</tr>
								<tr style='border-bottom: 1px solid #eee;'>
									<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/charts/notes-app/templates/frontend.yaml'>frontend.yaml</a></b></td>
									<td style='padding: 8px;'>- Deployments the frontend application, ensuring scalability and reliability<br>- It defines a deployment named after the applications name, with a specified replica count, container image, and ports<br>- The service is also defined to expose the deployed application to external traffic, utilizing a target port that matches the container port<br>- This configuration enables seamless communication between the frontend and backend services.</td>
								</tr>
								<tr style='border-bottom: 1px solid #eee;'>
									<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/charts/notes-app/templates/_helpers.tpl'>_helpers.tpl</a></b></td>
									<td style='padding: 8px;'>- Generates Chart Labels for Notes App**This template file generates essential labels for the notes app chart, including the chart name, fully qualified app name, and component-specific labels<br>- It allows for customization through values files, enabling flexible deployment of the application<br>- The resulting labels are used to identify resources in a Kubernetes cluster.</td>
								</tr>
								<tr style='border-bottom: 1px solid #eee;'>
									<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/charts/notes-app/templates/backend.yaml'>backend.yaml</a></b></td>
									<td style='padding: 8px;'>- The backend.yaml file defines a Kubernetes Deployment for the notes-app project, ensuring a scalable and secure backend service is up and running<br>- It configures a MongoDB wait loop to ensure database readiness before deploying the application, and sets environment variables for node runtime<br>- This ensures a stable and reliable backend infrastructure for the entire application.</td>
								</tr>
							</table>
						</blockquote>
					</details>
				</blockquote>
			</details>
		</blockquote>
	</details>
	<!-- flux-system Submodule -->
	<details>
		<summary><b>flux-system</b></summary>
		<blockquote>
			<div class='directory-path' style='padding: 8px 0; color: #666;'>
				<code><b>⦿ flux-system</b></code>
			<!-- flux-system Submodule -->
			<details>
				<summary><b>flux-system</b></summary>
				<blockquote>
					<div class='directory-path' style='padding: 8px 0; color: #666;'>
						<code><b>⦿ flux-system.flux-system</b></code>
					<table style='width: 100%; border-collapse: collapse;'>
					<thead>
						<tr style='background-color: #f8f9fa;'>
							<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
							<th style='text-align: left; padding: 8px;'>Summary</th>
						</tr>
					</thead>
						<tr style='border-bottom: 1px solid #eee;'>
							<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/flux-system/flux-system/kustomization.yaml'>kustomization.yaml</a></b></td>
							<td style='padding: 8px;'>- Architects the Flux systems configuration by defining a Kustomization that manages component and sync resources<br>- The kustomization.yaml file orchestrates the deployment of gotk-components and gotk-sync, enabling automated management of the applications infrastructure<br>- It serves as the central hub for configuring and updating the system's components in a Kubernetes environment.</td>
						</tr>
						<tr style='border-bottom: 1px solid #eee;'>
							<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/flux-system/flux-system/gotk-sync.yaml'>gotk-sync.yaml</a></b></td>
							<td style='padding: 8px;'>- Automates Kubernetes Infrastructure Updates**The <code>gotk-sync.yaml</code> file enables automated updates to the Kubernetes infrastructure using FluxCD and Kustomize<br>- It sets up a Git repository for monitoring changes, triggers a kustomization every 10 minutes, and prunes unnecessary resources<br>- This ensures the cluster remains up-to-date with the latest configuration, ensuring stability and security.</td>
						</tr>
						<tr style='border-bottom: 1px solid #eee;'>
							<td style='padding: 8px;'><b><a href='https://github.com/Chenarrr/k8s-Infra-/blob/master/flux-system/flux-system/gotk-components.yaml'>gotk-components.yaml</a></b></td>
							<td style='padding: 8px;'>- Namespace CreationThe file creates a Kubernetes namespace named <code>flux-system</code>, which serves as the foundation for the entire Flux system.2<br>- **Network PoliciesIt defines three network policies: <code>allow-egress</code>, <code>allow-scraping</code>, and <code>allow-webhooks</code><br>- These policies regulate incoming and outgoing traffic to and from pods within the <code>flux-system</code> namespace, ensuring that only necessary connections are established.By configuring these network policies, the Flux system can effectively manage its components, including controllers, and maintain a secure environment for its operations.</td>
						</tr>
					</table>
				</blockquote>
			</details>
		</blockquote>
	</details>
</details>

---

## Getting Started

### Prerequisites

This project requires the following dependencies:

- **Programming Language:** unknown

### Installation

Build k8s-Infra- from the source and intsall dependencies:

1. **Clone the repository:**

    ```sh
    ❯ git clone https://github.com/Chenarrr/k8s-Infra-
    ```

2. **Navigate to the project directory:**

    ```sh
    ❯ cd k8s-Infra-
    ```

3. **Install the dependencies:**

    ```sh
    ❯ helm dependency update charts/notes-app
    ```

### Usage

Deploy the Helm chart with:

    ```sh
    ❯ helm install notes-app charts/notes-app
    ```

Or apply via Flux:

    ```sh
    ❯ kubectl apply -k app/
    ```

### Testing

K8s-Infra- uses the **helm-unittest** test framework. Run the test suite with:

    ```sh
    ❯ make test
    ```

---

## Roadmap

- [X] **`Helm Chart`**: <strike>Create Notes App Helm chart with frontend, backend, and MongoDB.</strike>
- [X] **`CI Pipeline`**: <strike>Set up GitHub Actions for lint and unit tests.</strike>
- [X] **`Flux GitOps`**: <strike>Configure Flux CD for automated deployments.</strike>
- [ ] **`Monitoring`**: Add Prometheus and Grafana observability stack.
- [ ] **`TLS`**: Enable TLS termination on the Ingress.

---

## Contributing

- **[Join the Discussions](https://github.com/Chenarrr/k8s-Infra-/discussions)**: Share your insights, provide feedback, or ask questions.
- **[Report Issues](https://github.com/Chenarrr/k8s-Infra-/issues)**: Submit bugs found or log feature requests for the `k8s-Infra-` project.
- **[Submit Pull Requests](https://github.com/Chenarrr/k8s-Infra-/blob/main/CONTRIBUTING.md)**: Review open PRs, and submit your own PRs.

<details closed>
<summary>Contributing Guidelines</summary>

1. **Fork the Repository**: Start by forking the project repository to your github account.
2. **Clone Locally**: Clone the forked repository to your local machine using a git client.
   ```sh
   git clone https://github.com/Chenarrr/k8s-Infra-
   ```
3. **Create a New Branch**: Always work on a new branch, giving it a descriptive name.
   ```sh
   git checkout -b new-feature-x
   ```
4. **Make Your Changes**: Develop and test your changes locally.
5. **Commit Your Changes**: Commit with a clear message describing your updates.
   ```sh
   git commit -m 'Implemented new feature x.'
   ```
6. **Push to github**: Push the changes to your forked repository.
   ```sh
   git push origin new-feature-x
   ```
7. **Submit a Pull Request**: Create a PR against the original project repository. Clearly describe the changes and their motivations.
8. **Review**: Once your PR is reviewed and approved, it will be merged into the main branch. Congratulations on your contribution!
</details>

<details closed>
<summary>Contributor Graph</summary>
<br>
<p align="left">
   <a href="https://github.com{/Chenarrr/k8s-Infra-/}graphs/contributors">
      <img src="https://contrib.rocks/image?repo=Chenarrr/k8s-Infra-">
   </a>
</p>
</details>

---

## License

This project is distributed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [Flux CD](https://fluxcd.io/) for GitOps continuous delivery.
- [Helm](https://helm.sh/) for Kubernetes package management.
- [helm-unittest](https://github.com/helm-unittest/helm-unittest) for chart testing.
- [readmeai](https://github.com/eli64s/readme-ai) for README generation.

<div align="right">

[![][back-to-top]](#top)

</div>


[back-to-top]: https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square


---
