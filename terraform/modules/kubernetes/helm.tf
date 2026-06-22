# --- cert-manager ---

resource "helm_release" "cert_manager" {

  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  version = "v1.18.2"

  values = [
    file("${path.root}/../helm/platform/cert-manager/values.yaml")
  ]
}

# --- AWS Load Balancer Controller ---

resource "helm_release" "alb_controller" {

  depends_on = [
    helm_release.cert_manager
  ]

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  version = "1.14.1"

  values = [
    yamlencode({

      clusterName = var.cluster_name

      serviceAccount = {
        create = false
        name   = "aws-load-balancer-controller"
      }

      region = var.aws_region

      replicaCount = 2

      resources = {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }

        limits = {
          cpu    = "500m"
          memory = "512Mi"
        }
      }

      podDisruptionBudget = {
        enabled      = true
        minAvailable = 1
      }

      enableShield = false
      enableWaf    = false
      enableWafv2  = true

      ingressClass = "alb"

    })
  ]
}

# --- External DNS ---

resource "helm_release" "external_dns" {

  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true

  version = "1.18.0"

  values = [
    yamlencode({

      provider = "aws"

      policy = "sync"

      registry = "txt"

      txtOwnerId = var.hosted_zone_id

      serviceAccount = {
        create = false
        name   = "external-dns"
      }

      sources = [
        "ingress"
      ]

      domainFilters = [
        var.domain_name
      ]

      replicaCount = 2

      resources = {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }

        limits = {
          cpu    = "500m"
          memory = "512Mi"
        }
      }

    })
  ]
}

# --- External Secrets Operator ---

resource "helm_release" "external_secrets" {

  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true

  version = "0.20.4"

  values = [
    yamlencode({

      installCRDs = true

      replicaCount = 2

      serviceAccount = {
        create = false
        name   = "external-secrets"
      }

      resources = {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }

        limits = {
          cpu    = "500m"
          memory = "512Mi"
        }
      }

      podDisruptionBudget = {
        enabled      = true
        minAvailable = 1
      }

    })
  ]
}

# --- Metrics Server ---

resource "helm_release" "metrics_server" {

  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"

  version = "3.13.0"

  values = [
    yamlencode({

      replicaCount = 2

      resources = {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }

        limits = {
          cpu    = "500m"
          memory = "512Mi"
        }
      }

      podDisruptionBudget = {
        enabled      = true
        minAvailable = 1
      }

      args = [
        "--kubelet-preferred-address-types=InternalIP",
        "--kubelet-use-node-status-port"
      ]

    })
  ]
}

# --- Cluster Autoscaler ---

#resource "helm_release" "cluster_autoscaler" {
#
#  depends_on = [
#    helm_release.metrics_server
#  ]
#
#  name       = "cluster-autoscaler"
#  repository = "https://kubernetes.github.io/autoscaler"
#  chart      = "cluster-autoscaler"
#  namespace  = "kube-system"
#
#  version = "9.47.0"
#
#  values = [
#    yamlencode({
#
#      autoDiscovery = {
#        clusterName = var.cluster_name
#      }
#
#      awsRegion = var.aws_region
#
#      serviceAccount = {
#        create = false
#        name   = "cluster-autoscaler"
#      }
#
#      replicaCount = 2
#
#      extraArgs = {
#
#        balance-similar-node-groups = true
#
#        skip-nodes-with-system-pods = false
#
#        skip-nodes-with-local-storage = false
#
#        expander = "least-waste"
#
#        scale-down-delay-after-add = "10m"
#
#        scale-down-unneeded-time = "10m"
#
#        max-node-provision-time = "15m"
#      }
#
#      resources = {
#        requests = {
#          cpu    = "100m"
#          memory = "300Mi"
#        }
#
#        limits = {
#          cpu    = "500m"
#          memory = "600Mi"
#        }
#      }
#
#      podDisruptionBudget = {
#        enabled      = true
#        minAvailable = 1
#      }
#
#    })
#  ]
#}

# --- Karpenter ---

resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "https://charts.karpenter.sh"
  chart            = "karpenter"
  namespace        = "karpenter"
  create_namespace = true

  version = "0.37.0" # pick latest stable

  values = [
    yamlencode({
      serviceAccount = {
        create = false
        name   = "karpenter"
      }

      settings = {
        clusterName = var.cluster_name
        clusterEndpoint = var.cluster_endpoint
        aws = {
          defaultInstanceProfile = var.karpenter_instance_profile
          interruptionQueueName  = var.karpenter_queue_name
        }
      }

      replicaCount = 2

      resources = {
        requests = {
          cpu    = "200m"
          memory = "512Mi"
        }
        limits = {
          cpu    = "1"
          memory = "1Gi"
        }
      }

      podDisruptionBudget = {
        enabled      = true
        minAvailable = 1
      }
    })
  ]
}

# --- Prometheus Stack ---

resource "helm_release" "prometheus" {

  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  version = "78.5.0"

  values = [
    file("${path.root}/../helm/platform/prometheus/values.yaml")
  ]
}

# --- Grafana ---

resource "helm_release" "grafana" {

  depends_on = [
    helm_release.prometheus
  ]

  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"

  version = "10.1.0"

  values = [
    file("${path.root}/../helm/platform/grafana/values.yaml")
  ]
}

# --- Elasticsearch ---

resource "helm_release" "elasticsearch" {

  name             = "elasticsearch"
  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"
  namespace        = "logging"
  create_namespace = true

  version = "8.5.1"

  values = [
    file("${path.root}/../helm/platform/elasticsearch/values.yaml")
  ]
}

# --- Kibana ---

resource "helm_release" "kibana" {

  depends_on = [
    helm_release.elasticsearch
  ]

  name             = "kibana"
  repository       = "https://helm.elastic.co"
  chart            = "kibana"
  namespace        = "logging"

  version = "8.5.1"

  values = [
    file("${path.root}/../helm/platform/kibana/values.yaml")
  ]
}

# --- Fluent Bit ---

resource "helm_release" "fluent_bit" {

  depends_on = [
    helm_release.elasticsearch
  ]

  name             = "fluent-bit"
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluent-bit"
  namespace        = "logging"
  create_namespace = true

  version = "0.53.0"

  values = [
    yamlencode({

      replicaCount = 2

      service = {
        type = "ClusterIP"
      }

      resources = {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }

        limits = {
          cpu    = "500m"
          memory = "512Mi"
        }
      }

      backend = {
        type = "es"
      }

      config = {

        outputs = <<-EOT
[OUTPUT]
    Name            es
    Match           *
    Host            elasticsearch-master.logging.svc.cluster.local
    Port            9200
    Logstash_Format On
    Retry_Limit     False
EOT

      }

    })
  ]
}

# --- Velero ---

resource "helm_release" "velero" {

  name             = "velero"
  repository       = "https://vmware-tanzu.github.io/helm-charts"
  chart            = "velero"
  namespace        = "velero"
  create_namespace = true

  version = "11.0.0"

  values = [
  templatefile(
    "${path.root}/../helm/platform/velero/values.yaml",
    {
      bucket_name = var.velero_bucket_name
      aws_region  = var.aws_region
    }
  )
]
}

