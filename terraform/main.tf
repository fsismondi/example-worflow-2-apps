module "cluster" {
  source       = "git::https://github.com/camptocamp/devops-stack.git//modules/k3s/docker?ref=master"
  cluster_name = "default"
  node_count   = 1

  extra_app_projects = [
    {
      metadata = {
        name      = "argo-app-proj-dev"
        namespace = "argocd"
      }
      spec = {
        description = "Demo project"
        sourceRepos = ["*"]

        destinations = [
          {
            server    = "https://kubernetes.default.svc"
            namespace = "dev"
          }
        ]

        clusterResourceWhitelist = [
          {
            group = ""
            kind  = "Namespace"
          }
        ]
      }
    },
    {
      metadata = {
        name      = "argo-app-proj-int"
        namespace = "argocd"
      }
      spec = {
        description = "Demo project"
        sourceRepos = ["*"]

        destinations = [
          {
            server    = "https://kubernetes.default.svc"
            namespace = "int"
          }
        ]

        clusterResourceWhitelist = [
          {
            group = ""
            kind  = "Namespace"
          }
        ]
      }
    },
    {
      metadata = {
        name      = "argo-app-proj-prod"
        namespace = "argocd"
      }
      spec = {
        description = "Demo project"
        sourceRepos = ["*"]

        destinations = [
          {
            server    = "https://kubernetes.default.svc"
            namespace = "prod"
          }
        ]

        clusterResourceWhitelist = [
          {
            group = ""
            kind  = "Namespace"
          }
        ]
      }
    }
  ]

  extra_application_sets = [
    {
      metadata = {
        name      = "argo-app-set-dev"
        namespace = "argocd"

        annotations = {
          "argocd.argoproj.io/sync-options" = "SkipDryRunOnMissingResource=true"
        }
      }

      spec = {
        generators = [
          {
            git = {
              repoURL  = "https://github.com/fsismondi/example-worflow-2-apps.git"
              revision = "dev"
              directories = [
                {
                  path = "apps/*"
                }
              ]
            }
          }
        ]

        template = {
          metadata = {
            name = "{{path.basename}}"
          }

          spec = {
            project = "argo-app-proj-dev"

            source = {
              repoURL        = "https://github.com/fsismondi/example-worflow-2-apps.git"
              targetRevision = "dev"
              path           = "{{path}}"
              helm = {
                valueFiles = [
                  "values_common.yaml",
                  "values_dev.yaml",
                ]
              }
            }

            destination = {
              server    = "https://kubernetes.default.svc"
              namespace = "dev"
            }

            syncPolicy = {
              automated = {
                prune    = true
                selfHeal = false
              }

              syncOptions = [
                "CreateNamespace=true"
              ]
            }
          }
        }
      }
    },
    {
      metadata = {
        name      = "argo-app-set-int"
        namespace = "argocd"

        annotations = {
          "argocd.argoproj.io/sync-options" = "SkipDryRunOnMissingResource=true"
        }
      }

      spec = {
        generators = [
          {
            git = {
              repoURL  = "https://github.com/fsismondi/example-worflow-2-apps.git"
              revision = "int"
              directories = [
                {
                  path = "apps/*"
                }
              ]
            }
          }
        ]

        template = {
          metadata = {
            name = "{{path.basename}}"
          }

          spec = {
            project = "argo-app-proj-int"

            source = {
              repoURL        = "https://github.com/fsismondi/example-worflow-2-apps.git"
              targetRevision = "int"
              path           = "{{path}}"
              helm = {
                valueFiles = [
                  "values_common.yaml",
                  "values_int.yaml",
                ]
              }
            }

            destination = {
              server    = "https://kubernetes.default.svc"
              namespace = "int"
            }

            syncPolicy = {
              automated = {
                prune    = true
                selfHeal = false
              }

              syncOptions = [
                "CreateNamespace=true"
              ]
            }
          }
        }
      }
    },
    {
      metadata = {
        name      = "argo-app-set-prod"
        namespace = "argocd"

        annotations = {
          "argocd.argoproj.io/sync-options" = "SkipDryRunOnMissingResource=true"
        }
      }

      spec = {
        generators = [
          {
            git = {
              repoURL  = "https://github.com/fsismondi/example-worflow-2-apps.git"
              revision = "prod"
              directories = [
                {
                  path = "apps/*"
                }
              ]
            }
          }
        ]

        template = {
          metadata = {
            name = "{{path.basename}}"
          }

          spec = {
            project = "argo-app-proj-prod"

            source = {
              repoURL        = "https://github.com/fsismondi/example-worflow-2-apps.git"
              targetRevision = "prod"
              path           = "{{path}}"
              helm = {
                valueFiles = [
                  "values_common.yaml",
                  "values_prod.yaml",
                ]
              }
            }

            destination = {
              server    = "https://kubernetes.default.svc"
              namespace = "prod"
            }

            syncPolicy = {
              automated = {
                prune    = true
                selfHeal = false
              }

              syncOptions = [
                "CreateNamespace=true"
              ]
            }
          }
        }
      }
    }
  ]
}
