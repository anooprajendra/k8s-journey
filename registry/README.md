# Run a Docker Registry in Kubernetes

- Use the **registry** image from DockerHub

- Create the Self-signed Certificates to run with the registry
  ```console
  # openssl req -x509 -newkey rsa:4096 -days 3650 -nodes -sha256 -keyout certs/tls.key -out certs/tls.crt -subj "/CN=docker-registry" -addext "subjectAltName = DNS:docker-registry,IP:192.168.122.29,IP:192.168.122.30,IP:192.168.122.31
  ```
- Create a password for logging into the docker registry.
  > The registry uses the `htpasswd` utility with the **bcrypt** encryption.
  > The `htpasswd` utility is available in the apache2-utils package
  ```console
  # htpasswd -cB auth/htpasswd admin
  ```
- Use the registry.yaml file to deploy the pod to the kubernetes cluster
