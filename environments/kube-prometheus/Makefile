helm_name = kube-prometheus
namespace = monitoring
helm_file = kube-prometheus-values.yaml
chart = prometheus-community/kube-prometheus-stack

.PHONY: add-repo
add-repo:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

.PHONY: kustomize
kustomize:
	kubectl apply -k ./

.PHONY: install
install: kustomize
	helm install $(helm_name) -n $(namespace) -f $(helm_file) $(chart)

.PHONY: upgrade
upgrade: kustomize
	helm upgrade $(helm_name) -n $(namespace) -f $(helm_file) $(chart)

.PHONY: uninstall
uninstall:
	helm uninstall $(helm_name) -n $(namespace)
	kubectl delete -k ./
