<!--Getting Kubernetes resource names-->

Note

These filters have migrated to the kubernetes.core collection. Follow the installation instructions to install that collection.

Use the “k8s_config_resource_name” filter to obtain the name of a Kubernetes ConfigMap or Secret, including its hash:

    {{ configmap_resource_definition | kubernetes.core.k8s_config_resource_name }}
    
This can then be used to reference hashes in Pod specifications:

    my_secret:
      kind: Secret
      metadata:
        name: my_secret_name
        
    deployment_resource:
      kind: Deployment
      spec:
        template:
          spec:
            containers:
            - envFrom:
                - secretRef:
                    name: {{ my_secret | kubernetes.core.k8s_config_resource_name }}