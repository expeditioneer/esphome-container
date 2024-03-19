# ESPHome Container

[![Build and push container image](https://github.com/expeditioneer/esphome-container/actions/workflows/build-and-push-to-registry.yml/badge.svg)](https://github.com/expeditioneer/esphome-container/actions/workflows/build-and-push-to-registry.yml)

Based on RedHat UBI-9 Python3-11 image.

## Scope
Goal of this repository is to create a container which runs as smooth as possible on OpenShift.
This container enables pass-through TLS termination to protect also internal traffic.

## Configuration

### Environment Variables
- `DASHBOARD_USER` sets the username for the dashboard login
- `DASHBOARD_PASSWORD` sets the password for the dashboard login

If not set the dashboard will be accessible without any protection. 

### Volumes
Persistence for configuration files, should be mounted to _/opt/app-root/etc/esphome_ inside the container.

### Secrets
To protect internal traffic with TLS provide a secret for _server.crt_ and _server.key_ can be provided.
The locations should be _/opt/app-root/src/.pki/esphome/server.crt_ and _/opt/app-root/src/.pki/esphome/server.key_ for the container/pod.

#### Example configuration
```yaml
spec:
  template:
    spec:
      containers:
        - name: esphome
          volumeMounts:
            - name: esphome-tls
              mountPath: /opt/app-root/src/.pki/esphome
      volumes:
        - name: esphome-tls
          secret:
            defaultMode: 420
            secretName: esphome-tls
            items:
              - key: tls.crt
                path: server.crt
              - key: tls.key
                path: server.key
```

### Repetitive Logic
Cleanup should be run as a cron job with attached persistent storage for _/opt/app-root/etc/esphome_ with `pio system prune --force`.
