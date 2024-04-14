# Run a Docker Registry in Kubernetes

- Use the **registry** image from DockerHub

- Create the Self-signed Certificates to run with the registry
  ```console
  # openssl req -x509 -newkey rsa:4096 -days 3650 -nodes -sha256 -keyout certs/tls.key -out certs/tls.crt -subj "/CN=docker-registry" -addext "subjectAltName = DNS:docker-registry,<IP:IPADDR1>,<IP:IPADDR2>..."
  ```
- Create a password for logging into the docker registry.
  > The registry uses the `htpasswd` utility with the **bcrypt** encryption.
  > The `htpasswd` utility is available in the apache2-utils package
  ```console
  # htpasswd -cB auth/htpasswd admin
  ```
- Add htpasswd and certs as secrets to kubernetes
  ```
  # kubectl create secret tls certs-secret --cert=./certs/tls.crt --key=./certs/tls.key
  # kubectl create secret generic auth-secret --from-file=auth/htpasswd
  ```
- Use the registry.yaml file to deploy the pod to the kubernetes cluster

- Once your registry is deployed, you will need to configure your kubernetes cluster
  be able to pull from the local registry you have created.

- Since we are using K0S cluster (v1.29) which uses containerd as its runtime, we will
  need to configure containerd on all the K0s worker nodes.
  - **Optional** 
    Update `/etc/hosts` file, and add the IP address of the registry. Since we are running
    in kubernetes, pick the IP address of any of the k0s worker nodes, and add `docker-registry`
	to the end of the line. If we use just IP addresses instead of hostname, don't update
    `/etc/hosts` file
  - Create `/etc/k0s/containerd.d/registry.toml` file with the following content
	```
	[plugins."io.containerd.grpc.v1.cri".registry]
		config_path = "/etc/containerd/certs.d"
	```
  - The docker-registry will run on port 32500. So create a directory called `docker-registry:32500`.
    The name of this directory reflects the manner in which this registry will be accessed. If we
	prefer to use IP addresses instead of hostnames, this directory name can be changed.
	It will contain a  file called `hosts.toml` with the following content
	```
	server = "https://docker-registry:32500"

	[host."https://docker-registry:32500"]
   		ca = "/etc/containerd/certs.d/docker-registry:32500/tls.crt"
	```
  - Copy the tls certificate to /etc/containerd/certs.d/docker-registry:32500/
- Restart all the k0s worker nodes.
- Use 
  ```
  docker login
  ```
  command to log in to the docker registry. Use `docker push` and `docker pull` commands
  to store private container images.


## References 

https://github.com/containerd/containerd/blob/main/docs/hosts.md
https://github.com/containerd/containerd/blob/main/docs/cri/config.md#registry-configuration
https://docs.k0sproject.io/stable/runtime/
