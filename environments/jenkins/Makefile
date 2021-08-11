namespace = jenkins
chart = jenkinsci/jenkins

.PHONY: add-repo
add-repo:
	helm repo add jenkinsci https://charts.jenkins.io
	helm repo update

.PHONY: kustomize
kustomize:
	kubectl apply -k ./

.PHONY: install
install: kustomize
	helm install jenkins -n $(namespace) -f jenkins-values.yaml $(chart)

.PHONY: upgrade
upgrade: kustomize
	helm upgrade jenkins -n $(namespace) -f jenkins-values.yaml $(chart)
