build:
	RAILS_ENV=production rails assets:precompile

deploy_dev: build
	pushd ansible; ansible-playbook -i hosts_dev playbooks/main.yaml; popd

.PHONY: build deploy_dev
